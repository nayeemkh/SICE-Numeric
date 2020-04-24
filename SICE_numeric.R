# R Code for SICE-Numeric Algorithm

library(modeest)
library(mice)
library(dplyr)
library(BAS)


#taking input
data <- read.csv("kc_house_data.csv")


#keeping a copy of the original data
original <- data


#inserting NA values
data[sample(1:nrow(data), 2164), "price"] <- NA
sapply(data, function(x) sum(is.na(x)))


#calculating index of the missing data
na_index=which(is.na(data$price),arr.ind = TRUE)


#calculating original values of the missing data
original_values<-(original$price[na_index])


#mice algorithm
start <- Sys.time()
miceResult <- mice(data,m=7,maxit = 5,method = "norm")
end <- Sys.time()
mice_ex_time <- end - start


#mice Result
imputedPMM <- miceResult$imp$price
print(imputedPMM)



#SICE algorithm

#empty vector to store the data of each row of miceResult
singleRowSample <- vector()

#empty vector to store the SICE result
modedValCart <- vector()

for(i in 1:nrow(imputedPMM)){
  singleRowSample <- as.vector(imputedPMM[i,1:7])
  singleRowSample <- unlist(singleRowSample)
  modedSampleMOdel<- median(singleRowSample)
  modedValCart[[i]] <- modedSampleMOdel
}
print(modedValCart)

end <- Sys.time()
SICE_ex_time <-end - start


#RMSE function
RMSE = function(m, o){
  sqrt(mean((m - o)^2))
}


#measuring mice rmse
mice_rmse <- vector()
for(i in 1:ncol(imputedPMM))
{
  mice_res<-vector()
  mice_res<-imputedPMM[,i]
  
  rmse1 <- sqrt(mean((original_values - mice_res)^2))
  mice_rmse <<- c(mice_rmse, rmse1)
}


#SICE predicted values
predicted <- modedValCart


#measuring SICE rmse
SICE_rmse <- RMSE(original_values, predicted)




print("RMSE after 7 mice imputations: ")
print(mean(mice_rmse))
print(mice_ex_time)

print("RMSE after using SICE algorithm")
print(SICE_rmse)
print(SICE_ex_time)
