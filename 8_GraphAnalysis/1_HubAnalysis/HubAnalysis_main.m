%% Define the hub
%Define a hub like the i nodes that have a degree(i)>mean(degree)+std(degree)

%Define if a hun is inhibitory or exitatory (ratio of exitatory and
%inhibitory connections).

%Draw a figure that identify the inibitoy and excitatory hub).


%If the culture is compartmentalized define if there are hub of compartment
%and hub of network (evaluate the number of connection in and outside the
%compartment where is the hub

clear all
clc

[TCM_file,path] = uigetfile('pwd', 'Select Threshold Binary Matrix');
if isempty(strfind(TCM_file,'TCM_Binary'))
    errordlg('Selection Failed - End of Session', 'Error');
    return
end

cd(path)
[TCM,path] = uigetfile('pwd', 'Select the respective Threshold Matrix');
TCM_control = split(TCM_file,'_');
cc = strcat(TCM_control{end-1},'_',TCM_control{end});
if isempty(strfind(TCM,cc)) & ~isempty(strfind(cc,'TCM'))
    errordlg('Selection Failed - End of Session', 'Error');
    return
end


cd(path);
load(TCM_file);
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

if length(CC_bin) == 120
    mcs = MEA120_lookuptable;
elseif length(CC_bin) == 252
    mcs = MEA256_lookuptable;
elseif length(CC_bin) == 87 & ~isempty(chars)
    mcs = MEA4Q_lookuptable;
end



[id, od, deg] = degrees_dir(CC_bin);
thres = mean(deg) + std(deg);
el = find(deg > thres);
degrees = deg;
degrees(degrees<thres) = 0;


for k = 1:length(CC)
    in = CC(:,k);
    out = CC(k,:)';
    exc = length(find(in>0))+length(find(out>0));
    inh = length(find(in<0))+length(find(out<0));
    if exc > inh
        exc_inh(k) = 1;
    elseif exc < inh 
        exc_inh(k) = -1;
    else
        exc_inh(k) = 2; % Undefine electrode
    end
end

hub_exc_inh = exc_inh(el); 
nohub = setdiff([1:length(CC)],el);
exc_inh(nohub)=0;
 % If most connections are negative, I consider the node NEGATIVE (-1), if
 % most connection are positive, I consider the node POSITIVE (1). 2 is to
 % identify node with the same number of inhibitory and excitatory
 % connections.

el_str = mcs(ismember(str2num(str2mat(mcs(:,2))), el),1);
hub = [el_str,string(id(el)'), string(od(el)'), string(deg(el)'), string(hub_exc_inh')];   


cd(start)
mkdir(strcat(d(3).name(1:8),'_HubAnalysis'));
cd(strcat(d(3).name(1:8),'_HubAnalysis'));
save(strcat('IdentifiedHub_',TCM_file(1:end-4),'.mat'), 'hub');
hub_folder = pwd;

CC(nohub,nohub)=0;
CC_bin(nohub,nohub)=0;
Graph = Graph_hub(CC_bin, CC,'k',2,2,degrees, exc_inh);
cd(hub_folder);
savefig(Graph,strcat('Graph_TypeHub_',TCM_file(1:end-4),'.fig'))
close(Graph);

