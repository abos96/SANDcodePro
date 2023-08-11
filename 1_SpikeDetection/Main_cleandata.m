%% Main clean data
% -----------> INPUT FROM THE USER
filterFlag = 0;
absoluteThreshold = '';
threshold_calculation_window = [0, 1];

[start_folder]= uigetdir('C:\','Select the .mat files folder (RawMatFoldee)');
% if isempty (start_folder)
%     error('The folder is empty')
% elseif ~strcmp(split(start_folder,'\'),'RawMatFiles') %check  if the name is correct
%     error('The folder is not correct')
% end

%% Get a list of all files in the folder
files = dir(fullfile(start_folder, '*.mat'));
items = cell(length(files),1);
for i = 1:numel(files)
    items{i} = files(i).name;
end

selectedItems = selectItemsFromListbox(items);
selectedItems = cell2struct(selectedItems','name',1);
%% ---------------------------------PROCESS--------------------------------
[save_folder]= uigetdir('C:\','Select the save files folder');


cd(start_folder)
progressbar('cleaning data')
for i = 1 : length(selectedItems)
    name2load = fullfile(start_folder,selectedItems(i).name);
    load(name2load)
    dat = cleanData(dat,5);
    cd(save_folder)
    save(selectedItems(i).name,"dat","channels","fs")
    progressbar(i/length(selectedItems))
end
close all

