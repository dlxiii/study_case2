#!/bin/bash
#PJM -L "rscunit=ito-a"
#PJM -L "rscgrp=ito-s"
#PJM -L "vnode=1"
#PJM -L "vnode-core=36"
#PJM -L "elapse=48:00:00"
#PJM -S

LANG=C
module load matlab/R2017a
ulimit -a

matlab -nodisplay < ncfile_01.m
matlab -nodisplay < ncfile_02.m
matlab -nodisplay < ncfile.m
matlab -nodisplay < waterage.m
matlab -nodisplay < waterage2csv.m