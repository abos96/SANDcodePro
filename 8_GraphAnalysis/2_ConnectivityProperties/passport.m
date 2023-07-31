clear all
close all
clc

msc=MEA120_lookuptable;
[TCM,path_main] = uigetfile('pwd', 'Select the respective Threshold Matrix');
cd(path_main);
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
%% labels
labels= {'degree','InDegree','OutDegree', 'Exc','Inh','IN_Exc' ,'IN_Inh', 'OUT_Exc','OUT_Inh', 'd_in_exc',...
             'd_in_inh','d_out_exc','d_out_inh','MFR' ,'mean_percrandspike', 'std_percrandspikes', 'MBR'...
             ,'std(MBR)' ,'spikesxburst', 'std(spikesxburst)', 'burstduration', 'std(burstduration)','IBI', 'std(IBI'};
X=electrodesProp(:,[1 2 3 4 5 6 7 8 9 14 15 16 17 18 19 21]);

lab= {'degree','InDegree','OutDegree', 'Exc','Inh','IN_Exc','IN_Inh', 'OUT_Exc','OUT_Inh'...
             ,'MFR' ,'mean_percrandspike','std_percrandspike', 'MBR','STD_MBR'...
             ,'spikesxburst', 'burstduration'};
P=X; 
P(isnan(P))=0;
%% Calcolo PCA
[U,X,S]=pca(zscore(P));

figure
bar(1:16,100*S./sum(S))
xlabel('# componenti')
ylabel('%var');

% Lorenz
figure 
plot(1:16,100*cumsum(S)./sum(S))
xlabel('# componenti')
ylabel('%var');
%% predict
[model,path] = uigetfile('pwd', 'Select the SVM MODEL');
cd(path)
load(model)
[label,score] = predict(SVMModel,X(:,1:7));
%% build graph
CC_bin=CC;
CC_bin(CC_bin ~= 0)=1;
[in out deg]=degrees_dir(CC);
exc_inh=zeros(1,120);
exc_inh(find(score(:,1)>0.75))=1;
exc_inh(find(score(:,2)>0.75))=-1;

unknown = setdiff([1:length(CC)],[find(exc_inh ~= 0)]);

 % If most connections are negative, I consider the node NEGATIVE (-1), if
 % most connection are positive, I consider the node POSITIVE (1). 2 is to
 % identify node with the same number of inhibitory and excitatory
 % connections.


cd(start);
cd(strcat(date,'_ColorElectrode'));
d = dir;
load(d(3).name);

cd(start);
mkdir(strcat(date,'_EXC_INH_Analysis'));
cd(strcat(date,'_EXC_INH_Analysis'));
hub_folder = pwd;




degrees=out;
degrees(unknown)=0;
%degrees(exc_inh ~= 0)=5;
CC(unknown,unknown)=0;
CC_bin(unknown,unknown)=0;
[Graph,HPGABA, CHANNELGABA, CXGABA, ...
          HPGLUT, CHANNELGLUT, CXGLUT] = Graph_EXC_INH(CC_bin, CC,'k',1,2,degrees, exc_inh,color);
cd(hub_folder);
savefig(Graph,strcat('Graph_EXC_INH.fig'))
close(Graph);
%% save inh exc compartment
hetero=1;
if hetero==1
tabComp=table(HPGABA,CHANNELGABA, CXGABA,HPGLUT, CHANNELGLUT, CXGLUT,...
        'VariableNames',{'Hp Gaba' 'Ch Gaba' 'Cx Gaba' 'Hp glut' 'Ch Glut' 'Cx Glut' });
save('tab_number of Neuron','tabComp');
else
    tabComp=table(HPGABA  + CXGABA, HPGLUT + CXGLUT,CHANNELGLUT,CHANNELGABA,...
        'VariableNames',{'Gaba' 'Glut' 'Channels Gaba' 'Channels glut'});
save('tab_number of Neuron','tabComp');
end
% %% build graph
% idx_hub=find(cell2mat(electrodesProp(1,:))>0);
% threshold_hub=mean(cell2mat(electrodesProp(1,:)))+std(cell2mat(electrodesProp(1,:))); 
% hub=find(cell2mat(electrodesProp(1,:))>threshold_hub);
% nohub = setdiff([1:length(CIJ)],[hub]);
% exc_inh=zeros(1,120);
% exc_inh(GLUT_neurons)=1;
% exc_inh(GABA_neurons)=-1;
% exc_inh(nohub)=0;
% 
% cd(start)
% mkdir(strcat(name,'_EXC_INH_Analysis'));
% cd(strcat(name,'_EXC_INH_Analysis'));
% hub_folder = pwd;
% degrees=deg./2;
% degrees(nohub)=0;
% CIJ(nohub,nohub)=0;
% CIJ_bin(nohub,nohub)=0;
% Graph = Graph_EXC_INH(CIJ_bin, CIJ,'k',1,2,degrees, exc_inh);
% cd(hub_folder);
% clear electrodesProp
% electrodesProp=elPropout;
% %savefig(Graph,strcat('Graph_HUB_EXC_INH.fig'))
% %close(Graph);
%end

