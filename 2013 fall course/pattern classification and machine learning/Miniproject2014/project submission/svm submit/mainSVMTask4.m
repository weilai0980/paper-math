function mainSVMTask4()


    
     %0.2095 0
   
    
    %1.1046  0.8538
   


data = [0.2095,0, 1.1046, 0.8538];
h1=figure(1)
b = bar(data);
ch = get(b,'children');
grid on;
%set(ch,'FaceVertexCData',[4;2;3;1;5;6])

%set(gca,'XTickLabel',{'Sina all','Sina travel','S&S','x','mi'})
%set(gca,'XTickLabel',{'Sina all','Sina travel','S&S','STM','CHI','MI'})
set(gca,'XTickLabel',{'MLP on training data','SVM on training data','MLP on test data','SVM on test data'})
    
%xlabel('Iteraion number (every 20 SMO steps )');
ylabel('Zero/one error (%)');
saveTightFigure(h1,'C:\Users\guo\2013 fall course\pattern classification and machine learning\report\project-rep\figs\task4.pdf');

