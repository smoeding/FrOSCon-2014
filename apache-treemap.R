# apache-treemap.R --- Generate a treemap for Apache usage

## ---- apache-treemap-load ----
# Define a vector for the column names
cols <- c("time", "vhost", "method", "url", "query", "mimetype",
          "status", "data_bytes", "resp_bytes", "microsec")

# Load data
apache <- read.table(file = "data/apache_access.log.gz",
                     col.names = cols)

## ---- apache-treemap-cleanup ----
apache <- within(apache, {
  # Change existing attributes
  time     <- as.POSIXct(strptime(time, "%Y-%m-%d %H:%M:%S"))
  vhost    <- factor(sub("\\..*$", "", vhost))
  method   <- factor(method)
  # Create new attributes
  millisec <- as.numeric(microsec)/1000
  count    <- 1
  # Remove unused attributes
  rm(url, query, status, data_bytes, resp_bytes, mimetype)
})

## ---- apache-treemap-tail ----
tail(apache)

## ---- apache-treemap-plot ----
library(treemap)

treemap(apache, index = c("vhost", "method"), type = "value",
        vSize = "millisec", vColor = "count", palette = "Spectral",
        title = "Nutzung pro vhost", ymod.labels = c(-0.18, 0))
