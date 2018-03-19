function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 13-Sep-2016 16:02:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in signal.
function signal_Callback(hObject, eventdata, handles)
% hObject    handle to signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[ip,Fs] = audioread('b1.wav');
signal_length=600000;
ip1=ip(1:signal_length,1);
L=length(ip1);
sec=rem(L,32000);
last=(L-sec)/32000;
handles.sig=ip1;
Filter=fir1(60,310/Fs,'High',hamming(61));
Con=conv(Filter,ip1);
L=length(Con);

[applause,decay_val,first_zerocross,total_block]=blockprocessing(Con);


blockcount=0;
for i=1:total_block-1
    count=0;
    for j=1:250
        if((decay_val((i-1)*250+j)>0.4)&&(decay_val((i-1)*250+j)<0.8))
            count=count+1;
        end
    end
    if(count>50)
        blockcount=blockcount+1;
        applause_block(blockcount)=i;
    end  
end
 interval=[];
    for i=1:blockcount
        interval(i,1)= (applause_block(i)-1)*2;
        interval(i,2)=(applause_block(i))*2;  
        
    end
    
handles.interval=interval;
handles.applause=applause;
handles.decay_val=decay_val;
handles.first_zerocross=first_zerocross;
handles.total_block=total_block;
guidata(hObject,handles);
plot(ip1);
% --- Executes on button press in show.
function show_Callback(hObject, eventdata, handles)
% hObject    handle to show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=handles.sig;
plot(data);

% --- Executes on button press in decay.
function decay_Callback(hObject, eventdata, handles)
% hObject    handle to decay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot(smooth(handles.decay_val));
% --- Executes on button press in zero.
function zero_Callback(hObject, eventdata, handles)
% hObject    handle to zero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plot(smooth(handles.first_zerocross));
% --- Executes on button press in video.
function video_Callback(hObject, eventdata, handles)
% hObject    handle to video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

vidObj=VideoReader('b1.flv.mpg');
[audio,fs]=audioread('b1.wav');
audio=audio(:,1);
framesPerSecond = get(vidObj,'FrameRate');
framesPerSecond=int16(framesPerSecond);
numFrames = get(vidObj,'NumberOfFrames');

l=length(handles.interval);
for i=1:5
audio1=audio(fs*handles.interval(i,1)+1 : fs*handles.interval(i,2));
 video = read(vidObj,[1+framesPerSecond*handles.interval(i,1) framesPerSecond*handles.interval(i,2)]);
h = implay(video,30);

play(h.DataSource.Controls);

 sound(audio1,fs);
end
