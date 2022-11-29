# Análisis exploratorio de datos
library(tidyverse)
library(nycflights13)
theme_set(theme_minimal())

# análisis exploratorio de datos, o EDA


# Genera preguntas sobre tus datos.
# Busque respuestas visualizando, transformando y modelando sus datos.
# Use lo que aprende para refinar sus preguntas y/o generar nuevas preguntas.


# “No hay preguntas estadísticas de rutina, 
# solo rutinas estadísticas cuestionables”. — Sir David Cox

# “Es mucho mejor una respuesta aproximada a la pregunta correcta,
# que a menudo es vaga, que una respuesta exacta a la pregunta 
# equivocada, que siempre se puede precisar”. — John Tukey


# ¿Qué tipo de variación ocurre dentro de mis variables?
# ¿Qué tipo de covariación ocurre entre mis variables?

# Una variable es una cantidad, cualidad o propiedad que se puede 
# Un valor es el estado de una variable cuando la mides. 
# Una observación es un conjunto de mediciones realizadas en condiciones similares
# 
# datos tabulares
# variables = columnas
# observaciones = filas
# valores = estado de la observacion


# Visualización de distribuciones

data("diamonds")
str(diamonds)


# Una variable es categórica si solo 
# puede tomar uno de un pequeño conjunto de valores

diamonds %>% 
  count(cut)

diamonds %>% 
  ggplot(aes(
    cut
  ))+
  geom_bar()

# Una variable es continua si puede tomar cualquiera de 
# un conjunto infinito de valores ordenados

diamonds %>% 
  count(cut_width(carat, 0.5))


diamonds %>% 
  ggplot(aes(
    carat
  ))+
  geom_histogram(binwidth = 0.5)

diamonds %>% 
  filter(carat < 3) %>% 
  ggplot(aes(
    carat
  ))+
  geom_histogram(binwidth = 0.1)


diamonds %>% 
  filter(carat < 3) %>% 
  ggplot(aes(
    carat,
    colour = cut
  ))+
  geom_freqpoly(binwidth = 0.1)


diamonds %>% 
  filter(carat < 3) %>% 
  ggplot(aes(
    carat,
    colour = cut
  ))+
  geom_freqpoly(binwidth = 0.1)+
  facet_wrap(~cut)+
  theme(legend.position = "none")


# Valores tipicos

# ¿Qué valores son los más comunes? ¿Por qué?
# ¿Qué valores son raros? ¿Por qué? ¿Eso coincide con sus expectativas?
# ¿Puedes ver algún patrón inusual? ¿Qué podría explicarlos?

diamonds %>% 
  filter(carat < 3) %>% 
  ggplot(aes(
    carat
  ))+
  geom_histogram(binwidth = 0.01)

# ¿En qué se parecen las observaciones dentro de cada conglomerado?
# ¿En qué se diferencian las observaciones en grupos separados entre sí?
# ¿Cómo puedes explicar o describir los grupos?
# ¿Por qué podría ser engañosa la apariencia de los conglomerados?

data("faithful")
str(faithful)

faithful %>% 
  count(cut_width(eruptions, .25))

faithful %>% 
  ggplot(aes(
    eruptions
  ))+
  geom_histogram(binwidth = .25)


# Valores inusuales

# Los valores atípicos son observaciones que son inusuales; puntos de 
# datos que no parecen ajustarse al patrón.

diamonds %>% 
  ggplot(aes(
    y
  ))+
  geom_histogram(binwidth = 0.5)


# Para que sea más fácil ver los valores inusuales, necesitamos acercarnos
# a los valores pequeños del eje y con coord_cartesian()

diamonds %>% 
  ggplot(aes(
    y
  ))+
  geom_histogram(binwidth = 0.5)+
  coord_cartesian(ylim = c(0,30))

diamonds %>% 
  ggplot(aes(
    y
  ))+
  geom_histogram(binwidth = 0.5)+
  coord_cartesian(xlim = c(0,50))


diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  select(price, x, y, z) %>% 
  arrange(desc(y))


# Valores faltantes

diamonds %>% 
  filter(between(y, 3, 20))
#no recomendable datos de baja calidad

diamonds %>% 
  mutate(y  = ifelse(y < 3| y > 20, NA, y)) %>% 
  ggplot(aes(
    x,
    y
  ))+
  geom_point()


diamonds %>% 
  mutate(y  = ifelse(y < 3| y > 20, NA, y)) %>% 
  ggplot(aes(
    x,
    y
  ))+
  geom_point(na.rm = TRUE)

nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min /60
  ) %>% 
  ggplot(aes(
    sched_dep_time
  ))+
  geom_freqpoly(aes(
    colour = cancelled
  ), binwidth = 1/4)


 # Covariación

# Si la variación describe el comportamiento dentro de una variable,
# la covariación describe el comportamiento entre variables. 
# La covariación es la tendencia de los valores de dos o más variables
# a variar juntos de manera relacionada.

# Una variable categórica y continua

diamonds %>% 
  ggplot(aes(
    price,
    color = cut
  ))+
  geom_freqpoly(binwidth = 500)


diamonds %>% 
  ggplot(aes(
    cut
  ))+
  geom_bar()


diamonds %>%  
ggplot(aes(
   price,
   ..density..
   )) + 
  geom_freqpoly(aes(colour = cut), binwidth = 500)


# Otra alternativa para mostrar la distribución de una variable 
# continua desagregada por una variable categórica es el diagrama 
# de caja.

diamonds %>% 
  ggplot(aes(
    cut,
    price
  ))+
  geom_boxplot()


data(mpg)
str(mpg)


mpg %>% 
  ggplot(aes(
    class,
    hwy
  ))+
  geom_boxplot()


mpg %>% 
  mutate(class = fct_reorder(class, hwy, median)) %>% 
  ggplot(aes(
    class,
    hwy
  ))+
  geom_boxplot()+
  coord_flip()


# Dos variables categóricas
diamonds %>% 
  ggplot(aes(
    cut,
    color
  ))+
  geom_count()

# El tamaño de cada círculo en la gráfica muestra cuántas observaciones 
# ocurrieron en cada combinación de valores. La covariación aparecerá 
# como una fuerte correlación entre valores específicos de x y valores 
# específicos de y

diamonds %>% 
  count(color, cut)

diamonds %>% 
  count(color, cut) %>% 
  ggplot(aes(
    color,
    cut,
    fill = n
  ))+
  geom_tile()+
  coord_flip()

# paquetes recomendados : d3heatmap o heatmaply


diamonds %>% 
  count(color, cut) %>% 
  ggplot(aes(
    color,
    cut,
    fill = n
  ))+
  geom_tile()+
  scale_fill_gradient2(low = "blue", high = "red", midpoint = 2000)+
  coord_flip()


data(flights)
flights %>% 
  select(year, month,dep_time, arr_delay, origin, dest) %>% 
  mutate(dest = fct_lump(dest, 10),
    prom_delay = arr_delay / dep_time ) %>%
  group_by(year, month) %>% 
  count(origin, dest, prom_delay) %>% 
  ggplot(aes(
    origin,
    dest,
    fill =n
  ))+
  geom_tile()+
  coord_flip()


data(flights)
flights %>% 
  select(year, month,dep_time, arr_delay, origin, dest) %>% 
  mutate(dest = fct_lump(dest, 10),
         prom_delay = arr_delay / dep_time ) %>%
  group_by(year, month) %>% 
  count(origin, dest, prom_delay) %>% 
  ggplot(aes(
    origin,
    dest,
    fill = prom_delay
  ))+
  geom_tile()+
  scale_fill_gradient2(low = "blue", high = "red", midpoint = 50)+
  facet_wrap(~month, nrow = 2)


data(flights)
flights %>% 
  select(year, month,dep_time, arr_delay, origin, dest) %>% 
  mutate(dest = fct_lump(dest, 10)) %>%
  group_by(year, month) %>% 
  count(origin, dest) %>% 
  ggplot(aes(
    origin,
    dest,
    fill = n
  ))+
  geom_tile()+
  scale_fill_gradient2(low = "green", high = "yellow", midpoint = 2500)+
  facet_wrap(~month, nrow = 2)+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


# Dos variables continuas

diamonds %>% 
  ggplot(aes(
    carat,
    price
  ))+
  geom_point()


# mejorar la estetica
diamonds %>% 
  ggplot(aes(
    carat,
    price
  ))+
  geom_point(alpha = 1/100)

diamonds %>% 
  filter(carat < 3) %>% 
  ggplot(aes(
    carat,
    price
  ))+
  geom_bin2d()


#install.packages("hexbin")
library(hexbin)

diamonds %>% 
  filter(carat < 3) %>% 
  ggplot(aes(
    carat,
    price
  ))+
  geom_hex()

diamonds %>% 
  filter(carat < 3) %>% 
  ggplot(aes(
    carat,
    price,
    group = cut_width(carat, 0.25)
  ))+
  geom_boxplot()


diamonds %>% 
  filter(carat < 3) %>% 
  ggplot(aes(
    carat,
    price,
    group =cut_number(carat, 20)
  ))+
  geom_boxplot()


diamonds %>% 
  mutate(price_X_carat = carat/price) %>% 
  group_by(cut, price_X_carat) %>% 
  count(cut, price_X_carat) %>% 
  arrange(desc(n)) %>% 
  filter(n > 40) %>% 
  ggplot(aes(
    n,
  ))+
  geom_histogram(binwidth = 3)


diamonds %>% 
  ggplot(aes(
    x,
    y
  ))+
  coord_cartesian(xlim = c(4, 11), ylim = c(4, 11)

# Patrones y modelos

# ¿Podría este patrón deberse a una coincidencia (es decir, al azar)?
# ¿Cómo puedes describir la relación implícita en el patrón?
# ¿Qué tan fuerte es la relación implícita en el patrón?
# ¿Qué otras variables podrían afectar la relación?
# ¿Cambia la relación si observa subgrupos individuales de datos?

data(faithful)
str(faithful)                                    

faithful %>% 
  ggplot(aes(
    eruptions,
    waiting
  ))+
  geom_point()+
  geom_smooth()


#install.packages("modelr")
library(modelr)

diamonds %>% 
  add_residuals(mod = lm(log(price)~log(carat), diamonds)) %>% 
  mutate(resid = exp(resid)) %>% 
  ggplot(aes(
    carat,
    resid
  ))+
  geom_point()


diamonds %>% 
  add_residuals(mod = lm(log(price)~log(carat), diamonds)) %>% 
  mutate(resid = exp(resid)) %>% 
  ggplot(aes(
    carat,
    resid,
    group = cut
  ))+
  geom_boxplot()


diamonds %>% 
  count(cut, clarity) %>% 
  ggplot(aes(clarity, cut, fill = n)) + 
  geom_tile()
