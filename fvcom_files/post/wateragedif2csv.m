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
formatSpec = '%02i';
td = load("./wa_dif.mat");
wa_dif = td.wa_dif;
clear td;

%% present monthly layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
csv_resol = 1000;
layerlist = [1,8,16];
month = {'m09','m10','m11','m12',...
    'm01','m02','m03','m04','m05','m06',...
    'm07','m08'};
% caselist = {'c0001',...
%     'c0301','c0303',...
%     'c1001','c1003',...
%     'c2001','c2003'};
caselist = {'c0004',...
    'c2002'};
% c=1;l=1;layer=layerlist(l);m = 1;
otfile_bash = ['../../csv_files/multi_run_m.sh'];
info_file = ['../../csv_files/info_month_layers.csv'];
fileID0 = fopen(otfile_bash,'w');
fileID1 = fopen(info_file,'w');
fprintf(fileID0,'#!/bin/bash\n');
for c = 1:length(caselist)
    for l = 1:length(layerlist)
        layer = layerlist(l);
        for m = 1:length(month)
            data1 = double(wa_dif.(caselist{c}).(month{m})(:,layer));
            data1 = filloutliers(data1,'nearest','mean');
            data_temp.intp = scatteredInterpolant(...
                wa_dif.lon,...
                wa_dif.lat,...
                data1,...
                'natural');
            data_temp.lonint = (139.14:(csv_resol/111000):140.39)';
            data_temp.latint = (34.85:(csv_resol/111000):35.70)';
            data_temp.ageint = data_temp.intp({data_temp.lonint,data_temp.latint});

            data = data_temp.ageint;
            data = filloutliers(data,'nearest','mean');

            % Create csv
            [Y,X] = meshgrid(data_temp.latint,data_temp.lonint);
            M = [reshape(X,[numel(X),1]),...
                reshape(Y,[numel(Y),1]),...
                reshape(data_temp.ageint,[numel(data_temp.ageint),1])];
            if exist('../../csv_files', 'dir')~=7
                mkdir('../../csv_files')
            end
            filename = [caselist{c},'_',month{m},'_',num2str(layer,formatSpec)];
            otfile_csv = ['../../csv_files/',...
                 filename,'.csv'];
            fileID = fopen(otfile_csv,'w');
            % fprintf(fileID,'%12s %12s %12s\n','lon,','lat,','age,');
            for i = 1:length(M)
                fprintf(fileID,'%11.6f%1s %11.6f%1s %11.2f%1s\n',...
                    M(i,1),',',M(i,2),',',M(i,3),',');
            end
            fclose(fileID);
            
            % average value in polygen
            x = M(:,1); y = M(:,2); z = M(:,3); 
            shp_path = '/Users/yulong/GitHub/study_case2/gis_files/others/boundary_innerbay.shp';
            [~,~,val_age] = valInPol(x,y,z,shp_path);
            fprintf(fileID1,'%s%1s %5.2f%1s\n',...
                    filename,',',nanmean(val_age),','); 
            
            % Create vrt
            otfile_vrt = ['../../csv_files/',...
                 filename,'.vrt'];
            fileID = fopen(otfile_vrt,'w');
            fprintf(fileID,'<OGRVRTDataSource>\n');
            fprintf(fileID,'    <OGRVRTLayer name="%s">\n',filename);
            fprintf(fileID,'        <SrcLayer>%s</SrcLayer>\n',filename);
            fprintf(fileID,'        <LayerSRS>EPSG:4326</LayerSRS>\n');
            fprintf(fileID,'        <SrcDataSource>CSV:%s.csv</SrcDataSource>\n',filename);
            fprintf(fileID,'        <GeometryType>wkbPoint</GeometryType>\n');
            fprintf(fileID,'        <GeometryField encoding="PointFromColumns" x="field_1" y="field_2" z="field_3"/>\n');
            fprintf(fileID,'    </OGRVRTLayer>\n');
            fprintf(fileID,'</OGRVRTDataSource>\n');
            fclose(fileID);
 
            % Create bash
            otfile_sh = ['../../csv_files/',...
                 filename,'.sh'];
            fileID = fopen(otfile_sh,'w');
            fprintf(fileID,'#!/bin/bash\n');
            fprintf(fileID,'gdal_grid -l %s -zfield field_3 -a invdistnn:power=2.0:smothing=0.0:radius=%f:max_points=12:min_points=0:nodata=-9999.0 -ot Float32 -of GTiff %s.vrt %s.tif\n',filename,csv_resol*1.2,filename,filename);
            fprintf(fileID,'gdal_contour -b 1 -a ELEV -i 1.0 -f "ESRI Shapefile" %s.tif %s.shp\n',filename,filename);
            fclose(fileID);
            
            % Create bash
            fprintf(fileID0,'sh ./%s.sh\n',filename);
            
            %{
            % Create figure
            figure1 = figure(1);
            clf
            % Create axes
            axes1 = axes('Parent',figure1);
            hold(axes1,'on');
            % image(data_2020.lonint,data_2020.latint,data');
            % contourf(data_2020.lonint,data_2020.latint,data',[-25,-20,-15,-10,-5,0,5,10,15,20],'ShowText','on');
            [C,h] = contourf(data_temp.lonint,data_temp.latint,data',...
                [-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9,10]);
            v = [-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9,10];
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
                caselist{c},'_',month{m},'_',num2str(layer),'.png'],'-dpng','-r600');
            savefig(['./fig/',...
                caselist{c},'_',month{m},'_',num2str(layer),'.fig']);
            %}
        end
    end
end
fclose(fileID0);
fclose(fileID1);

%% present annual layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
csv_resol = 500;
layerlist = [1,8,16];
mmean = {'m00'};
month = {'m09','m10','m11','m12',...
    'm01','m02','m03','m04','m05','m06',...
    'm07','m08'};
% caselist = {'c0001',...
%     'c0301','c0303',...
%     'c1001','c1003',...
%     'c2001','c2003'};
caselist = {'c0004',...
    'c2002'};
% f = 1;m = 1;
for f = 1:length(caselist)
    wa_dif.(caselist{f}).m00 = 0;
    for m = 1:length(month)
        wa_dif.(caselist{f}).m00 = ...
            wa_dif.(caselist{f}).m00 + ...
            wa_dif.(caselist{f}).(month{m});
    end
    wa_dif.(caselist{f}).m00 = wa_dif.(caselist{f}).m00 / 12;
end

otfile_bash = ['../../csv_files/multi_run_a.sh'];
info_file = ['../../csv_files/info_annual_layers.csv'];
fileID0 = fopen(otfile_bash,'w');
fileID1 = fopen(info_file,'w');
fprintf(fileID0,'#!/bin/bash\n');
fprintf(fileID0,'# source /home/usr0/n70110d/usr/local/anaconda3/2019.03.py3/etc/profile.d/conda.sh\n');
fprintf(fileID0,'# conda activate gdal\n');
fprintf(fileID0,'\n');
for c = 1:length(caselist)
    for l = 1:length(layerlist)
        layer = layerlist(l);
        for m = 1:length(mmean)
            data1 = double(wa_dif.(caselist{c}).(mmean{m})(:,layer));
            data1 = filloutliers(data1,'nearest','mean');
            data_temp.intp = scatteredInterpolant(...
                wa_dif.lon,...
                wa_dif.lat,...
                data1,...
                'natural');
            data_temp.lonint = (139.14:(csv_resol/111000):140.39)';
            data_temp.latint = (34.85:(csv_resol/111000):35.70)';
            data_temp.ageint = data_temp.intp({data_temp.lonint,data_temp.latint});

            data = data_temp.ageint;
            data = filloutliers(data,'nearest','mean');

            % Create csv
            [Y,X] = meshgrid(data_temp.latint,data_temp.lonint);
            M = [reshape(X,[numel(X),1]),...
                reshape(Y,[numel(Y),1]),...
                reshape(data_temp.ageint,[numel(data_temp.ageint),1])];
            if exist('../../csv_files', 'dir')~=7
                mkdir('../../csv_files')
            end
            filename = [caselist{c},'_',mmean{m},'_',num2str(layer,formatSpec)];
            otfile_csv = ['../../csv_files/',...
                 filename,'.csv'];
            fileID = fopen(otfile_csv,'w');
            % fprintf(fileID,'%12s %12s %12s\n','lon,','lat,','age,');
            for i = 1:length(M)
                fprintf(fileID,'%11.6f%1s %11.6f%1s %11.2f%1s\n',...
                    M(i,1),',',M(i,2),',',M(i,3),',');
            end
            fclose(fileID);
            
            % average value in polygen
            x = M(:,1); y = M(:,2); z = M(:,3); 
            shp_path = '/Users/yulong/GitHub/study_case2/gis_files/others/boundary_innerbay.shp';
            [~,~,val_age] = valInPol(x,y,z,shp_path);
            fprintf(fileID1,'%s%1s %5.2f%1s\n',...
                    filename,',',nanmean(val_age),',');  
            
            % Create vrt
            otfile_vrt = ['../../csv_files/',...
                 filename,'.vrt'];
            fileID = fopen(otfile_vrt,'w');
            fprintf(fileID,'<OGRVRTDataSource>\n');
            fprintf(fileID,'    <OGRVRTLayer name="%s">\n',filename);
            fprintf(fileID,'        <SrcLayer>%s</SrcLayer>\n',filename);
            fprintf(fileID,'        <LayerSRS>EPSG:4326</LayerSRS>\n');
            fprintf(fileID,'        <SrcDataSource>CSV:%s.csv</SrcDataSource>\n',filename);
            fprintf(fileID,'        <GeometryType>wkbPoint</GeometryType>\n');
            fprintf(fileID,'        <GeometryField encoding="PointFromColumns" x="field_1" y="field_2" z="field_3"/>\n');
            fprintf(fileID,'    </OGRVRTLayer>\n');
            fprintf(fileID,'</OGRVRTDataSource>\n');
            fclose(fileID);
 
            % Create bash
            otfile_sh = ['../../csv_files/',...
                 filename,'.sh'];
            fileID = fopen(otfile_sh,'w');
            fprintf(fileID,'#!/bin/bash\n');
            fprintf(fileID,'gdal_grid -l %s -zfield field_3 -a invdistnn:power=2.0:smothing=0.0:radius=%f:max_points=12:min_points=0:nodata=-9999.0 -ot Float32 -of GTiff %s.vrt %s.tif --config GDAL_NUM_THREADS ALL_CPUS\n',filename,csv_resol*1.2,filename,filename);
            fprintf(fileID,'gdal_contour -b 1 -a ELEV -i 1.0 -f "ESRI Shapefile" %s.tif %s.shp\n',filename,filename);
            fclose(fileID);
            
            % Create bash
            fprintf(fileID0,'sh ./%s.sh\n',filename);
            
        end
    end
end
fclose(fileID0);
fclose(fileID1);

%% present annual layer average
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
csv_resol = 500;
layerlist = [1];
mmean = {'m00_va'};
% caselist = {'c0001',...
%     'c0301','c0303',...
%     'c1001','c1003',...
%     'c2001','c2003'};
caselist = {'c0004',...
    'c2002'};
month = {'m09','m10','m11','m12',...
    'm01','m02','m03','m04','m05','m06',...
    'm07','m08'};

% f = 1;m = 1;
for f = 1:length(caselist)
    wa_dif.(caselist{f}).m00_va = 0;
    for m = 1:length(month)
        wa_dif.(caselist{f}).m00_va = ...
            mean(wa_dif.(caselist{f}).m00,2);
    end
end

otfile_bash = ['../../csv_files/multi_run_ava.sh'];
info_file = ['../../csv_files/info_annual_vertical.csv'];
fileID0 = fopen(otfile_bash,'w');
fileID1 = fopen(info_file,'w');
fprintf(fileID0,'#!/bin/bash\n');
%fprintf(fileID0,'# source /home/usr0/n70110d/usr/local/anaconda3/2019.03.py3/etc/profile.d/conda.sh\n');
fprintf(fileID0,'# conda activate gis_gdal\n');
fprintf(fileID0,'\n');
for c = 1:length(caselist)
    for l = 1:length(layerlist)
        layer = layerlist(l);
        for m = 1:length(mmean)
            data1 = double(wa_dif.(caselist{c}).(mmean{m})(:,layer));
            data1 = filloutliers(data1,'nearest','mean');
            data_temp.intp = scatteredInterpolant(...
                wa_dif.lon,...
                wa_dif.lat,...
                data1,...
                'natural');
            data_temp.lonint = (139.14:(csv_resol/111000):140.39)';
            data_temp.latint = (34.85:(csv_resol/111000):35.70)';
            data_temp.ageint = data_temp.intp({data_temp.lonint,data_temp.latint});

            data = data_temp.ageint;
            data = filloutliers(data,'nearest','mean');

            % Create csv
            [Y,X] = meshgrid(data_temp.latint,data_temp.lonint);
            M = [reshape(X,[numel(X),1]),...
                reshape(Y,[numel(Y),1]),...
                reshape(data_temp.ageint,[numel(data_temp.ageint),1])];
            if exist('../../csv_files', 'dir')~=7
                mkdir('../../csv_files')
            end
            filename = [caselist{c},'_',mmean{m},'_',num2str(layer,formatSpec)];
            otfile_csv = ['../../csv_files/',...
                 filename,'.csv'];
            fileID = fopen(otfile_csv,'w');
            % fprintf(fileID,'%12s %12s %12s\n','lon,','lat,','age,');
            for i = 1:length(M)
                fprintf(fileID,'%11.6f%1s %11.6f%1s %11.2f%1s\n',...
                    M(i,1),',',M(i,2),',',M(i,3),',');
            end
            fclose(fileID);
            
            % average value in polygen
            x = M(:,1); y = M(:,2); z = M(:,3); 
            shp_path = '/Users/yulong/GitHub/study_case2/gis_files/others/boundary_innerbay.shp';
            [~,~,val_age] = valInPol(x,y,z,shp_path);
            fprintf(fileID1,'%s%1s %5.2f%1s\n',...
                    filename,',',nanmean(val_age),',');                
         
            % Create vrt
            otfile_vrt = ['../../csv_files/',...
                 filename,'.vrt'];
            fileID = fopen(otfile_vrt,'w');
            fprintf(fileID,'<OGRVRTDataSource>\n');
            fprintf(fileID,'    <OGRVRTLayer name="%s">\n',filename);
            fprintf(fileID,'        <SrcLayer>%s</SrcLayer>\n',filename);
            fprintf(fileID,'        <LayerSRS>EPSG:4326</LayerSRS>\n');
            fprintf(fileID,'        <SrcDataSource>CSV:%s.csv</SrcDataSource>\n',filename);
            fprintf(fileID,'        <GeometryType>wkbPoint</GeometryType>\n');
            fprintf(fileID,'        <GeometryField encoding="PointFromColumns" x="field_1" y="field_2" z="field_3"/>\n');
            fprintf(fileID,'    </OGRVRTLayer>\n');
            fprintf(fileID,'</OGRVRTDataSource>\n');
            fclose(fileID);
 
            % Create bash
            otfile_sh = ['../../csv_files/',...
                 filename,'.sh'];
            fileID = fopen(otfile_sh,'w');
            fprintf(fileID,'#!/bin/bash\n');
            fprintf(fileID,'gdal_grid -l %s -zfield field_3 -a invdistnn:power=2.0:smothing=0.0:radius=%f:max_points=12:min_points=0:nodata=-9999.0 -ot Float32 -of GTiff %s.vrt %s.tif --config GDAL_NUM_THREADS ALL_CPUS\n',filename,csv_resol*1.2,filename,filename);
            fprintf(fileID,'gdal_contour -b 1 -a ELEV -i 1.0 -f "ESRI Shapefile" %s.tif %s.shp\n',filename,filename);
            fclose(fileID);
             
            % Create bash
            fprintf(fileID0,'sh ./%s.sh\n',filename);
            
        end
    end
end
fclose(fileID0);
fclose(fileID1);