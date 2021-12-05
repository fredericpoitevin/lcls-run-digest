#!/bin/bash
rstart=275
rend=286
r=$rstart
#
list=""
#
while [ $r -le $rend ]
do
  stream=`ls r0${r}/cxi*.stream`
  if [ -f $stream ]; then
    list="$list $stream"
  fi
  r=` expr $r + 1`
  echo $r
done
echo $list
cat $list > r0${rstart}-r0${rend}_all.stream
