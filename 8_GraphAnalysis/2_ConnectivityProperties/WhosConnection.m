function [electrodesProp ,labels]=WhosConnection(CIJ)
% verifica per ogni elettrodo che tipo di connessioni ha
% preso el J: quante connessioni exc (in, out, tot) quante Inh??
% quanto sono lunghe queste connessioni?
coord=load('coordMEA120');
CIJ_bin=CIJ;
CIJ_bin(CIJ_bin~=0)=1;
electrodesProp=[];
for i=1:length(CIJ)
    
tot_in_conn = sum(CIJ_bin(:,i));                                           % indegree = column sum of CIJ
tot_out_conn = sum(CIJ_bin(i,:))';                                         % outdegree = row sum of CIJ
tot_conn = tot_in_conn+tot_out_conn;   

in_exc = length(find(CIJ(:,i)>0));                                         % indegree = column sum of CIJ
idx=find(CIJ(:,i)>0);
in_exc_d=eucledianDistance(i,idx,coord.MEA120_graph);

in_inh = length(find(CIJ(:,i)<0));                                         % outdegree = row sum of CIJ
idx=find(CIJ(:,i)<0);
in_inh_d=eucledianDistance(i,idx,coord.MEA120_graph);

out_exc = length(find(CIJ(i,:)>0));                                        % indegree = column sum of CIJ
idx=find(CIJ(i,:)>0);
out_exc_d=eucledianDistance(i,idx,coord.MEA120_graph);

out_inh = length(find(CIJ(i,:)<0));                                        % outdegree = row sum of CIJ
idx=find(CIJ(i,:)<0);
out_inh_d=eucledianDistance(i,idx,coord.MEA120_graph);

tot_exc =in_exc+out_exc;                                                   % degree = indegree+outdegree
tot_inh =in_inh+out_inh;                                                   % degree = indegree+outdegree

%% define a node
% node=struct('degree',tot_conn,'InDegree',tot_in_conn,'OutDegree',tot_out_conn,'RatioDeg',(tot_in_conn/tot_out_conn),...
%              'RatioExcInh',tot_exc/tot_inh,'RatioIN_ExcInh',in_exc/in_inh,'RatioOUT_ExcInh',out_exc/out_inh,...
%              'd_in_exc',mean(in_exc_d),'d_in_inh',mean(in_inh_d),'d_out_exc',mean(out_exc_d),'d_out_inh',mean(out_inh_d));
labels= ['degree''InDegree''OutDegree' 'Exc''Inh''IN_Exc' 'IN_Inh' 'OUT_Exc''OUT_Inh' 'd_in_exc'...
             'd_in_inh''d_out_exc''d_out_inh'];
temp=[tot_conn, tot_in_conn, tot_out_conn, tot_exc, tot_inh, in_exc, in_inh, out_exc, out_inh,...
             mean(in_exc_d),mean(in_inh_d),mean(out_exc_d),mean(out_inh_d) ]  ;    
electrodesProp=[electrodesProp; temp];

end