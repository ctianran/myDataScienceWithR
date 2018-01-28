library(ggplot2)
library(plotly)

plt <- ggplot(mtcars, aes(mpg, wt)) + geom_point()
gpl <- ggplotly(plt)


print(gpl)