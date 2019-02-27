Sys.setenv(SPARK_HOME = "C:\\Spark\\spark-2.4.0-bin-hadoop2.7\\spark-2.4.0-bin-hadoop2.7")
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"),"R","lib"), .libPaths()))
library(SparkR)

sc<-sparkR.session( master = 'local[*]')
print("Please enter row id:")
input<-readline()
sdf<-read.df(sc,"/C:/Users/shrey_vr/Desktop/intern/predct","csv")
colnames(sdf) <- c("Sepal_Length", "Sepal_Width", "Petal_Length", "Petal_Width", "Species", "ID", "label", "prediction")
sepal_width <- head(select(filter(sdf, sdf$ID == input), "Sepal_Width"))
sepal_width
