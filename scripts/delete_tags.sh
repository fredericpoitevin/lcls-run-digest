#!/bin/bash

taglist=" gpr6cvn424 gpr6 gpr6v2 gpr6v3 gpr6v4 gpr6v5 gpr6v6"
taglist=" $taglist at2v2 at2v3 at2v4 at2chuck"
taglist=" $taglist lysov2 "
taglist=" $taglist v1b "

dryrun=false

for tag in $taglist
do

  ncxi=` ls -1 r*/*${tag}.cxi 2>/dev/null | wc -l `

  if [ $ncxi -ne 0 ]; then

    size=` du -ch r*/*${tag}.cxi | grep total `
    echo -ne " $tag : $size "

    if $dryrun ; then
      echo " ==> not deleting just yet"
    else
      echo " ==> deleting now..."
      rm -f r*/*${tag}.cxi
    fi
  fi
done 
