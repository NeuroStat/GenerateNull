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
cat("In a next step, add",Nnew,"null studies to the meta-analysis. Set your maximum value for the FSN equal to",Nmax, "and your minimum value to",Nmin,".")}