%% Model Evaluation
training_error=squeeze(Err_Tra(1,1,1,1,1:10));
validation_error=squeeze(Err_Val(1,1,1,1,1:10));

figure,plot(1:10,training_error),hold on
plot(1:10,validation_error,'r'),hold off

%% Choose H1,H2, eta, see the effect of mu
h1=50;
eta=0.01;

training_error=squeeze(Err_Tra(H1_==h1,H2_==H2,eta_==eta,:,end));
validation_error=squeeze(Err_Val(H1_==h1,H2_==H2,eta_==eta,:,end));

figure,plot(1:10,training_error),hold on
plot(1:10,validation_error,'r'),hold off

%% See the effects of different (eta,mu) pairs with H1 set
h1=31;
H2=31;

eta=10;
mu=10;

training_error=squeeze(Err_Tra(H1_==h1,H2_==H2,eta_==eta,mu_==mu,:));
validation_error=squeeze(Err_Val(H1_==h1,H2_==H2,eta_==eta,mu_==mu,:));

figure,plot(1:10,training_error),hold on
plot(1:10,validation_error,'r'),hold off
title(['Logistic Error Over Dataset for Training and Validation Sets, '...
    'eta=',num2str(eta),', mu=',num2str(mu)])
xlabel('Iteration'),ylabel('Logistic Error')
legend('Training Error','Validation Error')
