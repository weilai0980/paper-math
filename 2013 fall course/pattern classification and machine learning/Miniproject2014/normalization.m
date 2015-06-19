function [ trainingdata, testdata ] = normalization(trainingdata,testdata)

% Normalize training data
[trainingdata.normdata,max,min]...
    =normalizeMatrix(trainingdata.data);
%[trainingdata.normdata.y,max_y,min_y]...
%    =normalizeFunction(trainingdata.label);

% Normalize test data
testdata.normdata...
    =normalizeMatrix(testdata.data,max,min);
%testdata.normdata.y...
%    =normalizeFunction(testdata.y,max_y,min_y);

end