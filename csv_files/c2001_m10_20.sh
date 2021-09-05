#!/bin/bash
gdal_grid -l c2001_m10_20 -zfield field_3 -a invdistnn:power=2.0:smothing=0.0:radius=1200.000000:max_points=12:min_points=0:nodata=-9999.0 -ot Float32 -of GTiff c2001_m10_20.vrt c2001_m10_20.tif
gdal_contour -b 1 -a ELEV -i 1.0 -f "ESRI Shapefile" c2001_m10_20.tif c2001_m10_20.shp
