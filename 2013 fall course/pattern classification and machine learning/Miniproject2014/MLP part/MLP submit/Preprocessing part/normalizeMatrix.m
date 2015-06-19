function [ normdata, varargout ] = normalizeMatrix(data,varargin)
%Usage: Normalizes a given feature matrix by using the given formula
%Input: 
%       data: Feature matrix
%   varargin: Parameters
%              varargin{1}: maximum
%              varargin{2}: minimum
%Output: 
%         out: Normalized feature matrix
%   varargout: Normalization parameters
%              varargout{1}: max
%              varargout{2}: minimum

% Max and Min of the input data (a single value for each feature)
if(nargin==3)
    max_data=varargin{1};
    min_data=varargin{2};
else
    max_data=max(data(:));
    min_data=min(data(:));
end

% Number of patterns
size_data=size(data);

% Normalize the input data
normdata=(data-(min_data.*ones(size_data)))/(max_data-min_data);

% Mean and standard deviation of the output
varargout{1}=max_data;
varargout{2}=min_data;

end