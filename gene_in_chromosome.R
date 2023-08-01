# Load necessary libraries
library(ggplot2)
library(dplyr)
library(readr)

# Define the file path
file_path <- "Homo_sapiens.gene_info.gz"

# Read the data from the file with correct column names
data <- read_delim(file_path, delim = "\t", col_names = c("TaxID", "GeneID", "Symbol", "LocusTag", "Synonyms", "dbXrefs", "Chromosome", "map_location", "Description", "Type_of_Gene", "Symbol_from_nomenclature_authority", "Full_name_from_nomenclature_authority", "Nomenclature_status", "Other_designations", "Modification_date", "Feature_type"))

# Filter out rows with ambiguous chromosome values containing "|"
data <- data %>%
  filter(!grepl("\\|", Chromosome))

# Define the order of the chromosome labels
chromosome_order <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "X", "Y", "MT", "Un")

# Convert the "Chromosome" column to a factor with the custom order
data$Chromosome <- factor(data$Chromosome, levels = chromosome_order)

# Count the number of genes per chromosome
genes_per_chromosome <- data %>%
  group_by(Chromosome) %>%
  summarise(Number_of_Genes = n())

# Create the plot using ggplot2
plot <- ggplot(genes_per_chromosome, aes(x = Chromosome, y = Number_of_Genes)) +
  geom_bar(stat = "identity", fill = "blue") +
  labs(title = "Number of Genes per Chromosome in Human Genome",
       x = "Chromosome", y = "Number of Genes")

# Save the plot to a PDF file
pdf("genes_per_chromosome_plot.pdf", width = 10, height = 6)
print(plot)
dev.off()
