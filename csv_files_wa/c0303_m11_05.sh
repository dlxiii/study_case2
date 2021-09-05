#!/bin/bash
gdal_grid -l c0303_m11_05 -zfield field_3 -a invdistnn:power=2.0:smothing=0.0:radius=1200.000000:max_points=12:min_points=0:nodata=-9999.0 -ot Float32 -of GTiff c0303_m11_05.vrt c0303_m11_05.tif
gdal_contour -b 1 -a ELEV -i 1.0 -f "ESRI Shapefile" c0303_m11_05.tif c0303_m11_05.shp
