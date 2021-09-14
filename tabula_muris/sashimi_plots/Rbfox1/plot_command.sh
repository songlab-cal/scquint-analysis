grep '230658' gene_all_transcripts.gtf | sed 's/ENSMUST00000230658/a/g' > gene.gtf;
python ../sashimi-plot.py -b bams.txt -c chr16:5763013-6174005 -g gene.gtf -P color.txt -o sashimi_shrinked -O 3 -C 3 -M 400 --width=6 --ann-height=0.3 --height=1.0 --base-size=10 --alpha=1.0 -F png --shrink
# intron: chr16:5763913-6173605
#python ../sashimi-plot.py -b bams.txt -c chr16:5756708-6179278 -g gene.gtf -P color.txt -o sashimi_shrinked -O 3 -C 3 -M 400 --width=10 --ann-height=1.0 --height=1.0 --base-size=10 --alpha=1.0 -F png --shrink
