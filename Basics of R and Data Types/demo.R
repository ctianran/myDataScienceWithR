library(ggplot2)

pl <- ggplot(txhousing, aes(x=sales, y=volume))
pl <- pl + geom_point(color='blue', alpha=0.3)
pl <- pl + geom_smooth(color='red')
print(pl)

