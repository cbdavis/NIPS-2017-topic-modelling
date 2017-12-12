library(tidyverse)
library(rvest)
library(httr)
library(lubridate)

dir.create("data")

baseURL = "https://nips.cc/Conferences/2017/Schedule"

nips <- html(baseURL)

item_ids = nips %>% 
  html_nodes(xpath="//div[@id[starts-with(., 'maincard')]]") %>% 
  html_attr("id") %>% unique() %>% setdiff(c("maincard_None", "maincardContainer")) %>% 
  as.character()

item_ids = gsub("maincard_", "", item_ids)

allData = c()
for (item_id in item_ids){
  print(item_id)
  url = paste0("https://nips.cc/Conferences/2017/Schedule?showEvent=", item_id)
  dl_file = paste0("./data/", item_id, ".html")
  if (!file.exists(dl_file)){
    download.file(url, destfile=dl_file)  
  }
  
  title = read_html(dl_file) %>% html_node(xpath="//div[@class='maincardBody']") %>% html_text()
  abstract = read_html(dl_file) %>% html_node(xpath="//div[@class='abstractContainer']") %>% html_text()
  authors = read_html(dl_file) %>% html_node(xpath="//div[@class='maincardFooter']") %>% html_text()
  date = read_html(dl_file) %>% html_node(xpath="//div[@class='maincardHeader']") %>% html_text()
  
  dateComponents = strsplit(date, " ")[[1]][1:3]
  dateComponents[3] = gsub("[a-z]", "", dateComponents[3])
  date = paste(c(dateComponents, "2017"), collapse=" ")
  date = as.Date(date, format="%a %b %d %Y")
  
  paper_url = read_html(dl_file) %>% html_node(xpath="//a[@class='btn btn-default btn-xs href_PDF']") %>% html_attr("href")
  
  pdf_file = NA
  
  if (!is.na(paper_url)){
    tmp = GET(paper_url)
    if (tmp$status_code != 404){
      pdf_url = paste0(tmp$url, ".pdf")
      pdf_file = paste0("./data/", tail(strsplit(pdf_url, "/")[[1]], 1))
      
      # get the pdf of the paper if it exists
      if (!file.exists(pdf_file)){
        print(pdf_file)
        download.file(pdf_url, destfile=pdf_file)
      }
    }
  }
  allData = rbind(allData, c(item_id, date, title, authors, abstract, paper_url, pdf_file))
}

allData = as.data.frame(allData)
colnames(allData) = c("id", "date", "title", "authors", "abstract", "paper_url", "pdf_file")

write.csv(allData, "NIPS_Abstracts.csv", row.names = FALSE)
