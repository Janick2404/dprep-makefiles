######################
# CREATE PIVOT TABLE #
######################

library(dplyr)
library(reshape2)

# import the data from `gen/data-preparation/aggregated_df.csv`
df <- read.csv("aggregated_df.csv")

# create pivot table
df_pivot <- df %>% dcast(date ~ neighbourhood, fun.aggregate = sum, value.var = "num_reviews")

# export results
write.csv(df_pivot, "pivot_table.csv")