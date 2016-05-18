cd /hp_shares/mgandal/projects/RNAseq_ASD_pancortical/ASDPanBatch1/BrainGVEX_tmp/raw

# Rename all *.txt to *.text
for f in *.txt.gz; do 
mv -- "$f" "${f%.txt.gz}.fastq.qz"
done
