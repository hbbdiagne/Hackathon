
output_dir = file("output_dir")

process createDir {

    script:
    """
    mkdir -p ${output_dir}
    """
}

	//PROCESSUS
	
process trimgalore {
    input:
    file x
    output:
    path "${x.baseName}_trimmed.fq"

    script:
    """
    trim_galore -q 20 --phred33 --length 25 ${x}
    """
}
process genome_index {
    input:
    file f
    file g
    output:
    path "*"

    script:
    """
    bowtie-build ${f} ${g}
    """
}
process mapping {
    input:
    file trimmed
    file ref
    output:
    path "*bam"
    script:
    """
    bowtie -p 16 -S reference.gff <(cat ${trimmed}) | \\
    samtools sort -@ 16 -o ${trimmed.baseName}.bam -
    samtools index ${trimmed.baseName}.bam
    """
}
process featurecount {
        input :
        file x
        file ref
        output:
        path "*txt*"
        script:
        """
        featureCounts --extraAttributes Name -t gene -g ID -F GTF -T 16 -a ${ref} -o ${x}.count.txt ${x}
	cp *.txt ${output_dir}	
        """
}

	//WORKFLOW

workflow {
	//CREATION REPERTOIRE OUTPUT
	createDir()

	//INDEXATION
	geno = genome_index(file("reference.fasta"),file("reference.gff")) 
	
	
	//WORKFLOW pour 1 fastq
	def monWorkflow = { fastq ->
		//Trim_galore, nettoie les sequences
	        trimq = trimgalore(file(fastq))
	        
	        //Mapping des sequences nettoyée sur le genome indexé
	        mapped = mapping(trimq,geno)
	        
	        //Comptage des sequences
	        count = featurecount(mapped,file("reference.gff"))
	        
	        //
	
	        count.view { "Result: ${it}" }
	}


	//création des 6 workflow pour les 6 fichiers fastq
	workflow flow1 {monWorkflow("SRR10379721.fastq")}
	workflow flow2 {monWorkflow("SRR10379722.fastq")}
	workflow flow3 {monWorkflow("SRR10379723.fastq")}
	workflow flow4 {monWorkflow("SRR10379724.fastq")}
	workflow flow5 {monWorkflow("SRR10379725.fastq")}
	workflow flow6 {monWorkflow("SRR10379726.fastq")}

	//Lance les analyses
        flow1.run()
        flow2.run()
        flow3.run()
        flow4.run()
        flow5.run()
        flow6.run()
	
}


























