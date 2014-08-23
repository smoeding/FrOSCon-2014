# tomcat-analyze.R --- Analyze Tomcat access log

## ---- tomcat-analyze-read ----
# Load data from file
tomcat <- read.table(file = "data/tomcat-01.log.gz")
## ---- tomcat-analyze-names ----
names(tomcat) <- c("ip", "rusr", "ausr", "time", "tz", "request",
                   "status", "size", "service_time")

## ---- tomcat-analyze-str ----
str(tomcat)

## ---- tomcat-analyze-summary ----
summary(tomcat$service_time)

## ---- tomcat-analyze-range ----
range(tomcat$service_time)

## ---- tomcat-analyze-mean ----
mean(tomcat$service_time)

## ---- tomcat-analyze-median ----
median(tomcat$service_time)

## ---- tomcat-analyze-iqr ----
IQR(tomcat$service_time)

## ---- tomcat-analyze-quantile ----
quantile(tomcat$service_time, probs = 0.99)

## ---- tomcat-analyze-stem ----
stem(tomcat$service_time, scale = 0.5, width = 70)

## ---- tomcat-analyze-hist ----
hist(tomcat$service_time, xlab = "Service Time [ms]", col = "cyan3")

## ---- tomcat-analyze-boxplot ----
boxplot(tomcat$service_time, horizontal = TRUE, col = "forestgreen")

## ---- tomcat-analyze-stripchart ----
stripchart(tomcat$service_time, method = "stack", ylim = c(0, 30),
           xlab = "Service Time [ms]", ylab = "Anzahl", pch = 16)
