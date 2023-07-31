% by Martina Brofiga (25 Marzo 2019)

%% Define graph connectivity
% Select the matrix binary
clear all 
close all
matrixFolder = uigetdir(pwd,'Select the folder that contains the cross correlation matrix files:');
if isempty(strfind(matrixFolder, 'CrossCorrelation'))
    f = errordlg('Selection failed', 'Folder Error');
    return 
end

[CC, CC_bin, exc, inh, method] = ThresholdMatrix(matrixFolder,'mean-std');
[CC_new, CC_bin_new, exc_new, inh_new, method_new] = ThresholdMatrix(matrixFolder,'NEW');

%[pHatp,pCIp] = lognfit(CC(CC>0));
% [pHatn,pCIn] = lognfit(CC(CC<0));
% Define the outdegree, indegree and total degree
[id, od, deg] = degrees_dir(CC_bin);
[id_new, od_new, deg_new] = degrees_dir(CC_bin_new);

answer = questdlg('What kind of information do you want to extract?', ...
	'Options', ...
	'Nodes degree','Connections Directionality', 'Nods degree');
% Handle response
switch answer
    case 'Nodes degree'
        choose = 1;
    case 'Connections Directionality'
        choose = 2;
end

if choose == 1
    Graph1 = Graph(CC_bin, CC, 'k', 2, 1, deg);
    cd(matrixFolder);
    d = dir;
    savefig(strcat('Graph_',method,'_nexc=',exc,'_ninh=',inh,'.fig'));
    save(strcat('outdeg_',string(method),'_exc=',exc,'_ninh=',inh,'_.mat'),'od');
    
    Graph2 = Graph(CC_bin_new, CC_new, 'k', 2, 1, deg_new);
    cd(matrixFolder);
    d = dir;
    savefig(strcat('Graph_',method_new,'_nexc=',exc_new,'_ninh=',inh_new,'.fig'));
    save(strcat('outdeg_',string(method_new),'_exc=',exc_new,'_ninh=',inh_new,'_.mat'),'od');
else 
    Graph1 = Graph_directionality(CC_bin, CC, 'k',2,2,deg);
    cd(matrixFolder);
    d = dir;
    savefig(strcat('Graph_',string(method),'_nexc=',exc,'_ninh=',inh,'_','_Directionality.fig'));
    
    Graph2 = Graph_directionality(CC_bin_new, CC, 'k',2,2,deg_new);
    cd(matrixFolder);
    d = dir;
    savefig(strcat('Graph_',string(method_new),'_nexc=',exc_new,'_ninh=',inh_new,'_','_Directionality.fig'));
end



EndOfProcessing (matrixFolder, 'Successfully accomplished');
clear all