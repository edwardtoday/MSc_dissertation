clear;

%% Files to process
save_dir = ['output'];

use_original_data = true;
% Toggle this for data source selection
% use_original_data = false;

if (use_original_data)
    data_dir = ['..' filesep 'rawdata'];
    file_mask = [data_dir filesep '*.zonly'];
    sample_width = 768;
    sample_height = 576;
    roi_size = 400;
else
    data_dir = ['..' filesep 'rawdata' filesep 'roi'];
    file_mask = [data_dir filesep '*.dat'];
    sample_width = 128;
    sample_height = 128;
    roi_size = 128;
end

file_list = dir(file_mask);
file_list = char({file_list.name});

num_of_samples = length(file_list);
sample_per_person = 10;
num_of_people = num_of_samples/sample_per_person;
% Toggle this for limited number of files
// num_of_people = 100;

feature_dimension = roi_size;
% feature_dimension = roi_size*roi_size;

features = zeros(num_of_people*sample_per_person,feature_dimension);

%% Parallel read files
tic;
for current_person = 1:num_of_people
    disp(['Loading data from ' num2str(current_person) ' of ' num2str(num_of_people) ' people.']);
    for current_sample = 1:sample_per_person
        file_id = (current_person - 1) * 10 + current_sample;
        sample_filename = strtrim([data_dir filesep file_list(file_id,:)]);
        
        mat = file2matrix(sample_filename, sample_width, sample_height);
        
        if (use_original_data)
            % Crop ROI from original data
            mat = mat(235:(234+roi_size),69:(68+roi_size));
        end;
        
        % Extract feature for this sample
        features(file_id,:) = calc_feature(mat);
    end
end

save(['output' filesep 'features.mat'], 'features');
toc;