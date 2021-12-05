#!/bin/bash
#
num_max=400
num=1

while [ $num -lt $num_max ]
do

  run=$(echo $num | awk '{printf("%04d", $1)}')
  dir="r${run}"
  
  if [ -d $dir ]; then 

    echo -ne "> checking  $dir ..."    
    if [ -L $dir ]; then

      echo ">> symlink: ignoring"

    else

      ncxi=` ls -1 ${dir}/*.cxi 2>/dev/null | wc -l `
      if [ $ncxi -ne 0 ]; then

        size=` du -ch ${dir}/*.cxi | grep total`
        echo ">> size: $size"

        tags=` ls ${dir}/*.cxi | awk -v FS="_" '{print $NF}' | sort -u | awk -v FS="." '{print $1}'`

        for tag in $tags; do
          size=` du -ch ${dir}/*${tag}.cxi | grep total `
          echo ">>> $tag: $size"
        done

      else

        echo ">> no .cxi file found."

      fi
    fi
  fi
  num=$[$num+1]

done
