#Loading Libraries
library('ggplot2')
library('mlr')
library("outliers")


#Loading data 

#temperature data file
tempData <- read.table("https://d37djvu3ytnwxt.cloudfront.net/assets/courseware/v1/592f3be3e90d2bdfe6a69f62374a1250/asset-v1:GTx+ISYE6501x+2T2017+type@asset+block/temps.txt", header = TRUE)

#Crime data file 
crimeData <- read.table("https://d37djvu3ytnwxt.cloudfront.net/assets/courseware/v1/17b85cea5d0e613bf08025ca2907b62f/asset-v1:GTx+ISYE6501x+2T2017+type@asset+block/uscrime.txt", header = TRUE)

#iris data file 
irisData <- iris

#Set seed for reproducibility
set.seed(156)

#Question 1
#Describe a situation or problem from your job, everyday life, current events, etc., for which a clustering model would be appropriate. List some (up to 5) predictors that you might use.
#Problem - classify skill group of customer service agents. Low skill, medium Skill, High Skill. 
#Predictors - AverageHandleTime, Tenure, TrainingDaysCompleted, RepeatCallRate, CustomerSatisfactionScore


# Question 2
# The iris data set contains 150 data points, each with four predictor variables and one categorical response. 
# The predictors are the width and length of the sepal and petal of flowers and the response is the type of flower. 
# The response values are only given to see how well a specific method performed and should not be used to build the model.
# Use the R function kmeans to cluster the points as well as possible. Report the best combination of predictors, your suggested value of k, and how well your best clustering predicts flower type.
# 


#Visualize the dataset:
ggplot(irisData, aes(Petal.Length, Petal.Width, color = Species)) + geom_point()
ggplot(irisData, aes(Sepal.Length, Sepal.Width, color = Species)) + geom_point()

irisCluster <- kmeans(iris[, 3:4], 3, nstart = 20)
irisCluster

table(irisCluster$cluster, iris$Species)

#Plot of results
irisCluster$cluster <- as.factor(irisCluster$cluster)
ggplot(irisData, aes(Petal.Length, Petal.Width, color = irisCluster$cluster)) + geom_point()


# write.csv(tempData, file = 'tempData.csv')
# write.csv(crimeData, file = 'crimeData.csv')


#Question 3 
# test to see whether there is an outlier in the last column 
# (number of crimes per 100,000 people). Is the lowest-crime city an outlier? 
# Is the highest-crime city an outlier? Use the grubbs.test function in the outliers 
# package in R.

#The grubbs test is based on the assumption of normal distributed data. 


outlier(crimeData)

grubbs.test(crimeData$Crime, type = 20)

ggplot(crimeData, aes(Crime)) +
  geom_histogram()


#question 5 - when does summer end? 
tempData <- read_csv("~/GTHomework/tempData.csv", 
                     col_types = cols(X1 = col_skip()))

#Summary of dataset 
summary(tempData)

testTemp <- tempData[,1:2]
testTemp$z_value <- scores(testTemp$X1996, type = 'z')

#stdev of data 
sd(as.matrix(tempData[,2:20]))

q <- cusum(tempData$X1996, decision.interval = 10, se.shift = 2, add.stats = TRUE)



