% Performance Evaluation using the test set
%% Load the training dataset
load(['Normalized Data/','data_3and5.mat'],'testdata_3and5');

test_data_3and5=testdata_3and5.normdata;
test_label_3and5=testdata_3and5.label;

% Calculate the test error
[~,test_error_3and5,a2_test_3and5]=MLPErrorOverDataset(test_data_3and5,test_label_3and5,parameter_3and5);
final_c_3and5=test_label_3and5'.*a2_test_3and5;

% Misclassified data
for i=1:length(final_c_3and5)
    if(final_c_3and5(i)<=0)        
        final_classifier_3and5(i)=1;
        final_largest_negative_3and5=min(final_c_3and5);     
        final_close_to_zero_3and5=-min(abs(final_c_3and5));
    else
        final_classifier_3and5(i)=0;
    end
        
end
    mean_final_classifier_3and5=mean(final_classifier_3and5);
    
%% Plot graphs
figure
plot(1:length(final_c_3and5),final_c_3and5);
title('The error on the test set of the final classifier given by t*a(2)')
xlabel('Iteration'),ylabel('t*a(2)')

std_3and=std(final_c_3and5);

figure
subplot(1,2,1);
plot(1:N,largest_negative_3and5);
title('The largest negative t*a(2)');
xlabel('Iteration'),ylabel('t*a(2)');

subplot(1,2,2);
plot(1:N,close_to_zero_3and5);
title('t*a(2) close to 0');
xlabel('Iteration'),ylabel('t*a(2)');
xlabel('Iteration'),ylabel('t*a(2)')