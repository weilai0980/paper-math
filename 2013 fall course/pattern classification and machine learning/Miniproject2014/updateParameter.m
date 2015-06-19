function [ new_parameter, new_update ] =...
    updateParameter( old_parameter, grad, previous_update, eta, mu)

% The new update is calculated for each weight and bias

new_update.w1    = -eta.*(1-mu).*grad.w1    + mu.*previous_update.w1;
new_update.b1    = -eta.*(1-mu).*grad.b1    + mu.*previous_update.b1;
new_update.w2    = -eta.*(1-mu).*grad.w2    + mu.*previous_update.w2;
new_update.b2    = -eta.*(1-mu).*grad.b2    + mu.*previous_update.b2;

% The new values of the parameters are calculated
new_parameter.w1    = old_parameter.w1    + new_update.w1;
new_parameter.b1    = old_parameter.b1    + new_update.b1;
new_parameter.w2    = old_parameter.w2    + new_update.w2;
new_parameter.b2    = old_parameter.b2    + new_update.b2;

end