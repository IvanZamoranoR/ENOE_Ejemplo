setwd("/Users/ivanzamorano/Downloads/enoe_2024_trim1_dbf")

install.packages("foreign") #Para exportar e importar datos en diferentes formatos como dbf, csv, dta y spss
install.packages("survey") #Para hacer análisis de datos que han sido obtenidos a partir de muestras complejas, se pueden calcular estimaciones, errores estándar, coeficientes de variación, intervalos de confianza, etc.
library(foreign)
library(survey)

viv <- read.dbf("ENOE_VIVT124.dbf")
hog <- read.dbf("ENOE_HOGT124.dbf")
