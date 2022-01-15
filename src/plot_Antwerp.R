######################
### PLOT ANTWERP ####
######################

library(dplyr)
library(reshape2)

# import the data from `gen/analysis/pivot_table`
df_pivot <- read.csv("temp/pivot_table.csv")

# convert the `date` column into date format.
df_pivot$date <- as.Date(df_pivot$date)

pdf("output/plot_Antwerp.pdf")
plot(x = df_pivot$date, 
     y = df_pivot$Stadspark, 
     col = "red", 
     type = "l", 
     xlab = "",
     ylab = "Total number of reviews", 
     main = "Effect of COVID-19 pandemic on Airbnb review count")


lines(df_pivot$date, df_pivot$Sint.Andries, col="blue")
lines(df_pivot$date, df_pivot$Centraal.Station, col="green")

legend("topleft", c("Stadspark", "Sint Andries", "Centraal Station"), fill=c("red", "blue", "green"))
dev.off()
