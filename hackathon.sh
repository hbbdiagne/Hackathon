	#outils

sudo apt install sra-toolkit  #fasterq_dump
conda install trim-galore     #trimgalore
conda install -c bioconda bowtie  #bowtie
conda install samtools  #samtools
conda create -n featurecounts -c bioconda subread 
conda activate featurecounts #featurecounts


#a reinstaller avec R :
conda install -c bioconda bioconductor-deseq2   #deseq2
#########################################################
	#Squelette du projet :

#downloadinf fastqc files
sudo apt install fastqc
fasterq-dump --threads 8 --progress SRR10379721
fasterq-dump --threads 8 --progress SRR10379722
fasterq-dump --threads 8 --progress SRR10379723
fasterq-dump --threads 8 --progress SRR10379724
fasterq-dump --threads 8 --progress SRR10379725
fasterq-dump --threads 8 --progress SRR10379726

gzip *.fastq


#trimming the reads
conda install trim-galore
trim_galore -q 20 --phred33 --length 25 <FASTQ FILE>

#downloading reference genome

wget -q -O reference.fasta "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=CP000253.1&rettype=fasta"


#downloading reference genome annotation

wget -O reference.gff "https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?db=nuccore&report=gff3&id=CP000253.1"

#creating genome index
conda install -c bioconda bowtie
bowtie-build <full genome fasta file> <index name>

#mapping fastq files
conda install samtools
conda install -c bioconda bowtie

bowtie -p <#cpus> -S <INDEX NAME> <(gunzip -c <GZIPED FASTQ FILE>) | \
samtools sort -@ <#CPUS> > <NAME>.bam
samtools index <NAME>.bam


#counting reads
conda create -n featurecounts -c bioconda subread
featureCounts --extraAttributes Name -t gene -g ID -F GTF -T <#CPUS> -a <GFF> -o counts.txt <BAM FILES>


#statistical analysis
conda install -c bioconda bioconductor-deseq2
DESeq2


#additional information



######################################Docker 
	#installation docker :
sudo apt update
sudo apt install docker.io
sudo systemctl status docker
sudo usermod -aG docker $USER #ajouter votre utilisateur au groupe docker
docker --version

		#image docker tirée de hub docker executée dans un conteneur:
		#exit pour sortir
docker run -it ubuntu
		#pull image, telecharge image 
docker pull nom_de_l_image[:tag]

		#creation de conteneur, utilise image telecharger pour creer un environnement de conteneur executable
docker run -it nom_de_l_image[:tag]
