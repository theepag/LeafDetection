function varargout = leaf_detect(varargin)
%LEAF_DETECT MATLAB code file for leaf_detect.fig
%      LEAF_DETECT, by itself, creates a new LEAF_DETECT or raises the existing
%      singleton*.
%
%      H = LEAF_DETECT returns the handle to a new LEAF_DETECT or the handle to
%      the existing singleton*.
%
%      LEAF_DETECT('Property','Value',...) creates a new LEAF_DETECT using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to leaf_detect_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      LEAF_DETECT('CALLBACK') and LEAF_DETECT('CALLBACK',hObject,...) call the
%      local function named CALLBACK in LEAF_DETECT.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help leaf_detect

% Last Modified by GUIDE v2.5 22-Apr-2020 17:58:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @leaf_detect_OpeningFcn, ...
                   'gui_OutputFcn',  @leaf_detect_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before leaf_detect is made visible.
function leaf_detect_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for leaf_detect
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes leaf_detect wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = leaf_detect_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Load image to GUI.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1);
[Sel_Img,SelImage_Path] = uigetfile({'*.jpg;*.png;*.bmp'},pwd,'Pick the test image file');
SelImage_Path = [SelImage_Path Sel_Img];

if Sel_Img == 0
    return;
end

image = imread(SelImage_Path);

axes(handles.axes1);
imshow(image), title('Image for Recognition');

handles.image = image;

guidata(hObject,handles);


% --- Image training.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

im = handles.blackwhiteimg;
c=input('Enter the Class(Number from 1-50)');
%% Feature Extraction
F=feature_statistical(im);
try 
    load DB;
    
    F=[F c];
    DB=[DB; F];
    save DB.mat DB 
catch 
    DB=[F c]; % 10 12 1
    save DB.mat DB
end
% --- Image testing.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Test leaf Image

cla(handles.axes7);
[Sel_Img,SelImage_Path] = uigetfile({'*.jpg;*.png;*.bmp'},pwd,'Pick the test image file');
SelImage_Path = [SelImage_Path Sel_Img];

if Sel_Img == 0
    return;
end

im1 = imread(SelImage_Path);
im = im2bw(im1);
axes(handles.axes7);
imshow(im), title('Image for Testing');

handles.Image = im;
guidata(hObject,handles);

%% Find the class the test plant image belongs
Ftest=feature_statistical(im);
%% Compare with the feature of training image in the database
load DB.mat
Ftrain=DB(:,1:2);
Ctrain=DB(:,3);
for (i=1:size(Ftrain,1));
    dist(i,:)=sum(abs(Ftrain(i,:)-Ftest));
end
Min=min(dist);
m=find(dist==Min,1);
det_class=Ctrain(m);
msgbox(strcat('Detected Class=',num2str(det_class)));
if det_class == 1
    helpdlg(' Camphor Leaf ');
    disp('Camphor Leaf');
elseif det_class == 2
    helpdlg(' Chineese Tulip Leaf ');
    disp(' Chinese Tulip Leaf ');
elseif det_class == 3
    helpdlg(' Ford woodlotus Leaf ');
    disp('Ford woodlotus Leaf');
elseif det_class == 4
    helpdlg(' Japanese cheese woods Leaf ');
    disp('Japanese cheese woods Leaf ');
elseif det_class == 5
    helpdlg(' Leaf redbud Leaf ');
    disp('Leaf redbud Leaf ');
elseif det_class == 6
    helpdlg(' Southern Magnelia Leaf ');
    disp('Southern Magnelia Leaf ');
elseif det_class == 7
    helpdlg(' Tangarine leaf ');
    disp('Tangarine Leaf ');
elseif det_class == 8
    helpdlg(' bamboo Leaf ');
    disp('bamboo Leaf ');
elseif det_class == 9
    helpdlg(' Banana Leaf ');
    disp('Banana Leaf ');
elseif det_class == 10
    helpdlg(' beals barberry Leaf ');
    disp('beals barberry Leaf ');
else
    helpdlg('Unable to recognize');
    disp('Unable to recognize');
end

% --- Converting to Black and white.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
 shadowless_img = handles.shadowremimg;
catch err
    msgbox('Perform pre-processing steps');
end

imgbw = im2bw(shadowless_img); % Need to change the size of the resize

% Displaying the image
axes(handles.axes6);
imshow(imgbw);
title('Black & White Image');

handles.blackwhiteimg = imgbw;
guidata(hObject,handles);

% --- Resetting the image.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2); cla(handles.axes2); title('');
axes(handles.axes1); cla(handles.axes1); title('');
axes(handles.axes3); cla(handles.axes3); title('');
axes(handles.axes5); cla(handles.axes5); title('');
axes(handles.axes6); cla(handles.axes6); title('');
axes(handles.axes7); cla(handles.axes7); title('');


% --- Image Resizing.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Image Resize
try
    image = handles.image;
catch err
    msgbox('Select the Image');
end


[row col channel] = size(image);
img_resized = imresize(image,[200 300]); % Need to change the size of the resize

% Displaying the image
axes(handles.axes2);
imshow(img_resized);
title('Resized Image(200*300)');

handles.ResizedImage = img_resized;
guidata(hObject,handles);

% --- Noise Removal.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    image_resized = handles.ResizedImage;
catch err
    msgbox('Please resize the image');
end

[cleanimg] = NoiseRemoval(image_resized);

axes(handles.axes5);
imshow(cleanimg);
title('Noise removed Image');

handles.cleanimg = cleanimg;
guidata(hObject,handles);


% --- Shadow removal.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    imag_for_shadow_rem = handles.cleanimg;
catch err
    msgbox('Please perform Noise Removal');
end

shadowless_img = ShadowRemoval(imag_for_shadow_rem);

axes(handles.axes3);
imshow(shadowless_img);
title('Image after Shadow Removal');

handles.shadowremimg = shadowless_img;
guidata(hObject,handles);
