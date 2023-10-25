#Creation de l'environnement Hackathon_env dans lequel executer RUN.sh


	#creation de l'environnement conda hackathon_env
yes | conda create --name hackathon_env
conda activate hackathon_env
##


#trimgalore
yes | conda install trim-galore 
    
#bowtie
yes | conda install -c bioconda bowtie  

#samtools
yes | conda install samtools  

#featurecounts
yes | conda install -c bioconda subread 

#nextflow
yes | conda install -c bioconda nextflow 


#deseq2
yes | conda install -c bioconda bioconductor-deseq2
 
#fasterq_dump
sudo rm /var/lib/dpkg/lock-frontend
sudo dpkg --configure -a
sudo apt install
yes | sudo apt install sra-toolkit  

























