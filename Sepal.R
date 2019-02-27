Sys.setenv(SPARK_HOME = "C:\\Spark\\spark-2.4.0-bin-hadoop2.7\\spark-2.4.0-bin-hadoop2.7")
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"),"R","lib"), .libPaths()))
library(SparkR)
sc<-sparkR.session( master = 'local[*]')
iris$ID<-(1:nrow(iris))
df <- createDataFrame(iris)
df_test <- sample(df,FALSE,0.2)
test_iris <- collect(select(df_test, "ID"))$ID
df$IS_TEST <- df$ID %in% test_iris
df_train <- subset(df, df$IS_TEST==FALSE)
acc<-c()
numt<-c()
n<- 0
for (i in 1: 10){
   
  n <- n+50
  
model <- spark.randomForest(df_train, Sepal_Width ~ Sepal_Length + Petal_Length + Petal_Width + Species, "regression", numTrees = n)
prediction<-predict(model, newData=df_test)
r_df <- collect(prediction)
r_df$prediction = round(abs(r_df$prediction),1)
prediction$prediction = round(abs(prediction$prediction),1)
total_rows <- NROW(prediction)
correct <- NROW(prediction[prediction$prediction == prediction$Sepal_Width])
accuracy <- correct/total_rows
acc<-c(acc,accuracy)
numt<-c(numt,n)
}
prediction
write.df(prediction,path='/C:/Users/shrey_vr/predct')
library(x)
write.df(prediction,path='predct',src='csv')
acc_Chrt<-data.frame(acc,numt)
acc_Chrt
write.csv(acc_Chrt, file = "C:/Users/shrey_vr/Desktop/intern/acc_Chrt.csv")
head(select(prediction, "Sepal_Width", "prediction"))
library(plotly)

p <- plot_ly(data = r_df, x = ~Petal_Width) %>%
   add_markers(y = ~prediction, showlegend = FALSE) %>%
   add_markers(y = ~Sepal_Width,colors = '#07A4B5', showlegend = FALSE) %>%
   add_lines(y = ~fitted(loess(prediction ~ Petal_Width)),
             line = list(color = '#07A4B5'),
             name = "Loess Smoother", showlegend = TRUE) %>%
   layout(xaxis = list(title = 'Petal Width'),
          yaxis = list(title = 'Prediction'))
p

