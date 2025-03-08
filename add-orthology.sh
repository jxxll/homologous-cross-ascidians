########## add reciprologs results
reciprologs -p 10 --chain -q 30 -o ab.txt --one_to_one --logging Aproteins.fasta Bproteins.fasta blastp

########## add eggnog-mapper results
### submit each species' protein sequences into http://eggnog-mapper.embl.de/ get the annotation results


##### give the create-orthology-list.sh results genesymbol,
##### then put the reciprologs and eggnog results as supplements
