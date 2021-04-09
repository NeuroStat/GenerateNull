In this folder all files necessary for constructing null studies to compute the Fail-Safe N can be found, 
along with 3 example datasets ([EickhoffHBM09.txt](EickhoffHBM09.txt), [Gamble.txt](Gamble.txt) and [Taste.txt](Taste.txt)).
In [Procedure.docx](Procedure.docx) the procedure for computing the Fail-Safe N and generating null studies is clearly described. 
[GenerateNull.R](GenerateNull.R) contains all code for easily generating null studies based on the parameters
of the meta-analysis of interest, while [algorithm_step4.R](algorithm_step4.R) aids in determining the number of null
studies to add in a next step. [within_MNI.txt](within_MNI.txt) and [within_MNI152.txt](within_MNI152.txt) are text files
that contain all voxels inside the default MNI and MNI152 masks as shipped with GingerALE, respectively. The 
[GenerateNull.R](GenerateNull.R) file depends on these files, it is therefore imperative that they are not deleted.
