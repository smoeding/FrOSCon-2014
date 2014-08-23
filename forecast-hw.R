# forecast-hw.R --- Estimate Holt-Winters parameters

## ---- forecast-prepare ----
web <- read.csv(file = "data/apache_requests.csv.gz", header = TRUE)

## ---- forecast-subset ----

web$time <- as.POSIXct(strptime(web$time, "%m/%d/%Y %H:%M:%S"))

# Remove value from data that we want to use for testing the forecast
web <- subset(web,
              time >= strptime("2014-01-13", "%Y-%m-%d") &
              time <  strptime("2014-01-19", "%Y-%m-%d"))

## ---- forecast-head ----
head(web)

## ---- forecast-ts ----
web.ts <- ts(web$requests_p_sec, frequency = 86400 / 10)

## ---- forecast-hw ----
hw <- HoltWinters(web.ts)

c(hw$alpha, hw$beta, hw$gamma)
