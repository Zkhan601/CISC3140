BEGIN {

FS = ","
OFS = ","

}
NR>1{

if( sum != $5) 
	{i++}
	{sum = $5};

print i,$1,$2,$3,$4,$5
}
