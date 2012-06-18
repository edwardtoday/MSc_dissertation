clear;

%% Files to process
save_dir = ['output'];

data_dir = ['..' filesep '..' filesep '3D_palm' filesep '3DPalm_zonly'];
data_dir = ['..' filesep 'rawdata'];
file_mask = [data_dir filesep '*.zonly'];
file_list = dir(file_mask);
file_list = char({file_list.name});

num_of_samples = length(file_list);
sample_per_person = 10;
num_of_people = num_of_samples/sample_per_person;
% Toggle this for limited number of files
num_of_people = 30;

feature_dimension = 576;

palms = createArrays(sample_per_person, [768 576], 'single');
features = zeros(num_of_people*sample_per_person,feature_dimension);

%% Parallel read files
tic;
for current_person = 1:num_of_people
    disp(['Loading data from ' num2str(current_person) ' of ' num2str(num_of_people) ' people.']);
    for current_sample = 1:sample_per_person
        file_id = (current_person - 1) * 10 + current_sample;
        sample_filename = [data_dir filesep file_list(file_id,:)];
        palms{current_sample} = file2matrix(sample_filename);
        
        % Extract feature for this sample
        features(file_id,:) = mean(palms{current_sample});
    end
%     toc;
end

save(['output' filesep 'features.mat'], 'features');
toc;