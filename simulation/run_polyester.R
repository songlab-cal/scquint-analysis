library(polyester)
library(Biostrings)

args = commandArgs(trailingOnly=TRUE)
fasta_path = args[1]
params_path = args[2]
n_samples_per_group = strtoi(args[3])
seed = strtoi(args[4])
out_dir = args[5]
print(fasta_path)
print(seed)

fasta = readDNAStringSet(fasta_path)
params = read.table(params_path, header=TRUE, sep="\t")
print(head(params))

num_reps = c(n_samples_per_group, n_samples_per_group)
fold_changes = cbind(params$fold_change_a, params$fold_change_b)
readLength = 100
# readspertx = round(params$coverage * width(fasta) / readLength)
readspertx = ceiling(params$coverage * width(fasta) / readLength)
print(head(readspertx))
print(min(readspertx))
size = readspertx * params$size_fraction
print(head(size))


simulate_experiment(
    fasta_path, reads_per_transcript=readspertx, num_reps=num_reps,
    fold_changes=fold_changes, outdir=out_dir, seed=seed, error_rate=0.0,
    strand_specific=TRUE, gzip=TRUE, paired=TRUE, size=size
)