#! /bin/bash

# Bash script for sumbitting MATLAB jobs to the new ION cluster queue based on LSF platform.
# This is the script you run from the command line to submit the jobs.
# Modified from: David Black-Schaffer, June 2007; Hou Han, 2018; Liu Bingyu, 2018
# Liu Bingyu, 201905-201906
# Permission to use and modify this script is granted.
# I am not responsible for any errors in this script, so be forewarned!

# Syntax for manual control: ./submit_job_ind.sh 1 2 10 2 4 10 3 1 10 4 2 5 5 3 5  --> 10 CPUs for c01n02 c02n04 c03n01 nodes, and 5 CPUs for c04n02 c05n03 nodes
# Syntax for automatical control: ./submit_job_ind.sh

module load matlab/2018b  # load matlab module on lsf platform

# change your batch file path & name here
BatchPath="/gpfsdata/home/byliu/Z/Data/TEMPO/BATCH/"
BatchFile="test.m"
#BatchFile="All.m"
#BatchFile="MSTd_vis.m"
#BatchFile="Polo_HD.m"


totalNode=0 # to count available nodes
totalCPU=0 # to count available CPUs

if [ $# -gt 0 ]  # Allocate nodes and CPUs manually
then
  config=("$@")   # Convert input to array, length should be an even number
  nNode=$[${#config[@]}/3] # Get node number
  totalCPU=0
  
  for ii in `seq 1 $nNode`
  do
  	thisNode1=${config[(ii-1)*3]}   # Get this node name 1
  	thisNode2=${config[(ii-1)*3+1]}   # Get this node name 2
  	thisCPU=${config[ii*3-1]}      # Get CPU requested for this node
  	   
  	echo " "  
  	echo $ii". Submitting to Node c0"$thisNode1"n0"$thisNode2", requesting "$thisCPU" CPUs"
    
    bsub -J BATCH_LBY -o job_%J.txt -e err_%J.txt -m "c0"$thisNode1"n0"$thisNode2"" -n $thisCPU matlab -nodisplay -nosplash -r\
    "BATCH_GUI_Tempo_Analysis('$BatchPath','$BatchFile',0,0,-1,-1,-[$ii,-${config[*]}])" >& run.log &
  
  	totalCPU=$[totalCPU+thisCPU]
  done

totalNode=$nNode
else   # Allocate nodes and CPUs automatically by lsf platform
  
  totalNode='Auto';
  totalCPU=10;  # how many CPUs you want to use, change the number here
  
  bsub -J BATCH_LBY -o job_%J.txt -e err_%J.txt -n $totalCPU matlab -nodisplay -nosplash -r\
  "BATCH_GUI_Tempo_Analysis('$BatchPath','$BatchFile',0,0,-1,-1,$totalCPU)" >& run.log &
  
  echo " "
  echo "Submitting to 10 CPUs, allocated automatically by LSF platform."
fi

echo " "  
echo "Total number of nodes: "$totalNode  
echo "Total number of CPUs: "$totalCPU
echo " "  
