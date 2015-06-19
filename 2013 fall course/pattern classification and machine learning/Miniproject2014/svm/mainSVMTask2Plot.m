function mainSVMTask2Plot()

kkt=load(['task2-kkt.txt']);
svm=load(['task2-svm.txt']);

n=size(kkt);
size(svm);

x=[1:n];
x=20.*[1:n];

h1=figure(1);

plot(x,svm,'-xk');
hold on;
%xlim([0.0 80]);
xlabel('Iteraion number (every 20 SMO steps )');
ylabel('SVM criterion');
title('SVM criterion ');
set(findall(gcf,'type','text'),'fontSize',14,'fontWeight','bold');
set(gca,'FontSize',12)
grid on;
saveTightFigure(h1,'C:\Users\guo\2013 fall course\pattern classification and machine learning\report\project-rep\figs\task2-1.pdf');

h2=figure(2);

tkkt=log(kkt);

plot(x,tkkt,'-xk');
hold on;
%xlim([0.0 80]);
xlabel('Iteraion number (every 20 SMO steps )');
ylabel('KKT violations');
title('KKT condition');
set(findall(gcf,'type','text'),'fontSize',14,'fontWeight','bold');
set(gca,'FontSize',12)
grid on;
saveTightFigure(h2,'C:\Users\guo\2013 fall course\pattern classification and machine learning\report\project-rep\figs\task2-2.pdf');