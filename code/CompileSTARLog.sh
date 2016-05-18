#!/bin/bash

cd /hp_shares/mgandal/projects/BrainGVEX/processed/logSTAR

for log in *_Log.final.out;do

name=(${log//_Log.final.out})
percent=$( sed -n 10p ${log} | cut -c 51-55 )

echo ${name} ${percent} >> STAR_AlignPercent.txt

done

