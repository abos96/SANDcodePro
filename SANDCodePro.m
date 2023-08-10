function varargout = SANDCodePro(varargin)
% SANDCODEPRO MATLAB code for SANDCodePro.fig
%      SANDCODEPRO, by itself, creates a new SANDCODEPRO or raises the existing
%      singleton*.
%
%      H = SANDCODEPRO returns the handle to a new SANDCODEPRO or the handle to
%      the existing singleton*.
%
%      SANDCODEPRO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SANDCODEPRO.M with the given input arguments.
%
%      SANDCODEPRO('Property','Value',...) creates a new SANDCODEPRO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SANDCodePro_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SANDCodePro_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SANDCodePro

% Last Modified by GUIDE v2.5 10-Aug-2023 17:16:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SANDCodePro_OpeningFcn, ...
                   'gui_OutputFcn',  @SANDCodePro_OutputFcn, ...
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


% --- Executes just before SANDCodePro is made visible.
function SANDCodePro_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SANDCodePro (see VARARGIN)

% Choose default command line output for SANDCodePro
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SANDCodePro wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SANDCodePro_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)

    imageFilePath = 'logo.jpeg';
    image = imread(imageFilePath);
    

    % Get the handles structure to access GUI components
    handles = guidata(hObject);

    % Plot the image in the axes
     % Use the name of your axes component
    imshow(image);
    
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --------------------------------------------------------------------
function Conversion_Callback(hObject, eventdata, handles)
% hObject    handle to Conversion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_7_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_6_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function unt_Callback(hObject, eventdata, handles)
% hObject    handle to unt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Multiconverter_Callback(hObject, eventdata, handles)
% hObject    handle to Multiconverter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MultiConverter


% --------------------------------------------------------------------
function spk2mat_Threshold_Callback(hObject, eventdata, handles)
% hObject    handle to spk2mat_Threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Main_mat2spk


% --------------------------------------------------------------------
function comp_MFR_Callback(hObject, eventdata, handles)
% hObject    handle to comp_MFR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Main_mfr

% --------------------------------------------------------------------
function Plot_MFR_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_MFR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Plot_mfr


% --------------------------------------------------------------------
function det_burst_string_Callback(hObject, eventdata, handles)
% hObject    handle to det_burst_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Main_burstdetection


% --------------------------------------------------------------------
function Burst_stat_Callback(hObject, eventdata, handles)
% hObject    handle to Burst_stat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MAIN_StatisticReportMean

% --------------------------------------------------------------------
function plot_burst_stat_Callback(hObject, eventdata, handles)
% hObject    handle to plot_burst_stat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Main_BurstPlot

% --------------------------------------------------------------------
function sttc_Callback(hObject, eventdata, handles)
% hObject    handle to plot_burst_stat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MainConnectivity


% --------------------------------------------------------------------
function graph_stat_Callback(hObject, eventdata, handles)
% hObject    handle to graph_stat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MainGraphAnalysis

% --------------------------------------------------------------------
function plot_indv_graph_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to plot_indv_graph_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Main_Individual_plot_graphAnalysis

% --------------------------------------------------------------------
function plot_graph_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to plot_graph_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Main_plot_graphAnalysis


% --------------------------------------------------------------------
function createSpreadSheet_Callback(hObject, eventdata, handles)
% hObject    handle to createSpreadSheet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GenerateCSV