BEGIN {
FS = ","
OFS = ","

print "New_Ranking,Ranking,Car_ID,Year,Car_Make,Car_Model,Total_Points"
}

{


if(make!= $4) {
	count = 1;
	make  = $4;};


if(count <= 3) {
	print count,$1,$2,$3,$4,$5,$6;
	 count++}
}
