
path_main='/';
%% Load the datasets for 3and5 binary classification
%path_dataset_3and5='mp_3-5_data.mat';
%[trainingdata_3and5,testdata_3and5]=importData( path_dataset_3and5);
  
%display('Datasets are loaded for 3and5 binary classification')

%[trainingdata_3and5,testdata_3and5]=normalization(trainingdata_3and5,testdata_3and5);
%display('Training and test sets for 3and5 binay classification are normalized')

%mkdir('Normalized Data')
%save(['Normalized Data/','data_3and5.mat'], 'trainingdata_3and5', 'testdata_3and5');
%display('The variables are saved for 3and5 binary classification')

%% Load the datasets for 4and9 binary classification
path_dataset_4and9='mp_4-9_data.mat';
[trainingdata_4and9,testdata_4and9]...
    =importData(path_dataset_4and9);

clear path_dataset_4and9
display('Datasets are loaded for 4and9 binary classification')
[trainingdata_4and9,testdata_4and9]=normalization(trainingdata_4and9,testdata_4and9);
display('Training and test sets for 3and5 binay classification are normalized')
mkdir('Normalized Data')
save(['Normalized Data/','data49.mat'], 'trainingdata_4and9', 'testdata_4and9');
display('The variables are saved for 4and9 binary classification')