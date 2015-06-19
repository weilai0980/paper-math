function [ training_data, validation_data, training_label, validation_label ] = ...
    splitTrainingValidationSets( trainingdata, ratio)
%Usage: Split training and validation sets
%Input: Training data and the ratio
%Input: The new training and validation dataset and label after spliting.

%Create new variable
training_x=trainingdata.normdata;
training_t=trainingdata.label;

% Number of patterns
n_patterns=size(training_x,1);

% Pattern numbers are mixed
random=(randperm(n_patterns))';

% Training and validation pattern numbers
training_random=random(1:floor(n_patterns*(1-ratio)));
validation_random=random(floor(n_patterns*(1-ratio))+1:end);

% Training feature matrix and labels
training_data=training_x(training_random,:);
training_label=training_t(training_random);

% Validation feature matrix and labels
validation_data=training_x(validation_random,:);
validation_label=training_t(validation_random);

end