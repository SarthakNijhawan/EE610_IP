function varargout = GUI_1(varargin)
% GUI_1 MATLAB code for GUI_1.fig
%      GUI_1, by itself, creates a new GUI_1 or raises the existing
%      singleton*.
%
%      H = GUI_1 returns the handle to a new GUI_1 or the handle to
%      the existing singleton*.
%
%      GUI_1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_1.M with the given input arguments.
%
%      GUI_1('Property','Value',...) creates a new GUI_1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_1

% Last Modified by GUIDE v2.5 20-Aug-2018 00:28:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
				   'gui_Singleton',  gui_Singleton, ...
				   'gui_OpeningFcn', @GUI_1_OpeningFcn, ...
				   'gui_OutputFcn',  @GUI_1_OutputFcn, ...
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

% --- Executes just before GUI_1 is made visible.
function GUI_1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_1 (see VARARGIN)

% Choose default command line output for GUI_1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%%%-------------------------------------------------------------------------------------------------------%%%%%%
%%%%%%-------------------------------------------------------------------------------------------------------%%%%%%
%%%%%%-------------------------------------------------------------------------------------------------------%%%%%%

% Import an image
function import_image(hObject, eventdata, handles)

	% All files are allowed
	[File_Name, Path_Name] = uigetfile('*.*','File Selector');
	image_path = strcat(Path_Name, File_Name);
	
	% Loading the image
	handles.edited_image = imread(image_path);
	axes(handles.Edited_Image);
	imshow(handles.edited_image);
	
	handles.original_image = imread(image_path);
	guidata(hObject, handles);
	axes(handles.Original_Image)
	imshow(handles.original_image);

	% Creating a Cellular Array for storing the state of the images
	handles.current_state = 1;
	handles.state_stack = {};
	handles.state_stack{handles.current_state} = handles.original_image;
	guidata(hObject, handles);

function gamma_correction(hObject, eventdata, handles)
	
	gamma_value = str2double(inputdlg('Gamma value(0.01 - 10)','Gamma',1,{'1'}));
	% handles.Gamma_value = Gamma_value;
	handles.edited_image = gamma_corr(handles.state_stack{handles.current_state}, gamma_value);
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;
	guidata(hObject, handles);

	axes(handles.Edited_Image);
	imshow(handles.edited_image);


function histogram_equalization(hObject, eventdata, handles)
	
	handles.edited_image = equalize_hist(handles.state_stack{handles.current_state});
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;
	guidata(hObject, handles);

	axes(handles.Edited_Image);
	imshow(handles.edited_image);


function log_transformation(hObject, eventdata, handles)
	
	handles.edited_image = log_transform(handles.state_stack{handles.current_state});
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);


function save_image(hObject, eventdata, handles)

	[filename, foldername] = uiputfile('.jpg','File Selector');
	complete_name = fullfile(foldername, filename);
	imwrite(handles.handles.state_stack{handles.current_state}, complete_name);


function rotate(hObject, eventdata, handles)

	angle_deg = str2double(inputdlg('Enter the angle in degrees','Angle-Theta',1,{'0'}));       %dialog box for angle of rotation

	handles.edited_image = rotate_img(handles.state_stack{handles.current_state}, angle_deg);
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);


function reset_Callback(hObject, eventdata, handles)

	handles.edited_image = handles.original_image;
	handles.current_state = 1;
	handles.state_stack = {};
	handles.state_stack{handles.current_state} = handles.original_image;

	set(handles.slider1,'Value',0);
	set(handles.slider2,'Value',0);
	guidata(hObject,handles);

	axes(handles.Edited_Image);
	imshow(handles.edited_image);


function exit(hObject, eventdata, handles)

	clc;
	clf;
	% clear the variables
	clearStr = 'clear all';
	evalin('base',clearStr);
	% delete figures
	delete(handles.Original_Image);
	delete(handles.Edited_Image);
	close(gcf);


function translation(hObject, eventdata, handles)

	coordinate = str2double(inputdlg({'x-coordinate in pixels','y-coordinate in pixels'},'coordinates',1,{'0','0'}));
	handles.edited_image = translate_img(handles.state_stack{handles.current_state}, coordinate(1), coordinate(2));
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);


function bit_plane_slicing(hObject, eventdata, handles)
	plane_number = str2double(inputdlg({'Plane Number (MSB:8 LSB:1)'}, 'Plane Number', 1, {'8'}));
	handles.edited_image = bitplane_splicing(handles.state_stack{handles.current_state}, plane_number);
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);

function adaptive_thresholding(hObject, eventdata, handles)

	% plane_number = str2double(inputdlg({'Plane Number (MSB:8 LSB:1)'}, 'Plane Number', 1, {'8'}));
	handles.edited_image = adaptive_thresh(handles.state_stack{handles.current_state}, 7, 7);
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);

function flip_image(hObject, eventdata, handles)
	handles.edited_image = flip_img(handles.state_stack{handles.current_state});
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);

function shear(hObject, eventdata, handles)
	parameters = str2double(inputdlg({'alpha (amount of shear in x-direction)', 'beta (amount of shear in y-direction)'},'parameters', 1, {'0','0'}));
	handles.edited_image = shear_img(handles.state_stack{handles.current_state}, parameters(1), parameters(2));
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);

function save_editimage(hObject, eventdata, handles)

	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;
	guidata(hObject, handles);

function undo(hObject, eventdata, handles)
	
	if handles.current_state >=2
		handles.current_state = handles.current_state - 1;
		handles.state_stack = handles.state_stack(1:handles.current_state);
		guidata(hObject, handles);

		handles.edited_image = handles.state_stack{handles.current_state};
		axes(handles.Edited_Image);
		imshow(handles.edited_image);
	end

	axes(handles.Original_Image);
	imshow(handles.original_image);


function slider_blurness(hObject, eventdata, handles)

	sliderVal1 = get(hObject,'Value');
	blur_number = (sliderVal1+ 0.0001)*15;
	n = 21;
	handles.edited_image = gauss_blur(handles.state_stack{handles.current_state}, n, blur_number);
	guidata(hObject,handles);

	axes(handles.Edited_Image);
	imshow(handles.edited_image);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

function slider_blurness_CreateFcn(hObject, eventdata, handles)
	if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
		set(hObject,'BackgroundColor',[.9 .9 .9]);
	end

function slider_sharpness(hObject, eventdata, handles)
	sliderVal = get(hObject,'Value');
	sharpness_factor = sliderVal + 0.0001;
	n = 11;
	sig = 5;
	handles.edited_image = sharpen(handles.state_stack{handles.current_state}, n, sig, sharpness_factor);
	guidata(hObject,handles);

	axes(handles.Edited_Image);
	imshow(handles.edited_image);

function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
	set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function calculate_dft(hObject, eventdata, handles)
	handles.dft = dft2D(handles.state_stack{handles.current_state});

% 	image = handles.state_stack{handles.current_state};
% 	
% 	img_val = image;
% 	if ndims(image) == 3
% 		hsv_img = rgb2hsv(image);
% 		img_val = uint8(255*hsv_img(:,:,3));
%     end	
% 	handles.dft = fftshift(fft2(img_val));
	
	handles.current_state = handles.current_state + 1;
	handles.edited_image = abs(handles.dft);
	handles.edited_image = uint8(255*handles.edited_image/max(max(handles.edited_image)));
	handles.state_stack{handles.current_state} = handles.dft;
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);


% --- Executes on button press in radiobutton18.
function dft_magnitude_save(hObject, eventdata, handles)
	handles.edited_image = abs(handles.dft);
	handles.edited_image = uint8(255*handles.edited_image/max(max(handles.edited_image)));
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);
	

% --- Executes on button press in radiobutton19.
function dft_phase_save(hObject, eventdata, handles)
	handles.edited_image = angle(handles.dft);
	handles.edited_image = uint8(255*handles.edited_image/max(max(handles.edited_image)));
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);

function freq_filt(hObject, eventdata, handles)

	freq_filtering(orig_img, freq_mask)


% --- Executes on button press in radiobutton21.
function radiobutton21_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton21


% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton20.
function radiobutton20_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton20
