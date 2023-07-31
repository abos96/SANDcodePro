function [handles] = SelectElectrode(handles,hObject)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    list = handles.Selectchx.String(1:end);
    indx = find(strcmp(string(list), hObject.String));
    indy = find(strcmp(string(list), hObject.String));
    
    fields = fieldnames(handles);
    for k = 1:length(fields)
        if startsWith(fields{k},'el')
            values(k) = handles.(fields{k}).Value ~= 0;
        end
    end
    check = sum(values);
    
    if hObject.Value hObject.Value ~= 0
        if strcmp(char(handles.Selectchx.String(handles.Selectchx.Value)),'---select channel x---')      
            if check > 2
                for k = 1:length(fields)
                    if startsWith(fields{k},'el')
                        set(handles.(fields{k}),'Value',0);
                    end
                end
                set(handles.Selectchx,'Value',1)
                set(handles.Selectchy,'Value',1)
            else
                set(handles.Selectchx,'Value',indx)
                handles.chx = string(list(indx));
            end
        else
            if strcmp(char(handles.Selectchy.String(handles.Selectchy.Value)),'---select channel y---')
                if check > 2
                    for k = 1:length(fields)
                        if startsWith(fields{k},'el')
                            set(handles.(fields{k}),'Value',0);
                        end
                    end
                    set(handles.Selectchx,'Value',1)
                    set(handles.Selectchy,'Value',1)
                else
                    set(handles.Selectchy,'Value',indy)
                    handles.chy = string(list(indy));
                end
            else
                if check > 2
                    for k = 1:length(fields)
                        if startsWith(fields{k},'el')
                            set(handles.(fields{k}),'Value',0);
                        end
                    end
                    set(handles.Selectchx,'Value',1)
                    set(handles.Selectchy,'Value',1)
                else
                    set(handles.Selectchx,'Value',indx-1)
                    handles.chx= list(indx)
                end    
                
            end
        end
    else
        if  strcmp(handles.Selectchx.String(handles.Selectchx.Value),hObject.String)
            set(handles.Selectchx,'Value',1)
        elseif strcmp(handles.Selectchy.String(handles.Selectchy.Value),hObject.String)
            set(handles.Selectchy,'Value',1)
        end
    end
end

