#!/bin/bash

# 检查必要的依赖是否安装
command -v orthofinder >/dev/null 2>&1 || { echo >&2 "OrthoFinder 未安装. 请先安装 OrthoFinder."; exit 1; }
command -v mafft >/dev/null 2>&1 || { echo >&2 "MAFFT 未安装. 请先安装 MAFFT."; exit 1; }
command -v FastTree >/dev/null 2>&1 || { echo >&2 "FastTree 未安装. 请先安装 FastTree."; exit 1; }
command -v phylopypruner >/dev/null 2>&1 || { echo >&2 "phylopypruner 未安装. 请先安装 phylopypruner."; exit 1; }
command -v reciprologs >/dev/null 2>&1 || { echo >&2 "reciprologs 未安装. 请先安装 reciprologs."; exit 1; }


echo "step1: 使用 OrthoFinder 构建跨物种的直系同源组"
orthofinder -f files/ -t 20 -S mmseqs -M msa


echo "step2: 使用 Orthogroup_Sequences 进行比对并创建系统发育树"
for i in *.fa; do
    mafft --maxiterate 1000 --localpair "$i" > "${i%%.fa}.fas"
done
for i in *.fas; do
    FastTree "$i" > "${i%%.fas}.nw"
done


echo "step3: 使用 phylopypruner 修剪系统发育树以获得单细胞系统发育树"
for i in *.fas; do
    base_name="${i%%.fas}"
    mkdir -p "$base_name"
    mv "$i" "$base_name/"
    if [[ -f "${base_name}.nw" ]]; then
        mv "${base_name}.nw" "$base_name/"
    fi
done

for i in */; do
    phylopypruner --dir "$i" --min-len 100 --trim-lb 4 --min-support 0.75 --prune MI --min-taxa 2 --min-otu-occupancy 0.0 --min-gene-occupancy 0.0
done


echo "step4: 将所有 /phylopypruner_output/output_alignments 结果汇总成一个表格以显示直系同源"




echo "All done."
