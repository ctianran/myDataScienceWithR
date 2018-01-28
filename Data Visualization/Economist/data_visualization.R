library(ggplot2)
library(ggthemes)
library(data.table)


pointsToLabel <- c("Russia", "Venezuela", "Iraq", "Myanmar", "Sudan",
                   "Afghanistan", "Congo", "Greece", "Argentina", "Brazil",
                   "India", "Italy", "China", "South Africa", "Spane",
                   "Botswana", "Cape Verde", "Bhutan", "Rwanda", "France",
                   "United States", "Germany", "Britain", "Barbados", "Norway", "Japan",
                   "New Zealand", "Singapore")

df <- fread("Economist_Data.csv", drop=1)
#print(head(df))

plt <- ggplot(df, aes(x=CPI, y=HDI, color=Region))
plt <- plt + geom_point(size=4, shape=1)
plt <- plt + geom_smooth(aes(group=1), method='lm', formula=y~log(x), se=FALSE, color='red')
plt <- plt + geom_text(aes(label = Country), color = "gray20", 
             data = subset(df, Country %in% pointsToLabel),check_overlap = TRUE)
plt <- plt + scale_x_continuous(name="Corruption Perceptions Index, 2011 (10 = least corrupt)", limits=c(0.9,10.5), breaks=1:10)
plt <- plt + scale_y_continuous(name="Human Development Index, 2011 (1=Best)", limits=c(0.2, 1.0))
plt <- plt + ggtitle("Corruption and Human Development")
plt <- plt + theme_economist_white() + theme(plot.title = element_text(hjust = 0.5))
print(plt)

