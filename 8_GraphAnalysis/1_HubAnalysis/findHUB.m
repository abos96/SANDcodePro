function [hub,n]=findHUB(CIJ)

%     [deg,~,~]=degrees_dir(CIJ.*(CIJ>0));
%     hub_exc = find(deg>mean(deg)+ std(deg));            % hub secondo IN_DEGREE
%     n_exc=length(hub_exc);
%     
%    [deg,~,~]=degrees_dir(abs(CIJ.*(CIJ<0)));
%     hub_inh=find(isoutlier(deg,'mean','ThresholdFactor',1.5));               % hub secondo IN_DEGREE
%     n_inh=length(hub_inh);
    
    [~,deg,~]=degrees_dir(weight_conversion(CIJ,'binarize'));
    hub = find(deg>mean(deg)+ std(deg));            % hub secondo IN_DEGREE
    n=length(hub);
% % -----------------hub classification
%     [Min,Mout,Mall] = matching_ind(CIJ);
%     [M,Q]= community_louvain(Mout,[],[],'negative_sym');
%     [Ci,Q]=modularity_dir(CIJ);
%     P_ms=participation_coef(CIJ,Ci,1);
    
    
    