function [lag_ms, tail, rep_num]= uigetBURSTinfo()
% Prompt a user-window for input information regarding the current
% experiment for computing PSTH
% by Michela Chiappalone (18 Gennaio 2006, 16 Marzo 2006)
% modified by Noriaki (9 giugno 2006)

cancelFlag = 0;
method= [];
lag_ms = [];
tail= [];
rep_num  = [];


PopupPrompt = {'lag_ms [msec]', ...
               'tail %', ...
               'rep_num'};         
PopupTitle  =  'Adj matric setting Settings';
PopupLines  =  1;
PopupDefault= {'25', '0.01', '100'};
Ianswer     = inputdlg(PopupPrompt,PopupTitle,[1 70;1 70; 1 70], PopupDefault);

if isempty(Ianswer)
    cancelFlag = 1;
else
    lag_ms = str2num(Ianswer{1,1});
    tail = str2num(Ianswer{2,1});
    rep_num = str2num(Ianswer{3,1});
  
end

clear Ianswer PopupPrompt PopupTitle PopupLines PopupDefault
