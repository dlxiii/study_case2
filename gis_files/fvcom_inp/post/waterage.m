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

load('ncfile.mat');

clear TD;
yidx = {'14','14','14','14',...
    '15','15','15','15','15','15','15','15'};
midx = {'09','10','11','12',...
    '01','02','03','04','05','06','07','08'};

for id = 1:length(yidx)
    timetoplot = {['age',yidx{id},'_',midx{id}]};
    TD.Times = ['20',yidx{id},'_',midx{id}];
    k1 = find(ncfile.time == mjuliandate(str2num(['20',yidx{id}]),str2num(midx{id}),01));
    try
        k2 = find(ncfile.time == mjuliandate(str2num(['20',yidx{id+1}]),str2num(midx{id+1}),01))-1;
    catch
        k2 = length(ncfile.time)-1;
    end
    TD.(['age',yidx{id},'_',midx{id}]) = mean(ncfile.age(:,:,k1:k2),3,'omitnan');
end

TD.lon = ncfile.lon;
TD.lat = ncfile.lat;
TD.nv = ncfile.nv;
TD.siglay = ncfile.siglay;
save('ncfile_TD.mat','TD','-v7.3','-nocompression');