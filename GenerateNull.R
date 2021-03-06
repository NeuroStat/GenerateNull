###############################################################################
#																			                                        #
#              							Generate null Studies		 	 				                #
#																			                                        #
###############################################################################

# Required input:  a set of studies used for an ALE meta-analysis 
# (for which the Fail-Safe N needs to be determined) and a pre-specified number of 
# null studies. The coordinate space is set to MNI. 
# From this set we deduct the set size, individual study sample sizes and number
# of peaks.
#
# Output: text-file containing the pre-specified number of null studies that
# can be added into the meta-analyses (coordinate space is MNI).
#
# To compute the Fail-Safe N (i.e. the number of null studies that can be added
# to your meta-analysis before the results are no longer statistically 
# significant) a minimum and maximum FSN need to be determined beforehand. 
# An ALE meta-analysis is then performed with a combination of the original data 
# and a selection of null studies. See the accompanying document for the full  
# algorithm that needs to be followed illustrated by an example.


###############################################################################
# To be filled out by the researcher
###############################################################################
# Read in data file
# Provide path to folder with file in variable home or set folder with file 
# to working directory
home<-paste(getwd(),"/",sep="")
setwd(home)
 
namefoci <- "EickhoffHBM09.txt"                              # Name of file
space <- "MNI"                                               # Either MNI or MNI152

  # Required number of null studies is standard set to to 5k + 10. If you require
  # more null studies set auto to "FALSE" and fill out number of required
  # null studies
  auto <- TRUE
  k.null1 <- 375


###############################################################################
# Not to be altered
###############################################################################
  # Read in foci
    foci.info <- array(NA,dim=c(1,5))
    colnames(foci.info) <- c("X","Y","Z","N","S")
    tempfoci <- array(NA,dim=c(1,3))
    foci.raw<-read.table(namefoci,fill=TRUE,header=FALSE,stringsAsFactors = FALSE)
    allfoci<-array(data=NA,dim=c(dim(foci.raw)[1],5))
    nvect <- vector()

    j<-0
    foci.raw2<-foci.raw[,1:3]
    for (i in 1:dim(foci.raw2)[1]) {
        if(foci.raw2[i,1]=="//" & (is.na(as.numeric(gsub("\\Subjects=", "", x=foci.raw2[i,2])))==FALSE)) {
            j<-j+1
            N<-as.numeric(gsub("\\Subjects=", "", x=foci.raw2[i,2]))                                            # Number of participants
        }
        if(is.na(as.numeric(foci.raw2[i,2]))) next

        allfoci[i,5] <- j                                                                                       # Study number
        allfoci[i,4] <- N
        
        nvect<-c(nvect,N)

        allfoci[i,1:3]<-as.numeric(foci.raw2[i,1:3])                                                                                # next study
    }

    allfoci<-na.omit(allfoci)
    foci.info <- allfoci[1:dim(allfoci)[1],1:dim(allfoci)[2]]


# Parameters
	n.r <- nvect 			                          # Sample sizes of individual studies
	k.r <- max (foci.info[,5])				          # Number of studies in the meta-analysis
	p.r <- as.numeric(table(foci.info[,5]))			# Number of peaks
  coord <- "MNI"                              # coordinate space
	k.null <- ifelse(auto==TRUE,10 + (k.r*10), k.null1)

# Generate new studies
    if (space == "MNI") {
      allvox <- read.table("within_MNI.txt")
    } else if (space == "MNI152") {
      allvox <- read.table("within_MNI152.txt")
    } else {
      stop("Please choose either 'MNI' or 'MNI152' as template space!")
    }

  # Set up variables
    p.n <- sample(p.r,k.null,replace=TRUE)

    seed <- sample(c(1:1000000),1)

    file<-array(data=NA,dim=c(sum(p.n)+(k.null*3),1))
    row<-1
    for (i in 1:k.null) {
      nfoci<-p.n[i]
      file[(row),1]<-paste("// NullStudy_",i,sep="")
      set.seed(seed+i)
      file[(row+1),1]<-paste("// Subjects=",sample(n.r,1),sep="")
      set.seed(seed+i)
      tempvox<-allvox[sample(dim(allvox)[1],nfoci,replace=FALSE),1:3]
      file[((row+2):(row+1+nfoci)),1]<-paste(tempvox[1:nfoci,1]," ",tempvox[1:nfoci,2]," ",tempvox[1:nfoci,3],sep="")
      file[(row+2+nfoci),1]<-paste(" ",sep="")
      row<-row+3+nfoci
    }

write.table(file,"NullStudies.txt",quote=FALSE,row.names=FALSE,col.names=FALSE)


