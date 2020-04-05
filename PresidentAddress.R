# Bykov's R - President Address
# Developed with help from https://www.r-bloggers.com/using-text-mining-to-find-out-what-rdatamining-tweets-are-about/
# Source 0 1994 https://ru.wikisource.org/wiki/%D0%9F%D0%BE%D1%81%D0%BB%D0%B0%D0%BD%D0%B8%D0%B5_%D0%9F%D1%80%D0%B5%D0%B7%D0%B8%D0%B4%D0%B5%D0%BD%D1%82%D0%B0_%D0%A4%D0%B5%D0%B4%D0%B5%D1%80%D0%B0%D0%BB%D1%8C%D0%BD%D0%BE%D0%BC%D1%83_%D1%81%D0%BE%D0%B1%D1%80%D0%B0%D0%BD%D0%B8%D1%8E_(1994) 
# Source 1 Annual Address to the Federal Assembly of the Russian Federation 2000 http://en.kremlin.ru/events/president/transcripts/21480
# Source 2 Address to the Federal Assembly of the Russian Federation 2008 http://en.kremlin.ru/events/president/transcripts/1968
# Source 3 Presidential Address to the Federal Assembly 2018 http://en.kremlin.ru/events/president/news/56957

# Check your working directory
getwd()
# If necessary, set your working directory
# setwd("/home/...")

# If necessary, install packages
install.packages("NLP")
install.packages("tm")
install.packages("SnowballC")
install.packages("RColorBrewer")
install.packages("wordcloud")

# Load package packages in operating memory
library("NLP")
library("tm")
library("SnowballC")
library("RColorBrewer")
library("wordcloud")

# Check if the package has been loaded
search()

# build a corpus, which is a collection of text documents
putin <- Corpus(DirSource("~/Putin2000/"))
# VectorSource specifies that the source is character vectors
myCorpus <- Corpus(VectorSource(putin))

# Replacespecial characters from the text with space
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
myCorpus <- tm_map(myCorpus, toSpace, "/")
myCorpus <- tm_map(myCorpus, toSpace, "@")
myCorpus <- tm_map(myCorpus, toSpace, "\\|")

# Clean the text
# Set lower case
myCorpus <- tm_map(myCorpus, tolower)
# Remove english common stopwords
myCorpus <- tm_map(myCorpus, removeWords, stopwords("english"))
# Remove punctuations
myCorpus <- tm_map(myCorpus, removePunctuation)
# Eliminate extra white spaces
myCorpus <- tm_map(myCorpus, stripWhitespace)

# Text stemming
myCorpus <- tm_map(myCorpus, stemDocument)

# Build a term-document matrix with function TermDocumentMatrix()
myDtm <- TermDocumentMatrix(myCorpus, control = list(minWordLength = 1))
m <- as.matrix(myDtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)

# Generate the Word cloud with 'wordcloud'
set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))