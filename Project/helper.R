library(shiny)
library(rCharts)
library(reshape2)


temp = read.csv("framingham.csv")
heart = subset(temp, select = -c(education))
model = glm(TenYearCHD ~ ., data = heart, family = binomial)

plotBMI <- function(){

sick = subset(heart, TenYearCHD == 1)
nonSick = subset(heart, TenYearCHD == 0)
sickMean = tapply(sick$BMI, sick$age, mean, na.rm = TRUE)
nonSickMean = tapply(nonSick$BMI, nonSick$age, mean, na.rm = TRUE)

BMISick = as.data.frame(as.matrix(sickMean))
BMINonSick = as.data.frame(as.matrix(nonSickMean[4:39]))
Age = c(seq(35,70))
df_BMI = data.frame(Age, BMISick,BMINonSick)

names(df_BMI)[names(df_BMI)=="V1"] <- "CHD"
names(df_BMI)[names(df_BMI)=="V1.1"] <- "nonCHD"

tmp_m = melt(df_BMI, id = "Age")
nPlot(value ~ Age, group = 'variable', data = tmp_m, type = 'lineChart')
}

