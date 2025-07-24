# homologous-cross-ascidians
This method is designed for the creation of phylogenetic trees for single-copy orthologous genes across different species. Orthologous genes are genes in different species that evolved from a common ancestral gene through speciation. By focusing on single-copy orthologs, which are genes that have only one copy in each species being compared, this method aims to provide a more accurate and less complex view of evolutionary relationships. The process involves identifying and aligning these genes across species, followed by constructing a phylogenetic tree that reflects their evolutionary history. This approach is particularly useful in comparative genomics, allowing researchers to trace the ancestry of genes and understand the genetic changes that have occurred over time across different lineages.

![yuque_diagram (1)](https://github.com/user-attachments/assets/fbbb3ecd-64cc-42e6-9ada-c93229777257)

# Required Dependencies
· conda install OrthoFinder

· conda install MAFFT

· conda install FastTree

· pip install phylopypruner

· reciprologs  https://github.com/glarue/reciprologs/blob/main/reciprologs

# Usage
sh create-orthology-list.sh -input_dir ./files/ -threads 20 -output_dir .


# the Ascidians' homologous Database 
https://jxxluotest.shinyapps.io/homologs-of-tunicate/
