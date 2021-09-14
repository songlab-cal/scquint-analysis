#cat gene_all_transcripts.gtf | sed 's/ENSMUST00000174008/a/g' > gene.gtf;
cp gene_all_transcripts.gtf gene.gtf

#python ../sashimi-plot.py -b bams.txt -c chr6:99329930-99608279 -g gene.gtf -o sashimi -P color.txt -O 3 -C 3 -M 400 --width=16 --ann-height=3.0 --height=2.0 --base-size=16 --alpha=1.0 -F png
#original python ../sashimi-plot.py -b bams.txt -c chr6:99259490-99309764  -g gene.gtf -o sashimi -P color.txt -O 3 -C 3 -M 200 --width=8 --ann-height=2.0 --height=2.0 --base-size=16 --alpha=1.0 -F pdf
#python ../sashimi-plot.py -b bams.txt -c chr6:99254340-99342119  -g gene.gtf -o sashimi -P color.txt -O 3 -C 3 -M 200 --width=8 --ann-height=2.0 --height=2.0 --base-size=16 --alpha=1.0 -F png
#python ../sashimi-plot.py -b bams.txt -c chr6:99159700-99346969 -g gene.gtf -o sashimi -P color.txt -O 3 -C 3 -M 400 --width=16 --ann-height=3.0 --height=2.0 --base-size=16 --alpha=1.0 -F png

#python ../sashimi-plot.py -b bams_split.txt -c chr6:99159700-99340000 -g gene.gtf -o sashimi -P color.txt -O 3 -C 3 -M 400 --width=16 --ann-height=3.0 --height=2.0 --base-size=16 --alpha=1.0 -F png
#python ../sashimi-plot.py -b bams_split.txt -c chr6:99259490-99309764 -g gene.gtf -o sashimi_new -P color.txt -O 3 -C 3 -M 400 --width=16 --ann-height=0.5 --height=2.0 --base-size=16 --alpha=1.0 -F png
#python ../sashimi-plot.py -b bams_split.txt -c chr6:99259590-99309064 -g gene.gtf -o sashimi_new -P color.txt -O 3 -C 3 -M 400 --width=8 --ann-height=0.5 --height=1.5 --base-size=16 --alpha=1.0 -F png
#python ../sashimi-plot.py -b bams_split.txt -c chr6:99159700-99340000 -g gene.gtf -o sashimi_shrinked -P color.txt -O 3 -C 3 -M 400 --width=10 --ann-height=3.0 --height=1.5 --base-size=16 --alpha=1.0 -F png --shrink
#python ../sashimi-plot.py -b bams.txt -c chr6:99159700-99340000 -g gene.gtf -o sashimi_shrinked_07_03_unique -P color.txt -O 3 -C 3 -M 400 --width=10 --ann-height=3.0 --height=1.5 --base-size=16 --alpha=1.0 -F png --shrink

python ../sashimi-plot.py -b bams.txt -c chr5:30924714-30928540 -g gene.gtf -o sashimi_shrinked -P color.txt -O 3 -C 3 -M 200 --width=5.0 --ann-height=1.0 --height=1.5 --base-size=14 --alpha=1.0 -F png --shrink
#python ../sashimi-plot.py -b bams.txt -c chr9:21615842-21633577 -g gene.gtf -o sashimi -P color.txt -O 3 -C 3 -M 400 --width=10 --ann-height=3.0 --height=1.5 --base-size=16 --alpha=1.0 -F png


# cat Foxp1_naive.bam | samtools view -h | awk '$6 ~ /N/ || $1 ~ /^@/' | samtools view -b - > Foxp1_naive_split.bam
