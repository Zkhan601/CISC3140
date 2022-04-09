BEGIN{
#field seperator
      FS = ","
      OFS = ","
}
#skip first row
	NR>1{
	#sums up the total from column 8 and on
		for (i = 8; i <= NF; ++i) {
			total += $i
		}
		#prints the total and resets to 0
        	print $7,$4,$5,$6,total;
		total=0;
	}
END{}
