BEGIN {

#Field seperator
FS = ","
OFS = ","

#heading
print "New_Ranking,Ranking,Car_ID,Year,Car_Make,Car_Model,Total_Points"
}

{

#resets count to 1 when theres a new car
if(make!= $4) {
	count = 1;
	make  = $4;};

#prints the top 3 ranks of each car numbered 1-3
if(count <= 3) {
	print count,$1,$2,$3,$4,$5,$6;
	 count++}
}
