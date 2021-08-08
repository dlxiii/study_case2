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
td = load("./ncfile_TD.mat");
td = td.TD;

%% present monthly layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,8,16];
month = {'age14_09','age14_10','age14_11','age14_12',...
    'age15_01','age15_02','age15_03','age15_04','age15_05','age15_06',...
    'age15_07','age15_08'};
for l = 1:length(layerlist)
    layer = layerlist(l);
    for m = 1:length(month)
        data1 = double(td.(month{m})(:,layer));
        data1 = filloutliers(data1,'nearest','mean');
        data_temp.intp = scatteredInterpolant(...
            td.lon,...
            td.lat,...
            data1,...
            'natural');
        data_temp.lonint = (139.14:(50/111000):140.39)';
        data_temp.latint = (34.85:(50/111000):35.70)';
        data_temp.ageint = data_temp.intp({data_temp.lonint,data_temp.latint});

        data = data_temp.ageint;
        data = filloutliers(data,'nearest','mean');

        % Create csv
        [X,Y] = meshgrid(data_temp.latint,data_temp.lonint);
        M = [reshape(X,[numel(X),1]),...
            reshape(Y,[numel(Y),1]),...
            reshape(data_temp.ageint,[numel(data_temp.ageint),1])];
        if exist('./csv', 'dir')~=7
            mkdir('./csv')
        end
        csvwrite(['./csv/',...
            'monthly_',month{m},'_layer',num2str(layer),'.csv'], M);
        
        % Create figure
        figure1 = figure(1);
        clf
        % Create axes
        axes1 = axes('Parent',figure1);
        hold(axes1,'on');
        % image(data_2020.lonint,data_2020.latint,data');
        % contourf(data_2020.lonint,data_2020.latint,data',[-25,-20,-15,-10,-5,0,5,10,15,20],'ShowText','on');
        [C,h] = contourf(data_temp.lonint,data_temp.latint,data',...
            [0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80]);
        v = [0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80];
        clabel(C,h,v,'FontSize',12,'FontName','Times','Color','black');
        % hold on;
        % ss = shaperead("boundary.shp");
        % mapshow(ss);
        hold on;
        file = "/Users/yulong/GitHub/OceanMesh2D/datasets/C23-06_TOKYOBAY.shp";
        s = shaperead(file);
        mapshow(s);
        % Uncomment the following line to preserve the X-limits of the axes
        xlim(axes1,[139.3 140.3]);
        % Uncomment the following line to preserve the Y-limits of the axes
        ylim(axes1,[34.85 35.75]);
        % Create ylabel
        ylabel('Latitude (degree)');
        % Create xlabel
        xlabel('Longtitude (degree)');
        % Create title
        % title([DateString, ': ', 'water ',NAME_ITEM, ' of ', NAME_LOCATION, ' ', item]);
        box(axes1,'on');

        if exist('./fig', 'dir')~=7
            mkdir('./fig')
        end
        print(gcf,['./fig/',...
            'monthly_',month{m},'_layer',num2str(layer),'.png'],'-dpng','-r600');
        savefig(['./fig/',...
            'monthly_',month{m},'_layer',num2str(layer),'.fig']);
    end
end