# Instalación de paquetes necesarios para procesar datos:
install.packages("tm")
install.packages("wordcloud")
install.packages("quanteda")
install.packages("tidyr")
install.packages("readr")

# Importación de paquetes
library(tm)
library(wordcloud)
library(quanteda)
library(tidyr)
library(ggplot2)
library("readr")
# Lectura de datos

# Limpieza y preprocesamiento de datos.
#   - Normalizar Texto -> minuscula/mayuscula
#   - Remover  caracteres especiales
#   - Remover  URLs
#   - Remover emoticones
#   - Remover signos de puntuacion
#   - Remover articulos, preposiciones y conjunciones
#   - Remover numeros si no aportan nada.
# my_data <- read.delim("./en_US/en_US.blogs.txt")
blogs <- read_tsv("./en_US/en_US.blogs.txt")
news <- read_tsv("./en_US/en_US.news.txt")
twitter <- read_tsv("./en_US/en_US.twitter.txt")
#texto <-removePunctuation(texto)
#str_replace_all(texto, "[^[:alnum:]]", " ")
