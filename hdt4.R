# Instalaci?n de paquetes necesarios para procesar datos:
install.packages("tm")  
install.packages("SnowballC") 
install.packages("wordcloud") 
install.packages("RColorBrewer") 
install.packages("syuzhet") 
install.packages("ggplot2") 
install.packages("readr")

# Importaci?n de paquetes
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library("syuzhet")
library("ggplot2")
library("readr")
# Lectura de datos

# Limpieza y preprocesamiento de datos.
#blogs <- readLines("./en_US/en_US.blogs.txt")
#news <- readLines("./en_US/en_US.news.txt")
#twitter <- readLines("./en_US/en_US.twitter.txt")

get_corpus <- function(dir) {
  return (VCorpus(DirSource(dir, encoding = "UTF-8"), readerControl = list(language = "en")))
}

blogs <- get_corpus("./en_US/blogs")
news <- get_corpus("./en_US/news")
twitter <- get_corpus("./en_US/twitter")

porciento <- 0.05
set.seed(50)
blogs[[1]]$content <- sample(blogs[[1]]$content, length(blogs[[1]]$content)*porciento)
news[[1]]$content <- sample(news[[1]]$content, length(news[[1]]$content)*porciento)
twitter[[1]]$content <- sample(twitter[[1]]$content, length(twitter[[1]]$content)*porciento)


# Funcion para cambiar a un espacio
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))

# Eliminar URLs
# Extraido de: https://stackoverflow.com/questions/41109773/gsub-function-in-tm-package-to-remove-urls-does-not-remove-the-entire-string
#removeURL <- content_transformer(function(x) gsub("(f|ht)tp(s?)://\\S+", "", x, perl=T))
# Extraido de: https://stackoverflow.com/questions/30994194/quotes-and-hyphens-not-removed-by-tm-package-functions-while-cleaning-corpus
#removeSpecialChars <- content_transformer(function(x) gsub(""."","",x))
removeURL <- function(x) gsub("http[[:alnum:]]*", "", x)
removeURL2 <- function(x) gsub("www[[:alnum:]]*", "", x)
removeEmojis <- function(x) gsub("[^\x01-\x7F]", "", x)
### myCorpus <- tm_map(myCorpus, removeURL, lazy=TRUE) 




data_cleaning <- function(corpus) {
  #   - Normalizar Texto -> minuscula/mayuscula
  corpus <- tm_map(corpus, content_transformer(tolower))
  
  corpus <- tm_map(corpus, content_transformer(removeURL))
  corpus <- tm_map(corpus, content_transformer(removeURL2))
  corpus <- tm_map(corpus, content_transformer(removeEmojis))
  #   - Remover signos de puntuacion
  corpus <- tm_map(corpus, removePunctuation)
  
  #   - Remover numeros si no aportan nada.
  corpus <- tm_map(corpus, removeNumbers)
  
  #   - Remover articulos, preposiciones y conjunciones
  corpus <- tm_map(corpus, removeWords, stopwords("english"))
  
  
  
  #   - Remover  caracteres especiales
  corpus <- tm_map(corpus, toSpace, "/")
  corpus <- tm_map(corpus, toSpace, "@")
  corpus <- tm_map(corpus, toSpace, "\\|")
  corpus <- tm_map(corpus, toSpace, "#")
  corpus <- tm_map(corpus, toSpace, "£")
  
  #   - Remover emoticones 
  #   Non Ascii
  #gsub("[^\x01-\x7F]", "", corpus)
  #
  #gsub(""."","",corpus)
  corpus <- tm_map(corpus, toSpace, "'")
  corpus <- tm_map(corpus, toSpace, """)
  corpus <- tm_map(corpus, toSpace, """)
  corpus <- tm_map(corpus, toSpace, "-")
  corpus <- tm_map(corpus, toSpace, ".")
  corpus <- tm_map(corpus, toSpace, "-")
  corpus <- tm_map(corpus, toSpace, "'")
  corpus <- tm_map(corpus, toSpace, "-")
  
  #   - Remover espacios extra
  corpus <- tm_map(corpus, stripWhitespace)
  
  
}

blogs <- data_cleaning(blogs)
news <- data_cleaning(news)
twitter <- data_cleaning(twitter)

term_doc_matrix <- function(corpus){
  # Build a term-document matrix
  tdm <- TermDocumentMatrix(corpus)
  dtm_m <- as.matrix(tdm)
  #Sort by descearing value of frequency
  dtm_v <- sort(rowSums(dtm_m),decreasing=TRUE)
  dtm_d <- data.frame(word = names(dtm_v),freq=dtm_v)
  # Display the top 5 most frequent words
  head(dtm_d, 5)
  
  # palabras mas frecuents
  barplot(dtm_d[1:5,]$freq, las = 2, names.arg = dtm_d[1:5,]$word,
          col ="lightgreen", main ="Top 5 most frequent words",
          ylab = "Word frequencies")
  # nube de palabras
  wordcloud(words = dtm_d$word, freq = dtm_d$freq, min.freq = 5,
            max.words=100, random.order=FALSE, rot.per=0.40, 
            colors=brewer.pal(8, "Dark2"))
}

term_doc_matrix(blogs)
term_doc_matrix(news)
term_doc_matrix(twitter)

writeCorpus(blogs, path = "./CleanData")
writeCorpus(news, path="./CleanData")
writeCorpus(twitter, path="./CleanData")




