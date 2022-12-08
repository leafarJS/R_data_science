# Importación de datos  
library(tidyverse)

# read_csv() archivo por comas
# read_csv2() archivos por punto y comas
# read_tsv() archivo por tabulador
# read_delim() cualquier archivo delimitador
# read_fwf() archivos de ancho fijo
# read_table() archivos de ancho fijo y columnas separadas en blanco
# read_log() archivos tipo apache

# LLAMAR A UN ARCHIVO DE UNA RUTA ESPECIFICA
data <- read_csv("database/horror_movie_0.csv")

#CREAR ARCHIVOS CSV
read_csv(
"a,b,c
1,2,3
4,5,6")

#NAME COLUMN AND METADATA
read_csv("The first line of metadata
  The second line of metadata
  x,y,z
  1,2,3", skip = 2)

# COMENTARIOS EN EL ARCHIVO
read_csv("# A comment I want to skip
  x,y,z
  1,2,3", comment = "#")

# ARCHIVOS SIN NOMBRE DE COLUMNA
read_csv("1,2,3\n4,5,6", col_names = FALSE)

# PASAR NOMBRES A LAS COLUMNAS 
read_csv("1,2,3\n4,5,6", col_names = c("x", "y", "z"))

#DATOS FALTANTES 
read_csv("a,b,c\n1,2,.", na = ".")


# ANALISIS 
#read_csv("a,b\n1,2,3\n4,5,6") # NO TEMIA LA MISMA DIMENSION
read_csv("a,b,.\n1,2,3\n4,5,6", na =".")

#read_csv("a,b,c\n1,2\n1,2,3,4") # NO TIENE LA MISMA DIMENSION
read_csv("a,b,c,d\n1,2,.,.\n1,2,3,4", na = ".")

#read_csv("a,b\n\"1") # ERROR EN SINTAXIS
read_csv("a,b\n\1,.", na = ".")

#read_csv("a,b\n1,2\na,b") # NO TIENE ERROR
read_csv("a,b\n1,2\na,b")

#read_csv("a;b\n1;3") NO ERA EL FORMATO ADECUDO
read_csv2("a;b\n1;3")



# Analizando un vector

str(parse_logical(c("TRUE", "FALSE", "NA")))
str(parse_integer(c("1", "2", "3")))
str(parse_date(c("2010-01-01", "1977-03-02")))

#informa de fallas en la conversión si un dato no concuerda
x <- parse_integer(c("123", "345", "abc", "123.45"))

problems(x)

# analizadores importantes 
parse_double()
parse_number()
parse_character()
parse_factor()
parse-datetime()
parse_date()
parse_time()
parse_logical()
parse_integer()

# numeros 
parse_double("1,23")# error

parse_double("1,23", locale = locale(decimal_mark = ","))


parse_number("$100")

parse_number("20%")

parse_number("el costo es $123.45")

parse_number("$123,456,789")

parse_number("123.456.789", locale = locale(grouping_mark = "."))

parse_number("123'456'789", locale = locale(grouping_mark = "'"))

#cadenas

charToRaw("jorge")


x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"

parse_character(x1, locale = locale(encoding = "Latin1"))

parse_character(x2, locale = locale(encoding = "Shift-JIS"))

# ayuda para saber el tipo de codificación 

guess_encoding(charToRaw(x1))

guess_encoding(charToRaw(x2))


# factores

x <- c("apple", "banana", "orange")
parse_factor(c("apple", "banana", "bananana"), levels = fruit)
# se debe ser cuidadoso con su tratamiento 

# fechas, fechas-horas y horas
parse_datetime("2010-10-01T2010")
# Si se omite la hora, se establecerá en la medianoche.
parse_datetime("20101010")

# para trabajar con horas y fechas https://en.wikipedia.org/wiki/ISO_8601

parse_date("2010-10-01")

parse_time("01:10 am")

parse_time("20:10:01")

# Año
# %Y(4 dígitos).
# %y(2 dígitos); 00-69 -> 2000-2069, 70-99 -> 1970-1999.
# Mes
# %m(2 dígitos).
# %b(nombre abreviado, como “Jan”).
# %B(nombre completo, “enero”).
# Día
# %d(2 dígitos).
# %e(espacio inicial opcional).
# Tiempo
# %H0-23 horas.
# %I0-12, debe usarse con %p.
# %pIndicador AM/PM.
# %Mminutos.
# %Ssegundos enteros.
# %OSsegundos reales.
# %ZZona horaria (como nombre, por ejemplo  America/Chicago). Tenga cuidado con las abreviaturas: si es estadounidense, tenga en cuenta que "EST" es una zona horaria canadiense que no tiene horario de verano. ¡ No es la hora estándar del Este! Volveremos a estas zonas horarias .
# %z(como compensación de UTC, por ejemplo  +0800).
# no dígitos
# %.salta un carácter que no sea un dígito.
# %*salta cualquier número de no dígitos.

parse_date("01/02/15", "%m/%d/%y")
parse_date("77/03/02", "%y/%m/%d")
parse_date("1 janvier 2015", "%d %B %Y", locale = locale("fr"))

#readr averigua el tipo de dato que se tiene 
guess_parser("2010-10-01") #> [1] "date"
guess_parser("15:01") #> [1] "time"
guess_parser(c("TRUE", "FALSE")) #> [1] "logical"
guess_parser(c("1", "5", "9")) #> [1] "double"
guess_parser(c("12,352,561")) #> [1] "number"
str(parse_guess("2010-10-10"))#>  Date[1:1], format: "2010-10-10"


challenge <- read_csv(readr_example("challenge.csv"));challenge
problems(challenge)
head(challenge)
tail(challenge)

challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_date()
  )
)
head(challenge)
tail(challenge)


challenge <- read_csv(readr_example("challenge.csv"), guess_max = 1001)
head(challenge)
tail(challenge)


challenge <- read_csv(readr_example("challenge.csv"), 
                       col_types = cols(.default = col_character())
)
challenge

# Escribir en un archivo

write_rds(challenge, "challenge.rds")
read_rds("challenge.rds")


#lenguaje binario de programación 

#install.packages("feather")
library(feather)

write_feather(challenge, "challenge.feather")
read_feather("challenge.feather")
