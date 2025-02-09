require(data.table)

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

numbo <- 3


if (numbo <= 0) {
  str2 <- paste("clust_", numbo, ".txt", sep = "")
}
setwd("/media/hdd0/unraiddisk1/student/neilm/primestmp/clusters")

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
  setwd("/media/hdd0/unraiddisk1/student/neilm/primestmp/clusters") 
  numbochar <- as.character(numbo)
  numbotempstr <- paste("template", numbochar, ".csv", sep = "")
  numbofillinsstr <- paste("fillins", numbochar, ".csv", sep = "")
  write.csv(template, file = numbotempstr, row.names = F)
  write.csv(fillins, file = numbofillinsstr, col.names = F)
  
}
numbo <- numbo + 1





while (numbo <= (750)) {
  
  if (numbo <= 750) {
    str2 <- paste("clust_", numbo, ".txt", sep = "")
  }
  setwd("/media/hdd0/unraiddisk1/student/neilm/primestmp/clusters")
  
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
    setwd("C:/Users/AI/Downloads/PipelineTestRun4PLAY") 
    numbochar <- as.character(numbo)
    numbotempstr <- paste("template", numbochar, ".csv", sep = "")
    numbofillinsstr <- paste("fillins", numbochar, ".csv", sep = "")
    write.csv(template, file = numbotempstr, row.names = F)
    write.csv(fillins, file = numbofillinsstr, col.names = F)
    
  }
  numbo <- numbo + 1
  
}
