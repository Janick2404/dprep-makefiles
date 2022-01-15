# Main build rule

all:	output/plot_Antwerp.pdf output/plot_all.pdf


# Sub-builds


data/reviews.csv	data/listings.csv:	src/download.R
		R	--vanilla	<	src/download.R

temp/aggregated_df.csv: src/clean.R	data/reviews.csv	data/listings.csv
		r	--vanilla	<	src/clean.R

temp/pivot_table.csv:	src/pivot_table.R	temp/aggregated_df.csv
		r	--vanilla	<	src/pivot_table.R
		
output/plot_Antwerp.pdf:	src/plot_Antwerp.R	temp/pivot_table.csv
		r	--vanilla	<	src/plot_Antwerp.R
		
output/plot_all.pdf: temp/aggregated_df.csv	src/plot_all.R
		r	--vanilla	<	src/plot_all.R
		