setwd("./templates")
namestr <- "./../plateletall.csv"
b <- read.csv(namestr, header = F, row.names = NULL, stringsAsFactors = F)

for (i in 1:ncol(b)) { 
  for (j in 1:nrow(b)) {
    if (i > 1) {
      b[j,1] <- paste(b[j,1], b[j, i], sep = "")
    }
  }
}

b <- as.data.frame(b[[1]])


b[] <- lapply(b, as.character)
b[] <- lapply(b, tolower)




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



##Platelet Change To Rules

b[] <- lapply(b[], function(x) gsub("Platelet","Platelets",x, ignore.case = T))
b[] <- lapply(b[], function(x) gsub("Plateletss","Platelets",x, ignore.case = T))
b[] <- lapply(b[], function(x) gsub("Platelet count","Platelets",x, ignore.case = T))
b[] <- lapply(b[], function(x) gsub("Platelets:","Platelets",x, ignore.case = T))
b[] <- lapply(b[], function(x) gsub("\\(plts\\)","",x, ignore.case = T))
b[] <- lapply(b[], function(x) gsub("\\(plt\\)","",x, ignore.case = T))
b[] <- lapply(b[], function(x) gsub(">",">=",x, ignore.case = T))
b[] <- lapply(b[], function(x) gsub("greater than or equal to",">=",x, ignore.case = T))
b[] <- lapply(b[], function(x) gsub(">==",">=",x, ignore.case = T))
b[] <- lapply(b[], function(x) gsub(" cell/mm\\^3","/mcL",x, ignore.case = T))
b[] <- lapply(b[], function(x) gsub(" */ *mm\\^3","/mcL",x, ignore.case = T))
b[] <- lapply(b[], function(x) gsub("/microliters","mcL",x, ignore.case = T))
b[] <- lapply(b[], function(x) gsub(" *cells/mcL","/mcL",x, ignore.case = T))
b[] <- lapply(b[], function(x) gsub(" mm\\^3","/mcL",x, ignore.case = T))
b[] <- lapply(b[], function(x) gsub(" *x *10\\^9/L","000/mcL",x, ignore.case = T))
b[] <- lapply(b[], function(x) gsub("100000","100 000",x, ignore.case = T))
b[] <- lapply(b[], function(x) gsub("ul","mcL",x, ignore.case = T))
b[] <- lapply(b[], function(x) gsub("mcl","mcL",x, ignore.case = T))








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

wc_df <- as.data.frame(l$wc) 
for (i in 1:nrow(wc_df)) {
  wc_df[i,1] <- ncol(l) - wc_df[i,1] - 1
  wc_df[i,2] <- 0
}


l <- l[1:(ncol(l)-1)]




base_str <- row1
text_df <- l
text_df_2 <- text_df
loc_df <- as.data.frame(matrix(0, ncol = 2*length(base_str), nrow = nrow(text_df)), stringsAsFactors = F)
rem_df <- as.data.frame(matrix('f', ncol = 1, nrow = nrow(text_df)), stringsAsFactors = F)
fillins_df <- as.data.frame(matrix(NA, ncol = length(base_str), nrow = nrow(text_df)), stringsAsFactors = F)
temp_df <- as.data.frame(matrix(NA, ncol = length(base_str) + 1, nrow = 1), stringsAsFactors = F)

i <- 1
j <- 1
diff <- 0
count <- 0
threshold <- 0.8
temp_loc <- 1
fillins_loc <- 1
loc <- 1
blank_check <- F
match_check <- F

while (j <= length(base_str)) {
  n <- 1
  k <- 1
  while (n <= nrow(text_df)) {
    #print("n:")
    #print(n)
    while (k <= (ncol(text_df)-diff)) {
      #print("k:")
      #print(k)
      if ( ((paste(text_df[n, k:(k+diff)], collapse = ' ')) == (paste(base_str[i:j], collapse = ' '))) ) {
        if (loc == 1) {
          match_check <- T
          count <- count + 1
          loc_df[n,loc] <- k
          loc_df[n,loc+1] <- k + diff
          k <- ncol(text_df)-diff+1
        }
        
        else if (diff == 0) {
          if (k > loc_df[n, loc-1]) {
          
            match_check <- T
            count <- count + 1
            loc_df[n,loc] <- k
            loc_df[n,loc+1] <- k + diff
            k <- ncol(text_df)-diff+1
          }
        } else {
            
            if (k == (loc_df[n,loc-2])) {
              match_check <- T
              count <- count + 1
              loc_df[n,loc] <- k
              loc_df[n,loc+1] <- k + diff
              k <- ncol(text_df)-diff+1
            }	
          }
        }
      k <- k + 1
    }
    if (match_check == F) {
      rem_df[n,1] <- 't'
    }else {
      print("YOU HIT A MATCH")
    }
    n <- n + 1
    k <- 1
    match_check <- F
  }
  if (count >= (nrow(text_df)*threshold)) {
    if (count < nrow(text_df)) {
      threshold <- ((threshold)*nrow(text_df_2))/(sum(rem_df$V1 == 'f'))
    }
    text_df <- text_df[which(rem_df$V1 == 'f'),]
    loc_df <- loc_df[which(rem_df$V1 == 'f'),]
    fillins_df <- fillins_df[which(rem_df$V1 == 'f'),]
    wc_df <- wc_df[which(rem_df$V1 == 'f'),]
    rem_df <- subset(rem_df, V1 == 'f')
    if (loc == 1) {
      for (n in 1:nrow(loc_df)) {
        if (loc_df[n, loc] != 1) {
          temp_df[1,temp_loc]  <- "BLANK"
          temp_loc <- temp_loc + 1
          blank_check <- T
          fillins_loc <- fillins_loc + 1
          break
        }
      }
    }else {
        for (n in 1:nrow(loc_df)) {
          if ((loc_df[n,loc]) - (loc_df[n,loc-1]) > 1) {
            temp_df[1,temp_loc]  <- "BLANK"
            temp_loc <- temp_loc + 1
            blank_check <- T
            fillins_loc <- fillins_loc + 1
            break
          }
        }
    }
    
    
    if (diff > 0) {
      temp_loc <- temp_loc - 1
      for (x in 1:nrow(loc_df)) {
        loc_df[x, loc - 2] <- loc_df[x, loc]
        loc_df[x, loc - 1] <- loc_df[x, loc + 1]
        loc_df[x, loc] <- 0 
        loc_df[x, loc + 1] <- 0 
      }
      loc <- loc - 2
    }
    if (blank_check == T) {
      print ("BLANK_CHECK")
      print (loc)
      print("161")
      for (x in 1:nrow(fillins_df)) {
        print("163")
        if (loc == 1) {
          print("165")
          if (loc_df[x, loc] != 1) {
            print("167")
            fillins_df[x, fillins_loc] <- paste(text_df[x, 1:(loc_df[x,loc]-1)], collapse = ' ')
          }
        }
        else {
          print("172")
          if ((loc_df[x,loc]) - (loc_df[x,loc-1]) > 1) {
            print("174")
            fillins_df[x, fillins_loc] <- paste(text_df[x, (loc_df[x,loc-1] + 1):(loc_df[x,loc]-1)], collapse = ' ')
          }
        }
      }
    }
    print("180")
    temp_df[temp_loc] <- paste(base_str[i:j], collapse = ' ')
    temp_loc <- temp_loc + 1
    loc <- loc + 2
    j <- j + 1
    #threshold <- ((threshold)*nrow(text_df_2))/(sum(rem_df$V1 == 'f'))
    #text_df <- text_df[which(rem_df$V1 == 'f'),]
    #loc_df <- loc_df[which(rem_df$V1 == 'f'),]
    #fillins_df <- fillins_df[which(rem_df$V1 == 'f'),]
    #wc_df <- wc_df[which(rem_df$V1 == 'f'),]
    #rem_df <- subset(rem_df, V1 == 'f')
  }else {
    #print("YOU HIT ELSE")
    if (diff > 0) {
      i <- j
      j <- i
    }else {
      i <- i + 1
      j <- i
    }
    
    loc_df[loc] <- 0
    loc_df[loc+1] <- 0
    rem_df$V1 <- 'f'
    
  }
  
  print("this is i: ")
  print (i)
  count <- 0
  diff <- j - i
  print("this is diff:")
  print(diff)
}


##This part could be cleaner
loc_df <- loc_df[, colSums(loc_df != 0) > 0]

blank_check_end <- F

for (n in 1:nrow(loc_df)) {
  if (loc_df[n, ncol(loc_df)] < wc_df[n, 1]) {
    blank_check_end <- T
  }
}

if (blank_check_end == T) {
  fillins_loc = fillins_loc + 1
  temp_df[temp_loc] <- "BLANK"
  for (x in 1:nrow(fillins_df)) {
    fillins_df[x, fillins_loc] <- paste(text_df[x, (loc_df[x,ncol(loc_df)] + 1):ncol(text_df)], collapse = ' ')
  }
}

for (x in 1:nrow(fillins_df)) {
  fillins_df[x, fillins_loc] <- gsub("IGNORE", "", fillins_df[x, fillins_loc])
}


##Part where we do the counting
fillins_df <- fillins_df[, colSums(is.na(fillins_df)) != nrow(fillins_df)]


for (i in 1:ncol(fillins_df)) {
  names(fillins_df)[i] <- paste("Blank", as.character(i), collapse = ' ')
}

fillins_df <- sapply(fillins_df, as.character)
fillins_df[is.na(fillins_df)] <- ""


i <- 1
while (i <=  ncol(fillins_df)) {
  fillins_df <- as.data.frame(cbind (fillins_df[,c(1:i)], rep(1, times = nrow(fillins_df)), fillins_df[,-c(1:i)]))
  i <- i+ 2
}

for (i in 1:ncol(fillins_df)) {
  if (i %% 2 == 0) {
    colnames(fillins_df)[i] <- "Frequency"
    fillins_df[,i] <- sapply(fillins_df[,i], as.character)
    fillins_df[,i] <- sapply(fillins_df[,i], as.numeric)
  }
}

for (i in 1:ncol(fillins_df)) {
  if (i %% 2 == 1) {
    colnames(fillins_df)[i] <- paste("Blank", (i+1)/2, collapse ="")
    fillins_df[,i] <- sapply(fillins_df[,i], as.character)
  }
}

for (j in 1:ncol(fillins_df)) {
  for (i in 1:nrow(fillins_df)) {
    if (j %% 2 == 1) {
      for (k in 1:i) {
        if (k < i) {
          if (trimws(fillins_df[i, j], which = "both") == trimws(fillins_df[k,j], which = "both")) {
            fillins_df[k, j+1] <- fillins_df[k, j+1] + 1
            fillins_df[i, j] <- paste("IGNORE", i, collapse ="")
            fillins_df[i, j + 1] <- 0 
          }
        }
      }
    }
  }
}

for (j in 1:ncol(fillins_df)) {
  for (i in 1:nrow(fillins_df)) {
    if (j %% 2 == 0) {
      if (fillins_df[i, j] == 0) {
        fillins_df[i, j] <- ""  
      }
    } else {
      fillins_df[i, j] <- gsub("IGNORE \\d+", "", fillins_df[i, j])
    }
  }
}

test2 <- as.data.frame(matrix(0, ncol = 0, nrow = (nrow(fillins_df))))
for (j in 1:ncol(fillins_df)) {
  if (j %% 2 == 1) {
    test <- fillins_df[, c(j, j+1)]
    test[,2] <- as.numeric(test[,2])
    test <- test[order(-test$Frequency),]
    test2 <- cbind(test2, test)
  }
}
fillins_df <- test2[rowSums(is.na(test2))!=(ncol(test2)/2),]


#for (j in 1:ncol(fillins_df)) {
#  for (i in 1:nrow(fillins_df)) {
#    if (j %% 2 == 1) {
#      while (fillins_df[i, j + 1] == "") {
#        for (l in i:nrow(fillins_df)) {
#          if (fillins_df[l, j + 1] != "") {
#            fillins_df[i, j] <- fillins_df[l, j] 
#            fillins_df[i, j + 1] <- fillins_df[l, j + 1] 
#          }
#        }
#        break
#      }
#      fillins_df[l, j] <- ""
#      fillins_df[l, j + 1] <- ""
#    } 
#  }
#}


#temp_df <- cbindPad(temp_df, b)
#fillins_df <- cbindPad(fillins_df, b)
#names(temp_df)[ncol(temp_df)] <- "Cluster Text"
#names(fillins_df)[ncol(fillins_df)] <- "Cluster Text"
write.csv(temp_df, file = paste0(namestr, "TEMPLATE.csv"), row.names = F)
write.csv(fillins_df, file = paste0(namestr, "FILLINS.csv"), col.names = F)

