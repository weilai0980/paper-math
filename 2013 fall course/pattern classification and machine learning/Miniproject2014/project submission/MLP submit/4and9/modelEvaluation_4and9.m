% Model Evaluation
%% Parameters
H1=10:10:100;
ETA=[0.01,0.03,0.1,0.3,1,3,9];
MU=0:.1:0.9;

N=50;

%% Load the training dataset
load(['Normalized Data/','data_4and9.mat'],'trainingdata_4and9');

%% Split training set and validation set
ratio=1/3;
[ training_data_4and9, validation_data_4and9, training_label_4and9, validation_label_4and9 ] ...
    =splitTrainingValidationSets(trainingdata_4and9,ratio);
display('Training and Validation Sets are splited')

%% Store error values for the training and validation sets
training_error_choose_4and9=zeros(length(H1),length(ETA),length(MU),N);
validation_error_choose_4and9=zeros(length(H1),length(ETA),length(MU),N);

% Number of patterns for training set
dimension.n=size(training_data_4and9,1);
dimension.d=size(training_data_4and9,2);

%% Model Selection
for index_h1=1:length(H1)
    h1_4and9=H1(index_h1);
   
    %% Layer dimensions
    dimension.h1=h1_4and9;
        
    for index_eta=1:length(ETA)
        eta_4and9=ETA(index_eta);
            
        for index_mu=1:length(MU)
            mu_4and9=MU(index_mu);
                
            %% Initialize parameters
            [parameter_4and9, previous_update] = initialization(dimension);

            %% Learning MLP
            for i=1:N
    
                % Choose random input point
                random=randperm(dimension.n);
                random=random(1);
    
                % Input used to calculate gradient
                x=training_data_4and9(random,:);
                t=training_label_4and9(random);
    
                % Gradient of error
                grad=gradient(x,t,parameter_4and9);
                [parameter_4and9,previous_update]=...
                    updateParameter(parameter_4and9,grad,previous_update,eta_4and9,mu_4and9);

                % Calculate and store error for training and validation set
                [~,training_error_choose_4and9(index_h1,index_eta,index_mu,i),~]...
                    =MLPErrorOverDataset(training_data_4and9,training_label_4and9,parameter_4and9);
                [~,validation_error_choose_4and9(index_h1,index_eta,index_mu,i),~]...
                    =MLPErrorOverDataset(validation_data_4and9,validation_label_4and9,parameter_4and9);
    
                [h1_4and9,eta_4and9,mu_4and9,i]
    
            end
        end
    end
end

%% Choose eta,mu observe h1
eta_4and9=0.01;
mu_4and9=0.5;

Training_error_h1_4and9=squeeze(training_error_choose_4and9(:,ETA==eta_4and9,MU==mu_4and9,:));
Validation_error_h1_4and9=squeeze(validation_error_choose_4and9(:,ETA==eta_4and9,MU==mu_4and9,:));

figure,
subplot(2,2,1);
plot(1:N,Training_error_h1_4and9(1:2:9,:)),hold on
plot(1:N,Validation_error_h1_4and9(1:2:9,:),'r'),hold off;
title(['Different h1, '...
    'mu=',num2str(mu_4and9),', eta=',num2str(eta_4and9)]);
legend('Training Error','Validation Error');
xlabel('Iteration'),ylabel('Logistic Error');
legend('Tr10','Tr30','Tr50','Tr70','Tr90','Va10','Va30','Va50','Va70','Va90');
                               
%% Choose h1,eta, observe mu
h1_4and9=70;
eta_4and9=0.01;

Validation_error_mu_4and9=squeeze(validation_error_choose_4and9(H1==h1_4and9,ETA==eta_4and9,:,:));

subplot(2,2,2);
plot(1:N,Validation_error_mu_4and9);
title(['Different mu, '...
    'h1=',num2str(h1_4and9),', eta=',num2str(eta_4and9)]);
xlabel('Iteration'),ylabel('Logistic Error');
legend('0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9')

%% Choose h1,mu, observe eta
h1_4and9=70;
mu_4and9=0.3;

Validation_error_eta_4and9=squeeze(validation_error_choose_4and9(H1==h1_4and9,:,MU==mu_4and9,:));


subplot(2,2,3);
plot(1:N,Validation_error_eta_4and9(1:4,:));
title(['Different eta, '...
    'h1=',num2str(h1_4and9),', mu=',num2str(mu_4and9)]);
xlabel('Iteration'),ylabel('Logistic Error');
legend('0.01','0.03','0.1','0.3');

subplot(2,2,4);
plot(1:N,Validation_error_eta_4and9);
title(['Different eta, '...
    'h1=',num2str(h1_4and9),', mu=',num2str(mu_4and9)]);
xlabel('Iteration'),ylabel('Logistic Error');
legend('0.01','0.03','0.1','0.3','1','3','9');

%% See the effects of different (eta,mu) pairs with H1 set
h1_4and9=70;
eta_4and9=0.01;
mu_4and9=0.3;

Training_error_4and9=squeeze(training_error_choose_4and9(H1==h1_4and9,ETA==eta_4and9,MU==mu_4and9,:));
Validation_error_4and9=squeeze(validation_error_choose_4and9(H1==h1_4and9,ETA==eta_4and9,MU==mu_4and9,:));

figure,plot(1:N,Training_error_4and9),hold on
plot(1:N,Validation_error_4and9,'r'),hold off
title(['Logistic Error,' 'h1=',num2str(h1_4and9), ...
    'eta=',num2str(eta_4and9),', mu=',num2str(mu_4and9)])
xlabel('Iteration'),ylabel('Logistic Error')
legend('Training Error','Validation Error')
