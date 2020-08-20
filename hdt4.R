# Instalación de paquetes necesarios para procesar datos:
install.packages("tm")  
install.packages("SnowballC") 
install.packages("wordcloud") 
install.packages("RColorBrewer") 
install.packages("syuzhet") 
install.packages("ggplot2") 
install.packages("readr")

# Importación de paquetes
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library("syuzhet")
library("ggplot2")
library("readr")
# Lectura de datos

# Limpieza y preprocesamiento de datos.
blogs <- readLines("./en_US/en_US.blogs.txt")
news <- readLines("./en_US/en_US.news.txt")
twitter <- readLines("./en_US/en_US.twitter.txt")

# Corpus
BlogTXT <- VCorpus(blogs)
NewsTXT <- VCorpus(news)
TwitterTXT <- VCorpus(twitter)

# Corpus division
BlogTXT$content<-sample(BlogTXT$content, length(BlogTXT$content)*0.05)
NewsTXT$content<-sample(NewsTXT$content, length(NewsTXT$content)*0.05)
TwitterTXT$content<-sample(TwitterTXT$content, length(TwitterTXT$content)*0.05)

# Funcion para cambiar a un espacio
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))

# Eliminar URLs
# Extraido de: https://stackoverflow.com/questions/41109773/gsub-function-in-tm-package-to-remove-urls-does-not-remove-the-entire-string
removeURL <- content_transformer(function(x) gsub("(f|ht)tp(s?)://\\S+", "", x, perl=T))



data_cleaning <- function(corpus) {
  #   - Normalizar Texto -> minuscula/mayuscula
  corpus <- tm_map(corpus, content_transformer(tolower))
  
  #   - Remover  caracteres especiales
  corpus <- tm_map(corpus, toSpace, "/")
  corpus <- tm_map(corpus, toSpace, "@")
  corpus <- tm_map(corpus, toSpace, "\\|")
  corpus <- tm_map(corpus, toSpace, "#")
  
  #   - Remover emoticones 
  #   Non Ascii
  gsub("[^\x01-\x7F]", "", corpus)
  
  #   - Remover signos de puntuacion
  corpus <- tm_map(corpus, removePunctuation)
  
  #   - Remover numeros si no aportan nada.
  corpus <- tm_map(corpus, removeNumbers)
  
  #   - Remover articulos, preposiciones y conjunciones
  corpus <- tm_map(corpus, removeWords, stopwords("english"))
  
  #   - Remover espacios extra
  corpus <- tm_map(corpus, stripWhitespace)
}

# Data cleaning for all 3 corpuses
data_cleaning(BlogTXT)
data_cleaning(NewsTXT)
data_cleaning(TwitterTXT)

inspect(BlogTXT)

# Build a term-document matrix
BlogTXT_dtm <- DocumentTermMatrix(BlogTXT)
dtm_m <- as.matrix(BlogTXT_dtm)
# Sort by descearing value of frequency
dtm_v <- sort(rowSums(dtm_m),decreasing=TRUE)
dtm_d <- data.frame(word = names(dtm_v),freq=dtm_v)
# Display the top 5 most frequent words
head(dtm_d, 5)

# Build a term-document matrix
#TextDoc_dtm <- TermDocumentMatrix(BlogTXT)
#dtm_m <- as.matrix(TextDoc_dtm)
# Sort by descearing value of frequency
#dtm_v <- sort(rowSums(dtm_m),decreasing=TRUE)
#dtm_d <- data.frame(word = names(dtm_v),freq=dtm_v)
# Display the top 5 most frequent words
#head(dtm_d, 5)







