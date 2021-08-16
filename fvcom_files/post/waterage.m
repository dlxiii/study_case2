clear all;
clearvars; 
clc;

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

folderpath = {...
    '0001','0002','0003','0004',...
    '0301','0302','0303','0304',...
    '1001','1002','1003','1004',...
    '2001','2002','2003','2004',...
    };
month = {'age14_09','age14_10','age14_11','age14_12',...
    'age15_01','age15_02','age15_03','age15_04','age15_05','age15_06',...
    'age15_07','age15_08'};
mcode = {'m09','m10','m11','m12',...
    'm01','m02','m03','m04','m05','m06',...
    'm07','m08'};

%% Extracting wa.mat
wa = [];
for f = 1:length(folderpath)
    load(fullfile(['/Volumes/Yulong/GitHub/paper_case2/fvcom_inp/',...
        folderpath{f},'/pst/ncfile_TD.mat']));
    if f == 1
        wa.lon = TD.lon;
        wa.lat = TD.lat;
        wa.nv = TD.nv;
        wa.siglay = TD.siglay;
        for m = 1:length(mcode)
            wa.c0001.(mcode{m}) = TD.(month{m});
        end
    else
        for m = 1:length(mcode)
            wa.(['c',folderpath{f}]).(mcode{m}) = TD.(month{m});
        end
    end
    clear TD;
end
save('wa.mat','wa','-v7.3','-nocompression');

%% Calculating wa_dif.mat
folderpath = {...
    '0001','0003',...
    '0301','0303',...
    '1001','1003',...
    '2001','2003',...
    };
mcode = {'m09','m10','m11','m12',...
    'm01','m02','m03','m04','m05','m06',...
    'm07','m08'};
wa_dif = [];
wa_dif.lon = wa.lon;
wa_dif.lat = wa.lat;
wa_dif.nv = wa.nv;
wa_dif.siglay = wa.siglay;
for f = 1:length(folderpath)
    for m = 1:length(mcode)
        wa_dif.(['c',folderpath{f}]).(mcode{m}) = ...
            wa.(['c',folderpath{f}]).(mcode{m}) - ...
            wa.c0003.(mcode{m});
    end
end
save('wa_dif.mat','wa_dif','-v7.3','-nocompression');