#script a executer dans le meme repertoire que les sorties de featurecounts
rm(liste=l)
#0########################Installation via R de DESeq2
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("DESeq2")
#



library("DESeq2")


#1#################Creation des tableau cts et coldata necessaire pour deseq2
tab1=read.table("output_dir/SRR10379721_trimmed.bam.count.txt",head = TRUE)
tab2=read.table("output_dir/SRR10379722_trimmed.bam.count.txt",head = TRUE)
tab3=read.table("output_dir/SRR10379723_trimmed.bam.count.txt",head = TRUE)
tab4=read.table("output_dir/SRR10379724_trimmed.bam.count.txt",head = TRUE)
tab5=read.table("output_dir/SRR10379725_trimmed.bam.count.txt",head = TRUE)
tab6=read.table("output_dir/SRR10379726_trimmed.bam.count.txt",head = TRUE)

cts=data.frame(tab1$SRR10379721_trimmed.bam,
               tab2$SRR10379722_trimmed.bam,
               tab3$SRR10379723_trimmed.bam,
               tab4$SRR10379724_trimmed.bam,
               tab5$SRR10379725_trimmed.bam,
               tab6$SRR10379726_trimmed.bam)

rownames(cts)=tab1$Name
x=c("tab1.SRR10379721_trimmed.bam",
    "tab2.SRR10379722_trimmed.bam",
    "tab3.SRR10379723_trimmed.bam",
    "tab4.SRR10379724_trimmed.bam",
    "tab5.SRR10379725_trimmed.bam",
    "tab6.SRR10379726_trimmed.bam"
)

coldata=data.frame(condition = x)
rownames(coldata)=coldata$condition
coldata$condition=c("treated","untreated")
coldata$type=c("1","2","3","1","2","3")
colnames(coldata)=c("condition","type")

coldata$condition = factor(coldata$condition)
coldata$type = factor(coldata$type)


#2#################################Analyse Deseq2
dds <- DESeqDataSetFromMatrix(countData = cts,
                              colData = coldata,
                              design= ~ type + condition)

dds <- DESeq(dds)
resultsNames(dds) # lists the coefficients
res <- results(dds)
summary(res)
plotMA(res, ylim=c(-2,2))
png(file = "out.png", width = 800, height = 700)
plot(rnorm(100))
dev.off()




