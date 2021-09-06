#!/bin/bash
gdal_grid -l c0303_m00_17 -zfield field_3 -a invdistnn:power=2.0:smothing=0.0:radius=600.000000:max_points=12:min_points=0:nodata=-9999.0 -ot Float32 -of GTiff c0303_m00_17.vrt c0303_m00_17.tif --config GDAL_NUM_THREADS ALL_CPUS
gdal_contour -b 1 -a ELEV -i 1.0 -f "ESRI Shapefile" c0303_m00_17.tif c0303_m00_17.shp
