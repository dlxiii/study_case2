#!/bin/bash

export CDIR='pwd'
export WDIR='pst'

for variable in '0002' '0003' '0004' '0301' '0302' '0303' '0304' '1001' '1002' '1003' '1004' '2001' '2002' '2003' '2004'
#for variable in '0001'
do 
    echo "[INFO] Step into $variable ..."
    cd /home/usr0/n70110d/paper_case2/$variable
    if [ -d $WDIR ];then
        # rm -rf $WDIR
        # mkdir -p $WDIR
        cd $WDIR
        echo "[INFO] Working DIR exsiting ..."
    else 
        mkdir -p $WDIR && cd $WDIR
        echo "[INFO] Working DIR creating ..."
    fi
    # cp ../../post/ncfile_01.m ncfile_01.m
    # cp ../../post/ncfile_02.m ncfile_02.m
    # cp /home/usr0/n70110d/paper_case2/post/ncfile_all.m ncfile_all.m
    # cp ../../post/ncfile.sh ncfile.sh
    # cp /home/usr0/n70110d/paper_case2/post/waterage.m waterage.m
    cp /home/usr0/n70110d/paper_case2/post/waterage2csv.m waterage2csv.m

    echo "[INFO] Reading NC file ..."
    # pjsub ./ncfile.sh
    # matlab -nodisplay < ncfile_01.m
    # matlab -nodisplay < ncfile_02.m
    # matlab -nodisplay < ncfile_all.m
    # matlab -nodisplay < waterage.m
    matlab -nodisplay < waterage2csv.m
done