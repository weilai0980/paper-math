%% Plot graphs
figure,
subplot(1,2,1);
plot(1:N,training_error_3and5),hold on;
plot(1:N,validation_error_3and5,'r'),hold on;
plot(1:N,mean_classifier_3and5,'g'),hold off;
title(['The Error of 3&5 subtask, '...
    'h1=',num2str(h1_3and5) ...
    ', eta=',num2str(eta_3and5)...
    ', mu=',num2str(mu_3and5)]);
legend('Training logistic error','Validation logistic error','Zero/one error');
xlabel('Iteration'),ylabel('Error');

subplot(1,2,2);
plot(1:N,training_error_4and9),hold on;
plot(1:N,validation_error_4and9,'r'),hold on;
plot(1:N,mean_classifier_4and9,'g'),hold off;
title(['The Error of 4&9 subtask, '...
    'h1=',num2str(h1_4and9) ...
    ', eta=',num2str(eta_4and9)...
    ', mu=',num2str(mu_4and9)]);
legend('Training logistic error','Validation logistic error','Zero/one error');
xlabel('Iteration'),ylabel('Error');

%% Plot graphs
figure
subplot(1,2,1);
plot(1:length(final_c_3and5),final_c_3and5);
title('The error on the test set of the final classifier given by t*a(2) for 3&5')
xlabel('Number of patterns'),ylabel('t*a(2)');

std_3and5=std(final_c_3and5);

subplot(1,2,2);
plot(1:length(final_c_4and9),final_c_4and9);
title('The error on the test set of the final classifier given by t*a(2) for 4&9');
xlabel('Number of patterns'),ylabel('t*a(2)');

std_4and9=std(final_c_4and9);