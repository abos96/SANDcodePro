%% 

close all
clear all
clc
msc=MEA120_lookuptable;
[TCM,path] = uigetfile('pwd', 'Select the respective Threshold Matrix');
cd(path);
load(TCM);
cd ..
d = dir;
start = pwd;
control = 0;
for k = 3:length(d)
    if strfind(d(k).name,'PeakDetectionMAT') & control == 0 
        cd(d(k).name);
        date = d(3).name(1:8);
        phase = dir;
        cd(phase(3).name);
        exp = dir;
        check = exp(3).name(end-6:end-4);
        control = 1;
    end
end
chars =  regexp(check,'([A-Z]+)','match');
[electrodesProp , labels]=WhosConnection(CC);
%% add MFR
[MFR,path] = uigetfile('pwd', 'Select the respective MFR file');
cd(path)
load(MFR)
electrodesProp(:,end+1)=0;
s=size(electrodesProp);
for i=1:length(mfr_table)
    electrodesProp(str2double(msc(find(strcmp(mfr_table(i,1),msc(:,1))),2)),s(2))=str2double(mfr_table(i,2));
end
%% add MBR
[MBR,path] = uigetfile('pwd', 'Select the respective MeanStatReportBURST file');
cd(path)
load(MBR)
s=size(electrodesProp);
electrodesProp(:,s(2)+1:24)=0;
electrodesProp(mat_statistic_burst(:,1),15:end)=mat_statistic_burst(:,2:end);
%% get connection lengths
coord=load('coordMEA120.mat');
coordinate=coord.MEA120_graph;
coordinate(:,2)=abs(coordinate(:,2)-13);
coordinate=coordinate; %[micron]
[d_glut , d_gaba, d_tot ]=EUdistTot(CC,coordinate);
x=[d_glut ; d_gaba; d_tot];
g1 = repmat({'GLUT'},length(d_glut),1);
g2 = repmat({'GABA'},length(d_gaba),1);
g3 = repmat({'ALL'},length(d_tot),1);
g = [g1; g2;g3];
figure
boxplot(x,g)
ylabel('Length [micrometri]')
title('Connection Lengths')
%% tot lengths
xtot=[];
ytot=[];
xexc=[];
yexc=[];
xinh=[];
yinh=[];
for i=1:6

[MBR,path] = uigetfile('pwd', strcat('Select the matrix: ',string(i),' of 6'));
cd(path)
load(MBR)
[d_glut , d_gaba, d_tot ]=EUdistTot(CC,coordinate);

if i<=3
xtot=[xtot ; d_tot];
else
ytot=[ytot;d_tot];
end

if i<=3
xexc=[xexc ; d_glut];
else
yexc=[yexc;d_glut];

end

if i<=3
xinh=[xinh; d_gaba];
else
yinh=[yinh;d_gaba];
end

end

g1 = repmat({'CX'},length(xtot),1);
g2 = repmat({'HP'},length(ytot),1);
X=[xtot;ytot];
g = [g1; g2];
figure
boxplot(X,g)
ylabel('Length [micrometri]')
title('Connection Lengths')

g1exc = repmat({'CX exc'},length(xexc),1);
g2exc = repmat({'HP exc'},length(yexc),1);
Xexc=[xexc;yexc];
gexc = [g1exc; g2exc];
figure
boxplot(Xexc,gexc)
ylabel('Length [micrometri]')
title('Connection Lengths EXC')

g1inh = repmat({'CX inh'},length(xinh),1);
g2inh = repmat({'HP inh'},length(yinh),1);
Xinh=[xinh;yinh];
ginh = [g1inh; g2inh];
figure
boxplot(Xinh,ginh)
ylabel('Length [micrometri]')
title('Connection Lengths INH')
%% labels
labels= {'degree','InDegree','OutDegree', 'Exc','Inh','IN_Exc' ,'IN_Inh', 'OUT_Exc','OUT_Inh', 'd_in_exc',...
             'd_in_inh','d_out_exc','d_out_inh','MFR' ,'mean_percrandspike', 'std_percrandspikes', 'MBR'...
             ,'std(MBR)' ,'spikesxburst', 'std(spikesxburst)', 'burstduration', 'std(burstduration)','IBI', 'std(IBI'};
X=electrodesProp(:,[1 2 3 4 5 6 7 8 9 14 15 16 17 18 19 20 21 22]);

lab= {'degree','InDegree','OutDegree', 'Exc','Inh','IN_Exc','IN_Inh', 'OUT_Exc','OUT_Inh'...
             ,'MFR' ,'mean_percrandspike','std_percrandspike', 'MBR','STD_MBR'...
             ,'spikesxburst', 'std(spikesxburst)', 'burstduration', 'std(burstduration)'};
P=X; 
P(isnan(P))=0;
%% Calcolo PCA
[U,X,S]=pca(zscore(P));
f=sqrt(U(:,1).^2+ U(:,2).^2+ U(:,3).^2);
sortlab=[];
for i=1:length(lab)
    first=find(max(f)==f);
    sortlab=[sortlab lab(first)];
    f(first)=0;
end

figure
bar(1:18,100*S./sum(S))
xlabel('# componenti')
ylabel('%var');
xticklabels(sortlab)

% Lorenz
figure 
plot(1:18,100*cumsum(S)./sum(S))
xlabel('# componenti')
ylabel('%var');
%% Biplot
% figure
% biplot(U([1 2 3 4 5 7 8 9 11 12 14 17 16 18],1:2),'varlabels',cellstr(lab([1 2 3 4 5 7 8 9 11 12 14 17 16 18])))
% title('Sole prime 14 componenti')

figure
h=biplot(U(:,1:3),'Varlabels',cellstr(lab(:)));
title('Tutte le componenti')


% %% Disegno i dati proiettati (score)
% 
% figure
% scatter3(X(:,1),X(:,2),X(:,3))
% axis equal
%% trovo exc e inh
ratio_exc_inh=P(:,8)./P(:,9);
exc=find(ratio_exc_inh>1.5);
inh=find(ratio_exc_inh<0.66);


figure
hold on
scatter3(X(exc,1),X(exc,2),X(exc,3),'r');
axis equal
scatter3( X(inh,1),X(inh,2),X(inh,3),'b');
hold off
%% creo decisore a reti neurale

% Train NN
ratio_exc_inh=P(:,8)./P(:,9);
isexc=find(ratio_exc_inh>=1);
isinh=find(ratio_exc_inh<1);
class=ones(length(isexc),1);
class=[class; zeros(length(isinh),1)];
%Train=P([isexc ;isinh],[1 2 3 4 5 7 8 9 11 12 14 17 16 18]);
Train=X([isexc ;isinh],1:7);
Test=Train(2:2:end,:);
Train=Train(1:2:end,:);
class_train=class(1:2:end);
class_test=class(2:2:end);

%% SVM
SVMModel = fitcsvm(Train,class_train,'ClassNames',{'1','0'},'Standardize',true);
SVMModel = fitPosterior(SVMModel);
[label,score] = predict(SVMModel,Test);
%% calcolare curva ROC
figure
plotroc(class_test',score(:,1)'); %valori veri e probabilità a posteriori di B
[tpr,fpr,th]= roc(class_test',score(:,1)');
% quad comando per calcolare intgrale definito
base = diff(fpr);
auro=sum(base.*tpr(1,1:end-1));
figure
plotconfusion(class_test',str2double(label(:,1)')); % prende la nostra scelta e il valore vero 
%% LDA
Trainz=zscore(Train);
muexc = mean(Trainz(class_train==1,:));
muinh = mean(Trainz(class_train==0,:));
sigmaexc = diag(std(Trainz(class_train==1,:)).^2);
sigmainh = diag(std(Trainz(class_train==0,:)).^2);


nBtr = length(exc);
nMtr = length(inh);

Sw = nBtr*sigmaexc + nMtr*sigmainh;

W = inv(Sw)*(muexc-muinh)';
W = W./sqrt(sum(W.^2));
figure
barh(W)
yticklabels(sortlab(1:7))
