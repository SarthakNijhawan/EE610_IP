% Author: Sarthak Nijhawan
% 
% Disclaimer: None of the code has been copied or emulted from any outside source
% 
% Description:  Main Script to initiate an interactive command line interface 
% 				to showcase and compare various image restoration techniques on
% 				sample images mentioned in the problem statement

clc
close all
clear all

disp('Select from below:')
disp('(1) Restore sample images using different methods');
disp('(2) Degrade an image and restore using different methods');
disp('(3) g part of the assingment');
ans = input('Response = ');

if ans==1
	sample_restore
elseif ans==2
	custom_degrade_and_restore
elseif ans==3
	g_part
else
	disp('Please enter a valid integer');
	disp('Exiting........');
end
		
	
