function [ trainingdata, testdata ] = normalization(trainingdata,testdata)
%Usage: Normalize the given data
%Inputs: trainingdata and testdata
%Outputs: normalized trainingdata and normalized testdata

% Normalize training data
[trainingdata.normdata,max,min]...
    =normalizeMatrix(trainingdata.data);

% Normalize test data
testdata.normdata...
    =normalizeMatrix(testdata.data,max,min);

end