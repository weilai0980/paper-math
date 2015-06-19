% Preprocess the data
%% The directory path containing the dataset
path_main='/Users/alonesec/Desktop/PCML'; %% CHANGE THIS!

%% Load the datasets for 3and5 binary classification
path_dataset_3and5='/mnist/mp_3-5_data.mat';
[trainingdata_3and5,testdata_3and5]...
    =importData([path_main path_dataset_3and5]);
clear path_dataset_3and5
display('Datasets are loaded for 3and5 binary classification')

%% Normalize training and test sets for 3and5 binary classification
[trainingdata_3and5,testdata_3and5]=normalization(trainingdata_3and5,testdata_3and5);
display('Training and test sets for 3and5 binay classification are normalized')

%% Save the normalized matrices and new labels
mkdir('Normalized Data')
save(['Normalized Data/','data_3and5.mat'], 'trainingdata_3and5', 'testdata_3and5');
display('The variables are saved for 3and5 binary classification')

%% Load the datasets for 4and9 binary classification
path_dataset_4and9='/mnist/mp_4-9_data.mat';
[trainingdata_4and9,testdata_4and9]...
    =importData([path_main path_dataset_4and9]);
clear path_dataset_4and9
display('Datasets are loaded for 4and9 binary classification')

%% Normalize training and test sets for 3and5 binary classification
[trainingdata_4and9,testdata_4and9]=normalization(trainingdata_4and9,testdata_4and9);
display('Training and test sets for 3and5 binay classification are normalized')

%% Save the normalized matrices and new labels
mkdir('Normalized Data')
save(['Normalized Data/','data_4and9.mat'], 'trainingdata_4and9', 'testdata_4and9');
display('The variables are saved for 4and9 binary classification')