#!/bin/bash

# Help information
usage() {
    echo "Usage: $0 -d <input_directory> -t <threads> -q <reciprocal_threshold> -o <output_file>"
    exit 1
}

# Parse command line parameters
while getopts "d:t:q:o:a:b:" opt; do
    case $opt in
        d) input_dir="$OPTARG" ;;
        t) threads="$OPTARG" ;;
        q) reciprocal_threshold="$OPTARG" ;;
        o) output_file="$OPTARG" ;;       
        *) usage ;;
    esac
done

# Check if necessary parameters are provided
if [ -z "$input_dir" ] || [ -z "$threads" ] || [ -z "$reciprocal_threshold" ] || [ -z "$output_file" ] ; then
    usage
fi

# Step 1: Build cross-species orthogroups using OrthoFinder
echo "Step 1: Build cross-species orthogroups using OrthoFinder"
ls $input_dir/* | awk -F'/' '{print $NF}' > species
for i in $input_dir/*; do
    species=$(basename "$i")  
    sed -i 's/>/>\"$species\"/g' $i;
done

orthofinder -f "$input_dir" -t "$threads" -S mmseqs -M msa

# Step 2: Align and create phylogenetic trees using Orthogroup_Sequences
echo "Step 2: Align and create phylogenetic trees using Orthogroup_Sequences"

cd $input_dir/OrthoFinder/Results_*/Orthogroup_Sequences
for i in *.fa; do
    mafft --maxiterate 1000 --localpair "$i" > "${i%%.fa}.fas"
done

for i in *.fas; do
    FastTree "$i" > "${i%%.fas}.nw"
done

# Step 3: Prune phylogenetic trees to get single-cell phylogenetic trees using phylopypruner
echo "Step 3: Prune phylogenetic trees to get single-cell phylogenetic trees using phylopypruner"
for i in *.fas; do
    base_name="${i%%.fas}"
    mkdir -p "$base_name"
    mv "$i" "$base_name/"
    if [[ -f "${base_name}.nw" ]]; then
        mv "${base_name}.nw" "$base_name/"
    fi
done
rm *.fa
for i in */; do
    phylopypruner --dir "$i" --min-len 100 --trim-lb 4 --min-support 0.75 --prune MI --min-taxa 2 --min-otu-occupancy 0.8 --min-gene-occupancy 0.0
done

echo "Step 4: create homologous gene list"

cp */phylopypruner_output/output_alignments/*fas ../fas
cd ../fas
mapfile -t species_list < species

output_file="$output_dir"/orthology-genelist.csv
echo "Orthogroup,$(IFS=,; echo "${species_list[*]}")" > "$output_file"

# 遍历所有.fas文件
for file in *.fas; do
    filename=$(basename "$file")
    row_content="$filename"

    for species in "${species_list[@]}"; do
        escaped_species=$(sed 's/[][\.^$*]/\\&/g' <<< "$species")
        
        gene_id=$(sed -n "/^>${escaped_species}@/{s/^>${escaped_species}@//p; q}" "$file")
        
        [[ -z "$gene_id" ]] && gene_id=""
        row_content="${row_content},${gene_id}"
    done
    
    # 追加结果到CSV文件
    echo "$row_content" >> "$output_file"
done

echo "All steps are completed."
