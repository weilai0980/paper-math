% Performance Evaluation using the test set
%% Load the training dataset
load(['Normalized Data/','data_4and9.mat'],'testdata_4and9');

test_data_4and9=testdata_4and9.normdata;
test_label_4and9=testdata_4and9.label;

% Calculate the test error
[~,test_error_4and9,a2_test_4and9]=MLPErrorOverDataset(test_data_4and9,test_label_4and9,parameter);
final_c_4and9=test_label_4and9'.*a2_test_4and9;

% Misclassified data
for i=1:length(final_c_4and9)
    if(final_c_4and9(i)<=0)        
        final_classifier_4and9(i)=1;
        final_largest_negative_4and9=min(final_c_4and9);     
        final_close_to_zero_4and9=-min(abs(final_c_4and9));
    else
        final_classifier_4and9(i)=0;
    end
        
end
    mean_final_classifier_4and9=mean(final_classifier_4and9);
    
%% Plot graphs
figure
plot(1:length(final_c_4and9),final_c_4and9);
title('The error on the test set of the final classifier given by t*a(2) for 4&9')
xlabel('Iteration'),ylabel('t*a(2)')

std_4and9=std(final_c_4and9);