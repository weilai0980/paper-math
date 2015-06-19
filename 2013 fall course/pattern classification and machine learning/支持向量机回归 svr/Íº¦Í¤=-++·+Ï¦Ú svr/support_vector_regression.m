function [ ] = support_vector_regression(  )
    clc,clear;
    tic
    global C
    global row
    global alpha  
    global b
    global error_cache
    fprintf('intial the svr\n');
    svr_intial();
    fprintf('finish the intialization\n');
    numchanged = 0;
    examineall = 1;
    count=0;
    while ( numchanged > 0||examineall ~= 0)
        count=count+1;
        numchanged = 0;
        startpoint = ceil(mod( 2*row, rand(1) * 2*row ));
        
        if examineall~= 0 % you have examine of the x
            fprintf('#%d : you have to examine all of the x\n',count);
            for i = startpoint:2*row
%                 fprintf('i = %d,numchanged = %d\n',i,numchanged);
                numchanged = numchanged + svr_ExamineExample( i);
            end
            for i = 1:startpoint - 1
%                 fprintf('i = %d,numchanged = %d\n',i,numchanged);
                numchanged = numchanged + svr_ExamineExample( i);
            end
        else
            fprintf('#%d : you should examine the sv of the x\n',count);
            for i = startpoint:2*row
                if alpha(i)~=0 && alpha(i)~=C
%                     fprintf('i = %d,numchanged = %d\n',i,numchanged);
                    numchanged = numchanged + svr_ExamineExample( i);
                end
            end
            for i = 1:startpoint - 1
                if alpha(i)~=0 && alpha(i)~=C
%                     fprintf('i = %d,numchanged = %d\n',i,numchanged);
                    numchanged = numchanged + svr_ExamineExample( i);
                end
            end
        end
        
         if examineall == 1
            examineall = 0;
        else if numchanged == 0
                examineall = 1;
            end
        end
    end
    svr_train_result();
    svr_test_result();
    svr_count_sv()
    save support_vector_regression 'alpha' 'b' 'error_cache';
    toc
end

