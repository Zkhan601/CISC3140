BEGIN {
#field seperator
FS = ","
OFS = ","

}
#skip first row
NR>1{

#assign ranks. same sum same rank
if( sum != $5) 
	{i++}
	{sum = $5};

#print each row with the rank i
print i,$1,$2,$3,$4,$5
}
