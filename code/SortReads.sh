## Script to sort reads

JAV=/usr/java/jdk1.7.0_51/bin
PIC=/geschwindlabshares/CrossDisorder_transcriptome_comparison/1_RNAseq/bin/picard-master/dist/picard.jar
direc=$1
PROCESSDIR=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/data/starQCtest/${direc}

${JAV}/java -Xmx4g -Djava.io.tmpdir=${PROCESSDIR}/tmp -jar ${PIC} SortSam INPUT=${PROCESSDIR}/Aligned.out.bam OUTPUT=${PROCESSDIR}/${direc}.bam SORT_ORDER=coordinate TMP_DIR=${PROCESSDIR}/tmp
        ## Reorder the .bam file according to the reference at hand
echo "sorted_reads.bam is now created"

${JAV}/java -Xmx2g -jar ${PIC} BuildBamIndex INPUT=${PROCESSDIR}/${direc}.bam
        ## Index the sorted reads file
echo "sorted reads file is now indexed"

