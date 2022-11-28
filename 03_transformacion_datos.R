# 5 transformación de datos 
library(nycflights13)
library(tidyverse)
view(flights)
flights

str(flights)
head(flights)
tail(flights)
dim(flights)

# Seleccione las observaciones por sus valores ( filter()).
# Reordenar las filas ( arrange()).
# Seleccione las variables por sus nombres ( select()).
# Crear nuevas variables con funciones de variables existentes ( mutate()).
# Contraiga muchos valores en un solo resumen ( summarise()).
# Todos estos se pueden usar junto con group_by()lo que cambia el alcance de cada función 

flights %>% 
  filter(month == 1, day == 1)

enero_1 <- flights %>% 
  filter(month == 1, day == 1)

(diciembre_25 <- flights %>% 
    filter(month == 12, day == 25))



sqrt(2) ^ 2 == 2
near(sqrt(2) ^ 2, 2)

1/ 49 * 49 == 1
near(1/ 49 * 49, 1)

flights %>% 
filter(month == 11 | month == 12)

flights %>% 
  filter(month %in% c(11,12))

# vuelos que no se hayan retrasado (a la llegada 
# o a la salida) más de dos horas.

flights %>% 
  filter(!(arr_delay > 120 | dep_delay > 120))

flights %>% 
  filter(arr_delay <= 120, dep_delay <= 120))

flights %>% 
  filter(arr_delay > 120 & dep_delay > 120) # error


# na

df <- tibble(x = c(1,20,30,50,18, NA, 45,65,76, NA))

df %>% 
  filter(x > 35)

df %>%
  filter(is.na(x) | x > 35)

#Ejercicios
flights %>% 
  filter(arr_delay >= 120) # 10200 vuelos

flights %>% 
  filter(dest %in% c("IAH", "HOU")) #9313

flights %>% 
  filter(carrier %in% c("UA", "AA", "DL")) # 139504

flights %>% 
  filter(month %in% c(7,8,9)) # 86326

flights %>% 
  filter(dep_delay <= 0, arr_delay > 120) # 29

flights %>% 
  filter(is.na(dep_time)) # 8255


# arrange()funciona de manera similar a filter()excepto que en lugar
# de seleccionar filas, cambia su orden. Se necesita un marco de datos
# y un conjunto de nombres de columna (o expresiones más complicadas) 
# para ordenar. 

flights %>% 
arrange(year, month, day)

flights %>% 
  arrange(desc(dep_delay))

# Nota: Los valores faltantes siempre se ordenan al final:
flights %>% 
arrange(is.na(head(50))) %>% 
  view()

flights %>% 
  arrange(arr_delay)

flights %>% 
  arrange(desc(distance))

flights %>% 
  arrange(distance)

flights %>% 
  arrange(flight)

# select() Le permite acercarse rápidamente a un subconjunto útil 
# mediante operaciones basadas en los nombres de las variables.

flights %>% 
  select(year, month, day) #336,776 × 3

flights %>% 
  select(year:day) #336,776 × 3


flights %>% 
  select( -(year:day)) #336,776 × 16

# starts_with("abc"): coincide con nombres que comienzan con "abc".
# ends_with("xyz"): coincide con nombres que terminan en “xyz”.
# contains("ijk"): coincide con nombres que contienen "ijk".
# matches("(.)\\1"): selecciona variables que coinciden con una expresión regular. 
# num_range("x", 1:3): coincidencias x1 y. x2 x3


# select() se puede usar para cambiar el nombre de las variables, pero
# rara vez es útil porque elimina todas las variables que no se mencionan
# explícitamente. En su lugar, use rename(), que es una variante de 
# select() que mantiene todas las variables que no se mencionan explícitamente:

flights %>% 
  rename(tail_num = tailnum) %>% 
  view()

# Esto es útil si tiene un puñado de variables que le gustaría mover
# al inicio del marco de datos.


flights %>% 
  select(time_hour, air_time, everything())

# ejercicios 

flights %>% 
  select(dep_time, dep_delay, arr_time, arr_delay)

flights %>% 
  select(c("dep_time", "dep_delay", "arr_time", "arr_delay"))

flights %>% 
  select(starts_with("dep"), starts_with("arr"))

flights %>% 
  select(ends_with("time"), ends_with("delay"))

flights %>% 
  select(flight, flight)

vector <- c("year", "month", "day", "dep_delay", "arr_delay")

flights %>% 
  select(any_of(vector))

flights %>% 
  select(contains("time"))


# a menudo es útil agregar nuevas columnas que son funciones de columnas existentes.
# Ese es el trabajo de mutate().
flights %>% 
  select(year:day, ends_with("delay"), distance, air_time) %>% 
  mutate(gain = dep_delay - arr_delay,
         speed = distance / air_time * 60,
         hours = air_time / 60,
         gain_per_hour = gain / hours) %>% 
  view()

flights %>% 
  transmute(gain = dep_delay - arr_delay,
            speed = distance / air_time * 60,
            hours = air_time / 60,
            gain_per_hour = gain / hours) %>% 
  view()


flights %>% 
transmute(
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100) %>% 
  view()


(x <- 1:10)
lag(x)
lead(x)
cumsum(x)
cummean(x)

(y<- c(1,2,2,NA,3,4))
min_rank(y)
min_rank(desc(y))
row_number(y)
dense_rank(y)
percent_rank(y)
cume_dist(y)


flights %>% 
  select(dep_time, sched_dep_time) %>% 
  mutate(time = dep_time - sched_dep_time) %>% 
  view()

flights %>% 
  select(air_time, arr_time, dep_time) %>% 
  mutate(time = (arr_time - dep_time)/60) %>% 
  transmute(time) %>% 
  view()

flights %>% 
  select(air_time, sched_dep_time, dep_delay) %>% 
  head(20) %>% 
  mutate(time = (sched_dep_time/60) - dep_delay) %>% 
  view()       

flights %>% 
  select(arr_delay) %>% 
  arrange(desc(arr_delay)) %>% 
  head(30) %>% 
  min_rank() %>% 
  view()


(x <- 1:3 + 1:10)
(y <- c(1,0,1))

cos(y)
sin(y)
tan(y)

cosh(y)
sinh(y)
tanh(y)

acos(y)
asin(y)
atan(y)


# summarise() no es muy útil a menos que lo combinemos con group_by(). 
# Esto cambia la unidad de análisis del conjunto de datos completo a 
# grupos individuales

flights %>% 
  summarise(delay = mean(dep_delay, na.rm = TRUE))

flights %>% 
  group_by(dep_delay) %>% 
  summarise(delay = mean(dep_delay, na.rm = TRUE)/distance) %>% 
  arrange(desc(dep_delay))

flights %>% 
  group_by(year, month, day) %>% 
  summarise(delay = mean(dep_delay, na.rm = TRUE))


flights %>% 
  group_by(dest) %>% 
  summarise(count = n(),
            dist = mean(distance, na.rm = TRUE),
            delay = mean(arr_delay, na.rm = TRUE)) %>%
  filter(count > 20, dest != "HNL") %>% 
  arrange(desc(count)) %>% 
  ggplot(aes(
    dist,
    delay
  ))+
  geom_point(aes(size = count),alpha=1/3)+
  geom_smooth(se = FALSE)

# Valores faltantes

flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay)) # NA en todas las filas


flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay, na.rm = TRUE)) 

flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay)) %>% 
  group_by(year, month, day) %>% 
  summarise(mean_dep = mean(dep_delay),
            mean_arr = mean(arr_delay))


# Conteos

flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay)) %>% 
  group_by(year, month, day, tailnum) %>%
  summarise(mean_dep = mean(dep_delay),
            mean_arr = mean(arr_delay)) %>% 
  ggplot(aes(
    mean_dep
  ))+
  geom_freqpoly(binwidth = 10)


flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay)) %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    count = n()
  ) %>% 
  ggplot(aes(
    count, 
    delay
  ))+
  geom_point(alpha = 1/10)


flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay)) %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    count = n()
  ) %>% 
  filter(count > 25) %>% 
  ggplot(aes(
    count,
    delay
  ))+
  geom_point(alpha = 1/10)



batting <- as_tibble(Lahman::Batting)

batting %>% 
  group_by(playerID) %>% 
  summarise(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  ) %>% 
  filter(ab > 100) %>% 
  arrange(desc(ab)) %>%
  ggplot(aes(
    ab,
    ba
  ))+
  geom_point()+
  geom_smooth(se = FALSE)

flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay), !is.na(distance)) %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance),
            distance_IQR = IQR(distance),
            distance_mad = mad(distance),
            first = min(dep_time),
            last = max(dep_time),
            first_dep = first(dep_time),
            last_dep = last(dep_time)) %>% 
  arrange(desc(distance_sd)) %>% 
  view()


flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay), !is.na(distance)) %>% 
  group_by(year, month, day) %>% 
  mutate(r = min_rank(desc(dep_time))) %>% 
  filter(r %in% range(r)) %>% 
  view()


flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay)) %>% 
  group_by(dest) %>% 
  summarise(carriers = n_distinct(carrier)) %>% 
  arrange(desc(carriers)) %>% 
  view()


flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay)) %>% 
  count(tailnum, wt = distance) %>% 
  view()

flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay)) %>% 
  group_by(year, month, day) %>% 
  summarise(n_early = sum(dep_time < 500)) %>% 
  view()

flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay)) %>% 
  group_by(year, month, day) %>% 
  summarise(hour_prop = mean(arr_delay > 60)) %>% 
  view()

# Agrupación por múltiples variables

flights %>% 
  group_by(year, month, day) %>% 
  summarise(per_day = n()) %>% 
  view()

flights %>% 
  summarise(per_day = sum(flight)) %>% 
  view()

# ejercicios 

flights %>% 
  filter(!is.na(dep_time), !is.na(arr_time)) %>% 
  group_by(year, month, day, dep_time, arr_time) %>% 
  mutate(dep_time_mean = median(dep_time),
            arr_time_mean = median(arr_time)) %>% 
  arrange(desc(arr_time)) %>% 
  view()


# encuentra los peores miembros de cada grupo:

flights %>% 
  group_by(year, month, day) %>% 
  filter(rank(desc(arr_delay))<60) %>% 
  view()

# encuentre todos los grupos mas grandes que un umbral

flights %>% 
  group_by(dest) %>% 
  filter(n() > 365) %>% 
  view()

flights %>% 
  filter(arr_delay > 0) %>% 
  mutate(prop__delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop__delay) %>% 
  view()
