#!/bin/bash
gdal_grid -l c0303_m00_08 -zfield field_3 -a invdistnn:power=2.0:smothing=0.0:radius=120.000000:max_points=12:min_points=0:nodata=-9999.0 -ot Float32 -of GTiff c0303_m00_08.vrt c0303_m00_08.tif
