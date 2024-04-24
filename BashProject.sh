#!/bin/bash

names="RandomNames.txt"
credit_cards="RandomCreditCard.txt"
random_number=""
security_num=""
name=""
low=0
high=9
count=0

if [ -f "$credit_cards" ]; then
	rm "$credit_cards"
fi

touch "$credit_cards"

read -p "How many credit cards do you want to create: " total_credit

while [ $count -lt $total_credit ]; do
	# Reset the random number.
	random_number=""
	
	# Reset the Name
	name=""
	
	# Reset the security number
	security_num=""

	# Get Random credit card numbers. 5555 5555 5555 5555
	for i in {1..16}; do
		number=$((low + RANDOM % (high-low+1)))
		random_number="$random_number$number"
		if [ $((i % 4)) -eq 0 ]; then
			random_number="$random_number "
		fi
	done

	# Create random security code ex. 555.
	for i in {1..3}; do
		number=$((low + RANDOM % (high-low+1)))
		security_num="$security_num$number"
	done
	
	# Get random name.
	ran_name=$((1 + RANDOM % (1000)))
	name=$(sed -n "${ran_name}p" "$names")
	
	echo "Name: $name" >> $credit_cards
	echo "Credit Card Number: $random_number" >> $credit_cards
	echo "Security: $security_num" >> $credit_cards
	echo " " >> $credit_cards
	((count++))
done

exit 0 
