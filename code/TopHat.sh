## Script to run TopHat

export PATH=$PATH:/share/apps/cufflinks-2.2.1
export PATH=$PATH:/share/apps/bowtie2-2.2.5

TOPHAT=/share/apps/tophat-2.0.14
FF1=$2
FF2=$3
BOWTIE=/geschwindlabshares/CrossDisorder_transcriptome_comparison/1_RNAseq/refGen/Homo_sapiens/Ensembl/GRCh37/Sequence/Bowtie2Index/genome
OUTPUT=$1
GTF=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/refGen/Homo_sapiens.GRCh37.75.gtf

$TOPHAT/tophat --output-dir $OUTPUT/tophat_raw --max-multihits 10  --mate-inner-dist 99 --library-type fr-secondstrand --num-threads 8 --G $GTF --no-novel-juncs $BOWTIE $FF1 $FF2
