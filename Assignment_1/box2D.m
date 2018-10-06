function [box_filter] = box2D(n)
	% Input:
	%       n    		-> Size of the filter (nxn)
	%
	% Output:
	%		box_filter 	-> Box filter of size n 

	box_filter = ones(n)/(n*n);
end