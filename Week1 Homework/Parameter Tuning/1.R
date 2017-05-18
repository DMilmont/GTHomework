source("./grid-search.r")
source("../prepare-data.R")
library('kernlab')
library('RCurl')
library('ggplot2')
library('GGally')
library('mlr')

file <- getURL('https://d37djvu3ytnwxt.cloudfront.net/assets/courseware/v1/e39a3df780dacd5503df6a8322d72cd2/asset-v1:GTx+ISYE6501x+2T2017+type@asset+block/credit_card_data-headers.txt', ssl.verifyhost=FALSE, ssl.verifypeer=FALSE)

data <- read.csv(textConnection(file), header=T, sep = "\t")

x <- as.matrix(data[,1:10])
y <- data[,11]

# http://www.csie.ntu.edu.tw/~cjlin/papers/tanh.pdf
# gaussian:  C x sigma     = {2^-3, ..., 2^12} x {2^-12, ..., 2^2}
# tanh:      C x sigma x r = {2^-3, ..., 2^12} x {2^-12, ..., 2^2} x {-2.4, -1.8, ..., 2.4}
# poly:      C x deg x off = {2^-3, ..., 2^12} x {1, ..., 5}       x {0,1}

G <- rbind(
  #expand.grid(kernel = "rbfdot",  C = 10^(-2:5), p1 = 10^(-5:1), p2 = N.),
  #expand.grid(kernel = "tanhdot", C = 10^(-2:5), p1 = 10^(-5:1), p2 = seq(-2.4,2.4,0.6))
  expand.grid(kernel = "polydot", C = 10^(-2:2), p1 = c(1,2,3,4,5), p2 = c(0,1))
)

G <- G[sample(nrow(G)),]

formula <- (y ~ x)


fullResult <- N.
step_size <- 40
num_of_iterations <- floor(nrow(G) / step_size) + ifelse(nrow(G)%%step_size==0,0,1)

for(i in 1:num_of_iterations) {
  subG <- G[((i-1)*step_size+1):min((i*step_size), nrow(G)),]
  print(sprintf("G from %d to %d",((i-1)*step_size+1),min((i*step_size), nrow(G))))
  
  subResult <- kernlab_grid_search(data$train, subG, formula, k=100)
  
  if(!is.na(fullResult)) {
    fullResult <- rbind(fullResult, subResult)
  } else {
    fullResult <- subResult
  }
  
  save.image("../data/svm.grid.search.RData")
}

fullResult_P <- fullResult[order(fullResult[,"cross"]),]
save.image("../data/svm.grid.search.RData")

##################################################################################################################
m <- ksvm(y ~ x, type = "C-svc", kernal = "polydot", C=100, scaled = TRUE,kpar=list(scale=0.01, offset=-1.2))
# m <- ksvm(formula, data=data$train, kernel="tanhdot", C=100, kpar=list(scale=0.01, offset=-1.2))

res <- data.frame(PassengerId = df_test$PassengerId, Survived = as.numeric(as.character(predict(m, data$test))))
write.table(res, "result.txt", row.names=FALSE, sep=",")