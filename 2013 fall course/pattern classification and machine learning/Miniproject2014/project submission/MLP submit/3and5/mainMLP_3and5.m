% Main MLP
%% Load the training dataset
load(['Normalized Data/','data_3and5.mat'],'trainingdata_3and5');
display('Datasets are loaded')

%% Split training set and validation set
ratio=1/3;
[ training_data_3and5, validation_data_3and5, training_label_3and5, validation_label_3and5 ] ...
    =splitTrainingValidationSets(trainingdata_3and5,ratio);
display('Training and Validation Sets are splited')

%% Parameters
% Number of layers
h1_3and5=30;

eta_3and5=0.01;      % learning rate
mu_3and5=0.5;       % momentum term

% Number of iterations
N=1000;

% Number of patterns for training set
dimension.n=size(training_data_3and5,1);
dimension.d=size(training_data_3and5,2);

% Layer dimensions
dimension.h1=h1_3and5;

%% Initialize parameters
[parameter_3and5, previous_update] = initialization(dimension);

training_error_3and5=zeros(1,N);
validation_error_3and5=zeros(1,N);

%% Learning MLP
for i=1:N
    
    % Choose random input point
    random=randperm(dimension.n);
    random=random(1);
    
    % Input used to calculate gradient
    x=training_data_3and5(random,:);
    t=training_label_3and5(random);
    
    % Gradient of error
    grad=gradient(x,t,parameter_3and5);
    [parameter_3and5,previous_update]=...
        updateParameter(parameter_3and5,grad,previous_update,eta_3and5,mu_3and5);

    % Calculate and store error for training and validation set
    [~,training_error_3and5(i),a2_3and5]...
        =MLPErrorOverDataset(training_data_3and5,training_label_3and5,parameter_3and5);
    [~,validation_error_3and5(i),~]...
        =MLPErrorOverDataset(validation_data_3and5,validation_label_3and5,parameter_3and5);

    c_3and5(i,:)=training_label_3and5'.*a2_3and5;
    
end

%% Misclassified data
for i=1:N
    for j=1:length(c_3and5)
        if(c_3and5(i,j)<=0)
            classifier_3and5(i,j)=1;
            largest_negative_3and5(i)=min(c_3and5(i,:));
            close_to_zero_3and5(i)=-min(abs(c_3and5(i,:)));
        else
            classifier_3and5(i,j)=0;
        end
    end
    mean_classifier_3and5(i)=mean(classifier_3and5(i,:));
end

%% Plot graphs
figure
plot(1:N,training_error_3and5),hold on
plot(1:N,validation_error_3and5,'r'),hold on
plot(1:N,mean_classifier_3and5,'g'),hold off
title(['The Error of Training and Validation Sets, '...
    'h1=',num2str(h1_3and5) ...
    ', eta=',num2str(eta_3and5)...
    ', mu=',num2str(mu_3and5)])
legend('Training logistic error','Validation logistic error','Zero/one error')
xlabel('Iteration'),ylabel('Error')
