clear all 
[file,start_folder,idx] = uigetfile('*.mat','Select the Thresholded Binary Connectivity Matrix file');
load(fullfile(start_folder,file));
% %% density
% [kden,~,K] = density_und(CC_bin);
% N = nnz (CC_bin);
% [r, c] = find(CC_bin ~=0);
% node = length(union (r, c));
%% Small world index, Cluster Coefficient, Path Length,degreee

[in, out, deg]= degrees_dir(CC_bin);
% ratio_in_out=in./out;
% figure
% loglog(linspace(1,max(deg),50),histcounts(deg,50));

%[SW,PL,CC] = small_world_index(CC_bin,100);
n = size(CC_bin,1);  % number of nodes
m = sum(sum(CC_bin)); %number of edges directed network
[Lrand,CrandWS] = NullModel_L_C(n,m,100,1);
[SW,CC,PL] = small_world_ness2(CC_bin,Lrand,CrandWS,1);
cd(start_folder)
SWI = table(SW,PL,CC,'VariableNames',{'SWI','PL','CC'});
name = split(file,'.');
name = split(name(1),'_');

%% Link distribution

degunique = unique(deg);
for i = 1:length(degunique)
count(i,1)= degunique(i);
count(i,2)=sum(deg==degunique(i));
end
DegreeDistribution = figure()
bar(count(:,2)/sum(count(:,2)));
xlabel('Degrees (k)');
ylabel('Probability p(k)')
box off
title('Linear Degree Distr ibution')
%% save
filename = strcat('DegreeDistribution_',name(end-1),'_',name(end));
saveas(gcf, char(filename), 'fig')
saveas(gcf,char(filename),'png')
filename = strcat('SmallWorldIndex_',name(end-1),'_',name(end));
save(char(filename),'SWI')
