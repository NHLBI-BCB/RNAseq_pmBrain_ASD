#!/bin/bash

##Define Input Variables and Functions
PROCESSDIR=$1 	## /geschwindlabshares/eQTL/data/FetalBrainRNASeq/2passStar/{dir} 
NAME=$2	## directory name


PIC=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/bin/picard-master/dist/picard.jar
gatk=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/bin/GenomeAnalysisTK.jar

outputdir=/geschwindlabshares/eQTL/data/FetalBrainRNASeq/2passStar
hg19=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/refGen/genome.fa
snp=/geschwindlabshares/eQTL/data/FetalBrainRNASeq/2passStar/code/Genome/dbsnp_GRCh37p19_b146common_all.vcf   # NEED DBSNP vcf from genome build

cd $PROCESSDIR

for bam in `ls *Aligned.out.bam`; do
	base=$(basename $bam Aligned.out.bam)
	## Add read groups, sort, mark duplicates, and create index Using Picard
	java -jar -Xmx4g -Djava.io.tmpdir=${outputdir}/tmp $PIC AddOrReplaceReadGroups I=$bam O=${base}_rg_added_sorted.bam SO=coordinate RGID=1 RGLB=library RGPL=illumina RGPU=machine RGSM=sample 
	java -jar -Xmx4g -Djava.io.tmpdir=${outputdir}/tmp $PIC MarkDuplicates I=${base}_rg_added_sorted.bam O=${base}_dedupped.bam  CREATE_INDEX=true VALIDATION_STRINGENCY=SILENT M=${base}_output.metrics 
	## Sort bam file
	java -Xmx4g -Djava.io.tmpdir=${outputdir}/tmp -jar $PIC SortSam INPUT=${base}_dedupped.bam OUTPUT=${base}_sorted.bam SORT_ORDER=coordinate TMP_DIR=${outputdir}/tmp
	## Reorder bam file
	java -Xmx4g -Djava.io.tmpdir=${outputdir}/tmp -jar $PIC ReorderSam INPUT=${base}_sorted.bam OUTPUT=${base}_reordered.bam REFERENCE=$hg19 TMP_DIR=${outputdir}/tmp
	## index bam file
	samtools index ${base}_reordered.bam
	## GATK Split'N'Trim and reassign mapping qualities
	java -Xmx4g -Djava.io.tmpdir=${outputdir}/tmp -jar $gatk -T SplitNCigarReads -R $hg19 -I ${base}_dedupped.bam -o ${base}_split.bam -rf ReassignOneMappingQuality -RMQF 255 -RMQT 60 -U ALLOW_N_CIGAR_READS 
	## Base Recalibration
	java -Xmx4g -Djava.io.tmpdir=${outputdir}/tmp -jar $gatk -T BaseRecalibrator -R $hg19 -I ${base}_split.bam  -knownSites $snp -o recal_data.table 
	## Recalibrate Bam
	java -Xmx4g -Djava.io.tmpdir=${outputdir}/tmp -jar $gatk -T PrintReads -R $hg19 -I ${base}_split.bam -BQSR recal_data.table -o ${base}_recalibration.bam
	## Variant Calling
	java -Xmx4g -Djava.io.tmpdir=${outputdir}/tmp -jar $gatk -T HaplotypeCaller -R $hg19 -I ${base}_recalibration.bam -dontUseSoftClippedBases -stand_call_conf 20.0 -stand_emit_conf 20.0 -o ${base}.vcf 
	## Variant Filtering
	java -Xmx4g -Djava.io.tmpdir=${outputdir}/tmp -jar $gatk -T VariantFiltration -R $hg19 -V ${base}.vcf -window 35 -cluster 3 -filterName FS -filter "FS > 30.0" -filterName QD -filter "QD < 2.0" -o ${base}_filtered.vcf 
	##remove intermediate bam files
	rm ${base}_rg_added_sorted.bam
	rm ${base}_dedupped.bam
	rm ${base}_dedupped.bai
	rm ${base}_sorted.bam
	rm ${base}_reordered.bam
	rm ${base}_reordered.bam.bai
	rm ${base}_split.bam
	rm ${base}_split.bai
done





