% Model Evaluation
%% Parameters
H1=10:10:100;
ETA=[0.01,0.03,0.1,0.3,1,3,9];
MU=0:.1:0.9;

N=50;

%% Load the training dataset
load(['Normalized Data/','data_3and5.mat'],'trainingdata_3and5');

%% Split training set and validation set
ratio=1/3;
[ training_data_3and5, validation_data_3and5, training_label_3and5, validation_label_3and5 ] ...
    =splitTrainingValidationSets(trainingdata_3and5,ratio);
display('Training and Validation Sets are splited')

%% Store error values for the training and validation sets
training_error_choose_3and5=zeros(length(H1),length(ETA),length(MU),N);
validation_error_choose_3and5=zeros(length(H1),length(ETA),length(MU),N);

% Number of patterns for training set
dimension.n=size(training_data_3and5,1);
dimension.d=size(training_data_3and5,2);

%% Model Selection
for index_h1=1:length(H1)
    h1_3and5=H1(index_h1);
   
    %% Layer dimensions
    dimension.h1=h1_3and5;
        
    for index_eta=1:length(ETA)
        eta_3and5=ETA(index_eta);
            
        for index_mu=1:length(MU)
            mu_3and5=MU(index_mu);
                
            %% Initialize parameters
            [parameter_3and5, previous_update] = initialization(dimension);

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
                [~,training_error_choose_3and5(index_h1,index_eta,index_mu,i),~]...
                    =MLPErrorOverDataset(training_data_3and5,training_label_3and5,parameter_3and5);
                [~,validation_error_choose_3and5(index_h1,index_eta,index_mu,i),~]...
                    =MLPErrorOverDataset(validation_data_3and5,validation_label_3and5,parameter_3and5);
    
                [h1_3and5,eta_3and5,mu_3and5,i]
    
            end
        end
    end
end

%% Choose eta,mu observe h1
eta_3and5=0.01;
mu_3and5=0.5;

Training_error_h1_3and5=squeeze(training_error_choose_3and5(:,ETA==eta_3and5,MU==mu_3and5,:));
Validation_error_h1_3and5=squeeze(validation_error_choose_3and5(:,ETA==eta_3and5,MU==mu_3and5,:));

figure,
subplot(2,2,1);
plot(1:N,Training_error_h1_3and5(1:2:9,:)),hold on
plot(1:N,Validation_error_h1_3and5(1:2:9,:),'r'),hold off;
title(['Different h1, '...
    'mu=',num2str(mu_3and5),', eta=',num2str(eta_3and5)]);
legend('Training Error','Validation Error');
xlabel('Iteration'),ylabel('Logistic Error');
legend('Tr10','Tr30','Tr50','Tr70','Tr90','Va10','Va30','Va50','Va70','Va90');
                               
%% Choose h1,eta, observe mu
h1_3and5=70;
eta_3and5=0.01;

Validation_error_mu_3and5=squeeze(validation_error_choose_3and5(H1==h1_3and5,ETA==eta_3and5,:,:));

subplot(2,2,2);
plot(1:N,Validation_error_mu_3and5);
title(['Different mu, '...
    'h1=',num2str(h1_3and5),', eta=',num2str(eta_3and5)]);
xlabel('Iteration'),ylabel('Logistic Error');
legend('0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9')

%% Choose h1,mu, observe eta
h1_3and5=70;
mu_3and5=0.3;

Validation_error_eta_3and5=squeeze(validation_error_choose_3and5(H1==h1_3and5,:,MU==mu_3and5,:));


subplot(2,2,3);
plot(1:N,Validation_error_eta_3and5(1:4,:));
title(['Different eta, '...
    'h1=',num2str(h1_3and5),', mu=',num2str(mu_3and5)]);
xlabel('Iteration'),ylabel('Logistic Error');
legend('0.01','0.03','0.1','0.3');

subplot(2,2,4);
plot(1:N,Validation_error_eta_3and5);
title(['Different eta, '...
    'h1=',num2str(h1_3and5),', mu=',num2str(mu_3and5)]);
xlabel('Iteration'),ylabel('Logistic Error');
legend('0.01','0.03','0.1','0.3','1','3','9');

%% See the effects of different (eta,mu) pairs with H1 set
h1_3and5=70;
eta_3and5=0.01;
mu_3and5=0.3;

Training_error_3and5=squeeze(training_error_choose_3and5(H1==h1_3and5,ETA==eta_3and5,MU==mu_3and5,:));
Validation_error_3and5=squeeze(validation_error_choose_3and5(H1==h1_3and5,ETA==eta_3and5,MU==mu_3and5,:));

figure,plot(1:N,Training_error_3and5),hold on
plot(1:N,Validation_error_3and5,'r'),hold off
title(['Logistic Error,' 'h1=',num2str(h1_3and5), ...
    'eta=',num2str(eta_3and5),', mu=',num2str(mu_3and5)])
xlabel('Iteration'),ylabel('Logistic Error')
legend('Training Error','Validation Error')
