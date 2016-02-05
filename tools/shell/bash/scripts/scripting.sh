#for loop that outputs 1 2 3 4 5 6 7 8 9 10 a b c
for i in {1..10} a b c
do
	echo $i
done

#conditional testing for an empty string
foo="bar"
if [ -z "$foo" ]; then
	echo $foo
fi

#conditional testing equal stings
if [ "$foo" == "bar" ]; then
	echo $foo
fi

#conditional testing numeric values
if [ 1 -eq 2 ]; then
	echo $foo
fi

#Example function
foobar(){
	echo $1
}
foobar "this echos this statement"

