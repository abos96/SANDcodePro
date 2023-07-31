function saveCCorrParam(c0, CI0, cPeak, CIpeak, peakLatency, Mean,Std,Median,StdError, binmsecNew,cellar, start_folder, end_folder)

% this function save files from compCCorrParam.m
% start_folder:folder contains the cc files to save
% end_folder: first parent folder

%% create folder where to save all the files
 save_dir = strcat( start_folder,'_Analysis'); % Name of the parent saving directory
 cd(end_folder)                                
 d=dir;
        if isempty(strmatch(save_dir, d(:),'exact')) % Check if the corrdir already exists
            mkdir (save_dir) % Make a new directory only if corrdir doesn't exist
        end
cd(start_folder)
folder_names=dir;
len=length(dir)-2; % numbers of CC sub-folders
%% save C0
for i= 1:len % create folders
    
   folder(i) = string(strcat('CAnalysis_',folder_names(i+2).name));  
   cd(save_dir)
   
   if isempty(strmatch(save_dir, dir,'exact')) % Check if the corrdir already exists
            mkdir (folder(i)) % Make a new directory FOR TRIALS only if corrdir doesn't exist
   end
   
   cd(folder(i))
   
   tab_statistic=table (Mean(:,i), Std(:,i) ,Median(:,i), StdError(:,i),'VariableNames',{'Mean' 'Std'...
       'Median' 'StdError'},'RowNames',{'c0' 'CI0'...
       'cPeak' 'CIpeak' 'peakLatency'});
   
   tab_statistic_cell=mat2cell(tab_statistic,5,4);
   
   tab_param=table(c0(:,:,i),CI0(:,:,i),cPeak(:,:,i),CIpeak(:,:,i),peakLatency(:,:,i),'VariableNames',{'c0' 'CI0'...
       'cPeak' 'CIpeak' 'peakLatency'});
   
   tab_param_cell=mat2cell(tab_param,120,5);
   
   tab_finale=table(tab_statistic_cell, tab_param_cell,'VariableNames',{'statistic' 'parameters'});
   
  
   save("CCparameters",'tab_finale');
   
   str=strcat('Phase_0',string(i));
   tab_subCultures=cell2table(cellar(i),'VariableNames',str);
   save("CCSubcultures",'tab_subCultures');


end

   
  

   