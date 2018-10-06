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

% Last Modified by GUIDE v2.5 19-Aug-2018 23:48:23

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
%											GUI fucntions follow
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
	axes(handles.Edited_Image);										% Choose the axes
	imshow(handles.edited_image);									% Display the image
	
	% Original Image storage variable
	handles.original_image = handles.edited_image;
	axes(handles.Original_Image)
	imshow(handles.original_image);

	% Creating a Cellular Array for storing the state of the images
	handles.current_state = 1;
	handles.state_stack = {};
	handles.state_stack{handles.current_state} = handles.original_image;

	% Storing the state in handles
	guidata(hObject, handles);



function gamma_correction(hObject, eventdata, handles)
	
	gamma_value = str2double(inputdlg('Gamma value(0.01 - 10)', 'Gamma', 1, {'1'}));

	% Applying gammar correction scheme
	handles.edited_image = gamma_corr(handles.state_stack{handles.current_state}, gamma_value);
	
	% Pushing the edited image to the top of the state-stack meant for the UNDO operation
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;
	
	% Saving the state of the GUI
	guidata(hObject, handles);

	axes(handles.Edited_Image);
	imshow(handles.edited_image);


function histogram_equalization(hObject, eventdata, handles)
	
	% Applying histo-equalization
	handles.edited_image = equalize_hist(handles.state_stack{handles.current_state});

	% Pushing the edited image to the top of the state-stack meant for the UNDO operation
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;

	% Saving the state of the GUI
	guidata(hObject, handles);

	axes(handles.Edited_Image);
	imshow(handles.edited_image);


function log_transformation(hObject, eventdata, handles)
	
	% Applying log-transform
	handles.edited_image = log_transform(handles.state_stack{handles.current_state});
	
	% Pushing the edited image to the top of the state-stack meant for the UNDO operation	
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;

	% Saving the state of the GUI
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);


function save_image(hObject, eventdata, handles)

	% Calling the file slector
	[filename, foldername] = uiputfile('.jpg','File Selector');
	complete_name = fullfile(foldername, filename);

	% Write the file
	imwrite(handles.state_stack{handles.current_state}, complete_name);


function rotate(hObject, eventdata, handles)

	% Calls the dialog box for inputs
	angle_deg = str2double(inputdlg('Enter the angle in degrees','Angle-Theta',1,{'0'}));       %dialog box for angle of rotation

	% Rotating the image at the top of the stack
	handles.edited_image = rotate_img(handles.state_stack{handles.current_state}, angle_deg);

	% Pushing the edited image to the top of the state-stack meant for the UNDO operation
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;

	% Saving the state of the GUI
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);


function reset_Callback(hObject, eventdata, handles)

	% Reseting the state of the GUI
	handles.edited_image = handles.original_image;
	handles.current_state = 1;
	handles.state_stack = {};												% Emptying the stack
	handles.state_stack{handles.current_state} = handles.original_image;	% Original Image at the top of the stack

	% Reseting the sliders
	set(handles.slider1,'Value',0);
	set(handles.slider2,'Value',0);

	% Saving the state of the GUI
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

	% Calling the dialog box for inputs
	coordinate = str2double(inputdlg({'x-coordinate in pixels','y-coordinate in pixels'},'coordinates',1,{'0','0'}));
	
	% Translating the topmost image on the state-stack
	handles.edited_image = translate_img(handles.state_stack{handles.current_state}, coordinate(1), coordinate(2), 0);
	
	% Pushing the edited image to the top of the state-stack meant for the UNDO operation	
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;

	% Saving the state of the GUi
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);


function bit_plane_slicing(hObject, eventdata, handles)

	% Calling the dialog box for inputs
	plane_number = str2double(inputdlg({'Plane Number (MSB:1 LSB:8)'}, 'Plane Number', 1, {'1'}));
	
	% Performing the sclicing of the image
	handles.edited_image = bitplane_splicing(handles.state_stack{handles.current_state}, plane_number);
	
	% Pushing the edited image to the top of the state-stack meant for the UNDO operation	
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;

	% Saving the state of the GUI
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);

function adaptive_thresholding(hObject, eventdata, handles)

	% Calling the dialog box for inputs
	parameters = str2double(inputdlg({'Size of the kernel (odd integer)', 'Enhancement Parameter'}, 'Parameters', 1, {'7','7'}));
	
	% Applying adaptive thresholding on the topmost image of the stack
	handles.edited_image = adaptive_thresh(handles.state_stack{handles.current_state}, parameters(1), parameters(2));
	
	% Pushing the edited image to the top of the state-stack meant for the UNDO operation	
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;

	% Saving the state of the GUI
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);

function flip_image(hObject, eventdata, handles)

	% Flipping the topmost image of the stack
	handles.edited_image = flip_img(handles.state_stack{handles.current_state});

	% Pushing the edited image to the top of the state-stack meant for the UNDO operation
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;

	% Saving the state of the stack
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);

function shear(hObject, eventdata, handles)
	% Calling the dialog box for inputs
	parameters = str2double(inputdlg({'alpha (amount of shear in x-direction)', 'beta (amount of shear in y-direction)'},'parameters', 1, {'0','0'}));
	
	% Shear the image with input parameters
	handles.edited_image = shear_img(handles.state_stack{handles.current_state}, parameters(1), parameters(2));

	% Pushing the edited image to the top of the state-stack meant for the UNDO operation	
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;

	% Saving the state of the GUI
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);

function save_editimage(hObject, eventdata, handles)

	% Saving the image in the "handles.edit_image" to the top of the stack
	% (Useful in sharpness and blurring sliders)
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;

	% Saving the state of the GUi
	guidata(hObject, handles);

function undo(hObject, eventdata, handles)
	% Undoes the last change by popping the topmost element(image) of the stack

	% Undoes only when 2 or more elements present in the stack 
	% (lowest element is always the original image)
	if handles.current_state >=2
		handles.current_state = handles.current_state - 1;
		handles.state_stack = handles.state_stack(1:handles.current_state);

		% Saving the state of the GUI
		guidata(hObject, handles);

		% Displaying the topmost image on the stack
		handles.edited_image = handles.state_stack{handles.current_state};
		axes(handles.Edited_Image);
		imshow(handles.edited_image);
	end

	axes(handles.Original_Image);
	imshow(handles.original_image);


function slider_blurness(hObject, eventdata, handles)

	% Reading the value of the blurring slider
	sliderVal1 = get(hObject,'Value');

	% Acts as the standard deviation for the gaussian kernel used in blurring
	blur_number = (sliderVal1+ 0.0001)*15;

	% Filter size 
	n = 21;

	% Applying the Gaussian filter
	handles.edited_image = gauss_blur(handles.state_stack{handles.current_state}, n, blur_number);

	% Saving the state of the GUi
	guidata(hObject,handles);

	axes(handles.Edited_Image);
	imshow(handles.edited_image);

function slider_blurness_CreateFcn(hObject, eventdata, handles)
	% Create_function for blurness slider
	if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
		set(hObject,'BackgroundColor',[.9 .9 .9]);
	end

function slider_sharpness(hObject, eventdata, handles)

	% Reading the value of the blurring slider
	sliderVal = get(hObject,'Value');

	% Relative amount of unsharp masking in the image
	sharpness_factor = sliderVal + 0.0001;

	% Filter size and Std_dev of the Gaussian Kernel
	n = 7;
	sig = 2;

	% Sharpening the image
	handles.edited_image = sharpen(handles.state_stack{handles.current_state}, n, sig, sharpness_factor);

	% Saving the state of the GUI
	guidata(hObject,handles);

	axes(handles.Edited_Image);
	imshow(handles.edited_image);

function slider2_CreateFcn(hObject, eventdata, handles)

	% slider create function for sharpness slider
	if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
	    set(hObject,'BackgroundColor',[.9 .9 .9]);
	end

function calculate_dft(hObject, eventdata, handles)
	% Calculates the 2D-DFT of the topmost image stored in the stack (Latest working image)
	% Variables in use:
	%			- dft_img	: Image on which dft is performed
	%			- dft 		: DFT of "dft_img"

	% Storing the image as a reference on which DFT is performed
	handles.dft_img = handles.state_stack{handles.current_state};

	% Taking the 2D-DFT of the image using the implemented 'myFFT2D' function based on Radix-2 FFT Algorithm
	% (Here the DFT is centralised in the image by using the fft_shift function created by us)
	handles.dft = fft_shift(myFFT2D(handles.state_stack{handles.current_state}));

	% Pushing the edited image to the top of the state-stack meant for the UNDO operation	
	handles.current_state = handles.current_state + 1;

	% Displaying the Magnitude Response of the DFT
	handles.edited_image = linear_contrast(abs(handles.dft));

	% Storing the magnitude response of the DFT as the topmost element on the stack
	handles.state_stack{handles.current_state} = handles.edited_image;

	% Saving the state of the GUI
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);


function dft_magnitude_save(hObject, eventdata, handles)
	% Saves the dft_magnitude on the top of the stack
	handles.edited_image = linear_contrast(abs(handles.dft));

	% Pushing the edited image to the top of the state-stack meant for the UNDO operation		
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;

	% Saving the state of the GUI
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);
	

function dft_phase_save(hObject, eventdata, handles)
	handles.edited_image = linear_contrast(angle(handles.dft));

	% Pushing the edited image to the top of the state-stack meant for the UNDO operation	
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;

	% Saving the state of the GUI
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);

function freq_filtering(hObject, eventdata, handles)
	% Applies a filter uploaded using the GUI on the magnitude of the resultant GUI
	% Note: 
	%	The filter must be centralised
	%
	% Variables Used:
	%		- freq_mask 		: Uploaded Mask
	%		- freq_filtered_mag : Filtered mag response
	% 		- filtered_img 		: IDFT of the filtered dft_img

	% All files are allowed
	[File_Name, Path_Name] = uigetfile('*.*','File Selector');
	image_path = strcat(Path_Name, File_Name);
	
	% Loading the image
	handles.freq_mask = imread(image_path);
	handles.freq_mask = handles.freq_mask/max(max(handles.freq_mask));			% Ensuring the filter is in the range [0,1]

	% Applying the filter on the magnitude of the dft_filter
	handles.freq_filtered_mag = abs(handles.dft).*handles.freq_mask;

	% Getting back the DFT for inversion
	filtered_dft = handles.freq_filtered_mag.*exp(1i*angle(handles.dft));		% Polar to complex form
	filtered_dft = fft_shift(filtered_dft);										% De-centralising the dft back

	% Taking the inverse FFT
	handles.idft = real(ifft2(filtered_dft));

	% Handling the case for colored images
	if ndims(handles.dft_img) == 3												% Colored Images
		[M,N,C] = size(handles.dft_img);
		handles.idft = handles.idft(1:M, 1:N);									% Carving out the original image back

		img_hsv = rgb2hsv(handles.dft_img);
		img_hsv(:,:,3) = handles.idft/255;
		handles.idft = uint8(255*hsv2rgb(img_hsv));
	else 
		[M,N] = size(handles.dft_img);
		handles.idft = uint8(handles.idft(1:M, 1:N));									% Carving out the original image back
		% handles.idft = linear_contrast(handles.idft);
	end

	% Enhancing the magnitude for display
	handles.edited_image = linear_contrast(abs(handles.freq_filtered_mag));

	% Pushing the edited image to the top of the state-stack meant for the UNDO operation	
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;
	
	% Saving the state of the GUI
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);


function idft_save_freq_filt(hObject, eventdata, handles)
	% Saves the (magnitude part) filtered dft on the top of the state stack

	% Enhancing the magnitude for display
	handles.edited_image = linear_contrast(abs(handles.freq_filtered_mag));

	% Pushing the edited image to the top of the state-stack meant for the UNDO operation		
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;

	% Saving the state of the GUI
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);


function idft_save_enhanced_image(hObject, eventdata, handles)

	% Saves the inverse IDFT image on the top of the stack
	handles.edited_image = handles.idft;

	% Pushing the edited image to the top of the state-stack meant for the UNDO operation		
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;

	% Saving the state of the GUI
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);


function apply_LPF(hObject, eventdata, handles)
	% Applies a Low Pass Filter in 2D over the dft_img (Stored beforehand)
	% Note: 
	%		The filter is a centralised LPF
	%
	% Variables Used:
	%		- freq_mask 		: Constructed LPF
	%		- freq_filtered_mag : Filtered mag response
	% 		- filtered_img 		: IDFT of the filtered dft_img


	% Reading the value of radius given as input
	parameters = str2double(inputdlg({'Radius of LPF (in pixels'}, 'Parameters', 1, {'20'}));
	
	% Constructing a frequency mask of the same size as the dft and given radius
	handles.freq_mask = construct_LPF(parameters(1), size(handles.dft));

	% Applying the filter on the magnitude of the dft_filter
	handles.freq_filtered_mag = abs(handles.dft).*handles.freq_mask;

	% Getting back the DFT for inversion
	filtered_dft = handles.freq_filtered_mag.*exp(1i*angle(handles.dft));		% Polar to complex form
	filtered_dft = fft_shift(filtered_dft);										% De-centralising the dft back

	% Taking the inverse FFT
	handles.idft = real(ifft2(filtered_dft));

	% Handling the case for colored images
	if ndims(handles.dft_img) == 3												% Colored Images
		[M,N,C] = size(handles.dft_img);
		handles.idft = handles.idft(1:M, 1:N);									% Carving out the original image back

		img_hsv = rgb2hsv(handles.dft_img);
		img_hsv(:,:,3) = handles.idft/255;
		handles.idft = uint8(255*hsv2rgb(img_hsv));
	else 
		[M,N] = size(handles.dft_img);
		handles.idft = uint8(handles.idft(1:M, 1:N));									% Carving out the original image back
	end

	% Enhancing the magnitude for display
	handles.edited_image = linear_contrast(abs(handles.freq_filtered_mag));

	% Pushing the edited image to the top of the state-stack meant for the UNDO operation	
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;
	
	% Saving the state of the GUI
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);


function apply_HPF(hObject, eventdata, handles)
	% Applies a High Pass Filter in 2D over the dft_img (Stored beforehand)
	% Note: 
	%		The filter is a centralised LPF
	%
	% Variables Used:
	%		- freq_mask 		: Constructed HPF
	%		- freq_filtered_mag : Filtered mag response
	% 		- filtered_img 		: IDFT of the filtered dft_img

	% Reading the value of radius given as input
	parameters = str2double(inputdlg({'Radius of HPF (in pixels'}, 'Parameters', 1, {'20'}));
	
	% Constructing a frequency mask of the same size as the dft and given radius
	handles.freq_mask = construct_HPF(parameters(1), size(handles.dft));

	% Applying the filter on the magnitude of the dft_filter
	handles.freq_filtered_mag = abs(handles.dft).*handles.freq_mask;

	% Getting back the DFT for inversion
	filtered_dft = handles.freq_filtered_mag.*exp(1i*angle(handles.dft));		% Polar to complex form
	filtered_dft = fft_shift(filtered_dft);										% De-centralising the dft back

	% Taking the inverse FFT
	handles.idft = real(ifft2(filtered_dft));

	% Handling the case for colored images
	if ndims(handles.dft_img) == 3												% Colored Images
		[M,N,C] = size(handles.dft_img);
		handles.idft = handles.idft(1:M, 1:N);									% Carving out the original image back

		img_hsv = rgb2hsv(handles.dft_img);
		img_hsv(:,:,3) = handles.idft/255;
		handles.idft = uint8(255*hsv2rgb(img_hsv));
	else 
		[M,N] = size(handles.dft_img);
		handles.idft = uint8(handles.idft(1:M, 1:N));									% Carving out the original image back
	end

	% Enhancing the magnitude for display
	handles.edited_image = linear_contrast(abs(handles.freq_filtered_mag));

	% Pushing the edited image to the top of the state-stack meant for the UNDO operation	
	handles.current_state = handles.current_state + 1;
	handles.state_stack{handles.current_state} = handles.edited_image;
	
	% Saving the state of the GUI
	guidata(hObject, handles);
	
	axes(handles.Edited_Image);
	imshow(handles.edited_image);
