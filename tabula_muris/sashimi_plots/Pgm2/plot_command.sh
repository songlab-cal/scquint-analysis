grep '87324' gene_all_transcripts.gtf | sed 's/ENSMUST00000087324/a/g' > gene.gtf;
python ../sashimi-plot.py -b bams.txt -c chr5:64092866-64097212 -g gene.gtf -P color.txt -o sashimi_shrinked -O 3 -C 3 -M 10 --width=3.1 --ann-height=0.5 --height=1.0 --base-size=9 --alpha=1.0 -F png --shrink
