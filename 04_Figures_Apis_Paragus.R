library(microeco)

otu_table <-
  read.csv("Outputs/Discription_microbiome/Discription_microbiome_OTU_PA.csv",
           row.names = 1)
taxonomy_table <-
  read.csv("outputs/Discription_microbiome/Discription_microbiome_taxonomy.csv",
           row.names=1)
sample_info <-
  read.csv(
    "outputs/Discription_microbiome/Discription_microbiome_metadata_PA.csv",
    row.names = 1
  )


# create an object of microtable
dataset <- microtable$new(sample_table = sample_info,
                          otu_table = otu_table,
                          tax_table = taxonomy_table)


phylum <- trans_abund$new(dataset = dataset, taxrank = "Phylum", ntaxa = 8)
P1 <- phylum$plot_bar(others_color = "grey70", facet = "Species",
                      xtext_keep = FALSE, legend_text_italic = FALSE)

fam <- trans_abund$new(dataset = dataset, taxrank = "Family", ntaxa = 8)
P2 <- fam$plot_bar(others_color = "grey70", facet = "Species",
                   xtext_keep = FALSE, legend_text_italic = FALSE)

gen <- trans_abund$new(dataset = dataset, taxrank = "Genus", ntaxa = 8)
P3 <- gen$plot_bar(others_color = "grey70", facet = "Species",
                   xtext_keep = FALSE, legend_text_italic = FALSE)

ASV <- trans_abund$new(dataset = dataset, taxrank = "ASV", ntaxa = 8)
P4 <- ASV$plot_bar(others_color = "grey70", facet = "Species",
                   xtext_keep = FALSE, legend_text_italic = FALSE)


P4

ggarange

library(palmerpenguins)
par(mfrow = c(1,3)) 



## Figure 2 --------------------------------------------------------------------

library(microeco)

otu_table <-
  read.csv("Outputs/Discription_microbiome/Discription_microbiome_OTU_PA.csv",
           row.names = 1)
taxonomy_table <-
  read.csv(
    "outputs/Discription_microbiome/Discription_microbiome_taxonomy.csv",
    row.names = 1
  )
sample_info <-
  read.csv(
    "outputs/Discription_microbiome/Discription_microbiome_metadata_PA.csv",
    row.names = 1
  )


# create an object of microtable
dataset <- microtable$new(sample_table = sample_info,
                          otu_table = otu_table,
                          tax_table = taxonomy_table)

gen <- trans_abund$new(dataset = dataset, taxrank = "Genus", ntaxa = 8)
P3 <- gen$plot_bar(
  others_color = "grey70", 
  facet = "Species", 
  xtext_keep = FALSE, 
  legend_text_italic = FALSE) +
  theme(strip.text = element_text(face = "italic", size = 14),
        legend.title = element_text(face = "bold", size = 14),
        legend.text = element_text(size = 12))

P3

ggsave("outputs/Figure_2_PA_2.tiff", device='tiff', dpi=300)



# create SI figure -----------------------------------------------

# create an object of microtable
dataset <- microtable$new(sample_table = sample_info,
                          otu_table = otu_table,
                          tax_table = taxonomy_table)

phylum <- trans_abund$new(dataset = dataset, taxrank = "Phylum", ntaxa = 8)
P1 <- phylum$plot_bar(
  others_color = "grey70", 
  facet = "Species", 
  xtext_keep = FALSE, 
  legend_text_italic = FALSE) +
  theme(strip.text = element_text(face = "italic", size = 14),
        legend.title = element_text(face = "bold", size = 14),
        legend.text = element_text(size = 12))

fam <- trans_abund$new(dataset = dataset, taxrank = "Family", ntaxa = 8)
P2 <- fam$plot_bar(
  others_color = "grey70", 
  facet = "Species", 
  xtext_keep = FALSE, 
  legend_text_italic = FALSE) +
  theme(strip.text = element_text(face = "italic", size = 14),
        legend.title = element_text(face = "bold", size = 14),
        legend.text = element_text(size = 12))



ggarrange(P1, P2, labels = c("A", "B"), ncol = 2, nrow = 1) 
#widths = c(20, 20, 40)

P1

ggsave("outputs/Figure_SI_3.tiff", device='tiff', dpi=300)

P2

ggsave("outputs/Figure_SI_4.tiff", device='tiff', dpi=300)
