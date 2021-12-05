#!/bin/bash
#
mode=$1
tag=$2 #'gpr6cvn424'
user='fpoitevi' #'cgati'
#
workdir="../../${user}/psocake/"
#
for i in 0 1;
do
  for j in 0 1 2 3 4 5 6 7 8 9;
  do
    for k in 0 1 2 3 4 5 6 7 8 9;
    do
      rundir=${workdir}r0${i}${j}${k}
      if [ -d $rundir ]; then
        status_file=status_${mode}_${tag}.txt
        if [ -f $rundir/$status_file ]; then

          if [ $mode == "peaks" ]; then
            data=`cat $rundir/$status_file | awk '{print$2" "$4}'`
          else
            data=`cat $rundir/$status_file | awk '{print$4" "$6}'`
          fi
          echo "$rundir $data"
        fi
      fi
    done
  done
done
