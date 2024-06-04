message('Loading Packages')
library(rvest)
library(tidyverse)
library(mongolite)

message('Scraping Data')

# URL halaman WEb BNPB Data Bencana
url <- "https://dibi.bnpb.go.id/xdibi2?tb=1"
page <- read_html(url)

titles <- page %>% html_nodes(xpath = "//a[@data-toggle='popover']") %>% html_text()
dates <- page %>% html_nodes(xpath = "//small[@class='date text-danger']") %>% html_text()
bodypage <- page %>% html_nodes(xpath = "//div[@class='d-flex flex-row']") %>% html_text()
links <- page %>% html_nodes(xpath = "//a[@data-toggle='popover']") %>% html_attr("href")

data <- data.frame(
  time_scraped = Sys.time(),
  titles = head(titles, ),
  dates = head(dates, ),
  bodypage = head(bodypage, ),
  links = head(links, ),
  stringsAsFactors = FALSE
)

# MONGODB
message('Input Data to MongoDB Atlas')

# Connection String dari MongoDB Atlas
conn_string <- Sys.getenv("ATLAS_URL")

# Membuka koneksi ke MongoD Atlas
atlas_conn <- mongo(
  collection = Sys.getenv("ATLAS_COLLECTION"),
  db = Sys.getenv("ATLAS_DB"),
  url = conn_string
)

# Input Data ke MongoDB Atlas
atlas_conn$insert(data)

# Menutup koneksi 
rm(atlas_conn)

message('Scraping and Data Insertion Completed Successfully')
