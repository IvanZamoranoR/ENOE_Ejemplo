#Definimos directorio, descargamos ENOE más reciente de la página del INEGI 
setwd("/Users/ivanzamorano/Downloads/enoe_2024_trim1_dbf")

install.packages("foreign") #Para exportar e importar datos en diferentes formatos como dbf, csv, dta y spss
install.packages("survey") #Para hacer análisis de datos que han sido obtenidos a partir de muestras complejas, se pueden calcular estimaciones, errores estándar, coeficientes de variación, intervalos de confianza, etc.
#Para Encuestas 
library(foreign)
library(survey)
library(tidyverse)


#Para geoespacial

library(raster)
library(ggspatial)


viv <- read.dbf("ENOE_VIVT124.dbf")
hog <- read.dbf("ENOE_HOGT124.dbf")
sdem <- read.dbf("ENOE_SDEMT124.dbf")
coe1 <- read.dbf("ENOE_COE1T124.dbf")
coe2 <- read.dbf("ENOE_COE2T124.dbf")


#Cálculo de la población total.
#El criterio para identificar a la población total es considerar a todos los residentes con entrevista completa y que sean residentes de la vivienda.
#Lo anterior se traduce como (R_DEF =00 y (C_RES =1 o C_RES=3))

#Crearemos la variable para identificar a la población total y se aplica el ponderador: 
#La función apply permite aplicar funciones o subconjuntos de datos de un data frame o vectores
sdem$PT <- ifelse(sdem$R_DEF%in%"00" &sdem$C_RES%in%c("1","3"),1,0)
tapply(sdem$FAC_TRI,sdem$PT,sum)

#Cálculo de la población total usando survey
#Diseño muestral 
disenio <- svydesign(id = ~UPM, strata = ~EST_D_TRI, weights = ~FAC_TRI, data = sdem, nest=TRUE )

#Cálculo de estimación de la población total 
PTotal <- svytotal(~PT, disenio)

#Visualización de estimación puntual y su error estándar 
PTotal 
est_ee <- data.frame(PTotal)
est_ee

#Cálculo de precisiones de la población total usando survey: 

resultados <- cbind(est_ee[1],round(100*cv(PTotal),3), round(SE(PTotal),0),
                    round(est_ee[1]-(est_ee[2]*1.645),0), round(est_ee[1]+(est_ee[2]*1.645),0))
colnames(resultados) <- c("Estimación", "cv(%)", "ee", "LIIC", "LSIC")

#Visualización final de estimaciones, cv, ee, e intervalos de confianza al 90%
resultados

