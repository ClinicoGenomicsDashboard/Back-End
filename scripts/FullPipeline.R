
te: the clustering seems to be working pretty well, but the template algorithm still needs some work.


#Run began approx. 9:06 AM, 9/10/18

library("tm")
library("SnowballC")
library("ggplot2")
library("wordcloud")
library("cluster")
setwd("C:/Users/cloud/Downloads")


ctcl <- read.csv("ctsampleinds_cleaned.csv", header = F)

setwd("C:/Users/cloud/Downloads/ClusterSentCritFinalRun2PLAY")

###NOTE: IF the words "inclusion criterion" or "exclusion criterion" actually appear in your data file,
#then pick different words to use for the below loops



n <- 1
s <- seq(1, ncol(ctcl), by = 2)
for (i in 1:nrow(ctcl)) {
  for (j in s) {
    if (!is.na(ctcl[i,j])) {
      if (ctcl[i,j] != "") {
        n <- as.character(n)
        str <- paste("s", n, ".txt", sep = "")
        incexc <- "UNKNOWN WHETHER INCLUSION CRITERION OR EXCLUSION CRITERION"
        if (!is.na(ctcl[i,j+1])) {
          if (ctcl[i,j+1] != "") {
            if (ctcl[i,j+1] == "TRUE") {
              incexc <- "INCLUSION CRITERION"
            }
            if (ctcl[i,j+1] == "FALSE") {
              incexc <- "EXCLUSION CRITERION"
            }
          }
        }
        write.table(as.data.frame(paste(ctcl[i,j], incexc, sep = " ")),file = str, row.names = F, col.names = F)
        n <- as.numeric(n)
        n <- n + 1
      }
    }
  }
}

sentdocs <- Corpus(DirSource("C:/Users/cloud/Downloads/ClusterSentCritFinalRun2PLAY"))
writeLines(as.character(sentdocs[[25]]))

sentdocs <- tm_map(sentdocs,content_transformer(tolower))
toSpace <- content_transformer(function(x, pattern) { return (gsub(pattern, " ", x))})
sentdocs <- tm_map(sentdocs, toSpace, '"')
sentdocs <- tm_map(sentdocs, toSpace, 'inclusion criterion')
sentdocs <- tm_map(sentdocs, toSpace, 'exclusion criterion')
sentdocs <- tm_map(sentdocs, removeWords, stopwords("english"))
sentdocs <- tm_map(sentdocs, stripWhitespace)
sentdocs <- tm_map(sentdocs,stemDocument)
sentdtm <- DocumentTermMatrix(sentdocs)
sentm <- as.matrix(sentdtm)


#Clust number selection
library("NbClust")
sentmdf <- as.data.frame(sentm)

nb1 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
               method = "ward.D", index = "kl", alphaBeale = 0.1)

nb2 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
               method = "ward.D", index = "ch", alphaBeale = 0.1)

nb3 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
               method = "ward.D", index = "hartigan", alphaBeale = 0.1)

nb4 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
               method = "ward.D", index = "ccc", alphaBeale = 0.1)

nb5 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
               method = "ward.D", index = "scott", alphaBeale = 0.1)

nb6 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
               method = "ward.D", index = "marriot", alphaBeale = 0.1)

nb7 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
               method = "ward.D", index = "trcovw", alphaBeale = 0.1)

nb8 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
               method = "ward.D", index = "tracew", alphaBeale = 0.1)

nb9 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
               method = "ward.D", index = "friedman", alphaBeale = 0.1)

nb10 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
                method = "ward.D", index = "rubin", alphaBeale = 0.1)

nb11 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
                method = "ward.D", index = "cindex", alphaBeale = 0.1)

nb12 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
                method = "ward.D", index = "db", alphaBeale = 0.1)

nb13 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
                method = "ward.D", index = "silhouette", alphaBeale = 0.1)

nb14 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
                method = "ward.D", index = "duda", alphaBeale = 0.1)

nb15 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
                method = "ward.D", index = "pseudot2", alphaBeale = 0.1)

nb16 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
                method = "ward.D", index = "beale", alphaBeale = 0.1)

nb17 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
                method = "ward.D", index = "ratkowsky", alphaBeale = 0.1)

nb18 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
                method = "ward.D", index = "ball", alphaBeale = 0.1)

nb19 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
                method = "ward.D", index = "ptbiserial", alphaBeale = 0.1)

nb20 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
                method = "ward.D", index = "gap", alphaBeale = 0.1)

nb21 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
                method = "ward.D", index = "frey", alphaBeale = 0.1)

nb22 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
                method = "ward.D", index = "mcclain", alphaBeale = 0.1)

nb23 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
                method = "ward.D", index = "gamma", alphaBeale = 0.1)

nb24 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
                method = "ward.D", index = "gplus", alphaBeale = 0.1)

nb25 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
                method = "ward.D", index = "tau", alphaBeale = 0.1)

nb26 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
                method = "ward.D", index = "dunn", alphaBeale = 0.1)

nb27 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
                method = "ward.D", index = "hubert", alphaBeale = 0.1)

nb28 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
                method = "ward.D", index = "sdindex", alphaBeale = 0.1)

nb29 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
                method = "ward.D", index = "dindex", alphaBeale = 0.1)

nb30 <- NbClust(data = sentmdf, diss = NULL, distance = "euclidean", min.nc = 10, max.nc = 50, 
                method = "ward.D", index = "sdbw", alphaBeale = 0.1)



list1 <- unlist(list(if(exists("nb1")) { if(!is.null(nb1$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb1$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb1$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb2")) { if(!is.null(nb2$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb2$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb2$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb3")) { if(!is.null(nb3$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb3$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb3$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb4")) { if(!is.null(nb4$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb4$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb4$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb5")) { if(!is.null(nb5$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb5$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb5$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb6")) { if(!is.null(nb6$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb6$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb6$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb7")) { if(!is.null(nb7$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb7$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb7$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb8")) { if(!is.null(nb8$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb8$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb8$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb9")) { if(!is.null(nb9$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb9$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb9$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb10")) { if(!is.null(nb10$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb10$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb10$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb11")) { if(!is.null(nb11$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb11$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb11$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb12")) { if(!is.null(nb12$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb12$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb12$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb13")) { if(!is.null(nb13$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb13$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb13$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb14")) { if(!is.null(nb14$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb14$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb14$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb15")) { if(!is.null(nb15$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb15$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb15$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb16")) { if(!is.null(nb16$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb16$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb16$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb17")) { if(!is.null(nb17$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb17$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb17$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb18")) { if(!is.null(nb18$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb18$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb18$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb19")) { if(!is.null(nb19$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb19$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb19$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb20")) { if(!is.null(nb20$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb20$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb20$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb21")) { if(!is.null(nb21$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb21$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb21$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb22")) { if(!is.null(nb22$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb22$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb22$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb23")) { if(!is.null(nb23$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb23$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb23$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb24")) { if(!is.null(nb24$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb24$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb24$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb25")) { if(!is.null(nb25$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb25$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb25$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb26")) { if(!is.null(nb26$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb26$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb26$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb27")) { if(!is.null(nb27$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb27$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb27$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb28")) { if(!is.null(nb28$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb28$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb28$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb29")) { if(!is.null(nb29$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb29$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb29$Best.nc[1]), "Number_clusters")))}}},
                     if(exists("nb30")) { if(!is.null(nb30$Best.nc)) { if ( !is.infinite(as.numeric(unlist(strsplit(as.character(nb30$Best.nc[1]), "Number_clusters"))))) {as.numeric(unlist(strsplit(as.character(nb30$Best.nc[1]), "Number_clusters")))}}}))

round2 = function(x, n) {
  posneg = sign(x)
  z = abs(x)*10^n
  z = z + 0.5
  z = trunc(z)
  z = z/10^n
  z*posneg
}

round2(median(list1), 0)
round2(mean(list1), 0)

cutnum <- round2(mean(list1), 0)


numbo <- 1

gsubin <- function(x){gsub("INCLUSION CRITERION", "", x)}
gsubex <- function(x){gsub("EXCLUSION CRITERION", "", x)}

groups <- cutree(hclust(dist(sentm),method="ward.D"), k=cutnum)
clust_list <- lapply(sort(unique(groups)), function(x) which(groups==x))

for (numbo in 1:cutnum) {
  
cdf <- as.data.frame(clust_list[[numbo]])

gsubsen <- function(x) {gsub("s\\d+ .. ", "", x)}
row.names(cdf) <- lapply(row.names(cdf), gsubsen)

cdf[] <- lapply(cdf, as.character)

cdf[,1] <- row.names(cdf)

setwd("C:/Users/cloud/Downloads/ClusterSentCritFinalRun2PLAY")

require(data.table)

for (i in 1:nrow(cdf)) {
  if ((file.info(paste(cdf[i,1],"",sep=""))$size) > 0) {
    if (as.character(read.table(paste(cdf[i,1],"",sep=""), header = F)[1,1]) %like% "INCLUSION CRITERION") {
      incexc2 <- "Inclusion criterion"
    }
    if (as.character(read.table(paste(cdf[i,1],"",sep=""), header = F)[1,1]) %like% "EXCLUSION CRITERION") {
      incexc2 <- "Exclusion criterion"
    }
    cdf[i,2] <- as.character(read.table(paste(cdf[i,1],"",sep=""), header = F)[1,1])  
    cdf[i,2] <- gsubin(cdf[i,2])
    cdf[i,2] <- gsubex(cdf[i,2])
    cdf[i,3] <- incexc2
  }
} 



cdf <- cdf[,c(1,2,3)]

setwd("C:/Users/cloud/Downloads/NewClusterRun4PLAY")

if (nrow(cdf)>1) {
  
n <- as.character(numbo)
str <- paste("cluster", n, ".txt", sep = "")
write.table(cdf,file = str, row.names = F, col.names = F)


}else {

  write.table(cdf,file = "clustersingletons.txt", row.names = F, col.names = F, append = TRUE)
}

}

cbindPad <- function(...){
  args <- list(...)
  n <- sapply(args,nrow)
  mx <- max(n)
  pad <- function(x, mx){
    if (nrow(x) < mx){
      nms <- colnames(x)
      padTemp <- matrix(NA, mx - nrow(x), ncol(x))
      colnames(padTemp) <- nms
      if (ncol(x)==0) {
        return(padTemp)
      } else {
        return(rbind(x,padTemp))
      }
    }
    else{
      return(x)
    }
  }
  rs <- lapply(args,pad,mx)
  return(do.call(cbind,rs))
}

numbo <- 1


while (numbo <= (cutnum +1)) {
  
  if (numbo <= cutnum) {
  str2 <- paste("cluster", numbo, ".txt", sep = "")
  }else {
    str2 <- "clustersingletons.txt"
  }
  setwd("C:/Users/cloud/Downloads/NewClusterRun4PLAY")
  
  res <- try(read.table(str2),silent = TRUE)
  
  if (!inherits(res, 'try-error')) {
    b <- read.table(str2)
    b <- b[,2, drop = F] 
    b[] <- lapply(b, as.character)
    b[] <- lapply(b, tolower)
    
    l <- as.data.frame(matrix(0, ncol = 1, nrow = (nrow(b))))
    
    
    for (i in 1:nrow(b)) {
      if (length( unlist(strsplit(unlist(strsplit (b[i,1], "[^[:alnum:]<>=./]")), "(?=[<>=./])", perl = TRUE))) > ncol(l)) {
        l <- as.data.frame(matrix(0, ncol = length( unlist(strsplit(unlist(strsplit (b[i,1], "[^[:alnum:]<>=./]")), "(?=[<>=./])", perl = TRUE))), nrow = (nrow(b))))
      }
      
    }
    n <- 1
    for (i in 1:nrow(b)) {
      
      n <- as.numeric(as.numeric(ncol(l)) - as.numeric(length( unlist(strsplit(unlist(strsplit (b[i,1], "[^[:alnum:]<>=./]")), "(?=[<>=./])", perl = TRUE)))))
      l[i,] <- c( unlist(strsplit(unlist(strsplit (b[i,1], "[^[:alnum:]<>=./]")), "(?=[<>=./])", perl = TRUE)), rep("IGNORE", times = as.numeric(n)))
    }
    
    l <- cbind(l, rep(0, times = nrow(l)))
    names(l)[ncol(l)] <- "wc"
    for (i in 1:nrow(l)) {
      l[i,ncol(l)] <- length(grep("IGNORE", l[i,]))
    }
    
    
    row1 <- unlist(strsplit(unlist(strsplit(b[which.max(l$wc),1], "[^[:alnum:]<>=./]")), "(?=[<>=./])", perl = TRUE))
    
    l <- l[1:(ncol(l)-1)]
    d <- as.data.frame(matrix(.Machine$double.xmax, ncol = ncol(l), nrow = nrow(l)), stringsAsFactors = F)
    listo <- rep(.Machine$double.xmax, times = nrow(l))
    
    results <- rep('IGNORE', times = ncol(l))
    n <- 1
    k <- 1
    g <- 1
    p <- 0
    s <- 1
    check <- 0
    ignorecheck <- 0
    switch01 <- 0
    while (n <= length(row1)) {
      while (k <= length(row1)) {
        p <- 0 
        if (n > 0) {
          if (k > 0) {
            for (i in 1:nrow(l)) {
              if (i > 0) {
                for (v in 1:ncol(l)) {
                  for (w in 1:ncol(l)) {  
                    if (s == 1) {  
                      if ( ((paste(l[i, v:w], collapse = ' ')) == (paste(row1[n:k], collapse = ' '))) ){
                        if (w < listo[i]) {  
                          p <- p + 1
                          listo[i] <- w
                          if (n == 1 & v > 1) {
                            check <- check + 1
                          }
                        }
                      }
                    }else {
                      if ( ((paste(l[i, v:w], collapse = ' ')) == (paste(row1[n:k], collapse = ' '))) ){
                        if (v > d[i,s-1]) {
                          if (w < listo[i]) {
                            p <- p + 1
                            listo[i] <- w
                          }
                        }
                      }
                    } 
                  } 
                }
              }    
            }
          }
        }
        if (p >= nrow(b)) {
          results[g] <- paste(row1[n:k], collapse = ' ')
          if (k == length(row1)) {
            n <- k
          }
          if (k < length(row1)) {
            k <- k + 1
          }
          d[,s] <- listo
          listo <- rep(.Machine$double.xmax, times = nrow(l))
          ignorecheck <- ignorecheck + 1
          switch01 <- 1
        }
        if ((p < nrow(b))) {
          if (n < length(row1)) {
            if (switch01 == 0) {
              n <- k + 1
              k <- n
            }
            if (switch01 == 1) {
              n <- k
            }
            g <- g + 2
            if (d[1,s] != .Machine$double.xmax) {
              s <- s + 1
            }
            listo <- rep(.Machine$double.xmax, times = nrow(l))
            switch01 <- 0 
          }
        }
        if (n == length(row1)) {
          n <- n + 1
          k <- k + 1
        }
      }
    }
    if (ignorecheck > 0) {
      results <- unlist(strsplit(results, " "))
      
      results <- as.data.frame((results))
      results <- cbind(results, rep("f", times = nrow(results)))
      colnames(results)[ncol(results)] <- "tf"
      results[] <- lapply(results, as.character)
      results <- results[complete.cases(results),]
      
      for (i in 2:nrow(results)) {
        if (results[i,1] == "IGNORE") {
          if (results[i,1] == results[(i-1),1]) {
            results[i,2] <- "t"
          }
        }
      }
      
      igcheck <- 0
      results <- subset(results, tf == "f")  
      results <- as.data.frame(results[,-(ncol(results))])
      colnames(results)[1] <- "Template"
      results <- as.character(results[,1])
      if (length(results) < ncol(l)) {
        for (i in (length(results)+1):(ncol(l))) {
          results[i] <- "IGNORE"
          igcheck <- 1
        }
      }
      
      if (check > 0) {
        results <- c("IGNORE", results)
      }
      
      seq <- as.data.frame(t(as.data.frame(results)))
      seq <- seq[,(1:(ncol(l)))]
      seq [] <- lapply(seq, as.character)
      l[] <- lapply(l, as.character)
      
      p <- list(as.character(print(seq[1,])))
      p <- as.data.frame(p)
      colnames(p)[1] <- "col1"
      p <- cbind(p, rep("f", times =nrow(p)))
      colnames(p)[2] <- "tf"
      p[,2] <- sapply(p[,2], as.character)
      for (i in 2:nrow(p)) {
        if ((trimws(p[i,1], which = "both")) == "IGNORE") {
          if (p[i,1] == p[(i-1),1])
            p[i,2] <- "t"
        }
      }
      
      
      p <- subset(p, tf == "f")
      p <- as.character(print(p[,1]))
      p <- paste(p,collapse=" ")
      w <- strsplit(p, "IGNORE")
      w <- as.data.frame(w[[1]])
      colnames(w)[1] <- "col1"
      w <- subset(w, col1 != " ")
      w <- subset(w, col1 != "")
      w <- as.character(w[,1])
      w <- gsub(" ","", w)
      
      
      non2 <- as.data.frame(matrix(0, ncol = ncol(l), nrow = nrow(l)), stringsAsFactors = F)
      d2 <- as.data.frame(matrix("f", ncol = length(w), nrow = nrow(l)), stringsAsFactors = F)
      
      non2[] <- lapply(non2, as.numeric)
      
      g <- 1 
      
      for (j in 1:nrow(l)) {
        if (j > 0) {
          for (i in 1:length(w)) {
            if (i > 0) {
              for (k in 1:ncol(l)) {
                for (m in 1:ncol(l)) {
                  if ( (gsub(" ","",paste(l[j,k:m],collapse=" ")) == w[i]) & (d2[j,i] == "f") ){
                    d2[j,i] <- "t"
                    if (g == 1) {
                      non2[j, g] <- k
                      non2[j, g+1] <- m
                      g <- g + 2
                    }else if ((k > as.numeric(non2[j, (g-1)])) & (m > as.numeric(non2[j, (g-1)]))) {
                      non2[j, g] <- k
                      non2[j, g+1] <- m
                      g <- g + 2
                    }
                  }
                }
              }
            }
          }
        }
        g <- 1
      }
      
      non3 <- as.data.frame(matrix("IGNORE", ncol = ncol(l), nrow = nrow(l)), stringsAsFactors = F)
      
      g <- rep(1, times = nrow(non2))
      f <- 1
      
      
      for (m in 1:nrow(non2)) {
        q <- as.character(print(non2[m,]))
        q <- paste(q,collapse=" ")
        q <- unlist(strsplit(q, " "))
        x <- 1
        while (x <= length(q)) {
          if (q[x] == "0") {
            q <- q[-x]
          }else {
            x <- x + 1
          }
        }
        q <- list(q)
        q <- as.data.frame(q[[1]])
        colnames(q)[1] <- "col1"
        q <- subset(q, col1 != "")
        q[,1] <- sapply(q[,1], as.character)
        q[,1] <- sapply(q[,1], as.numeric)
        i <- 1
        while (i <= nrow(q)) {
          if (i == 1) { 
            if (as.numeric(q[i,1]-1) >=1) {
              non3[m,g[m]] <- paste(as.character(l[m,1:(as.numeric(q[i,1]-1))]), collapse = " ")
              g[m] <- g[m] + 1
            }else {
              g[m] <- 2
            }
          }
          if ((i %% 2 == 0) & (i != nrow(q)) & ((as.numeric(q[i+1,1]-1)) >= (as.numeric(q[i,1]+1)))) {
            non3[m,g[m]] <- paste(as.character(l[m,(as.numeric(q[i,1]+1)):(as.numeric(q[i+1,1]-1))]), collapse = " ")
            g[m] <- g[m] + 1
          }
          if ((i %% 2 == 0) & (i != nrow(q)) & ((as.numeric(q[i+1,1]-1)) < (as.numeric(q[i,1]+1)))) {
            g[m] <- g[m] + 1
          }
          if ((i %% 2 == 0) & (i == nrow(q)) & (as.numeric(q[i,1]+1) <= as.numeric(ncol(l)))) {
            non3[m,g[m]] <- paste(as.character(l[m,(as.numeric(q[i,1]+1)):(as.numeric(ncol(l)))]), collapse = " ")
            g[m] <- g[m] + 1
          }
          if (i < nrow(q)) {
            i <- i + 1
          }else {
            break
          }
        }
      }
      
      
      for (i in 1:ncol(seq)) {
        if (seq[1,i] == "IGNORE") {
          seq[1,i] <- "BLANK" 
        }
      }
      
      non3 <- as.data.frame(t(non3))
      non3 <- cbind(non3, rep("f", times = nrow(non3)))
      colnames(non3)[ncol(non3)] <- "tf"
      non3[] <- lapply(non3, as.character)
      
      for (i in 1:nrow(non3)) {
        if (paste(as.character(print(non3[i,1:(ncol(non3)-1)])), collapse = " ") == paste(as.character(rep("IGNORE", times = ncol(non3)-1)), collapse = " ")) {
          non3[i,ncol(non3)] <- "t" 
        }
      }
      
      non3 <- subset(non3, tf == "f")  
      non3 <- non3[,-(ncol(non3))]
      non3 <- as.data.frame(t(non3))
      
      seq <- as.data.frame(t(seq))
      seq <- cbind(seq, rep("f", times = nrow(seq)))
      colnames(seq)[ncol(seq)] <- "tf"
      seq[] <- lapply(seq, as.character)
      
      for (i in 2:nrow(seq)) {
        if (seq[i,1] == "BLANK") {
          if (seq[i,1] == seq[(i-1),1]) {
            seq[i,2] <- "t"
          }
        }
      }
      
      if (seq[nrow(seq),1] == "BLANK") {
        if (igcheck == 1) {
          seq[nrow(seq),2] <- "t" 
        }
      }
      
      seq <- subset(seq, tf == "f")  
      seq <- as.data.frame(seq[,-(ncol(seq))])
      
      
      
      
      colnames(seq)[1] <- "Template"
      seq <- as.data.frame(t(seq))
      
      
      template <- seq
      
      
      
      fillins <- non3
      
      if (ncol(non3) > 0) {
        
        for (j in 1:ncol(fillins)) {
          fillinstest <- as.character(fillins[,j])
          for (i in 1:length(fillinstest)) {
            fillinstest[i] <- gsub("IGNORE", "", fillinstest[i])
          }
          fillins[,j] <- fillinstest
        }
        
        
        
        i <- 1
        while (i <=  ncol(fillins)) {
          fillins <- as.data.frame(cbind (fillins[,c(1:i)], rep(1, times = nrow(fillins)), fillins[,-c(1:i)]))
          i <- i+ 2
        }
        
        for (i in 1:ncol(fillins)) {
          if (i %% 2 == 0) {
            colnames(fillins)[i] <- "Frequency"
            fillins[,i] <- sapply(fillins[,i], as.character)
            fillins[,i] <- sapply(fillins[,i], as.numeric)
          }
        }
        for (i in 1:ncol(fillins)) {
          if (i %% 2 == 1) {
            colnames(fillins)[i] <- paste("Blank", (i+1)/2, collapse ="")
            fillins[,i] <- sapply(fillins[,i], as.character)
          }
        }
        for (j in 1:ncol(fillins)) {
          for (i in 1:nrow(fillins)) {
            if (j %% 2 == 1) {
              for (k in 1:i) {
                if (k < i) {
                  if (trimws(fillins[i, j], which = "both") == trimws(fillins[k,j], which = "both")) {
                    fillins[k, j+1] <- fillins[k, j+1] + 1
                    fillins[i, j] <- paste("IGNORE", i, collapse ="")
                    fillins[i, j + 1] <- 0 
                  }
                }
              }
            }
          }
        }
        
      }
      
    } else {
      template <- fillins <- as.data.frame(matrix("", ncol = 1, nrow = 1))
    }
    

    template <- cbindPad(template, b)
    fillins <- cbindPad(fillins, b)
    names(template)[ncol(template)] <- "Cluster Text"
    names(fillins)[ncol(fillins)] <- "Cluster Text"
    setwd("C:/Users/cloud/Downloads/PipelineTestRun4PLAY") 
    numbochar <- as.character(numbo)
    numbotempstr <- paste("template", numbochar, ".csv", sep = "")
    numbofillinsstr <- paste("fillins", numbochar, ".csv", sep = "")
    write.csv(template, file = numbotempstr, row.names = F)
    write.csv(fillins, file = numbofillinsstr, col.names = F)
    
  }
  numbo <- numbo + 1
  
}

