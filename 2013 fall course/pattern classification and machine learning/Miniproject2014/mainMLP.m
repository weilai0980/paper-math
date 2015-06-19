% Main MLP
%% Load the training dataset
load(['Normalized Data/','data_3and5.mat'],'trainingdata_3and5');

%% Split training set and validation set
ratio=1/3;
[ training_data, validation_data, training_label, validation_label ] ...
    =splitTrainingValidationSets(trainingdata_3and5,ratio);
display('Training and Validation Sets are splited')

%% Parameters
% Number of layers
h1=200;

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

training_error=zeros(1,N);
validation_error=zeros(1,N);

%% Learning MLP
for i=1:N
    
    % Choose random input point
    random_stoc=randperm(dimension.n);
    random=random_stoc(1);
    
    % Input used to calculate gradient
    x=training_data(random,:);
    t=training_label(random);
    
    % Gradient of error
    grad=gradient(x,t,parameter);
    [parameter,previous_update]=...
        updateParameter(parameter,grad,previous_update,eta,mu);

    % Calculate and store error for training and validation set
    [~,training_error(i),~]...
        =MLPErrorOverDataset(training_data,training_label,parameter);
    [~,validation_error(i),~]...
        =MLPErrorOverDataset(validation_data,validation_label,parameter);
    
end

%% Plot graphs
figure
plot(1:N,training_error),hold on
plot(1:N,validation_error,'r'),hold off
title(['Logistic Error for Training and Validation Sets, '...
    'h1=',num2str(h1) ...
    ', eta=',num2str(eta)...
    ', mu=',num2str(mu)])
legend('Training Error','Validation Error')
xlabel('Iteration'),ylabel('Logistic Error')
