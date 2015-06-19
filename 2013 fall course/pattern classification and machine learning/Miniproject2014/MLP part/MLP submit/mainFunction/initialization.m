function [ parameter, previous_update ] = initialization ( dimension )

% Dimensions of input layer and hidden layers
d=dimension.d;
h1=dimension.h1;

% Weights for the first hidden layer (mean=0, variance=1/d)
sd1=1/sqrt(d); % sqrt of variance
parameter.w1=normrnd(0,sd1,2*h1,d); % w1_L
parameter.b1=normrnd(0,sd1,2*h1,1); % b1_L

% Weights for the output layer (mean=0, variance=1/H2 or 1)
sd2=1/sqrt(h1); % sqrt of variance for L&R
parameter.w2=normrnd(0,sd2,h1,1); % w2_L
parameter.b2=normrnd(0,sd2,1,1); % b2_L

% Weights for the first hidden layer
previous_update.w1=zeros(2*h1,d); % w1_L
previous_update.b1=zeros(2*h1,1); % b1_L

% Weights for the output layer
previous_update.w2=zeros(h1,1);
previous_update.b2=zeros(1,1);

end