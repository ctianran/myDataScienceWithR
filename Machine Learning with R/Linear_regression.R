library(ggplot2)
library(ggthemes)
library(dplyr)
library(corrgram)
library(corrplot)
library(caTools)

###*understand the data*
# load the data
df <- read.csv('student-mat.csv', sep=';')
# Grab only numeric columns
num.cols <- sapply(df, is.numeric)

# filter to numeric columns for correlation
cor.data <- cor(df[,num.cols])
print(cor.data)

corrplot(cor.data, method='color')
corrgram(df, order=TRUE, lower.panel=panel.shade,
         upper.panel=panel.pie, text.panel=panel.txt)

ggplot(df, aes(x=G3)) + geom_histogram(bins=20, alpha=0.5, fill='blue') + theme_minimal()


###*building a Model*
set.seed(101)
# split up sample
sample <- sample.split(df$G3, SplitRatio = 0.7)
#train data
train <- subset(df, sample == TRUE)
#test data
test <- subset(df, sample == FALSE)

#train and build model
model <- lm(G3 ~ ., data = train)

summary(model)

###*Visualize the Model*

# Grab residuals
res <- residuals(model)

# Convert to DataFrame for ggplot
res <- as.data.frame(res)

#head(res)

ggplot(res, aes(res)) + geom_histogram(fill='blue', alpha=0.5)

plot(model)

###*Predictions*
G3.predictions <- predict(model, data=test)

results <- cbind(G3.predictions, test$G3)
colnames(results) <- c('predicted', 'actual')
results <- as.data.frame(results)

# take care of negative values
to_zero <- function(x) {
  if(x < 0) {
    return(0)
  } else {
    return(x)
  }
}

# apply zero function
results$predicted <- sapply(results$predicted, to_zero)

## MEAN SQUARED ERROR
mse <- mean((results$actual - results$predicted)^2)
print(paste("MSE: ", mse))

## RMSE
print(paste("Squared Root OF MSE: ", mse^0.5))

## SSE
SSE <- sum((results$predicted - results$actual)^2)
print(paste("Sum OF Squared Error: ", SSE))

## SST
SST <- sum((mean(df$G3) - results$actual)^2)
print(paste("Sum OF Squared Total: ", SST))

## Calculate R2
R2 <- 1 - SSE/SST
print(paste("R2: ", R2))
