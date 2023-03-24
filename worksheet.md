# Trimming Raw Reads Worksheet

<!--- Write name below --->
## Name: Dante Celani 

<!--- For this worksheet, answer the following questions--->

## Q1: What does "cleaning" your reads mean?
Answer:	removing reads that dont meet the requremen ts set for fastp

### Q2: Open the script called "trim_raw_reads.sh". For every line that says ```insert description here```, replace that text with a description of what the line will do

### Q4: Attach an image of the plot from fastqc showing the average base quality from your reads files
![before-trimming-PHRED-plot-1](./images/<plot-for-reads1>)
![before-trimming-PHRED-plot-1](./images/<plot-for-reads2>)

---

## The following questions pertain to your first fastp run (without altering the parameters)
### Q5: How many reads were there in the R1 file before filtering?
Answer: 33967298 
### Q6: How many bases were there in the R1 file before filtering?
Answer: 3430697098
### Q7: What proportion of bases were above PHRED score of 20 before filtering?
Answer: 95.0005%
### Q8: What proportion of bases were above PHRED score of 30 before filtering?
Answer: 90.0214%

### Q13: How many reads were there in the R2 file before filtering?
Answer: 33967298 
### Q14: How many bases were there in the R2 file before filtering?
Answer: 3430697098
### Q15: What proportion of bases were above PHRED score of 20 before filtering?
Answer: 95.0005%
### Q16: What proportion of bases were above PHRED score of 30 before filtering?
Answer: 90.0214%

### Q17: How many reads were there in the merged file after filtering?
Answer: 12295196
### Q18: How many bases were there in the merged file after filtering?
Answer: 1750796378
### Q19: What proportion of bases in the merged file were above PHRED score of 20 after filtering?
Answer: 98.9275%
### Q20: What proportion of bases in the merged file were above PHRED score of 30 after filtering?
Answer: 95.3968%

### Q21: What is the difference between the merged and unmerged files (in principle, not quantitatively)?
Answer: Merged files are when read 1 and read 2 overlap they're combined into a single read and if they don't overlap the reads are put in unmerged files.
### Q22: Why are the unmerged files for R1 and R2 different lengths?
Answer: One of the unmerged files had more cleaned reads than the other that had more discarded reads.

---

## The following questions pertain to Remix 1 (the first time you change fastp parameters)
### Q23: What parameters did you change?
Answer: changed window size (-W) from 4 to 8
### Q24: How did you expect this to change the filtering results (be specific)?
Answer: I thought it might increase the number of reads because a larger window would need a low average phred score to discard the read.
### Q25: Explain the results. Did the change cause an effect that matched your expectations? Use information from the fastp output to explain.
Answer: I'm suprised that a larger window would decrease the number of reads. There were less reads, bases after filtering and larger portions above phred score 20 and 30

---

## The following questions pertain to Remix 2 (the first time you change fastp parameters)
### Q26: What parameters did you change?
Answer: changed average read phred score (-e) from 25 to 30 
### Q27: How did you expect this to change the filtering results (be specific)?
Answer: I'd expect this to decrease the number of reads and increase the percentage of bases above a phred score of 30
### Q28: Explain the results. Did the change cause an effect that matched your expectations? Use information from the fastp output to explain.
Answer: the effect did match my expectations it lowered the number of reads and bases in the merged file after filtering and increased the percentage of reads above a phred score of 20 and 30.

