% Debugging (Gradient testing)
%% Load the training dataset
load(['Normalized Data/','data_3and5.mat'],'trainingdata_3and5');

%% Split training set and validation set
ratio=1/3;
[ training_data, validation_data, training_label, validation_label ] ...
    =splitTrainingValidationSets(trainingdata_3and5,ratio);
display('Training and Validation Sets are splited')


%% Create a debugging detaset by downsampling
training_data=imresize(training_data,[size(training_data,1) 64]);
validation_data=imresize(validation_data,[size(validation_data,1) 64]);

%% Parameters
% Number of layers
h1=1;

eta=0.01;   % learning rate
mu=0;       % momentum term

% Number of iterations
N=1000;

% Number of patterns for training set
dimension.n=size(training_data,1);
dimension.d=size(training_data,2);

% Layer dimensions
dimension.h1=h1;

%% Initialize parameters
[parameter, previous_update] = initialization(dimension);
parameter_plus=parameter;
parameter_minus=parameter;
training_error_plus=zeros(1,N);
validation_error_plus=zeros(1,N);
training_error_minus=zeros(1,N);
validation_error_minus=zeros(1,N);

%% Parameters for testing the gradient
epsilon=0.0001;

parameter_plus.w1=parameter.w1+epsilon;
parameter_minus.w1=parameter.w1-epsilon;
parameter_plus.w2=parameter.w2+epsilon;
parameter_minus.w2=parameter.w2-epsilon;

%% Learning MLP
for i=1:N
    
    % Choose random input point
    random_stoc=randperm(dimension.n);
    random=random_stoc(1);
    
    % Input used to calculate gradient
    x=training_data(random,:);
    t=training_label(random);
    
    % Gradient of error
    grad_plus=gradient(x,t,parameter_plus);
    [parameter_plus,previous_update]=...
        updateParameter(parameter_plus,grad_plus,previous_update,eta,mu);

    % Calculate and store error for training and validation set
    [~,training_error_plus(i),~]...
        =MLPErrorOverDataset(training_data,training_label,parameter_plus);
    [~,validation_error_plus(i),~]...
        =MLPErrorOverDataset(validation_data,validation_label,parameter_plus);
    
    % Gradient of error
    grad_minus=gradient(x,t,parameter_minus);
    [parameter_minus,previous_update]=...
        updateParameter(parameter_minus,grad_minus,previous_update,eta,mu);

    % Calculate and store error for training and validation set
    [~,training_error_minus(i),~]...
        =MLPErrorOverDataset(training_data,training_label,parameter_minus);
    [~,validation_error_minus(i),~]...
        =MLPErrorOverDataset(validation_data,validation_label,parameter_minus);
    
end

%% Check debugging

directional_deriv=(training_error_plus-training_error_minus)/(2*epsilon);

figure
plot(1:N,training_error),hold on
plot(1:N,directional_deriv,'r'),hold off
title(['Gradient Testing, '...
    'h1=',num2str(h1) ...
    ', eta=',num2str(eta)...
    ', mu=',num2str(mu)])
legend('Training Error','directional derivatives')
xlabel('Iteration'),ylabel('Logistic Error')
