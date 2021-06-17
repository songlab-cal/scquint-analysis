suppressPackageStartupMessages(library("dendextend"))

args <- commandArgs(trailingOnly=TRUE)
inpath1 = args[1]
scale1 = args[2]
inpath2 = args[3]
scale2 = args[4]
outpath = args[5]

X1 = read.table(inpath1, header=TRUE, row.names=1, sep="\t")
X2 = read.table(inpath2, header=TRUE, row.names=1, sep="\t")

make_dendrogram <- function(X, scale) {
  if (scale) {
    X %>%
    scale() %>%
    dist() %>%
    hclust() %>%
    as.dendrogram()
  } else {
    X %>%
    dist() %>%
    hclust() %>%
    as.dendrogram()
  }
}

dend1 <- make_dendrogram(X1, scale1)
dend2 <- make_dendrogram(X2, scale2)
dend12 <- dendlist(dend1, dend2)
res <- entanglement(untangle(dend12, method="step2side"))
write(res, file=outpath)
