function varargout = ModulatorGUI(varargin)
% MODULATORGUI MATLAB code for ModulatorGUI.fig
%      MODULATORGUI, by itself, creates a new MODULATORGUI or raises the existing
%      singleton*.
%
%      H = MODULATORGUI returns the handle to a new MODULATORGUI or the handle to
%      the existing singleton*.
%
%      MODULATORGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODULATORGUI.M with the given input arguments.
%
%      MODULATORGUI('Property','Value',...) creates a new MODULATORGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ModulatorGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ModulatorGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ModulatorGUI

% Last Modified by GUIDE v2.5 23-Apr-2020 15:01:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ModulatorGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ModulatorGUI_OutputFcn, ...
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


% --- Executes just before ModulatorGUI is made visible.
function ModulatorGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ModulatorGUI (see VARARGIN)

% Choose default command line output for ModulatorGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ModulatorGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ModulatorGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in modulate.
function modulate_Callback(hObject, eventdata, handles)
% hObject    handle to modulate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%CZESTOTLIWOSCI SINUSOW
f1 = str2num(get(handles.edit_fSinus1,'string')); 
f2 = str2num(get(handles.edit_fSinus2,'string')); 
f3 = str2num(get(handles.edit_fSinus3,'string')); 
f4 = str2num(get(handles.edit_fSinus4,'string')); 
time = str2num(get(handles.edit_time,'string')); 
sampFreq = str2num(get(handles.edit_sampFreq,'string')); 
carrierFreq = str2num(get(handles.edit_carrierFreq,'string')); 
check3 = get(handles.check_fSinus3,'value');
check4 = get(handles.check_fSinus4,'value');
modType = get(handles.radioButtonGroup,'SelectedObject');
whichModType = get(modType,'String');
fDev = 1;
F = [f1 f2 f3 f4];
everythingOK = 1;

set(handles.text_errorUP,'String','');
set(handles.text_errorDOWN,'String','');
set(handles.edit_fSinus1,'BackgroundColor','1 1 1');
set(handles.edit_fSinus2,'BackgroundColor','1 1 1');
set(handles.edit_fSinus3,'BackgroundColor','1 1 1');
set(handles.edit_fSinus4,'BackgroundColor','1 1 1');
set(handles.edit_sampFreq,'BackgroundColor','1 1 1');
set(handles.edit_time,'BackgroundColor','1 1 1');
set(handles.edit_carrierFreq,'BackgroundColor','1 1 1');

%KONTROLA B£ÊDÓW _____________________________________________________
if(isempty(f1) || f1<=0)
    set(handles.text_errorUP,'String','Error! Please complete all needed data with positive values!');
    set(handles.edit_fSinus1,'BackgroundColor','1 0.5 0.5');
    everythingOK = 0;
elseif (isempty(f2) || f2<=0)
    set(handles.text_errorUP,'String','Error! Please complete all needed data with positive values!');
    set(handles.edit_fSinus2,'BackgroundColor','1 0.5 0.5');
    everythingOK = 0;
elseif (isempty(time) || time<=0)
    set(handles.text_errorUP,'String','Error! Please complete all needed data with positive values!');
    set(handles.edit_time,'BackgroundColor','1 0.5 0.5');
    everythingOK = 0;
elseif (isempty(sampFreq) || sampFreq<=0)
    set(handles.text_errorUP,'String','Error! Please complete all needed data with positive values!');
    set(handles.edit_sampFreq,'BackgroundColor','1 0.5 0.5');
    everythingOK = 0;
elseif (isempty(carrierFreq) || carrierFreq<=0)
    set(handles.text_errorUP,'String','Error! Please complete all needed data with positive values!');
    set(handles.edit_carrierFreq,'BackgroundColor','1 0.5 0.5');
    everythingOK = 0;
elseif (sampFreq < 2*carrierFreq)
    set(handles.text_errorUP,'String','Error! Sampling frequency must be at least 2*Carrier frequency!');
    set(handles.edit_sampFreq,'BackgroundColor','1 0.5 0.5');
    set(handles.edit_carrierFreq,'BackgroundColor','1 0.5 0.5');
    everythingOK = 0;
elseif(check3==1)
    if(isempty(f3) || f3<=0)
        set(handles.text_errorUP,'String','Error! Please complete all needed data with positive values!');
        set(handles.edit_fSinus3,'BackgroundColor','1 0.5 0.5');
        everythingOK = 0;
    end
    if(check4==1)
        if(isempty(f4) || f4<=0)
            set(handles.text_errorUP,'String','Error! Please complete all needed data with positive values!');
            set(handles.edit_fSinus4,'BackgroundColor','1 0.5 0.5');
            everythingOK = 0;
        end
    end
end


if(sampFreq <= 2*max(F))    
    idx = find(2*F >= sampFreq);
    for i=1:1:length(idx)
        checkvalue = idx(i);
        switch checkvalue
            case 1
                set(handles.edit_fSinus1,'BackgroundColor','1 0.5 0.5');
            case 2
                set(handles.edit_fSinus2,'BackgroundColor','1 0.5 0.5');
            case 3
                set(handles.edit_fSinus3,'BackgroundColor','1 0.5 0.5');
            case 4
                set(handles.edit_fSinus4,'BackgroundColor','1 0.5 0.5');
        end
    end
   set(handles.text_errorDOWN,'String','Warning! Too little Sampling frequency value. It may cause aliasing effect.');
   set(handles.edit_sampFreq,'BackgroundColor','1 0.5 0.5');
   everythingOK = 0;
end

%_________________________________________________________________________

if (everythingOK == 1)
    t = [0:1./sampFreq:time];
    x1 = sin(2*pi*f1*t);
    x2 = sin(2*pi*f2*t);
    x = x1 + x2;

    if(check3==1)
            x3 = sin(2*pi*f3*t);
            x = x + x3;
    end

    if(check4==1)
            x4 = sin(2*pi*f4*t);
            x = x + x4;
    end

    set(handles.text_errorUP,'String','');
        
end

if(everythingOK == 1)
    if(whichModType == "Amplitude Modulation")
            y = ammod(x,carrierFreq,sampFreq);

        elseif(whichModType == "Frequency Modulation")
            y = fmmod(x,carrierFreq,sampFreq,fDev);
    end
    
    t = [0:1./sampFreq:time];
    axes(handles.axes1);
    plot(t,x,'r',t,y,'b')
    xlabel('Time (s)')
    ylabel('Amplitude')
    legend('Original Signal','Modulated Signal')
    grid on
    
    Y = [sampFreq,y;sampFreq,t];
    
    save('ModulatedSignal.mat','Y')
end


function edit_time_Callback(hObject, eventdata, handles)
% hObject    handle to edit_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_time as text
%        str2double(get(hObject,'String')) returns contents of edit_time as a double


% --- Executes during object creation, after setting all properties.
function edit_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_sampFreq_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sampFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sampFreq as text
%        str2double(get(hObject,'String')) returns contents of edit_sampFreq as a double


% --- Executes during object creation, after setting all properties.
function edit_sampFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sampFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_carrierFreq_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carrierFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carrierFreq as text
%        str2double(get(hObject,'String')) returns contents of edit_carrierFreq as a double


% --- Executes during object creation, after setting all properties.
function edit_carrierFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carrierFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_fSinus2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fSinus2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fSinus2 as text
%        str2double(get(hObject,'String')) returns contents of edit_fSinus2 as a double


% --- Executes during object creation, after setting all properties.
function edit_fSinus2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fSinus2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_fSinus3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fSinus3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fSinus3 as text
%        str2double(get(hObject,'String')) returns contents of edit_fSinus3 as a double


% --- Executes during object creation, after setting all properties.
function edit_fSinus3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fSinus3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_fSinus4_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fSinus4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fSinus4 as text
%        str2double(get(hObject,'String')) returns contents of edit_fSinus4 as a double


% --- Executes during object creation, after setting all properties.
function edit_fSinus4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fSinus4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_fSinus1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fSinus1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fSinus1 as text
%        str2double(get(hObject,'String')) returns contents of edit_fSinus1 as a double


% --- Executes during object creation, after setting all properties.
function edit_fSinus1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fSinus1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in check_fSinus3.
function check_fSinus3_Callback(hObject, eventdata, handles)
% hObject    handle to check_fSinus3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_fSinus3
check3 = get(handles.check_fSinus3,'value');

if(check3==1)
    set(handles.edit_fSinus3,'Enable','on')
    set(handles.check_fSinus4,'Enable','on')

else
    set(handles.edit_fSinus3,'Enable','off')
    set(handles.check_fSinus4,'Enable','off')
    set(handles.check_fSinus4,'value',0)
    set(handles.edit_fSinus4,'Enable','off')
end


% --- Executes on button press in check_fSinus4.
function check_fSinus4_Callback(hObject, eventdata, handles)
% hObject    handle to check_fSinus4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_fSinus4

check4 = get(handles.check_fSinus4,'value');

if(check4==1)
    set(handles.edit_fSinus4,'Enable','on')
else
    set(handles.edit_fSinus4,'Enable','off')
end
