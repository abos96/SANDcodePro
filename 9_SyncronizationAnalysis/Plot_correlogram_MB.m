function varargout = Plot_correlogram_MB(varargin)
% PLOT_CORRELOGRAM_MB M-file for Plot_correlogram_MB.fig
%      PLOT_CORRELOGRAM_MB, by itself, creates a new PLOT_CORRELOGRAM_MB or raises the existing
%      singleton*.
%
%      H = PLOT_CORRELOGRAM_MB returns the handle to a new PLOT_CORRELOGRAM_MB or the handle to
%      the existing singleton*.
%
%      PLOT_CORRELOGRAM_MB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOT_CORRELOGRAM_MB.M with the given input arguments.
%
%      PLOT_CORRELOGRAM_MB('Property','Value',...) creates a new PLOT_CORRELOGRAM_MB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Plot_correlogram_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Plot_correlogram_MB_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Plot_correlogram_MB

% Last Modified by GUIDE v2.5 06-Feb-2020 15:56:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Plot_correlogram_MB_OpeningFcn, ...
                   'gui_OutputFcn',  @Plot_correlogram_MB_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Plot_correlogram_MB is made visible.
function Plot_correlogram_MB_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% varargin   command line arguments to Plot_correlogram_MB (see VARARGIN)

% Choose default command line output for Plot_correlogram_MB
handles.output = hObject;

% Variables' initialization
handles.chx     = [];
handles.chy     = [];
handles.xyLim   = [0;0;0;0];
handles.dataplot= [];
axis([-150 150 0 2])

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Plot_correlogram_MB wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Plot_correlogram_MB_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SelectFolder.
function SelectFolder_Callback(hObject, eventdata, handles)
% hObject    handle to SelectFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.start_folder = uigetdir(pwd,'Select a Correlogram folder');
if  strcmp(num2str(handles.start_folder),'0')
    errordlg('Selection Failed', 'Error');
    return
else
    start_folder = handles.start_folder;
    cd(start_folder);
    dir_cc = pwd;
    cd ..
    cd ..
    main_folder = dir;
    for k = 3:length(main_folder)
        if ~isempty(strfind(main_folder(k).name,'ColorElectrode'))
            cd(main_folder(k).name);
            load('ColorElectrode');
            gray = string(find(color(:,1)==0.8));
        end
    end
    set(handles.text6, 'String', start_folder)
    name_split = split(start_folder,'\');
    name_split = split(name_split{end},'_');
    nEl = regexp(name_split{2},'\d*','Match');
    handles.nEl = nEl{:};
    set(handles.CCparameters, 'Visible', 'on');
    
    if strcmp(nEl{:},'60')
        set(handles.Configuration60, 'Visible', 'on');
        list = [(12:17)';(21:28)';(31:38)';(41:48)';(51:58)';(61:68)';(71:78)';(82:87)'];
        ll = list;
        listx = ['---select channel x---'; string(list)];
        listy = ['---select channel y---'; string(list)];
        handles.Selectchx.String = listx;
        handles.Selectchy.String = listy;
    elseif strcmp(nEl{:},'120')
        set(handles.Configuration120, 'Visible', 'on');
        ll = MEA120_lookuptable;
        list = ll(:,1); 
        listx = ['---select channel x---'; string(list)];
        listy = ['---select channel y---'; string(list)];
        handles.Selectchx.String = listx;
        handles.Selectchy.String = listy;
        [C,ia] = intersect(ll(:,2),gray);
        gray = ll(ia,1);
    elseif strcmp (nEl{:},'252')
        set(handles.Configuration252, 'Visible', 'on');
        ll = MEA256_lookuptable;
        list = ll(:,1);
        listx = ['---select channel x---'; string(list)];
        listy = ['---select channel y---'; string(list)];
        handles.Selectchx.String = listx;
        handles.Selectchy.String = listy;
        [C,ia] = intersect(ll(:,2),gray);
        gray = ll(ia,1);
    elseif strcmp(nEl{:},'4')
        set(handles.Configuration4Q, 'Visible', 'on');
        ll = MEA4Q_lookuptable;
        list = ll(:,1);
        listx = ['---select channel x---'; string(list)];
        listy = ['---select channel y---'; string(list)];
        handles.Selectchx.String = listx;
        handles.Selectchy.String = listy;
        [C,ia] = intersect(ll(:,2),gray);
        gray = ll(ia,1);
    else
        errordlg('Selection Failed', 'Error');
    end
    handles.meael = ll;
    
    
    if exist('color','var')
         fields = fieldnames(handles);
        for k = 1:length(fields)
            if startsWith(fields{k},'el')
                el = handles.(fields{k}).String;
                if ~isempty(intersect(gray,el))
                    handles.(fields{k}).FontWeight = 'bold';
                    handles.(fields{k}).ForegroundColor = [0.7 0 0];
                end
            end
        end
    end
    
    cd(dir_cc)
    cc = dir;
    if double(nEl{:})~=length(cc)-2
        for k = 3:length(cc)
            name = cc(k).name;
            name = split(name,'.');
            name = split(name{1},'_');
            name = name{end};
            el_in(k-2) = string(name);
        end
        el_out = setxor(string(ll(:,1)),el_in);
        for k = 1:length(fields)
            if startsWith(fields{k},'el')
                el = handles.(fields{k}).String;
                if ~isempty(intersect(el_out,el))
                    handles.(fields{k}).Enable = 'off';
                end
            end
        end
        listx = ['---select channel x---'; string(setdiff(string(list), el_out))];
        listy = ['---select channel y---'; string(setdiff(string(list), el_out))];
        handles.Selectchx.String = listx;
        handles.Selectchy.String = listy;
    end    
    guidata(hObject, handles);
end




% --- Executes on selection change in Selectchx.
function Selectchx_Callback(hObject, eventdata, handles)
% hObject    handle to Selectchx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns Selectchx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Selectchx
    before = handles.chx;
    if get(hObject,'Value') == 1
    % Add error check
    else   
        selx= get(hObject,'Value')- 1;
        handles.chx= hObject.String(hObject.Value);
        el = cell2mat(hObject.String(hObject.Value));
        handles.(strcat('el',string(el))).Value = 1;
        if ~isempty(before)
            handles.(strcat('el',string(before{1}))).Value = 0;
        end
        set(handles.Selectchx,'Value',selx+1);
    end
    guidata(hObject, handles);

% --- Executes during object creation, after setting all propertie

function Selectchx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Selectchx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Selectchx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.



% --- Executes on selection change in Selectchy.
function Selectchy_Callback(hObject, eventdata, handles)
% hObject    handle to Selectchy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns Selectchy contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Selectchy
     before = handles.chy;
    if get(hObject,'Value') == 1
    % Add error check
    else
        sely= get(hObject,'Value')- 1;
        handles.chy= hObject.String(hObject.Value);
        el = cell2mat(hObject.String(hObject.Value));
        handles.(strcat('el',string(el))).Value = 1;
        if ~isempty(before)
            handles.(strcat('el',string(before{1}))).Value = 0;
        end
        set(handles.Selectchy,'Value',sely+1);
    end
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Selectchy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Selectchy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in PlotCorrelogram.
function PlotCorrelogram_Callback(hObject, eventdata, handles)
% hObject    handle to PlotCorrelogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.chx)||isempty(handles.chy)
    errordlg('You must selct two channels','Bad Input','modal')
    return
end
cd(handles.start_folder) % Go to the directory selected by the user
content=dir;
ind = strfind(content(3).name,'_');
filename=strcat(content(3).name(1:ind(end)), string(handles.chx), '.mat');
if exist(fullfile(handles.start_folder, filename))
    load(fullfile(handles.start_folder, filename)) % Cell array r_table is loaded
%     if length(r_table)==87 %added for compatibility with previous versions of SM
%         r_table(end+1)=[];
%     end
% else
%     % Error Check
    if strcmp(handles.nEl, '120')
        mea = MEA120_lookuptable;
        chy = mea(strcmp(mea(:,1),handles.chy),2);
    elseif strcmp(handles.nEl, '252')
        mea = MEA256_lookuptable;
        chy = mea(strcmp(mea(:,1),handles.chy),2);
    elseif strcmp(handles.nEl, '4Q')
        mea = MEA4Q_lookuptable;
        chy = mea(strcmp(mea(:,1),handles.chy),2);
    else
        chy = handles.chy;
    end
    
end
rtoplot=r_table{double(chy),1}; % Save the selected correlogram into the handles
[r,c]=size(rtoplot);

% Get bin size and window info
slashindex=strfind(handles.start_folder, filesep);
foldername=handles.start_folder(slashindex(end-1):slashindex(end));
window=str2double(foldername(strfind(foldername, '-')+1:strfind(foldername, 'msec')-1));
% underscoreindex=strfind(foldername, '_');
% bin=str2double(foldername(underscoreindex(end):strfind(foldername, '-')-1));
x=[-window:(2*window/(r-1)):window];

% Plot the correlogram
set(handles.CCplot,'Visible','on');
if sum(rtoplot ~=0)
    plot(handles.axes1, x, rtoplot);
    axis([-window window 0 max(rtoplot)+max(rtoplot)/10])
    titolo=strcat('Cross correlogram ', string(handles.chx), '-', string(handles.chy));
    title (titolo)

    % Enable Axis Property
    set(handles.xmin,'Enable','on')
    set(handles.xmax,'Enable','on')
    set(handles.ymin,'Enable','on')
    set(handles.ymax,'Enable','on')
else
    errordlg('Not enough information!','Bad Input','modal')
end

guidata(hObject, handles);



function Hold_Callback(hObject, eventdata, handles)
% hObject    handle to Hold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hold on
% This button is no more available - It is necessary to add it in a second
% version of the software



% --- Executes on button press in zoomin.
function zoomin_Callback(hObject, eventdata, handles)
% hObject    handle to zoomin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom on



% --- Executes on button press in zoomout.
function zoomout_Callback(hObject, eventdata, handles)
% hObject    handle to zoomout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom off
zoom (0.25)



function ymin_Callback(hObject, eventdata, handles)
% hObject    handle to ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of ymin as text
%        str2double(get(hObject,'String')) returns contents of ymin as a double
ymin=str2double(get(hObject,'String'));
if isnan(ymin)
    errordlg('You must enter a numeric value','Bad Input','modal')
else
    handles.xyLim(1,1)=ymin;
    ylimits=ylim;
    ylim([ymin ylimits(2)])
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function ymin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ymax_Callback(hObject, eventdata, handles)
% hObject    handle to ymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of ymax as text
%        str2double(get(hObject,'String')) returns contents of ymax as a double
ymax=str2double(get(hObject,'String'));
if isnan(ymax)
    errordlg('You must enter a numeric value','Bad Input','modal')
else
    handles.xyLim(2,1)=ymax;
    ylimits=ylim;
    ylim([ylimits(1) ymax])
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function ymax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xmin_Callback(hObject, eventdata, handles)
% hObject    handle to xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of xmin as text
%        str2double(get(hObject,'String')) returns contents of xmin as a double
xmin=str2double(get(hObject,'String'));
if isnan(xmin)
    errordlg('You must enter a numeric value','Bad Input','modal')
else
    handles.xyLim(3,1)=xmin;
    xlimits=xlim;
    xlim([xmin xlimits(2)])
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function xmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function xmax_Callback(hObject, eventdata, handles)
% hObject    handle to xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of xmax as text
%        str2double(get(hObject,'String')) returns contents of xmax as a double
xmax=str2double(get(hObject,'String'));
if isnan(xmax)
    errordlg('You must enter a numeric value','Bad Input','modal')
else
    handles.xyLim(4,1)=xmax;
    xlimits=xlim;
    xlim([xlimits(1) xmax])
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function xmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in closepanel.
function closepanel_Callback(hObject, eventdata, handles)
% hObject    handle to closepanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close

% MENUBAR - to be added in a second time
% we must give the user the following possibilities:
% - hold on the previous graph
% - save the current graph
% - print the current graph
% --------------------------------------------------------------------
function savefigure_Callback(hObject, eventdata, handles)
% hObject    handle to savefigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function printfigure_Callback(hObject, eventdata, handles)
% hObject    handle to printfigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in el12.
function el12_Callback(hObject, eventdata, handles)
% hObject    handle to el12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el12


% --- Executes on button press in el13.
function el13_Callback(hObject, eventdata, handles)
% hObject    handle to el13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el13


% --- Executes on button press in el14.
function el14_Callback(hObject, eventdata, handles)
% hObject    handle to el14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el14


% --- Executes on button press in el15.
function el15_Callback(hObject, eventdata, handles)
% hObject    handle to el15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el15


% --- Executes on button press in el16.
function el16_Callback(hObject, eventdata, handles)
% hObject    handle to el16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el16


% --- Executes on button press in el17.
function el17_Callback(hObject, eventdata, handles)
% hObject    handle to el17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el17


% --- Executes on button press in el22.
function el22_Callback(hObject, eventdata, handles)
% hObject    handle to el22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el22


% --- Executes on button press in el23.
function el23_Callback(hObject, eventdata, handles)
% hObject    handle to el23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el23


% --- Executes on button press in el24.
function el24_Callback(hObject, eventdata, handles)
% hObject    handle to el24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el24


% --- Executes on button press in el25.
function el25_Callback(hObject, eventdata, handles)
% hObject    handle to el25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el25


% --- Executes on button press in el26.
function el26_Callback(hObject, eventdata, handles)
% hObject    handle to el26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el26


% --- Executes on button press in el27.
function el27_Callback(hObject, eventdata, handles)
% hObject    handle to el27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el27


% --- Executes on button press in el32.
function el32_Callback(hObject, eventdata, handles)
% hObject    handle to el32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el32


% --- Executes on button press in el33.
function el33_Callback(hObject, eventdata, handles)
% hObject    handle to el33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el33


% --- Executes on button press in el34.
function el34_Callback(hObject, eventdata, handles)
% hObject    handle to el34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el34


% --- Executes on button press in el35.
function el35_Callback(hObject, eventdata, handles)
% hObject    handle to el35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el35


% --- Executes on button press in el36.
function el36_Callback(hObject, eventdata, handles)
% hObject    handle to el36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el36


% --- Executes on button press in el37.
function el37_Callback(hObject, eventdata, handles)
% hObject    handle to el37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el37


% --- Executes on button press in el42.
function el42_Callback(hObject, eventdata, handles)
% hObject    handle to el42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el42


% --- Executes on button press in el43.
function el43_Callback(hObject, eventdata, handles)
% hObject    handle to el43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el43


% --- Executes on button press in el44.
function el44_Callback(hObject, eventdata, handles)
% hObject    handle to el44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el44


% --- Executes on button press in el45.
function el45_Callback(hObject, eventdata, handles)
% hObject    handle to el45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el45


% --- Executes on button press in el46.
function el46_Callback(hObject, eventdata, handles)
% hObject    handle to el46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el46


% --- Executes on button press in el47.
function el47_Callback(hObject, eventdata, handles)
% hObject    handle to el47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el47


% --- Executes on button press in el52.
function el52_Callback(hObject, eventdata, handles)
% hObject    handle to el52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el52


% --- Executes on button press in el53.
function el53_Callback(hObject, eventdata, handles)
% hObject    handle to el53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el53


% --- Executes on button press in el54.
function el54_Callback(hObject, eventdata, handles)
% hObject    handle to el54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el54


% --- Executes on button press in el55.
function el55_Callback(hObject, eventdata, handles)
% hObject    handle to el55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el55


% --- Executes on button press in el56.
function el56_Callback(hObject, eventdata, handles)
% hObject    handle to el56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el56


% --- Executes on button press in el57.
function el57_Callback(hObject, eventdata, handles)
% hObject    handle to el57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el57


% --- Executes on button press in el62.
function el62_Callback(hObject, eventdata, handles)
% hObject    handle to el62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el62


% --- Executes on button press in el63.
function el63_Callback(hObject, eventdata, handles)
% hObject    handle to el63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el63


% --- Executes on button press in el64.
function el64_Callback(hObject, eventdata, handles)
% hObject    handle to el64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el64


% --- Executes on button press in el65.
function el65_Callback(hObject, eventdata, handles)
% hObject    handle to el65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el65


% --- Executes on button press in el66.
function el66_Callback(hObject, eventdata, handles)
% hObject    handle to el66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el66


% --- Executes on button press in el67.
function el67_Callback(hObject, eventdata, handles)
% hObject    handle to el67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el67


% --- Executes on button press in el72.
function el72_Callback(hObject, eventdata, handles)
% hObject    handle to el72 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el72


% --- Executes on button press in el73.
function el73_Callback(hObject, eventdata, handles)
% hObject    handle to el73 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el73


% --- Executes on button press in el74.
function el74_Callback(hObject, eventdata, handles)
% hObject    handle to el74 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el74


% --- Executes on button press in el75.
function el75_Callback(hObject, eventdata, handles)
% hObject    handle to el75 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el75


% --- Executes on button press in el76.
function el76_Callback(hObject, eventdata, handles)
% hObject    handle to el76 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el76


% --- Executes on button press in el77.
function el77_Callback(hObject, eventdata, handles)
% hObject    handle to el77 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el77


% --- Executes on button press in el82.
function el82_Callback(hObject, eventdata, handles)
% hObject    handle to el82 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el82


% --- Executes on button press in el83.
function el83_Callback(hObject, eventdata, handles)
% hObject    handle to el83 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el83


% --- Executes on button press in el84.
function el84_Callback(hObject, eventdata, handles)
% hObject    handle to el84 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el84


% --- Executes on button press in el85.
function el85_Callback(hObject, eventdata, handles)
% hObject    handle to el85 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el85


% --- Executes on button press in el86.
function el86_Callback(hObject, eventdata, handles)
% hObject    handle to el86 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el86


% --- Executes on button press in el87.
function el87_Callback(hObject, eventdata, handles)
% hObject    handle to el87 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el87


% --- Executes on button press in el21.
function el21_Callback(hObject, eventdata, handles)
% hObject    handle to el21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el21


% --- Executes on button press in el31.
function el31_Callback(hObject, eventdata, handles)
% hObject    handle to el31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el31


% --- Executes on button press in el41.
function el41_Callback(hObject, eventdata, handles)
% hObject    handle to el41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el41


% --- Executes on button press in el51.
function el51_Callback(hObject, eventdata, handles)
% hObject    handle to el51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el51


% --- Executes on button press in el61.
function el61_Callback(hObject, eventdata, handles)
% hObject    handle to el61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of el61


% --- Executes on button press in el71.
function el71_Callback(hObject, eventdata, handles)
% hObject    handle to el71 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el71


% --- Executes on button press in el28.
function el28_Callback(hObject, eventdata, handles)
% hObject    handle to el28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el28


% --- Executes on button press in el38.
function el38_Callback(hObject, eventdata, handles)
% hObject    handle to el38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el38


% --- Executes on button press in el48.
function el48_Callback(hObject, eventdata, handles)
% hObject    handle to el48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el48


% --- Executes on button press in el58.
function el58_Callback(hObject, eventdata, handles)
% hObject    handle to el58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el58


% --- Executes on button press in el68.
function el68_Callback(hObject, eventdata, handles)
% hObject    handle to el68 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el68


% --- Executes on button press in el78.
function el78_Callback(hObject, eventdata, handles)
% hObject    handle to el78 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of el78






% --- Executes during object creation, after setting all properties.
function Configuration120_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Configuration120 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called





% --- Executes on button press in elA04.
function elA04_Callback(hObject, eventdata, handles)
% hObject    handle to elA04 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elA04


% --- Executes on button press in elA05.
function elA05_Callback(hObject, eventdata, handles)
% hObject    handle to elA05 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elA05


% --- Executes on button press in elA06.
function elA06_Callback(hObject, eventdata, handles)
% hObject    handle to elA06 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elA06


% --- Executes on button press in elA07.
function elA07_Callback(hObject, eventdata, handles)
% hObject    handle to elA07 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elA07


% --- Executes on button press in elA08.
function elA08_Callback(hObject, eventdata, handles)
% hObject    handle to elA08 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elA08


% --- Executes on button press in elA09.
function elA09_Callback(hObject, eventdata, handles)
% hObject    handle to elA09 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elA09


% --- Executes on button press in elB03.
function elB03_Callback(hObject, eventdata, handles)
% hObject    handle to elB03 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elB03


% --- Executes on button press in elB05.
function elB05_Callback(hObject, eventdata, handles)
% hObject    handle to elB05 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elB05


% --- Executes on button press in elB04.
function elB04_Callback(hObject, eventdata, handles)
% hObject    handle to elB04 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elB04


% --- Executes on button press in elB06.
function elB06_Callback(hObject, eventdata, handles)
% hObject    handle to elB06 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elB06


% --- Executes on button press in elB08.
function elB08_Callback(hObject, eventdata, handles)
% hObject    handle to elB08 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elB08


% --- Executes on button press in elB09.
function elB09_Callback(hObject, eventdata, handles)
% hObject    handle to elB09 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elB09


% --- Executes on button press in elD10.
function elB10_Callback(hObject, eventdata, handles)
% hObject    handle to elD10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elD10


% --- Executes on button press in elD01.
function elD01_Callback(hObject, eventdata, handles)
% hObject    handle to elD01 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elD01


% --- Executes on button press in elC02.
function elC02_Callback(hObject, eventdata, handles)
% hObject    handle to elC02 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elC02


% --- Executes on button press in elC03.
function elC03_Callback(hObject, eventdata, handles)
% hObject    handle to elC03 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elC03


% --- Executes on button press in elC04.
function elC04_Callback(hObject, eventdata, handles)
% hObject    handle to elC04 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elC04


% --- Executes on button press in elC05.
function elC05_Callback(hObject, eventdata, handles)
% hObject    handle to elC05 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elC05


% --- Executes on button press in elC06.
function elC06_Callback(hObject, eventdata, handles)
% hObject    handle to elC06 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elC06


% --- Executes on button press in elC07.
function elC07_Callback(hObject, eventdata, handles)
% hObject    handle to elC07 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elC07


% --- Executes on button press in elC08.
function elC08_Callback(hObject, eventdata, handles)
% hObject    handle to elC08 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elC08


% --- Executes on button press in elC09.
function elC09_Callback(hObject, eventdata, handles)
% hObject    handle to elC09 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elC09


% --- Executes on button press in elD10.
function elD10_Callback(hObject, eventdata, handles)
% hObject    handle to elD10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elD10


% --- Executes on button press in elC11.
function elC11_Callback(hObject, eventdata, handles)
% hObject    handle to elC11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elC11


% --- Executes on button press in elD02.
function elD02_Callback(hObject, eventdata, handles)
% hObject    handle to elD02 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elD02


% --- Executes on button press in elD03.
function elD03_Callback(hObject, eventdata, handles)
% hObject    handle to elD03 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elD03


% --- Executes on button press in elD04.
function elD04_Callback(hObject, eventdata, handles)
% hObject    handle to elD04 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elD04


% --- Executes on button press in elD05.
function elD05_Callback(hObject, eventdata, handles)
% hObject    handle to elD05 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elD05


% --- Executes on button press in elD06.
function elD06_Callback(hObject, eventdata, handles)
% hObject    handle to elD06 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elD06


% --- Executes on button press in elD07.
function elD07_Callback(hObject, eventdata, handles)
% hObject    handle to elD07 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elD07


% --- Executes on button press in elD08.
function elD08_Callback(hObject, eventdata, handles)
% hObject    handle to elD08 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elD08


% --- Executes on button press in elD09.
function elD09_Callback(hObject, eventdata, handles)
% hObject    handle to elD09 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elD09


% --- Executes on button press in elE10.
function elE10_Callback(hObject, eventdata, handles)
% hObject    handle to elE10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elE10


% --- Executes on button press in elD11.
function elD11_Callback(hObject, eventdata, handles)
% hObject    handle to elD11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elD11


% --- Executes on button press in elE12.
function elE12_Callback(hObject, eventdata, handles)
% hObject    handle to elE12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elE12


% --- Executes on button press in elE01.
function elE01_Callback(hObject, eventdata, handles)
% hObject    handle to elE01 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elE01


% --- Executes on button press in elE02.
function elE02_Callback(hObject, eventdata, handles)
% hObject    handle to elE02 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elE02


% --- Executes on button press in elE03.
function elE03_Callback(hObject, eventdata, handles)
% hObject    handle to elE03 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elE03


% --- Executes on button press in elE04.
function elE04_Callback(hObject, eventdata, handles)
% hObject    handle to elE04 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elE04


% --- Executes on button press in elE05.
function elE05_Callback(hObject, eventdata, handles)
% hObject    handle to elE05 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elE05


% --- Executes on button press in elE06.
function elE06_Callback(hObject, eventdata, handles)
% hObject    handle to elE06 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elE06


% --- Executes on button press in elE07.
function elE07_Callback(hObject, eventdata, handles)
% hObject    handle to elE07 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elE07


% --- Executes on button press in elF07.
function elF07_Callback(hObject, eventdata, handles)
% hObject    handle to elF07 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elF07


% --- Executes on button press in elE08.
function elE08_Callback(hObject, eventdata, handles)
% hObject    handle to elE08 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elE08


% --- Executes on button press in elE09.
function elE09_Callback(hObject, eventdata, handles)
% hObject    handle to elE09 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elE09


% --- Executes on button press in elF10.
function elF10_Callback(hObject, eventdata, handles)
% hObject    handle to elF10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elF10


% --- Executes on button press in elF11.
function elF11_Callback(hObject, eventdata, handles)
% hObject    handle to elF11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elF11


% --- Executes on button press in radiobutton114.
function radiobutton114_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton114 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of radiobutton114


% --- Executes on button press in elF01.
function elF01_Callback(hObject, eventdata, handles)
% hObject    handle to elF01 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elF01


% --- Executes on button press in elF02.
function elF02_Callback(hObject, eventdata, handles)
% hObject    handle to elF02 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elF02


% --- Executes on button press in elF03.
function elF03_Callback(hObject, eventdata, handles)
% hObject    handle to elF03 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elF03


% --- Executes on button press in elF04.
function elF04_Callback(hObject, eventdata, handles)
% hObject    handle to elF04 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elF04


% --- Executes on button press in elF05.
function elF05_Callback(hObject, eventdata, handles)
% hObject    handle to elF05 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elF05


% --- Executes on button press in elF06.
function elF06_Callback(hObject, eventdata, handles)
% hObject    handle to elF06 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elF06


% --- Executes on button press in elG07.
function elG07_Callback(hObject, eventdata, handles)
% hObject    handle to elG07 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elG07


% --- Executes on button press in elF08.
function elF08_Callback(hObject, eventdata, handles)
% hObject    handle to elF08 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elF08


% --- Executes on button press in elF09.
function elF09_Callback(hObject, eventdata, handles)
% hObject    handle to elF09 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elF09


% --- Executes on button press in elG10.
function elG10_Callback(hObject, eventdata, handles)
% hObject    handle to elG10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elG10


% --- Executes on button press in elG11.
function elG11_Callback(hObject, eventdata, handles)
% hObject    handle to elG11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elG11


% --- Executes on button press in elG12.
function elG12_Callback(hObject, eventdata, handles)
% hObject    handle to elG12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elG12


% --- Executes on button press in elG01.
function elG01_Callback(hObject, eventdata, handles)
% hObject    handle to elG01 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elG01


% --- Executes on button press in elG02.
function elG02_Callback(hObject, eventdata, handles)
% hObject    handle to elG02 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elG02


% --- Executes on button press in elG03.
function elG03_Callback(hObject, eventdata, handles)
% hObject    handle to elG03 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elG03


% --- Executes on button press in elG04.
function elG04_Callback(hObject, eventdata, handles)
% hObject    handle to elG04 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elG04


% --- Executes on button press in elG05.
function elG05_Callback(hObject, eventdata, handles)
% hObject    handle to elG05 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elG05


% --- Executes on button press in elG06.
function elG06_Callback(hObject, eventdata, handles)
% hObject    handle to elG06 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elG06


% --- Executes on button press in elH07.
function elH07_Callback(hObject, eventdata, handles)
% hObject    handle to elH07 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elH07


% --- Executes on button press in elG08.
function elG08_Callback(hObject, eventdata, handles)
% hObject    handle to elG08 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elG08


% --- Executes on button press in elG09.
function elG09_Callback(hObject, eventdata, handles)
% hObject    handle to elG09 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elG09


% --- Executes on button press in elH10.
function elH10_Callback(hObject, eventdata, handles)
% hObject    handle to elH10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elH10


% --- Executes on button press in elH11.
function elH11_Callback(hObject, eventdata, handles)
% hObject    handle to elH11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elH11


% --- Executes on button press in elH12.
function elH12_Callback(hObject, eventdata, handles)
% hObject    handle to elH12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elH12


% --- Executes on button press in elH01.
function elH01_Callback(hObject, eventdata, handles)
% hObject    handle to elH01 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elH01


% --- Executes on button press in elH02.
function elH02_Callback(hObject, eventdata, handles)
% hObject    handle to elH02 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elH02


% --- Executes on button press in elH03.
function elH03_Callback(hObject, eventdata, handles)
% hObject    handle to elH03 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elH03


% --- Executes on button press in elH04.
function elH04_Callback(hObject, eventdata, handles)
% hObject    handle to elH04 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elH04


% --- Executes on button press in elH05.
function elH05_Callback(hObject, eventdata, handles)
% hObject    handle to elH05 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elH05


% --- Executes on button press in elH06.
function elH06_Callback(hObject, eventdata, handles)
% hObject    handle to elH06 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elH06


% --- Executes on button press in elJ07.
function elJ07_Callback(hObject, eventdata, handles)
% hObject    handle to elJ07 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elJ07


% --- Executes on button press in elH08.
function elH08_Callback(hObject, eventdata, handles)
% hObject    handle to elH08 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elH08


% --- Executes on button press in elH09.
function elH09_Callback(hObject, eventdata, handles)
% hObject    handle to elH09 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elH09


% --- Executes on button press in elJ11.
function elJ11_Callback(hObject, eventdata, handles)
% hObject    handle to elJ11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elJ11


% --- Executes on button press in elJ12.
function elJ12_Callback(hObject, eventdata, handles)
% hObject    handle to elJ12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elJ12


% --- Executes on button press in elJ01.
function elJ01_Callback(hObject, eventdata, handles)
% hObject    handle to elJ01 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elJ01


% --- Executes on button press in elJ02.
function elJ02_Callback(hObject, eventdata, handles)
% hObject    handle to elJ02 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elJ02


% --- Executes on button press in elJ03.
function elJ03_Callback(hObject, eventdata, handles)
% hObject    handle to elJ03 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elJ03


% --- Executes on button press in elJ04.
function elJ04_Callback(hObject, eventdata, handles)
% hObject    handle to elJ04 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elJ04


% --- Executes on button press in elJ05.
function elJ05_Callback(hObject, eventdata, handles)
% hObject    handle to elJ05 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elJ05


% --- Executes on button press in elJ06.
function elJ06_Callback(hObject, eventdata, handles)
% hObject    handle to elJ06 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elJ06


% --- Executes on button press in elK07.
function elK07_Callback(hObject, eventdata, handles)
% hObject    handle to elK07 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elK07


% --- Executes on button press in elJ08.
function elJ08_Callback(hObject, eventdata, handles)
% hObject    handle to elJ08 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elJ08


% --- Executes on button press in elJ09.
function elJ09_Callback(hObject, eventdata, handles)
% hObject    handle to elJ09 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elJ09


% --- Executes on button press in elJ10.
function elJ10_Callback(hObject, eventdata, handles)
% hObject    handle to elJ10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elJ10


% --- Executes on button press in elK11.
function elK11_Callback(hObject, eventdata, handles)
% hObject    handle to elK11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elK11


% --- Executes on button press in elD12.
function elD12_Callback(hObject, eventdata, handles)
% hObject    handle to elD12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elD12


% --- Executes on button press in elK02.
function elK02_Callback(hObject, eventdata, handles)
% hObject    handle to elK02 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elK02


% --- Executes on button press in elK03.
function elK03_Callback(hObject, eventdata, handles)
% hObject    handle to elK03 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elK03


% --- Executes on button press in elK04.
function elK04_Callback(hObject, eventdata, handles)
% hObject    handle to elK04 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elK04


% --- Executes on button press in elK05.
function elK05_Callback(hObject, eventdata, handles)
% hObject    handle to elK05 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elK05


% --- Executes on button press in elK06.
function elK06_Callback(hObject, eventdata, handles)
% hObject    handle to elK06 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elK06


% --- Executes on button press in elL08.
function elL08_Callback(hObject, eventdata, handles)
% hObject    handle to elL08 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elL08


% --- Executes on button press in elK08.
function elK08_Callback(hObject, eventdata, handles)
% hObject    handle to elK08 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elK08


% --- Executes on button press in elK09.
function elK09_Callback(hObject, eventdata, handles)
% hObject    handle to elK09 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elK09


% --- Executes on button press in elK10.
function elK10_Callback(hObject, eventdata, handles)
% hObject    handle to elK10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elK10


% --- Executes on button press in elM04.
function elM04_Callback(hObject, eventdata, handles)
% hObject    handle to elM04 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elM04


% --- Executes on button press in elL03.
function elL03_Callback(hObject, eventdata, handles)
% hObject    handle to elL03 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elL03


% --- Executes on button press in elL04.
function elL04_Callback(hObject, eventdata, handles)
% hObject    handle to elL04 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elL04


% --- Executes on button press in elL05.
function elL05_Callback(hObject, eventdata, handles)
% hObject    handle to elL05 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elL05


% --- Executes on button press in L07.
function L07_Callback(hObject, eventdata, handles)
% hObject    handle to L07 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of L07


% --- Executes on button press in elL07.
function elL07_Callback(hObject, eventdata, handles)
% hObject    handle to elL07 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elL07


% --- Executes on button press in eM08.
function eM08_Callback(hObject, eventdata, handles)
% hObject    handle to eM08 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of eM08


% --- Executes on button press in elL10.
function elL10_Callback(hObject, eventdata, handles)
% hObject    handle to elL10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elL10


% --- Executes on button press in elM05.
function elM05_Callback(hObject, eventdata, handles)
% hObject    handle to elM05 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elM05


% --- Executes on button press in elM06.
function elM06_Callback(hObject, eventdata, handles)
% hObject    handle to elM06 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elM06


% --- Executes on button press in elM07.
function elM07_Callback(hObject, eventdata, handles)
% hObject    handle to elM07 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elM07


% --- Executes on button press in elL09.
function elL09_Callback(hObject, eventdata, handles)
% hObject    handle to elL09 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elL09


% --- Executes on button press in elM09.
function elM09_Callback(hObject, eventdata, handles)
% hObject    handle to elM09 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elM09


% --- Executes on button press in elE11.
function elE11_Callback(hObject, eventdata, handles)
% hObject    handle to elE11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elE11


% --- Executes on button press in elF12.
function elF12_Callback(hObject, eventdata, handles)
% hObject    handle to elF12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elF12


% --- Executes on button press in radiobutton191.
function radiobutton191_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton191 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of radiobutton191


% --- Executes on button press in elB07.
function elB07_Callback(hObject, eventdata, handles)
% hObject    handle to elB07 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elB07


% --- Executes on button press in elL06.
function elL06_Callback(hObject, eventdata, handles)
% hObject    handle to elL06 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elL06


% --- Executes on button press in elC10.
function elC10_Callback(hObject, eventdata, handles)
% hObject    handle to elC10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elC10


% --- Executes on button press in elM08.
function elM08_Callback(hObject, eventdata, handles)
% hObject    handle to elM08 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SelectElectrode(handles, hObject);
    guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of elM08
