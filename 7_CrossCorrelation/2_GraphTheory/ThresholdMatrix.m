% by Martina Brofiga (23 Marzo 2019)

%% Create a Thresholded Connectivity Matrix
function [CC, CC_bin, exc, inh,method] = ThresholdMatrix(CCfolder,m)

    cd (CCfolder);
    DR = dir;
    Directednew=[];

    for k = 3:length(DR)
        if (~isempty(strfind(DR(k).name,'ConnectivityMatrix')))
            load(DR(k).name);
        end
    end
   
    % Dialog box to choise the parameter for threshold both inhibitory and
    % excitatory links. Default values are: n_inh= 0, n_exc=1

% Handle response
switch m
    case 'mean-std'
        
         prompt = {'Enter parameter for threshold excitatory links:','Enter parameter for threshold inhibitory links:'};
                            title = 'Input';
                            dims = [1 50];
                            definput = {'1','0'};
                            answer = inputdlg(prompt,title,dims,definput);

                            %% Calculation of matrices by setting a threshold
                            ConnectivityMatrix(isnan(ConnectivityMatrix))=0;
                            CC = ConnectivityMatrix;
                            tmpCC = CC(CC~=0);
                            exc = answer{1} ;
                            inh = answer{2};
                            n_exc = str2num(answer{1});
                            n_inh = str2num(answer{2});
                            thres_exc = mean(tmpCC(tmpCC>0))+n_exc*std(tmpCC(tmpCC>0));
                            thres_inh = mean(tmpCC(tmpCC<0))-n_inh*std(tmpCC(tmpCC<0));
                            ecc=0;
                            in=0;

                            for i=1:length(CC)
                                for j=1:length(CC)
                                    if CC(i,j)>= 0
                                        if CC(i,j)<thres_exc
                                            CC(i,j) = 0;
                                        else 
                                            ecc = ecc+1;
                                        end
                                    else
                                        if CC(i,j) > thres_inh
                                            CC(i,j) = 0;
                                        else
                                            in = in+1;                    
                                        end
                                    end
                                end
                            end

               

                            fnameCC = fullfile(CCfolder,[strcat('TCM_nexc=',answer{1},'_ninh=',answer{2},'.mat')]);
                            save(fnameCC, 'CC');

                            ratio = ecc*100 /(in+ecc);
                            values = [ratio, in, ecc];
                            fnameratio = fullfile(CCfolder,[strcat('Ratio_TCM_nexc=',answer{1},'_ninh=',answer{2},'.mat')])
                            save(fnameratio, 'values');

                            %% Given the matrix Directed, the analogous binary is defined
                            CC_bin = CC;
                            CC_bin(CC_bin ~= 0) = 1;

                            fnameBin = fullfile(CCfolder,[strcat('TCM_Binary_nexc=',answer{1},'_ninh=',answer{2},'.mat')]);
                            save(fnameBin, 'CC_bin');

                            %% Graf Theory
                            % Based on the new calculated matrices we want to obtain the number of
                            % nodes and link

                            link= nnz (CC);
                            [r, c] = find(CC ~=0);
                            node = length(union (r, c));
                            fnameNode = fullfile(CCfolder,[strcat('LinkNode_nexc=',answer{1},'_ninh=',answer{2},'.mat')]);
                            save(fnameNode, 'node','link');
                            method="";

                        
    case 'NEW'
         
            prompt = {'Enter parameter for proportional threshold excitatory links:','Enter parameter for proportional threshold inhibitory links:'};
            title = 'Input';
            dims = [1 50];
            definput = {'1','0'};
            answer = inputdlg(prompt,title,dims,definput);
            method="NEW";
            %% Calculation of matrices by setting a threshold
n=length(ConnectivityMatrix);
exc=answer{1};
inh=answer{2};
nexc=str2double(answer{1});
ninh=str2double(answer{2});
CCcost=zeros(n,n,length(nexc));
CC_bin_cost=zeros(n,n,length(nexc));
Wpositive=zeros(n,n,length(nexc));
for k=1:length(nexc)
%fprintf("positive k=%f\n",k);
W=ConnectivityMatrix;
%% ------------------------positive------------------------------
Wpos_out=zeros(length(W));
Wpos=W.*(W>0);
a=find(Wpos>0);
[out_pos,~,~,C]=isoutlier(Wpos(Wpos>0),'mean','ThresholdFactor',nexc(k));
Wpos_out(a(out_pos))=W(a(out_pos));
Wpos_out(Wpos_out<C)=0;

% Wneg_out=zeros(length(W));
% Wneg=W.*(W<0);
% a=find(Wneg<0);
% [out_neg,~,~,C]=isoutlier(abs(Wneg(Wneg<0)),'mean','ThresholdFactor',ninh(k)+0.2);
% Wneg_out(a(out_neg))=Wneg(a(out_neg));
% Wneg_out(Wneg_out>(-C))=0;

Wnoise_pos=Wpos-Wpos_out;
[r,c]=find((Wnoise_pos)~=0);
pos=0;
for i=1:length(r)
    %for j=c
        weight=Wnoise_pos(r(i),c(i));
        if weight>0 
           noise = Wnoise_pos(r(i),(Wnoise_pos(r(i),:)>0));  % Wnoise((Wnoise(:,c(i))>0),c(i))'
           %noise = Wnoise(r(i),(Wnoise(r(i),:)>0));
         
           th=mean(noise)+(3)*std(noise);              % SW:  3.5/4  
           if  weight>th                       % ttest2(weight,noise,'Tail','right','Alpha',0.001)  
               Wpos_out(r(i),c(i))= weight;
               %fprintf("add positive\n");
               pos=pos+1;
           end
%         elseif weight<0   
%             noise = Wnoise((Wnoise(:,c(i))<0),c(i));  %Wnoise((Wnoise(:,c(i))<0),c(i))'
%             %noise = Wnoise(r(i),(Wnoise(r(i),:)<0));
%             h=ttest2(weight,noise,'Tail','left','Alpha',0.001);
% %            th=mean(noise)-(3.5)*std(noise);
%             if h                             % weight<th
%                 Wneg_out(r(i),c(i))= weight;
%                 fprintf("add negative %f %f\n",r(i),c(i));            
%             end
        end
       
    %end
   
      
end
fprintf("positive added : %f \n",pos); 
Wpositive(:,:,k)=Wpos_out;
end
%% --------------------------negative----------------------------------------
Wnegative=zeros(n,n,length(ninh));
for k=1:length(ninh)
fprintf("negative k=%f\n",k);
W=ConnectivityMatrix;
Wneg_out=zeros(length(W));
Wneg=W.*(W<0);
a=find(Wneg<0);
[out_neg,~,~,C]=isoutlier(abs(Wneg(Wneg<0)),'mean','ThresholdFactor',ninh(k));
Wneg_out(a(out_neg))=Wneg(a(out_neg));
Wneg_out(Wneg_out>(-C))=0;

Wnoise_neg=Wneg-Wneg_out;
[r,c]=find((Wnoise_neg)~=0);
neg=0;
for i=1:length(r)
    %for j=c
        weight=Wnoise_neg(r(i),c(i));
  
        if weight<0   
            noise = Wnoise_neg((Wnoise_neg(:,c(i))<0),c(i));  %Wnoise((Wnoise(:,c(i))<0),c(i))'
            %noise = Wnoise(r(i),(Wnoise(r(i),:)<0));
           
            th=mean(noise)-(3)*std(noise);
            if  weight<th   %ttest2(weight,noise,'Tail','left','Alpha',0.001) %weight<th         
                Wneg_out(r(i),c(i))= weight;
                neg=neg+1;            
            end
        end
       
    %end
end
fprintf("negative added : %f \n",neg); 
Wnegative(:,:,k)=Wneg_out;
end
%--------------------------------------------------------------------------

for i=1:length(ninh)
    for j=1:length(nexc)
        R=Wpositive(:,:,j)+Wnegative(:,:,i);
%         fnameCC = fullfile(CCfolder,[strcat('TCM_Cost',string(nexc(j)),'_',string(ninh(i)),'.mat')]);
%         save(fnameCC, 'R');
%         fnameCC = fullfile(CCfolder,[strcat('TCM_Binary_Cost',string(nexc(j)),'_',string(ninh(i)),'.mat')]);
%         R_bin=weight_conversion(R,'binarize');
%         save(fnameCC,'R_bin');
%         CCcost(:,:,ind)=R;
%         CC_bin_cost(:,:,ind)=R_bin;
%         ind=ind+1;
    end
end

 
                            CC=squeeze(R);
                            fnameCC = fullfile(CCfolder,[strcat('TCM_NEW_nexc=',answer{1},'_ninh=',answer{2},'.mat')]);
                            save(fnameCC, 'CC');

                            ratio = length(find(CC>0))*100 /(length(find(CC>0))+length(find(CC<0)));
                            values = [ratio, length(find(CC<0)), length(find(CC>0))];
                            fnameratio = fullfile(CCfolder,[strcat('Ratio_NEW_nexc=',answer{1},'_ninh=',answer{2},'.mat')])
                            save(fnameratio, 'values');

                            %% Given the matrix Directed, the analogous binary is defined
                            CC_bin = CC;
                            CC_bin(CC_bin ~= 0) = 1;

                            fnameBin = fullfile(CCfolder,[strcat('TCM_Binary_NEW_nexc=',answer{1},'_ninh=',answer{2},'.mat')]);
                            save(fnameBin, 'CC_bin');

                            %% Graf Theory
                            % Based on the new calculated matrices we want to obtain the number of
                            % nodes and link

                            link= nnz (CC);
                            [r, c] = find(CC ~=0);
                            node = length(union (r, c));
                            fnameNode = fullfile(CCfolder,[strcat('LinkNode_NEW_nexc=',answer{1},'_ninh=',answer{2},'.mat')]);
                            save(fnameNode, 'node','link');
                          

   
end

