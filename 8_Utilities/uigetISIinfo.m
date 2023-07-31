function [isibin, isiwin, ylim, fs, cancelFlag] = uigetISIinfo()
% 
% by Michela Chiappalone (14 Marzo 2006)
% modified by Noriaki (9 giugno 2006)

cancelFlag = 0;
fs         = []; 
isibin     = [];
isiwin     = [];
ylim       = [];

PopupPrompt  = {'ISI bin [msec]', 'ISI window [msec]', 'Ylim [0,1]', 'Sampling frequency [samples/sec]'};         
PopupTitle   = 'Inter Spike Interval - ISI Histogram)';
PopupLines   = 1;
PopupDefault = {'1', '100', '1', '10000'};
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault);

if isempty(Ianswer)
    cancelFlag = 1;
else
    fs         =  str2num(Ianswer{4,1});           % Sampling frequency
    isibin     =  str2num(Ianswer{1,1});           % Bin of the ISI [msec]
    isiwin     =  str2num(Ianswer{2,1});           % Window of the ISI [msec]
    ylim       =  str2double(Ianswer{3,1});        % Limit of the Y-axis for the ISI plot
end