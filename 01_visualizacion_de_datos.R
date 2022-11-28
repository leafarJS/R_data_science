##########################
# 3 VISUALIZACIÓN DE DATOS
##########################


#install.packages("tidyverse")
library(tidyverse)
theme_set(theme_minimal())
# acutalizar modificaciones
# tidyverse_update()

install.packages(c("nycflights13", "gapminder", "Lahman"))

# errores en español
Sys.setenv(LANGUAGE = "es")

data(mtcars)
mtcars

str(mtcars)
dim(mtcars)
view(mtcars)


sessioninfo::session_info(c("tidyverse"))

# 1. Introducción 
# mpg Marco de datos 

mpg
str(mpg)

mpg %>% 
  ggplot(aes(
    displ,
    hwy
  ))+
  geom_point()+
  geom_smooth(method = "lm", formula = 'y ~ x')


# “El mayor valor de una imagen 
# es cuando nos obliga a notar lo
# que nunca esperábamos ver”. — John Tukey


# estetica
mpg %>% 
  ggplot(aes(
    displ,
    hwy,
    color = class
  ))+
  geom_point(size = 4)+
  theme(legend.position = "bottom")



mpg %>% 
  ggplot(aes(
    displ,
    hwy,
    color = class
  ))+
  geom_point(aes(size = class))+
  theme(legend.position = "bottom")


mpg %>% 
  ggplot(aes(
    displ,
    hwy,
    size = class
  ))+
  geom_point()+
  theme(legend.position = "bottom")



mpg %>% 
  ggplot(aes(
    displ,
    hwy,
    alpha = class
  ))+
  geom_point()+
  theme(legend.position = "bottom")


mpg %>% 
  ggplot(aes(
    displ,
    hwy,
    shape = class
  ))+
  geom_point()+
  theme(legend.position = "bottom")

# shape del 0 a 20


# facetas
mpg %>% 
  ggplot(aes(
    displ,
    hwy
  ))+
  geom_point()+
  facet_wrap(~class, nrow = 2)


mpg %>% 
  ggplot(aes(
    displ,
    hwy
  ))+
  geom_point()+
  facet_grid(drv ~ cyl)


mpg %>% 
  ggplot(aes(
    displ,
    hwy
  ))+
  geom_point()+
  facet_grid(.~ cyl)



mpg %>% 
  ggplot(aes(
    displ,
    hwy
  ))+
  geom_point()+
  facet_grid(drv ~ .)


mpg %>% 
  ggplot(aes(
    displ,
    hwy
  ))+
  geom_point()+
  facet_grid(. ~ cyl)


mpg %>% 
  ggplot(aes(
    displ,
    hwy
  ))+
  geom_point()+
  facet_wrap( ~ class, nrow = 2)

# Objetos Geometricos

mpg %>% 
  ggplot(aes(
    displ, 
    hwy
  ))+
  geom_point()


mpg %>% 
  ggplot(aes(
    displ, 
    hwy
  ))+
  geom_smooth()


mpg %>% 
  ggplot(aes(
    displ, 
    hwy, 
    color = drv
  ))+
  geom_point()+
  geom_smooth(aes(linetype = drv))

# ejercicios

mpg %>% 
  ggplot(aes(
    displ, 
    hwy
  ))+
  geom_smooth()


mpg %>% 
  ggplot(aes(
    displ, 
    hwy, 
    group = drv
  ))+
  geom_smooth()


mpg %>% 
  ggplot(aes(
    displ, 
    hwy, 
    color = drv
  ))+
  geom_smooth(show.legend = FALSE)


mpg %>% 
  ggplot(aes(
    displ, 
    hwy, 
    color = drv
  ))+
  geom_point()+
  geom_smooth(show.legend = FALSE)


mpg %>% 
  ggplot(aes(
    displ, 
    hwy
  ))+
  geom_point(aes(color = class))+
  geom_smooth(show.legend = FALSE, method = "loess", formula = 'y ~ x')



mpg %>% 
  ggplot(aes(
    displ, 
    hwy
  ))+
  geom_point(aes(color = class))+
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)


mpg %>% 
  ggplot(aes(
    displ,
    hwy,
    color = drv
  ))+
  geom_point()+
  geom_smooth(se = FALSE)+
  facet_wrap(~drv, nrow = 2)



mpg %>% 
  ggplot(aes(
    displ,
    hwy
  ))+
  geom_point()+
  geom_smooth(method = "loess", formula = 'y ~ x')


mpg %>% 
  ggplot()+
  geom_point(aes(
    displ,
    hwy
  ))+
  geom_smooth(aes(
    displ,
    hwy
  ))


mpg %>% 
  ggplot(aes(
    displ,
    hwy
  ))+
  geom_point(size = 2)+
  geom_smooth(se = FALSE)

mpg %>% 
  ggplot(aes(
    displ,
    hwy
  ))+
  geom_point(size = 2)+
  geom_smooth(aes(color = drv), se = FALSE)


mpg %>% 
  ggplot(aes(
    displ,
    hwy, 
    color = drv
  ))+
  geom_point(size = 2)+
  geom_smooth(aes(color = drv), se = FALSE)

mpg %>% 
  ggplot(aes(
    displ,
    hwy, 
    color = drv
  ))+
  geom_point()+
  geom_smooth(se = FALSE)


mpg %>% 
  ggplot(aes(
    displ,
    hwy, 
    color = drv
  ))+
  geom_point()+
  geom_smooth(aes(linetype = drv), se = FALSE)

mpg %>% 
  ggplot(aes(
    displ,
    hwy, 
    color = drv,
    size = class
  ))+
  geom_point()+
  theme(legend.position = "none")



# Transformacines estadisticas

diamonds
str(diamonds)
dim(diamonds)
sample(diamonds)
head(diamonds)
tail(diamonds)

class(diamonds$cut)

diamonds %>% 
  ggplot(aes(
    cut
  ))+
  geom_bar()


diamonds %>% 
  ggplot(aes(
    cut
  ))+
  stat_count()

# TRIBBLE crear tablas pequeñas para su legilibilidad

demo <- tribble(
  ~cut,         ~freq,
  "Fair",       1610,
  "Good",       4906,
  "Very Good",  12082,
  "Premium",    13791,
  "Ideal",      21551
)

demo %>% 
  ggplot(aes(
    cut,
    freq
  ))+
  geom_bar(stat = "identity")
  

diamonds %>% 
  ggplot(aes(
    cut,
    after_stat(prop),
    group = 1
  ))+
  geom_bar()  


diamonds %>% 
  ggplot()+
  stat_summary(
    aes(
      fct_reorder(cut),
      depth
    ),
    fun.min = min,
    fun.max = max,
    fun = median
  )+
  coord_flip()

diamonds %>% 
  ggplot(aes(
    cut,
    after_stat(prop)
  ))+
  geom_bar()

diamonds %>% 
  ggplot(aes(
    cut,
    after_stat(prop)
  ))+
  geom_bar(aes(fill = color))


#con group se logra un gráfico escalonado
ggplot(diamonds)+
  geom_bar(aes(
    cut,
    after_stat(prop),
    group = 1
  ))


diamonds %>% 
  ggplot(aes(
    cut,
    after_stat(prop),
    group = 1
  ))+
  geom_bar(aes(fill = cut))



diamonds %>% 
  ggplot(aes(
    cut, 
    colour = cut,
  ))+
  geom_bar()

diamonds %>% 
  ggplot(aes(
    cut, 
    fill = cut,
  ))+
  geom_bar()


diamonds %>% 
  ggplot(aes(
    cut,
    fill = clarity
  ))+
  geom_bar()

# ajuste de posición "identity", "dodge" o "fill"

diamonds %>% 
  ggplot(aes(
    cut,
    fill = clarity
  ))+
  geom_bar(aes(alpha = 0.5, position = 'identtity'))

diamonds %>% 
ggplot(aes(
  x = cut,
  colour = clarity)) + 
  geom_bar(fill = NA, position = "identity")


diamonds %>% 
  ggplot(aes(
    cut,
    fill= clarity
  ))+
  geom_bar(position = 'fill')


diamonds %>% 
  ggplot(aes(
    cut,
    fill= clarity
  ))+
  geom_bar(position = 'dodge')

mpg %>% 
  ggplot(aes(
    displ,
    hwy
  ))+
  geom_point()

mpg %>% 
  ggplot(aes(
    displ,
    hwy
  ))+
  geom_point(position = 'jitter')

mpg %>% 
  ggplot(aes(
    cty,
    hwy
  ))+
  geom_point()


mpg %>% 
  ggplot(aes(
    cty,
    hwy
  ))+
  geom_jitter()

# sistema de coordenadas

mpg %>% 
  ggplot(aes(
    class,
    hwy
  ))+
  geom_boxplot()

mpg %>%
  mutate(class = fct_reorder(class, hwy)) %>% 
  ggplot(aes(
    class,
    hwy
  ))+
  geom_boxplot()+
  coord_flip()

#install.packages("mapdata")
library(mapdata)
#> Loading required package: maps
library(ggplot2)
library(maps)
library(ggrepel)
library(dplyr)

world <- map_data("world") 

world %>% 
  filter(region == "Bolivia") %>% 
  ggplot(aes(
    long,
    lat,
    group = group
  ))+
  geom_polygon(fill="grey90", colour = "grey70")


world %>% 
  filter(region == "Bolivia") %>% 
  ggplot(aes(
    long,
    lat,
    group = group
  ))+
  geom_polygon(fill = "white", colour="black")

world %>% 
  filter(region == "Bolivia") %>% 
  ggplot(aes(
    long,
    lat,
    group = group
  ))+
  geom_polygon(fill = "white", colour="black")+
  coord_quickmap()


graph <- diamonds %>% 
  ggplot(aes(
    cut,
    fill = cut
  ))+
  geom_bar(show.legend = FALSE, width = 1)+
  theme(aspect.ratio = 1)+
  labs(
    x = NULL,
    y = NULL
  )

graph + coord_flip()

graph + coord_polar()
