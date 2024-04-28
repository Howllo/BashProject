#!/bin/bash

create_reports(){
	names="RandomNames.txt"
	paragraphs="RandomLatinParagraph.txt"
	credit_cards="CreditCard_Report.txt"
	low=0
	high=9
	count=0

	if [ -f "$credit_cards" ]; then
		rm "$credit_cards"
	fi

	touch "$credit_cards"

	read -p "How many credit reports you want to generate: " total_credit
	
	while [ $count -lt $total_credit ]; do
		# Reset the random number.
		credit_num=""
		
		# Reset the Name
		name=""
		
		# Reset the security number
		security_num=""

		# Get Random credit card numbers. 5555 5555 5555 5555
		for i in {1..16}; do
			number=$((low + RANDOM % (high-low+1)))
			credit_num="$credit_num$number"
			if [[ $((i % 4)) -eq 0 && $i -ne 16 ]]; then
				credit_num="$credit_num "
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
		
		# Get random paragraph.
		ran_para=$((1 + RANDOM % (15)))
		para=$(sed -n "${ran_para}p" "$paragraphs")
		
		# Get random date.
		random_year=$((25 + RANDOM % (28-25+1)))
		random_month=$((1 + RANDOM % (12)))
		date="$random_month/$random_year"
		
		# Pattern match credit card number.
		para=${para//'[credit card number]'/$credit_num}
		
		# Pattern match security code.
		para=${para//'[security code]'/$security_num}
		
		# Pattern match name.
		para=${para//'[name]'/$name}
		
		# Pattern match date.
		para=${para//'[date]'/$date}
		
		echo "$para" >> $credit_cards
		((count++))
	done
}

echo "Do you want to generate reports (y or n)?" 
read -r user_input

if [[ $user_input == "y" || $user_input == "yes" || $user_input == "Y" ]]; then
	create_reports
fi

exit 0 
