clear all;
clearvars; 
clc;

delete('diary')
diary on;
% Which system am I using?
if ismac        % On Mac
    basedir = '/Users/yulong/GitHub/';
    addpath([basedir,'fvcomtoolbox/custom/']);
    addpath([basedir,'fvcomtoolbox/utilities/']);
elseif isunix	% Unix?
    basedir = '/home/usr0/n70110d/';
    addpath([basedir,'github/fvcomtoolbox/custom/']);
    addpath([basedir,'github/fvcomtoolbox/utilities/']);
elseif ispc     % Or Windows?
    basedir = 'C:/Users/Yulong WANG/Documents/GitHub/';      
    addpath([basedir,'fvcom-toolbox/custom/']);
    addpath([basedir,'fvcom-toolbox/utilities/']);
end

%%%------------------------------------------------------------------------
%%%                          INPUT CONFIGURATION
%%%------------------------------------------------------------------------

mat1 = load('ncfile_01.mat');
nc = mat1.ncfile;
clear mat1;
mat2 = load('ncfile_02.mat');

nc.time  = cat(1,nc.time, mat2.ncfile.time(2:end,:));
nc.Times = cat(1,nc.Times, mat2.ncfile.Times(2:end,:));
nc.age   = cat(3,nc.age, mat2.ncfile.age(:,:,2:end));
nc.DYE   = cat(3,nc.DYE, mat2.ncfile.DYE(:,:,2:end));
nc.DYE_AGE = cat(3,nc.DYE_AGE, mat2.ncfile.DYE_AGE(:,:,2:end));

save('ncfile.mat','nc','-v7.3','-nocompression');
delete 'ncfile_01.mat';
delete 'ncfile_02.mat';