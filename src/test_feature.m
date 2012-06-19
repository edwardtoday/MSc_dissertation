%% Load features
load(['output' filesep 'features.mat']);

[total,~] = size(features);

%% Split into training set and testing set
training_id=unique([
    1:10:total
    2:10:total
    3:10:total
    4:10:total
    5:10:total
    6:10:total
    ]);

trainingset = features(training_id,:);

test_id=unique([
    7:10:total
    8:10:total
    9:10:total
    10:10:total
    ]);

testingset = features(test_id,:);

%% Find match for each test input
nearest_id = knnsearch(trainingset, testingset, 'k', 10);

%% Interpret the match to person
[total_training,~] = size(trainingset);
training_sample_per_person = total_training / total * 10;
nearest_person = ceil(nearest_id/training_sample_per_person);

%% Check performance
[total_testing,~] = size(testingset);
testing_sample_per_person = total_testing / total * 10;
for i = 1:total_testing
    correct(i) = eq(nearest_person(i),ceil(i/testing_sample_per_person));
end
correct = correct';

accuracy = sum(correct)/total_testing