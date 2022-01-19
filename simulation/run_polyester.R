library(polyester)
library(Biostrings)

args = commandArgs(trailingOnly=TRUE)
fasta_path = args[1]
params_path = args[2]
n_samples_per_group = strtoi(args[3])
seed = strtoi(args[4])
group = args[5]
bias = args[6]
out_dir = args[7]
truncated_fasta_path = args[8]



if (group == "a") {
   num_reps = c(n_samples_per_group, 0)
   bias = "none"
} else if (group == "b") {
   num_reps = c(0, n_samples_per_group)
   seed = seed + 1
}
print(group)
print(num_reps)
print(bias)
print(seed)

if (bias == "cdnaf") {
   fasta_path  = truncated_fasta_path
}

fasta = readDNAStringSet(fasta_path)
print(width(fasta))
params = read.table(params_path, header=TRUE, sep="\t")

fold_changes = cbind(params$fold_change_a, params$fold_change_b)
readLength = 100
readspertx = ceiling(params$coverage * width(fasta) / readLength)
size = readspertx * params$size_fraction


simulate_experiment(
    fasta_path, reads_per_transcript=readspertx, num_reps=num_reps,
    fold_changes=fold_changes, outdir=out_dir, seed=seed, error_rate=0.0,
    strand_specific=TRUE, gzip=TRUE, paired=TRUE, size=size, bias=bias
)
