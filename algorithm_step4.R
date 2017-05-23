###############################################################################
#                                                                             #
#        Determine the number of null Studies to add in the next step         #
#                                                                             #
###############################################################################

# Required input: number of null studies added in a previous step, statistical
# significance of the cluster after adding these null studies, minimum and 
# maxmum FSN
#
# Output: Observed minimum or maximum FSN, number of null studies to be added
# in a next step
#
# Fill out the number of null studies that were added in the previous step, 
# whether the cluster of interest was still statistically significant and the
# minimum and maximum FSN. These can either be your predefined minumum and 
# maximum, or an observed value. If your predefined minumum was e.g. 20 and 
# after adding 50 null studies the cluster is still activated, the observed 
# minimum becomes 50.


###############################################################################
# To be filled out by the researcher
###############################################################################
  # number of null studies that were added in the last step
  N <- 261
  # statistical significance of cluster in previous step, TRUE or FALSE
  Significance <- FALSE
  # minimum number of null studies (this can be the predefined or observed minimum)
  Min <- 261
  # maximum number of null studies (this can be the predefined or observed maximum)
  Max <- 375


###############################################################################
# Not to be altered
###############################################################################

nrnullstudies<-function(N,Min,Max,Significance)
{
if(N<Min|Min>Max|N>Max){stop("Incorrect values are provided in the input.")}  
if(is.logical(Significance)==FALSE){stop("Please provide whether the cluster of interest remained significant (Significance=TRUE) or not (Significance=FALSE) after adding ",N," null studies.")}
  
if(Min==Max)
{cat("The FSN is equal to",Min,".")}
  
if(Significance==FALSE)
{Nnew<-round((Min+N)/2)
  Nmax<-N
  Nmin<-Min
}

if(Significance==TRUE)
{Nnew<-round((Max+N)/2)
  Nmax<-Max
  Nmin<-N
}
cat("In a next step, add",Nnew,"null studies to the meta-analysis. Set your maximum value for the FSN equal to",Nmax, "and your minimum value to",Nmin,".")
}

nrnullstudies(N,Min,Max,Significance)

