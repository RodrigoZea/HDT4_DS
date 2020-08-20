# Instalación de paquetes necesarios para procesar datos:
install.packages("tm")
install.packages("wordcloud")
install.packages("quanteda")
install.packages("tidyr")

# Importación de paquetes
library(tm)
library(wordcloud)
library(quanteda)
library(tidyr)
library(ggplot2)

# Lectura de datos

# Limpieza y preprocesamiento de datos.
#   - Normalizar Texto -> minuscula/mayuscula
#   - Remover  caracteres especiales
#   - Remover  URLs
#   - Remover emoticones
#   - Remover signos de puntuacion
#   - Remover articulos, preposiciones y conjunciones
#   - Remover numeros si no aportan nada.