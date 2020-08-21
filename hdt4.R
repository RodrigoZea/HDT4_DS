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
BlogTXT <- VCorpus(blogs, readerControl = list(language = "en"))

get_corpus <- function(dir) {
  return (VCorpus(DirSource(dir, encoding = "UTF-8"), readerControl = list(language = "en")))
}
blogs <- get_corpus("./en_US/blogs")
porciento <- 0.05
set.seed(50)
blogs[[1]]$content <- sample(blogs[[1]]$content, length(blogs[[1]]$content)*porciento)


# Funcion para cambiar a un espacio
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))

#   - Normalizar Texto -> minuscula/mayuscula
blogs[[1]]$content <- tm_map(blogs[[1]]$content, content_transformer(tolower))

#   - Remover  caracteres especiales
BlogTXT <- tm_map(BlogTXT, toSpace, "/")
BlogTXT <- tm_map(BlogTXT, toSpace, "@")
BlogTXT <- tm_map(BlogTXT, toSpace, "\\|")
BlogTXT <- tm_map(BlogTXT, toSpace, "#")

#   - Remover  URLs

#   - Remover emoticones

#   - Remover signos de puntuacion
BlogTXT <- tm_map(BlogTXT, removePunctuation)

#   - Remover numeros si no aportan nada.
BlogTXT <- tm_map(BlogTXT, removeNumbers)

#   - Remover articulos, preposiciones y conjunciones
BlogTXT <- tm_map(BlogTXT, removeWords, stopwords("english"))

BlogTXT <- tm_map(BlogTXT, stemDocument)

#   - Remover espacios extra
BlogTXT <- tm_map(BlogTXT, stripWhitespace)


# Build a term-document matrix
hola <- TermDocumentMatrix(blogs)
dtm_m <- as.matrix(hola)
#Sort by descearing value of frequency
dtm_v <- sort(rowSums(dtm_m),decreasing=TRUE)
dtm_d <- data.frame(word = names(dtm_v),freq=dtm_v)
# Display the top 5 most frequent words
head(dtm_d, 5)






