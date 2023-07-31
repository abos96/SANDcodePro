function [el, ibibin, ibiwin, ylim, fs, cancelFlag]= uigetIBIinfo(single,list)
% 
% by Michela Chiappalone (26 Maggio 2006)
% modified by Noriaki

cancelFlag = 0;
fs         =  [];
ibibin     =  [];
ibiwin     =  [];
ylim       =  [];
el = [];

PopupTitle   = 'Inter Burst Interval - IBI Histogram)';   
PopupPrompt  = {'IBI bin [sec]', 'IBI window [sec]', ...
                'Ylim [0,1]', 'Sampling frequency [samples/sec]'};         
PopupLines   = 1;
PopupDefault = {'0.5', '20', '1', '10000'};


if (single==1)
    Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault);
    [indx,tf] = listdlg('PromptString','Select the electrode','SelectionMode','single','ListString',string(list));
    if isempty(Ianswer)
        cancelFlag = 1;
    else
        %Make a check on the channel name
        el      = list(indx);           % Electrode whose IBI must be plotted
    end
else
    Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault);
    el=string(0);
end

if isempty(Ianswer)
    cancelFlag = 1;
else
    fs         =  str2double(Ianswer{4,1});           % Sampling frequency
    ibibin     =  str2double(Ianswer{1,1});          % Bin of the IBI [sec]
    ibiwin     =  str2double(Ianswer{2,1});      % Window of the IBI [sec]
    ylim       =  str2double(Ianswer{3,1});        % Limit of the Y-axis for the IBI plot
end