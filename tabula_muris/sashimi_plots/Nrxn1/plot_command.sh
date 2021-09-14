grep '177342\|174331' gene_all_transcripts.gtf | sed 's/ENSMUST00000174331/a/g' | sed 's/ENSMUST00000177342/b/g' > gene.gtf;
python ../sashimi-plot.py -b bams.txt -c chr17:90597361-90623749 -g gene.gtf -P color.txt -o sashimi_shrinked -O 3 -C 3 -M 20 --width=3 --ann-height=0.8 --height=1.0 --base-size=9 --alpha=1.0 -F png --shrink
