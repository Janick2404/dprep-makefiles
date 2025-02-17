library(dplyr)
library(reshape2)

######################
### DOWNLOAD DATA ####
######################
download_data <- function(url, filename){
  download.file(url = url, destfile = paste0(filename, ".csv"))
}

url_listings <- "http://data.insideairbnb.com/belgium/vlg/antwerp/2021-02-25/visualisations/listings.csv"
url_reviews <- "http://data.insideairbnb.com/belgium/vlg/antwerp/2021-02-25/visualisations/reviews.csv"

download_data(url_listings, "listings")
download_data(url_reviews, "reviews")

######################
#### CLEAN DATA ######
######################
reviews <- read.csv("reviews.csv")
listings <- read.csv("listings.csv")

# convert date column
reviews$date <- as.Date(reviews$date)

# filter for reviews published since 01/01/2015
reviews_filtered <- reviews %>% filter(date > "2016-01-01")

# filter for `listings` that have received at least 1 review.
listings_filtered <- listings %>% filter(number_of_reviews > 1)

# merge the `reviews` and `listings` dataframes on a common columns (the type of join doesn't really matter since we already filtered out listings without any reviews)
df_merged <- reviews_filtered %>% 
  inner_join(listings_filtered, by = c("listing_id" = "id"))

# group the number of reviews by month and neighborhood.
df_grouped <- df_merged %>%
  mutate(month = format(date, "%m"), year = format(date, "%Y")) %>%
  group_by(year, month, neighbourhood) %>%
  summarise(num_reviews = n())

# create date column
df_grouped$date <- as.Date(paste0(df_grouped$year, "-", df_grouped$month, "-01"))

# store the final data frame in `gen/data-preparation` as `aggregated_df.csv`
write.csv(df_grouped, "aggregated_df.csv")

######################
# CREATE PIVOT TABLE #
######################

# import the data from `gen/data-preparation/aggregated_df.csv`
df <- read.csv("aggregated_df.csv")

# create pivot table
df_pivot <- df %>% dcast(date ~ neighbourhood, fun.aggregate = sum, value.var = "num_reviews")

# export results
write.csv(df_pivot, "pivot_table.csv")


######################
### PLOT ANTWERP ####
######################

# import the data from `gen/analysis/pivot_table`
df_pivot <- read.csv("pivot_table.csv")

# convert the `date` column into date format.
df_pivot$date <- as.Date(df_pivot$date)

pdf("plot_Antwerp.pdf")
plot(x = df_pivot$date, 
     y = df_pivot$Universiteitsbuurt, 
     col = "red", 
     type = "l", 
     xlab = "",
     ylab = "Total number of reviews", 
     main = "Effect of COVID-19 pandemic on Airbnb review count")


lines(df_pivot$date, df_pivot$Sint.Andries, col="blue")
lines(df_pivot$date, df_pivot$Centraal.Station, col="green")

legend("topleft", c("Universiteitsbuurt", "Sint Andries", "Centraal Station"), fill=c("red", "blue", "green"))
dev.off()


######################
##### PLOT ALL #######
######################

# import the data from `gen/data-preparation/aggregated_df.csv`
df <- read.csv("aggregated_df.csv")

# convert the `date` column into date format.
df$date <- as.Date(df$date)

# group by date and calculate the sum of all reviews across neighbourhoods.
df_groupby <- df %>% group_by(date) %>% summarise(num_reviews = sum(num_reviews))

# plot the chart and store the visualisation.
pdf("plot_all.pdf")
plot(x = df_groupby$date, 
     y = df_groupby$num_reviews, 
     type = "l", 
     xlab = "",
     ylab = "Total number of reviews", 
     main = "Effect of COVID-19 pandemic on Airbnb review count")
dev.off()