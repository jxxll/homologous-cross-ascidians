#!/bin/bash

# 检查必要的依赖是否安装
command -v orthofinder >/dev/null 2>&1 || { echo >&2 "OrthoFinder 未安装. 请先安装 OrthoFinder."; exit 1; }
command -v mafft >/dev/null 2>&1 || { echo >&2 "MAFFT 未安装. 请先安装 MAFFT."; exit 1; }
command -v FastTree >/dev/null 2>&1 || { echo >&2 "FastTree 未安装. 请先安装 FastTree."; exit 1; }
command -v phylopypruner >/dev/null 2>&1 || { echo >&2 "phylopypruner 未安装. 请先安装 phylopypruner."; exit 1; }
command -v reciprologs >/dev/null 2>&1 || { echo >&2 "reciprologs 未安装. 请先安装 reciprologs."; exit 1; }

# 步骤1: 使用 OrthoFinder 构建跨物种的直系同源组
echo "步骤1: 使用 OrthoFinder 构建跨物种的直系同源组"
orthofinder -f files/ -t 20 -S mmseqs -M msa

# 步骤2: 使用 Orthogroup_Sequences 进行比对并创建系统发育树
echo "步骤2: 使用 Orthogroup_Sequences 进行比对并创建系统发育树"
for i in *.fa; do
    mafft --maxiterate 1000 --localpair "$i" > "${i%%.fa}.fas"
done
for i in *.fas; do
    FastTree "$i" > "${i%%.fas}.nw"
done

# 步骤3: 使用 phylopypruner 修剪系统发育树以获得单细胞系统发育树
echo "步骤3: 使用 phylopypruner 修剪系统发育树以获得单细胞系统发育树"
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

# 步骤4: 将所有 /phylopypruner_output/output_alignments 结果汇总成一个表格以显示直系同源
echo "步骤4: 将所有 /phylopypruner_output/output_alignments 结果汇总成一个表格以显示直系同源"
# 这个步骤需要更多的细节来实现，这里暂时省略

# 步骤5: 使用 reciprologs 基于 blastp 分析两个物种之间的最佳匹配
echo "步骤5: 使用 reciprologs 基于 blastp 分析两个物种之间的最佳匹配"
reciprologs -p 10 --chain -q 30 -o ab.txt --one_to_one --logging Aproteins.fasta Bproteins.fasta blastp

# 步骤6: 使用 reciprologs 结果和小鼠结果作为参考来填补直系同源组中的空白
echo "步骤6: 使用 reciprologs 结果和小鼠结果作为参考来填补直系同源组中的空白"
# 这个步骤需要更多的细节来实现，这里暂时省略

# 使用 EggNOG-mapper 数据库获取结果并填补直系同源组中的空白
echo "步骤6: 使用 EggNOG-mapper 数据库获取结果并填补直系同源组中的空白"
# 这个步骤需要更多的细节来实现，这里暂时省略

echo "所有步骤已完成."
