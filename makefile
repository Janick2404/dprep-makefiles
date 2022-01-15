# Main build rule

all:	plot_Antwerp.pdf plot_all.pdf


reviews.csv	listings.csv:	download.R
		R	--vanilla	<	download.R

# Sub-builds

aggregated_df.csv: clean.R	reviews.csv	listings.csv
		r	--vanilla	<	clean.R

pivot_table.csv:	pivot_table.R	aggregated_df.csv
		r	--vanilla	<	pivot_table.R
		
plot_Antwerp.pdf:	plot_Antwerp.R	pivot_table.csv
		r	--vanilla	<	plot_Antwerp.R
		
plot_all.pdf: aggregated_df.csv	plot_all.R
		r	--vanilla	<	plot_all.R
		