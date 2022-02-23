BEGIN{FS = ","
	print "Car_ID,Year,Car_Make,Car_Model,Total_Points,Ranking"
}
#BODY
{
	if (NR>1) {
		total = 0
		for (i = 8; i <= NF; ++i) {
			total += $i
		}
        	print $7 "|" $4 "|" $5 "|" $6 "|" total;
	}
}
END{}
