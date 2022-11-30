# Tibbles 
library(tidyverse)
library(lubridate)
library(nycflights13)
#convertir marco de datos a tibbles 
as_tibble(iris)

# tibbles de marcos individuales

tibble(
  x = 1:5,
  y = 1,
  z = x ^ 2 + y
)

# no permites muchas modificaciones como un data frame

# puede tener nombres no sintacticos 

tibble(
  `:)` = "smile",
  `:0` = "awesome",
  `2000` = "number"
)

# personalizar para la entrada de datos en el codigo ~

tribble(
  ~x, ~y, ~z,
  #--|--|----|
  "a", 2, 3.6,
  "b", 1, 8.5
)


# tibbles vs data.frame

tibble(
  a = now() + runif(1e3) * 86400,
  b = today() + runif(1e3) * 30, 
  c = 1:1e3,
  d = runif(1e3), 
  e = sample(letters, 1e3, replace = TRUE)
)

flights %>% 
  print(n = 10, width = Inf)


x <- tibble(
  x = runif(5),
  y = rnorm(5)
)
x

x %>% .$x
x %>% .[["x"]]


class(as.data.frame(x))


# ejercicios
class(mtcars)
class(as_tibble(mtcars))

x = data.frame(abc = 1, xyz = "a")

x$x
x[, "xyz"]
x[, c("abc", "xyz")]


x <- tibble(
  abc = 1, 
  xyz = "a"
)

x$x
x[, "xyz"]
x[, c("abc", "xyz")]

# extracción en tibble
x %>%  .$abc

