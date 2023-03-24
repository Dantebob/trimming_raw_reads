{
usage="$(basename "$0") [-h] [-l <SRA_list>]
Script to perform raw read preprocessing using fastp
    -h show this help text
    -l path/file to tab-delimitted sra list"
options=':hl:'
while getopts $options option; do
    case "$option" in
        h) echo "$usage"; exit;;
	l) l=$OPTARG;;
	:) printf "missing argument for -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
       \?) printf "illegal option: -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
     esac
done

# mandatory arguments
if [ ! "$l" ]; then
    echo "argument -l must be provided"
    echo "$usage" >&2; exit 1
fi

begin=`date +%s`
wd=~/Biol_4310/example_4/trimming_raw_reads

echo "load required modules"
module load fastqc/0.11.4
module load multiqc/1.12
module load fastp/0.20.1

echo "create file storing environment"
mkdir -p sra_files
mkdir -p raw_reads
mkdir -p cleaned_reads/merged_reads
mkdir -p cleaned_reads/unmerged_reads

echo "Downloading SRA files from the given list of accessions"
module load sra-toolkit/3.0.2
cd sra_files
prefetch --max-size 800G -O ./ --option-file ../${l}
ls | grep SRR > sra_list
cd ..
echo "SRA files were downloaded in current directory"
echo ""

echo "Getting fastq files from SRA files"
cd sra_files
while read i; do 
	cd "$i" 
	fastq-dump --split-files --gzip "$i".sra 
	# the --split-files option is needed for PE data
	mv "$i"*.fastq.gz ../../raw_reads/ 
	cd ..
done<sra_list
cd ..
module unload sra-toolkit/3.0.2
echo "Done"


###################################
# Quality check of raw read files #
###################################

echo "Perform quality check of raw read files"
cd raw_reads
ls
pwd
while read i; do 
  	fastqc "$i"_1.fastq.gz # run fastqc onfirst read file which is a file named after sample id in sra_list
  	fastqc "$i"_2.fastq.gz # run fastqc on second read file
done<../sra_files/sra_list
multiqc . # run multiqc in current directory
cd ..

####################################################
# Trimming downloaded Illumina datasets with fastp #
####################################################

echo "Trimming downloaded Illumina datasets with fastp."
cd raw_reads
pwd
ls *.fastq.gz | cut -d "." -f "1" | cut -d "_" -f "1" | sort | uniq > fastq_list
while read z ; do 
# Perform trimming
# -----------------------------------------------
# -i is input file name
# -m is TRUE or FALSE to merge pair-end reads into single read
# -merged_out is output filename for merged reads
# -out1 and out2 are output filenames for read1 and read2 that were not merged
# -e is required average phred value for reads to be kept
# -l is minimum required length of reads
# -q is a minimum phred score and -u is a precentage. if the percentage of nucleotides below the -q phred score is above -u then the read is discarded
# --adapter_sequence --adapter_sequence_r2 are the adapters used for read1 and read2
# -W and -M, are window size and minimum avg phred score required for the window
# -5 and -3 are True or False whehter to trim leading sequences or trailing sequences with averages less than -M
# -c is on or off to use overlap analysis to correct bases with low qualiy
# -----------------------------------------------
fastp -i "$z"_1.fastq.gz -I "$z"_2.fastq.gz \
      -m --merged_out $wd/cleaned_reads/merged_reads/"$z"_merged.fastq \
      --out1 $wd/cleaned_reads/unmerged_reads/"$z"_unmerged1.fastq --out2 $wd/cleaned_reads/unmerged_reads/"$z"_unmerged2.fastq \
      -e 25 -q 15 \
      -u 40 -l 15 \
      --adapter_sequence AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
      --adapter_sequence_r2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
      -M 20 -W 4 -5 -3 \
      -c 
cd ../cleaned_reads/merged_reads
gzip "$z"_merged.fastq
cd ../../raw_reads
done<fastq_list
cd ..
echo ""



#######################################
# Quality check of cleaned read files #
#######################################

echo "Perform check of cleaned read files"
cd $wd/cleaned_reads/merged_reads
pwd
while read i; do 
	fastqc "$i"_merged.fastq.gz # run fastqc on merged reads
done<$wd/sra_files/sra_list

 }
