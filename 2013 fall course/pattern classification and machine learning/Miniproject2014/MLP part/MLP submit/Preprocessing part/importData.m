function [ trainingdata, testdata ] = importdata( path_mat_file )

% This function imports the raw datasets and saves them in structs.

%% Load the mat file
load(path_mat_file) %'mp_3-5_data.mat'

%% Save the training data in a struct
trainingdata.data=Xtrain;
trainingdata.label=Ytrain;

%% Save the test data in a struct
testdata.data=Xtest;
testdata.label=Ytest;

end