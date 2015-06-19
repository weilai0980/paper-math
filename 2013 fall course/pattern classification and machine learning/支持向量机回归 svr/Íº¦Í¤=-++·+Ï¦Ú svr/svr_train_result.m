function [ ] = svr_train_result(  )
   global y;
   global row
   global epsilon
   train_result = zeros(row,3);
   for i = 1:row
       train_result(i,1) = svr_learned_func(i);
   end
   train_result(:,2) = y(1:row,1)+epsilon;
   train_result(:,3) = y(1:row,1)-epsilon;
   save svr_train_result 'train_result';
   subplot(2,1,1);
   plot(train_result);
end

