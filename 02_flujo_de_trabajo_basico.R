# 4 flujo de trabajo : conceptos basicos
library(tidyverse)

200 * 30
(59 + 73 + 2) / 3
sin(pi / 2)

# crear objetos calculados

x <- 3 * 4

this_is_really_long_name <- 2.5
this_is_really_long_name <- 3.5


r_rock <- 2 ^ 3
R_rock # error

r_rock


# Funcionas propias de R

seq(0,50,5)
seq(1,10, length.out = 5)
(x <- seq(0,100,15))


my_variable <- 10
my_varıable # error en la i


mpg %>% 
  ggplot(aes(
    displ,
    hwy
  ))+
  geom_point()


filter(mpg, cyl == 8)

filter(diamonds, carat > 3)


# Alt + Shift + K shortflucuts


