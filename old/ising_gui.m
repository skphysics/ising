function varargout = ising_gui(varargin)
% ISING_GUI MATLAB code for ising_gui.fig
%      ISING_GUI, by itself, creates a new ISING_GUI or raises the existing
%      singleton*.
%
%      H = ISING_GUI returns the handle to a new ISING_GUI or the handle to
%      the existing singleton*.
%
%      ISING_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ISING_GUI.M with the given input arguments.
%
%      ISING_GUI('Property','Value',...) creates a new ISING_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ising_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ising_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ising_gui

% Last Modified by GUIDE v2.5 16-Feb-2018 05:40:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ising_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @ising_gui_OutputFcn, ...
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


% --- Executes just before ising_gui is made visible.
function ising_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ising_gui (see VARARGIN)



% Choose default command line output for ising_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ising_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ising_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%Physical parameters:
J=1; %exchange constant (joules) 
T=1.6*2*J / log(1+sqrt(2));%J*tem; %k*temperature (joules)
Tmin=0.01; Tmax=5;
%System size:
N=2^5; %NxN square grid
time=100000; %number of time steps

p=0.01; %initial Boltzmann factor
%S=-1*ones(N,N); %initial spin matrix (all spins down)
S=sign(p-rand(N,N));

%Metropolis algorithm
for t=1:time
    %generate two random numbers ii & jj here to swap (ii,jj)'th random spin
    r=1+randi(N-1,1,2); %2 random integers between 1 & N
    ii=r(1); jj=r(2); %save column (ii) and row (jj) indices
    %find its nearest neighbors (periodic boundary conditions)
    above = mod(jj - 1 - 1, size(S,1)) + 1;
    below = mod(jj + 1 - 1, size(S,1)) + 1;
    left  = mod(ii - 1 - 1, size(S,2)) + 1;
    right = mod(ii + 1 - 1, size(S,2)) + 1;
    St=S(ii,jj); %choose a random spin
    %calculate the energy component if that spin is flipped
    E_t=-J*(-St)*(S(right,jj)+S(left,jj)...
        +S(ii,above)+S(ii,below));
    if E_t<0
        %flip the spin if that reduces the energy
        S(ii,jj)=-St;
    else
        %if that increases the energy, then flip the spin with probability,
        %supressed by the corresponding boltzmann factor p=exp(-delta_E/T)
        delta_E=2*E_t; %energy change due to the flip
        p=exp(-delta_E/T); %update Boltzmann factor (probability)        
        x=rand; %uniform random variable
        if x<p
            S(ii,jj)=-St;
        else
            S(ii,jj)=St;
        end
    end
    
    pause(0.0001)
    [r, c] = size(S);                          % Get the matrix size
    clf;
    imagesc((1:c)+0.5, (1:r)+0.5, S);       % Plot the image
    colormap(gray);                              % Use a gray colormap
    axis equal                                   % Make axes grid sizes equal
    set(gca, 'XTick', 1:(c+1), 'YTick', 1:(r+1), ...  % Change some axes properties
        'XLim', [1 c+1], 'YLim', [1 r+1], ...
        'GridLineStyle', '-', 'XGrid', 'on', 'YGrid', 'on');
        %Plot the current spin grid
end



% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

