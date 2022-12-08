# Datos Ordenados 
library(tidyverse)

# Cada variable debe tener su propia columna.
# Cada observación debe tener su propia fila.
# Cada valor debe tener su propia celda.

# Hay una ventaja general en elegir una forma consistente de almacenar datos.
# Si tiene una estructura de datos consistente, es más fácil aprender las
# herramientas que funcionan con ella porque tienen una uniformidad subyacente.

# Hay una ventaja específica en colocar variables en columnas porque permite que
# brille la naturaleza vectorizada de R. Como aprendió en las funciones de mutación
# y resumen , la mayoría de las funciones integradas de R funcionan con vectores
# de valores. Eso hace que la transformación de datos ordenados se sienta 
# particularmente natural.

table1 <- data.frame(
  country = c("Afghanistan","Afghanistan","Brasil","Brasil","China","China"),
  year = c(1999,2000,1999,2000,1999,2000),
  casos = c(745,2666,37737,80488,212258,213766),
  poblacion = c(19987071,20595360,172006362,174504898,1272915272,1280428583)
)

table1 %>% 
  mutate(rate =  round(casos / poblacion * 10000,2) )

table1 %>%
  count(year, casos)

table1 %>%
  count(year, wt = casos)

table1 %>% 
  ggplot(aes(
    year,
    casos,
    group = country,
    color = year
  ))+
  geom_line()+
  scale_x_continuous(breaks = c(1999,2000))+
  geom_point()+
  theme_minimal()+
  theme(legend.position = "none")


# Pivotar 

# La mayoría de las personas no están familiarizadas con los principios de los 
# datos ordenados, y es difícil derivarlos usted mismo a menos que pase mucho 
# tiempo trabajando con datos.
#
# Los datos a menudo se organizan para facilitar algún uso que no sea el análisis.
# Por ejemplo, los datos a menudo se organizan para que la entrada sea lo más 
# fácil posible.

# Una variable puede estar distribuida en varias columnas?
 
# Una observación puede estar dispersa en varias filas?


#longer

table2 <- tibble(
  country = c("Afghanistan", "Brasil", "China"),
  `1999` = c(745,37737,212258),
  `2000` = c(2666,80488,213766)
)

table2.1 <-table2 %>% 
  pivot_longer(c(`1999`,`2000`), names_to = "periodo", values_to = "casos")


table3 <- tibble(
  country = c("Afghanistan", "Brasil", "China"),
  `1999` = c(199987074,172006362,127915272),
  `2000` = c(20595360,174504898,1280428583)
)

table3.1 <- table3 %>% 
  pivot_longer(c(`1999`,`2000`), names_to = "periodo", values_to = "poblacion")

left_join(table2.1, table3.1)

# wider
  
table4 <- tibble(
  country = c("afganistan", "afganistan", "afganistan", "afganistan", "brasil", "brasil"),
  periodo = c(1999,1999,2000,2000,1999,1999),
  tipo = c("casos", "población","casos", "población","casos", "población"),
  total = c(745,19987071,2666,20595360,37773,172006362)
)

table4.1 <- table4 %>% 
  pivot_wider(names_from = tipo, values_from = total)


stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)

stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(`2015`:`2016`, names_to = "year", values_to = "return")


people <- tribble(
  ~name,             ~names,  ~values,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)
people %>% 
  pivot_wider(names_from =names, values_from = values) %>% 
  view()


preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)

preg %>% 
  pivot_longer(c("male", "female"),names_to = "sexo", values_to = "values") %>% 
  view()

# separar y unir


#separar
tabla <- tibble(
  country = c("Afghanistan","Afghanistan","Brasil","Brasil","China","China"),
  year = c(1999,2000,1999,2000,1999,2000),
  ratio = c("745/19987071","2666/20595360","37737/172006362","80488/174504898","212258/1272915272","213766/1280428583")
  )


tabla %>% 
  separate(ratio, into = c("casos", "poblacion"), sep = "/")
#resultado casos y población son de tipo character

tabla.1 <- tabla %>% 
  separate(year,
           into = c("centuria", "periodo"),
           sep = 2) %>% 
  separate(ratio,
           into = c("casos", "poblacion"),
           sep = "/",
           convert = TRUE)


# unir 
tabla.1 %>% 
  unite(new, centuria, periodo)

tabla.1 %>% 
  unite(new, centuria, periodo, sep = "")


# valores faltantes

# Explícitamente , es decir, marcado con NA.
# Implícitamente , es decir, simplemente no está presente en los datos.

stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)

# Falta explícitamente el rendimiento del cuarto trimestre de 2015, porque la celda
# donde debería estar su valor contiene NA.
 
# Implícitamente falta el rendimiento del primer trimestre de 2016, porque simplemente 
# no aparece en el conjunto de datos.

stocks %>% 
  pivot_wider(names_from = year, values_from = return)



stocks %>% 
  pivot_wider(names_from = year, 
              values_from = return) %>% 
  pivot_longer(cols = c(`2015`, `2016`),
               names_to = "year",
               values_to = "return", 
               values_drop_na = TRUE)
  
# complete()toma un conjunto de columnas y encuentra todas las combinaciones únicas.
stocks %>% 
  complete(year, qtr)


# fill(). Toma un conjunto de columnas en las que desea que los valores faltantes
# se reemplacen por el valor no faltante más reciente (a veces llamado última observación transferida).

treatment <- tribble(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4
)

treatment %>% 
  fill(person)


# Ejercicio estudio de caso tuberculosis
tidyr::who

data(who)
str(who)
dim(who)
head(who)
print(who)
tail(who)
view(who)

new_who <- who %>% 
  pivot_longer(
    cols = starts_with("new"),
    names_to = "key",
    values_to = "cases",
    values_drop_na = TRUE
  ) 

new_who %>% 
  group_by(country, year) %>% 
  mutate(percent = cases / sum(cases)) %>% 
  arrange(percent)

new_who %>% 
  count(key) %>% 
  mutate(percent = n / sum(n)) %>% 
  arrange(desc(percent))

new_who_2 <- new_who %>% 
  mutate(key = stringr::str_replace(key, "newrel", "new_rel"))

new_who_3 <- new_who_2 %>% 
  separate(key, c("new", "type", "sexage"), sep = "_")


new_who_3 %>% 
  count(new)

new_who_4 <- new_who_3 %>% 
  select(-new, -iso2, -iso3)

new_who_5 <- new_who_4 %>% 
  separate(sexage, c("sex", "age"), sep = 1)

#refacotorizar 

who %>% 
  pivot_longer(
    cols = starts_with("new"),
    names_to = "key",
    values_to = "cases",
    values_drop_na = TRUE
  ) %>% 
  mutate(
    key = stringr::str_replace(key, "newrel", "new_rel")
  ) %>% 
  separate(key, c("new", "var", "sexage")) %>% 
  select(-new, -iso2, -iso3) %>% 
  separate(sexage, c("sex", "age"), sep = 1)
    
