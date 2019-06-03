#!/bin/bash
module load matlab/2018b
ii=1;
config=("$@")
bsub -J test_LBY -o run_%J.txt -e errput_%J.txt matlab -nosplash -nodesktop -r "BATCH_GUI_Tempo_Analysis('/gpfsdata/home/byliu/Z/Data/TEMPO/BATCH/','test.m',0,0,-1,-1,-[$ii,${config[@]}])" >& run.log &

#bsub -m c01n01 -J test_LBY -o job_%J -e err_%J matlab -nosplash -nodesktop -r "test" >& run.log &


