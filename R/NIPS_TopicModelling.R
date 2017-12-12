#never ever convert strings to factors
options(stringsAsFactors = FALSE)

options(java.parameters="-Xmx2g")   # optional, but more memory for Java helps
# devtools::install_github("agoldst/dfrtopics")
library(dfrtopics)
library(mallet)

removeText = "[^A-za-z0-9+,.;:() ]+"

df = read.csv("NIPS_Abstracts.csv")

df$full_text = ""

for (i in c(1:nrow(df))){
  print(i)
  
  fileName = df$pdf_file[i]
  if (!is.na(fileName)){
    fileName = shQuote(fileName, type = "sh")  
    text = system(paste('pdftotext ', fileName, " -", sep=""), intern=TRUE)
    text = paste(text, collapse = " ")
    text = gsub("\\f", "", text)
    text = gsub("-\n", "", text) # remove hyphenation at new lines
    df$full_text[i] = text 
  }
}



df$SoupText = paste(df$title, df$abstract, df$full_text)
#df$SoupText = paste(df$title, df$keywords, df$abstract)
df$SoupText = gsub(removeText, " ", df$SoupText)
df$title = gsub(removeText, " ", df$title)

# dfr-browser expects seven metadata columns: id,title,author,journaltitle,volume,issue,pubdate,pagerange
df$id = paste0("https://nips.cc/Conferences/2017/Schedule?showEvent=", df$id)
df$journaltitle = "NIPS"
df$volume = ""
df$issue = ""
df$pubdate = as.Date(df$date, origin="1970-01-01")
df$pagerange = ""
df$author = df$authors
df$doi = ""

df = df[which(df$author != ""),]

instance = mallet.import(df$id, df$SoupText, "en.txt")

df = df[,c("id", "title", "author", "journaltitle", "volume", "issue", "pubdate", "pagerange", "doi")]
# authors need to be separated by a tab in order to show up correctly
df$author = gsub(" · ", "\t", df$author)

m <- train_model(instance, n_topics=50, n_iters=10000, metadata=df, threads=8)

dfr_browser(m, out_dir = "./topic-modelling-visualization", internalize = TRUE, browse = FALSE)
