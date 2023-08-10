function csv2save = fillBatchFile (dirname,fill_div,fill_genotype,genotype)
% fillBatchFile create a .csv file in the folder ExportFolder based on file in the dirname folder   
% edited by AB may23; 


    
    mat_files=dir(fullfile(dirname,'*.mat')); %pick out only .mat files produced by rawConvert.m
    batchHdrs={'Filename','DIV','Genotype','Ground'}; 
    row_number=1;
    div_str='';

    batch_cell=cell(length(mat_files),length(batchHdrs));
    batch_table=cell2table(batch_cell,'VariableNames',batchHdrs);

    for i=1:length(mat_files)
        mat_fname=mat_files(i).name(1:end-4);
        batch_table.Filename{row_number}=mat_fname;

        if strcmp(fill_genotype,'y') 
            rowIndex = 0;
            well = findLetterAfterLastUnderscore(mat_fname);
            % Loop through the cell array to find the element
            for j = 1:size(genotype, 1)
                
                    if strcmp(genotype{j, 1}, well)
                        rowIndex = j;
                        
                        break;  % Break the loop once the element is found
                    end
               
                if rowIndex > 0
                    break;  % Break the outer loop once the element is found
                end
            end
            batch_table.Genotype(i,1)=genotype(rowIndex,2);
        end

        if strcmp(fill_div,'y')
            ii=strfind(mat_fname,'DIV')+3;

            while isstrprop(mat_fname(ii),'digit')
                div_str=append(div_str,mat_fname(ii));
                ii=ii+1;
            end 
            batch_table.DIV{row_number}=div_str;
            row_number=row_number+1;
            div_str='';
        end
    end
%     cell_batch = cell(1,size(batch_table,2));
      csv2save = batch_table;
      
end
