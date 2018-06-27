#!/bin/bash

# SGE job script for submitting matlab jobs to an SGE cluster queue
# This is submitted to the queue by the job.sh script. It simply runs
#  matlab with the correct arguments.
# By David Black-Schaffer, June 2007.
# Permission to use and modify this script is granted.
# I am not responsible for any errors in this script, so be forewarned!

#$ -cwd
###################$ -pe openmpi 17 # Moved to submit_job_ind
#$ -S /bin/sh
#$ -V
#$ -m abes
#$ -M byliu@ion.ac.cn

# Modify these to put the stdout and stderr files in the right place for your system.
##$ -o ~/job-nobackup.$JOB_ID.$TASK_ID.out
##$ -e ~/job-nobackup.$JOB_ID.$TASK_ID.err

BatchPath="/ion/gu_lab/byliu/Z/Data/TEMPO/BATCH/"

BatchFile="test.m"
#BatchFile="All.m"

echo "Starting job: $n / ${config[@]}"

# Call my codes. The last term is negative meaning the jobs are controlled by SGE
matlab -nodisplay -nosplash -r\
 "BATCH_GUI_Tempo_Analysis('$BatchPath','$BatchFile',0,0,-1,-1,-[$n,${config[@]}])"

#BATCH_GUI_Tempo_Analysis('/ion/gu_lab/byliu/Z/Data/TEMPO/BATCH/','test.m',0,0,-1,-1)

echo "Done with job: $n"
