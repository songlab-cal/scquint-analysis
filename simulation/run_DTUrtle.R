library(DTUrtle)

args = commandArgs(trailingOnly=TRUE)
gtf_path = args[1]
metadata_path = args[2]
output_path = args[3]

tx2gene <- import_gtf(gtf_file = gtf_path)
tx2gene <- move_columns_to_front(df = tx2gene, columns = c("transcript_id", "gene_id"))
print(tx2gene)

metadata = read.table(metadata_path, sep="\t", header=TRUE)
print(metadata)

files <- as.character(metadata$quant_path)
names(files) <- metadata$sample_id
print(files)

cts <- import_counts(files, type = "salmon", tx2gene=tx2gene[,c("transcript_id", "gene_id")])
print(dim(cts))

dturtle <- run_drimseq(
    counts = cts,
    tx2gene = tx2gene,
    pd=metadata,
    id_col = "sample_id",
    cond_col = "condition",
    cond_levels = c("a", "b"),
    filtering_strategy = "sc",
)
print(dturtle$used_filtering_options)
dturtle <- posthoc_and_stager(dturtle = dturtle, ofdr = 0.05, posthoc = 0.1)

res <- dturtle$FDR_table
print(res)

res$gene_id <- res$geneID
res$p_value_gene_adj <- res$gene
print(res)

res <- res[!duplicated(res$gene_id),]
print(res)

write.table(res, file = output_path, sep = "\t", quote = FALSE, row.names = FALSE)
