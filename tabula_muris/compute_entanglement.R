suppressPackageStartupMessages(library("dendextend"))

args <- commandArgs(trailingOnly=TRUE)
inpath1 = args[1]
inpath2 = args[2]
colorpath = args[3]
outpath1 = args[4]
outpath2 = args[5]

X1 = read.table(inpath1, header=TRUE, row.names=1, sep="\t")
X2 = read.table(inpath2, header=TRUE, row.names=1, sep="\t")
colors = read.table(colorpath, header=FALSE, comment.char="")$V1
print(colors)
#stop("debug")

make_dendrogram <- function(X) {
  X %>%
  dist() %>%
  hclust() %>%
  as.dendrogram()
}

dend1 <- make_dendrogram(X1)
colors1 = colors[order.dendrogram(dend1)]
print(colors1)
dend1 = color_labels(dend1, col=colors1)
dend2 <- make_dendrogram(X2)
colors2 = colors[order.dendrogram(dend2)]
dend2 = color_labels(dend2, col=colors2)
dend12 <- dendlist(dend1, dend2)
dend12 <- untangle(dend12, method="step2side")

#dend1
#print(dend12)
#print(dend12[1])
#print(dend12[2])

res <- entanglement(dend12)
write(res, file=outpath1)
print(res)

svg(file=outpath2, width = 10, height = 7)  # default is 7 for both
tanglegram(
  dend12,
  main_left = "Expression",
  main_right = "Splicing",
  common_subtrees_color_lines = FALSE, highlight_distinct_edges  = FALSE, highlight_branches_lwd = FALSE,
  sort = TRUE,
  columns_width = c(5, 2, 5),
  margin_inner = 18.5,
)
dev.off()
