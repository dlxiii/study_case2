#!/bin/bash
gdal_grid -l c0003_m10_16 -zfield field_3 -a invdistnn:power=2.0:smothing=0.0:radius=1200.000000:max_points=12:min_points=0:nodata=-9999.0 -ot Float32 -of GTiff c0003_m10_16.vrt c0003_m10_16.tif
