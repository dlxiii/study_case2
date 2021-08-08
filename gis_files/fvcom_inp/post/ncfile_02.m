clear all;
clearvars; 
clc;

delete('diary')
diary on;
% Which system am I using?
if ismac        % On Mac
    basedir = '/home/usr0/n70110d/';
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

ncfile.name = '../otp/tokyobay_0001.nc';
fprintf(['NC file at:',ncfile.name,'\n']);
% ncfile.info = ncdisp(ncfile.name);

% matfile = '../inp/varb/Mobj_02.mat';
% load(matfile);
% fprintf(['mat file at:',matfile,'\n']);

jj = (31+31+30+31+30+31+31+28)*24+1; % From Mar 2015
ti = 1;           % Time interval 6 hours.
start = jj;       % 0*24+1;
% extent = Inf;     % number or 'Inf'
extent = (31+30+31+30+31+31)*24+1;% From Mar 2015
filename = 'ncfile_02.mat';

%=================================================================================
% variable   long name                         units             dimensions
%=================================================================================
% x:         nodal x-coordinate                meters           [node]
% y:         nodal y-coordinate                meters           [node]
% lon:	     nodal longitude                   degrees_east     [node]
% lat:	     nodal latitude                    degrees_north    [node]
% xc:        zonal x-coordinate                meters           [nele]
% yc:        zonal y-coordinate                meters           [nele]
% lonc:	     zonal longitude                   degrees_east     [nele]
% latc:	     zonal latitude                    degrees_north    [nele]
% siglay:    Sigma Layers                      -                [node,siglay]
% nv:        nodes surrounding element         -                [nele,three]
% Times:     time                              -                [time]
% zeta:      Water Surface Elevation           meters           [node,time]
% ua:        Vertically Averaged x-velocity    meters s-1       [nele,time]
% va:        Vertically Averaged y-velocity    meters s-1       [nele,time]
% temp:      temperature                       degrees_C        [node,siglay,time]
% salinity:  salinity                          1e-3             [node,siglay,time]
% DYE:       passive tracer concentration      -                [node,siglay,time]
% DYE_AGE:   passive tracer concentration age  sec              [node,siglay,time]
%=================================================================================

vartoread = {'x','y','lon','lat','h','nv','siglay'};%'lonc','latc'
vartoread1d = {'time','Times'};
%vartoread2d = {'zeta'};% 'ua','va'
vartoread3d = {'DYE','DYE_AGE'};%'temperature'???'salinity'
for i = 1:length(vartoread)
    ncfile.(vartoread{i}) = ncread(ncfile.name,vartoread{i});
    ncfile.(vartoread{i}) = double(ncfile.(vartoread{i}));
    fprintf(['Read 0d var ',vartoread{i},'.\n']);
end
ncfile.xy           = [ncfile.x, ncfile.y];
ncfile.lonlat       = [ncfile.lon, ncfile.lat];
ncfile.tri_xy       = triangulation(ncfile.nv,ncfile.xy);
ncfile.tri_lonlat   = triangulation(ncfile.nv,ncfile.lonlat);
ncfile.tri          = ncfile.tri_xy.ConnectivityList;
ncfile.tri(:,[2 3]) = ncfile.tri(:,[3 2]);
if exist('vartoread1d','var') == 1
    % 1d time dimension
    ncfile.time = ncread(ncfile.name,'time',[start],[extent]);
    ncfile.Times = ncread(ncfile.name,'Times',[1, start],[Inf, extent]);
    % Minor change array of ncfile.Times
    ncfile.Times = ncfile.Times';
    fprintf(['Read 1d var time and Times.\n']);
end
if exist('vartoread2d','var') == 1
    % 2d variables
    for i = 1:length(vartoread2d)
        ncfile.(vartoread2d{i}) = ncread(ncfile.name,vartoread2d{i},[1, start],[Inf, extent]);
        fprintf(['Read 2d var ',vartoread2d{i},'.\n']);
    end
end
if exist('vartoread3d','var') == 1
    % 3d variables
    for i = 1:length(vartoread3d)
        ncfile.(vartoread3d{i}) = ncread(ncfile.name,vartoread3d{i},[1, 1, start],[Inf, Inf, extent]);
        fprintf(['Read 3d var ',vartoread3d{i},'.\n']);
    end
    if ismember('DYE',vartoread3d) && ismember('DYE_AGE',vartoread3d)
        % water_mask = squeeze(ncfile.DYE<=1E-6);
        % water_age = squeeze(ncfile.DYE_AGE./ncfile.DYE);
        water_mask = ncfile.DYE<=1E-6;
        water_age = ncfile.DYE_AGE./ncfile.DYE;
        water_age(water_mask)=nan;
        water_age=water_age/24/60;
        ncfile.age=water_age;
        clear water_*
    end
end
% clear ncfile.temp;
fprintf(['NC file reading finished.\n']);
save(filename,'ncfile','-v7.3','-nocompression');