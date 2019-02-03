#!/bin/bash -x
cd Data/
wget -A "*00N060E*tgz" -i urls.txt -nd -np -r -S
ls *00N060E*tgz | xargs -n 1 -P 7 tar --wildcards -x *.avg_rade9h.tif -f
ls *00N060E*tgz | xargs rm
cd ..
