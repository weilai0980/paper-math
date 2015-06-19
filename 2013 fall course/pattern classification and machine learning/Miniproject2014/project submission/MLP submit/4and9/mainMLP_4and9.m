% Main MLP choosing the parameters from 'modelEvaluation.m'
%% Load the training dataset
load(['Normalized Data/','data_4and9.mat'],'trainingdata_4and9');

%% Split training set and validation set
ratio=1/3;
[ training_data_4and9, validation_data_4and9, training_label_4and9, validation_label_4and9 ] ...
    =splitTrainingValidationSets(trainingdata_4and9,ratio);
display('Training and Validation Sets are splited')

%% Parameters
% Number of layers
h1_4and9=70;

eta_4and9=0.01;      % learning rate
mu_4and9=0.3;       % momentum term

% Number of iterations
N=1000;

% Number of patterns for training set
dimension.n=size(training_data_4and9,1);
dimension.d=size(training_data_4and9,2);

% Layer dimensions
dimension.h1=h1_4and9;

%% Initialize parameters
[parameter_4and9, previous_update] = initialization(dimension);

training_error_4and9=zeros(1,N);
validation_error_4and9=zeros(1,N);

%% Learning MLP
for i=1:N
    
    % Choose random input point
    random_stoc=randperm(dimension.n);
    random=random_stoc(1);
    
    % Input used to calculate gradient
    x=training_data_4and9(random,:);
    t=training_label_4and9(random);
    
    % Gradient of error
    grad=gradient(x,t,parameter_4and9);
    [parameter_4and9,previous_update]=...
        updateParameter(parameter_4and9,grad,previous_update,eta_4and9,mu_4and9);

    % Calculate and store error for training and validation set
    [~,training_error_4and9(i),a2_4and9]...
        =MLPErrorOverDataset(training_data_4and9,training_label_4and9,parameter_4and9);
    [~,validation_error_4and9(i),~]...
        =MLPErrorOverDataset(validation_data_4and9,validation_label_4and9,parameter_4and9);

    c_4and9(i,:)=training_label_4and9'.*a2_4and9;
    
end

%% Misclassified data
for i=1:N
    for j=1:length(c_4and9)
        if(c_4and9(i,j)<=0)
            classifier_4and9(i,j)=1;
            largest_negative_4and9(i)=min(c_4and9(i,:));
            close_to_zero_4and9(i)=-min(abs(c_4and9(i,:)));
        else
            classifier_4and9(i,j)=0;
        end
    end
    mean_classifier_4and9(i)=mean(classifier_4and9(i,:));
end

%% Plot graphs
figure
plot(1:N,training_error_4and9),hold on
plot(1:N,validation_error_4and9,'r'),hold on
plot(1:N,mean_classifier_4and9,'g'),hold off
title(['Logistic Error for Training and Validation Sets, '...
    'h1=',num2str(h1_4and9) ...
    ', eta=',num2str(eta_4and9)...
    ', mu=',num2str(mu_4and9)])
legend('Training Error','Validation Error','Zero/one error')
xlabel('Iteration'),ylabel('Logistic Error')


%% Plot graphs
figure
plot(1:N,mean_classifier_4and9),
title(['Zero/one error for digits 4&9, '...
    'h1=',num2str(h1_4and9) ...
    ', eta=',num2str(eta_4and9)...
    ', mu=',num2str(mu_4and9)])
xlabel('Iteration'),ylabel('Error')
