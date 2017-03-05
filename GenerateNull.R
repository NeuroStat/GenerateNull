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
 
 namefoci <- "Gambling.txt"                              # Name of file

  # Required number of null studies
    k.null <- 500


###############################################################################
# Not to be altered
###############################################################################
  # Read in foci
    foci.info <- array(NA,dim=c(1,5))
    colnames(foci.info) <- c("X","Y","Z","N","S")
    foci <- array(NA,dim=c(1,3))
    foci.raw<-read.table(namefoci,fill=TRUE)
    n <- NA
    p <- NA
    for(i in 1:50000){
      S <- i

      
      for (j in 2:500) {
        if((sum(grepl(foci.raw[j,1],c(0:9))) > 0) & (grepl(foci.raw[j-1,1],"//"))) {
          l.n<-j
          #print(c(j,l.n))
        } else if((sum(grepl(foci.raw[j-1,1],c(-150:150))) > 0) & (is.na(grepl(foci.raw[j,1],"//")))) {
          l.t<-j
          #print(c(j,l.t))
          break
        } else if((sum(grepl(foci.raw[j-1,1],c(-150:150))) > 0) & (grepl(foci.raw[j,1],"//"))) {
          l.t<-j
          #print(c(j,l.t))
          break
        } else if(j==500) {
         cat("Warning: more then 500 foci were found in 1 study")
        }
      }

      N <- as.numeric(gsub("\\D", "", x=foci.raw[l.n-1,2]))
      n <- cbind(n,N)

      p <- cbind(p,l.t-l.n+1)

      foci <- foci.raw[l.n:(l.t-1),1:3]
      names(foci) <- c("X","Y","Z")
      foci.info <- rbind(foci.info,cbind(foci,N,S))
      foci.raw <- foci.raw[-(1:(l.t)),,]
        
      if(dim(foci.raw)[1]==0)
      break
      if(i==50000)
      cat("Warning: more then 50000 studies were included in the meta-analysis")
    }

  # Final foci and info matrix
    foci.info <- na.omit(foci.info)


# Parameters
	n.r <- n[!is.na(n)] 			        # Sample sizes of individual studies
	k.r <- max (foci.info[,5])				# Number of studies in the meta-analysis
	p.r <- p[!is.na(p)]				        # Number of peaks
  coord <- "MNI"                  # coordinate space
	

# Generate new studies
  # Read in coordinates within mask
    # allvox <- read.table("small_mask_vox_MNI.txt")
    # MNI<-c(39,57,36) 
    # toxyz<-function(x,origin) ((x-origin)*2)*c(-1,1,1)           # from R to ALE

    # allvox.MNI<-array(data=NA,dim=c(dim(allvox)[1],3))
    # for (i in 1:dim(allvox)[1]) {
    #   allvox.MNI[i,]<-as.numeric(toxyz(allvox[i,1:3],MNI))
    # }

    # write.table(allvox.MNI,"within_MNI.txt",quote=FALSE,row.names=FALSE,col.names=FALSE)

    allvox <- read.table("within_MNI.txt")

  # Set up variables
    p.n <- sample(p.r,k.null,replace=TRUE)

    file<-array(data=NA,dim=c(sum(p.n)+(k.null*3),1))
    row<-1
    for (i in 1:k.null) {
      nfoci<-p.n[i]
      file[(row),1]<-paste("// NullStudy_",i,sep="")
      file[(row+1),1]<-paste("// Subjects=",sample(n.r,1),sep="")
      tempvox<-allvox[sample(dim(allvox)[1],nfoci,replace=FALSE),1:3]
      file[((row+2):(row+1+nfoci)),1]<-paste(tempvox[1:nfoci,1]," ",tempvox[1:nfoci,2]," ",tempvox[1:nfoci,3],sep="")
      file[(row+2+nfoci),1]<-paste(" ",sep="")
      row<-row+3+nfoci
    }

write.table(file,"NullStudies.txt",quote=FALSE,row.names=FALSE,col.names=FALSE)


