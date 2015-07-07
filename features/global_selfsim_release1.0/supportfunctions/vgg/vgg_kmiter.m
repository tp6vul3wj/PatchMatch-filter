%VGG_KMITER

% $Id: vgg_kmiter.m,v 1.1 2007/11/06 20:39:16 ojw Exp $

function varargout = vgg_kmiter(varargin)
funcName = mfilename;
sourceList = {[funcName '.cxx']}; % Cell array of source files
vgg_mexcompile_script; % Compilation happens in this script
return