## Script just for getting vcf files

PROCESSDIR=$1   ## ~/data/R100  <- workingdir AND bamdir - so [${workingdir}/${bfile}/ = $PROCESSDIR/] here
DIRNAME=$2      ## R100                 <- bfile, -.bam at end
PARENTDIR=$3    ## ~/data

FASTA=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/refGen/genome.fa
BCF=/geschwindlabshares/RNAseq_ASD_pancortical/ASDPanBatch1/bin/bcftools-1.2


if [ ! -f  ${PROCESSDIR}/var.flt.vcf ]; then
      samtools mpileup -I -t SP -gu -f ${FASTA} ${PROCESSDIR}/PEmatched_markdup_sorted.bam | ${BCF}/bcftools call -m - > ${PROCESSDIR}/var.raw.bcf
      ${BCF}/bcftools view ${PROCESSDIR}/var.raw.bcf | ${BCF}/vcfutils.pl varFilter -D100 > ${PROCESSDIR}/var.flt.vcf
else
        echo "Variants already called"
fi

