## script to do additional picard tools and qc measures

FASTA=/geschwindlabshares/CrossDisorder_transcriptome_comparison/1_RNAseq/refGen/hg19.ucsc.fa
JAV=/usr/java/jdk1.7.0_51/bin
PIC=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/bin/picard-master/dist/picard.jar
REFFLAT=/geschwindlabshares/CrossDisorder_transcriptome_comparison/1_RNAseq/refGen/refFlat.Hsv75.chr.txt

PROCESSDIR=$1
name=$2


##${JAV}/java -Xmx4g -Djava.io.tmpdir=${PROCESSDIR}/tmp -jar ${PIC} CollectInsertSizeMetrics INPUT=${PROCESSDIR}/PEmatched_markdup_sorted.bam OUTPUT=${PROCESSDIR}/${name}_insert_metrics.txt  HISTOGRAM_FILE=${PROCESSDIR}/${name}_insert_metrics_histogram.txt TMP_DIR=${PROCESSDIR}/tmp

 if [ ! -f ${PROCESSDIR}/rnaseq_stats.txt ]; then
        
        ${JAV}/java -Xmx2g -jar ${PIC} CollectRnaSeqMetrics REFERENCE_SEQUENCE=${FASTA} INPUT=${PROCESSDIR}/PEmatched_markdup_sorted.bam OUTPUT=${PROCESSDIR}/rnaseq_stats.txt REF_FLAT=${REFFLAT} ASSUME_SORTED=false STRAND_SPECIFICITY=NONE
        ## Collect sequencing metrics if the file is not present
        echo "rnaseq_stats.txt is now created"

    else
        echo ".bam file already analyzed for RNA seq metrics"
 fi


