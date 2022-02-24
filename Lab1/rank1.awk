BEGIN{FS = ","
      OFS = ","
}

	NR>1{
		for (i = 8; i <= NF; ++i) {
			total += $i
		}
        	print $7,$4,$5,$6,total;
		total=0;
	}
END{}
