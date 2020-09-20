function varargout = DemodulatorGUI(varargin)
% DEMODULATORGUI MATLAB code for DemodulatorGUI.fig
%      DEMODULATORGUI, by itself, creates a new DEMODULATORGUI or raises the existing
%      singleton*.
%
%      H = DEMODULATORGUI returns the handle to a new DEMODULATORGUI or the handle to
%      the existing singleton*.
%
%      DEMODULATORGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEMODULATORGUI.M with the given input arguments.
%
%      DEMODULATORGUI('Property','Value',...) creates a new DEMODULATORGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DemodulatorGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DemodulatorGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DemodulatorGUI

% Last Modified by GUIDE v2.5 30-Apr-2020 18:37:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DemodulatorGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @DemodulatorGUI_OutputFcn, ...
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


% --- Executes just before DemodulatorGUI is made visible.
function DemodulatorGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DemodulatorGUI (see VARARGIN)

% Choose default command line output for DemodulatorGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DemodulatorGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DemodulatorGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

path = ' ';
[file,path] = uigetfile;
handles = guidata(hObject);
handles.file = file;
if isequal(file,0)
   disp('User selected Cancel');
else
    [filepath,name,ext] = fileparts(file);
   
   if(ext == ".mat")
       
        temp = load(file(1,:))
        fn = fieldnames(temp);
        Data = temp.(fn{1});
        Time = Data(2,2:end);
        handles.y = Data(1,2:end);
        fs = Data(1,1);
        str2 = [path, file];
        set(handles.text2,'String',str2);
        
        
        if (get(handles.edit1,'String'))==""
            
            g = msgbox("You did not choose the % of signal to be cut so it is set to 0");
            
        end
        
        if get(handles.edit1,'String')~=""
           
            if isnan(str2double(get(handles.edit1,'String')))||str2double(get(handles.edit1,'String'))<=0
            g = msgbox("You put an incorrect value of percentage so the percentage is set to 0");
            handles.y = handles.y
            end
            
            if ~isnan(str2double(get(handles.edit1,'String')))&&~(str2double(get(handles.edit1,'String'))==0)&&sign(str2double(get(handles.edit1,'String')))~=-1
            str = get(handles.edit1,'String')    
            g = msgbox("You put the value of percentage of a signal to be cut = " + str);
            percentToCut = str2double(get(handles.edit1,'String'));
            whereToCut = ceil(length(handles.y)*(percentToCut/100))
            handles.y = handles.y(whereToCut:end);
            y = handles.y;
            Time = Data(2,whereToCut:end-1);
            end

            
        end
        
        axes(handles.axes1); % Switch current axes to axes11.
        plot(Time,handles.y); % Will plot into axes11.
        grid on
   
        [fftvalues] = fftfunction(handles.y);
        
        switch get(handles.popupmenu1,'Value')
            
            case 1
                
            window = hamming(length(fftvalues) )
            fftvalues = fftvalues.*window';
                
            case 2
                
            window = hann(length(fftvalues) )
            fftvalues = fftvalues.*window';    
                
            case 3
                
            window = gausswin(length(fftvalues) )
            fftvalues = fftvalues.*window';      
                
            case 4
                
            window = kaiser(length(fftvalues) )
            fftvalues = fftvalues.*window';      
                
            case 5
                
            window = rectwin(length(fftvalues) )
            fftvalues = fftvalues.*window';      
                
        end
        
        df = fs/length(fftvalues);
        n = length(fftvalues);
        sampleIndex = 0:length(fftvalues)-1;
        % create a copy that is multiplied by the complex operator
        complexf = i*fftvalues;

        % find indices of positive and negative frequencies
        positive = 2:floor(n/2)+mod(n,2);
        negative = ceil(n/2)+1+~mod(n,2):n;

        % rotate Fourier coefficients
        % (note 1: this works by computing the iAsin(2pft) component, i.e., the phase quadrature)
        % (note 2: positive frequencies are rotated counter-clockwise; negative frequencies are rotated clockwise)
        fftvalues(positive) = fftvalues(positive) + -1i*complexf(positive);
        fftvalues(negative) = fftvalues(negative) +  1i*complexf(negative);
        
        
        ifftvalues = ifftfunction(fftvalues);
        save('ifftvalues.mat','ifftvalues')
        
        B = ifftvalues;
              
        amplitude = (abs(B)); %envelope extraction
        amplitude2 = (-abs(B));
        phase = unwrap(angle(B));%inst phase
        freq = diff(phase)/(2*pi)*fs;%inst frequency

        t=0:1/fs:length(B)/fs;
        p = polyfit(t(1:end-1),phase,1); %linearly fit the instaneous phase
        estimated = polyval(p,t); %re-evaluate the offset term using the fitted values
        offsetTerm = estimated(1:end-1);

        demodulated = phase - offsetTerm;
 
        freq = freq-mean(freq)
        f = df:df:fs-1;
        
        switch get(handles.listbox1,'Value')
            
            case 1
            axes(handles.axes4); % Switch current axes to axes11.
            plot(Time,demodulated); %demodulated signal
            grid on    
                
                
            case 2
            axes(handles.axes4); % Switch current axes to axes11.
            plot(Time(1:length(freq)),freq); %demodulated signal
            grid on    
                
        end
        
        
        axes(handles.axes3); % Switch current axes to axes11.
        plot(Time,amplitude,'b'); %demodulated signal
        grid on
        hold on
        plot(Time,amplitude2,'b')
        hold on
        plot(Time,handles.y,'k'); % Will plot into axes11.
        hold off
        
        axes(handles.axes5); % Switch current axes to axes11.
        plot(Time,amplitude,'b'); %demodulated signal
        grid on
        
       [fftdemodulated]= fftfunction(B);
        
        axes(handles.axes2); % Switch current axes to axes11.
       plot(f,abs(fftdemodulated(1:length(f)))); %demodulated signal
       
       ReceivedData.ModulatedSig = handles.y;
       ReceivedData.FFT = fftfunction(B);
       ReceivedData.Time = Time;
       ReceivedData.AMinformation = amplitude;
       ReceivedData.Phase = demodulated;
       ReceivedData.FreqFM = freq;
       save('Received.mat','ReceivedData')
   else  
        
       
           
  
       file = 0;
       f = msgbox('You chose the incorrect extension. The correct one is .mat');
       
   end
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
