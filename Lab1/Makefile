lab1:
	awk -f rank1.awk data_lab1/data.csv | sort -t, -k5rn >output.csv 
	awk -f rank2.awk output.csv
	awk -f rank2.awk output.csv |sort -t, -k4,4 -k1n,1 >output2.csv								
	awk -f top3.awk output2.csv > Top3.csv 
