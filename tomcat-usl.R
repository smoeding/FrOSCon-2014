# tomcat-usl.R --- Universal Scalability Law

## ---- tomcat-usl-read ----
# Define a vector for the desired column names
columns <- c("ip", "ruser", "auser", "time", "tz", "request",
             "status", "size", "delay")

# Number of clients used in different test runs
clients <- c(1, 2, 4, 8, 16, 32)

# Create empty data frame to store loadtest
loadtest <- data.frame(clients      = as.numeric(),
                        request_rate = as.numeric(),
                        service_time = as.numeric())

for (i in clients) {
  row <- nrow(loadtest)+1

  # Store number of clients used for the test run
  loadtest[row, 'clients'] <- i

  # Generate file name and read data
  fnum <- formatC(i, width=2, format="d", flag="0")
  fnam <- paste0("data/tomcat-", fnum, ".log.gz")
  tomcat <- read.table(file=fnam, col.names=columns)

  tomcat <- within(tomcat, {
    time <- paste(time, tz)
    time <- as.POSIXct(strptime(time, format="[%d/%b/%Y:%H:%M:%S %z]"))
  })

  # Calculate arrival rate [1/sec]
  request_rate <- as.vector(table(tomcat$time))

  # Alternative calculation
  #request_rate <- nrow(tomcat) / as.double(max(tomcat$time) - min(tomcat$time))

  # Calculate service time [ms]
  service_time <- tomcat$delay

  # Store means
  loadtest[row, 'request_rate'] <- mean(request_rate)
  loadtest[row, 'service_time'] <- mean(service_time)
}

# Cleanup
rm(service_time, request_rate, tomcat, fnum, fnam, row, clients)

## ---- tomcat-usl-data ----
print(loadtest)

## ---- tomcat-usl-model ----
library(usl)

loadtest.usl <- usl(request_rate ~ clients, data = loadtest)

## ---- tomcat-usl-coef ----
coef(loadtest.usl)

## ---- tomcat-usl-summary ----
summary(loadtest.usl)

## ---- tomcat-usl-plot-data ----
plot(request_rate ~ clients, data = loadtest, pch = 16)

## ---- tomcat-usl-plot-model ----
plot(request_rate ~ clients, data = loadtest, pch = 16)
plot(loadtest.usl, col = "red", add = TRUE)

## ---- tomcat-usl-scalability ----
scf <- scalability(loadtest.usl)

# Predict throughput for 30, 36 and 40 clients
scf(c(30, 36, 40))

## ---- tomcat-usl-peak ----
peak.scalability(loadtest.usl)
scf(peak.scalability(loadtest.usl))

## ---- tomcat-usl-predict-peak ----
# Assume a smaller sigma
peak.scalability(loadtest.usl, sigma = 0.02)

## ---- tomcat-usl-predict-scalability ----
scf <- scalability(loadtest.usl, sigma = 0.02)

scf(peak.scalability(loadtest.usl, sigma = 0.02))

## ---- tomcat-usl-overhead ----
library(scales)
library(ggplot2)
library(reshape2)

loadtest.time <- data.frame(clients = c(1,4,15,30))

loadtest.time <- within(loadtest.time, {
  appl <- 1 / clients
  contention <- coef(loadtest.usl)[['sigma']] * (clients - 1) / clients
  coherency <- coef(loadtest.usl)[['kappa']] * (1/2) * (clients - 1)
})

loadtest.overhead <- melt(loadtest.time,
                          id.vars = "clients", value.name = "percent",
                          measure.vars = c("appl", "contention", "coherency"))

loadtest.overhead <- within(loadtest.overhead, {
  clients <- factor(clients, levels = rev(loadtest.time$clients))
  overhead <- factor(variable,
                     levels=c("appl", "contention", "coherency"),
                     labels=c("Anwendung", "Contention (sigma)", "Coherency (kappa)"))
})

loadtest.sum <- within(loadtest.time, {total <- coherency+contention+appl})
loadtest.15 <- loadtest.sum[which(loadtest.sum$clients==15), ]
loadtest.30 <- loadtest.sum[which(loadtest.sum$clients==30), ]

loadtest.diff <- loadtest.15[1, 'total'] - loadtest.30[1, 'total']
loadtest.diff <- signif(100 * loadtest.diff, 2)

## ---- tomcat-usl-plot-overhead ----
p <- ggplot(loadtest.overhead, aes(x = clients, y = percent, fill = overhead))
p <- p + geom_bar(position = "stack", stat = "identity")
p <- p + scale_y_continuous(name = "relative Laufzeit", labels = percent)
p <- p + scale_x_discrete(name = "Clients")
p <- p + scale_fill_brewer(name = "Zeitlicher Anteil:", palette = "Set2")
p <- p + ggtitle("Konkrete Zusammensetzung der relativen Laufzeit")
p <- p + theme(legend.title = element_text(),
               legend.position = "bottom",
               plot.title = element_text(face="bold"))
p <- p + coord_flip()

print(p)
