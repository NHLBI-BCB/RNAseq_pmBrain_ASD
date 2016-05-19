SOURCEDIR=/hp_shares/mgandal/projects/BrainGVEX/source

cd $SOURCEDIR

while read direc;do

ln -s /hp_shares/mgandal/projects/BrainGVEX/data/case-control/RAW/${direc}/* /hp_shares/mgandal/projects/BrainGVEX/data/temp/

done<samples_redo_fromAlgn.txt
