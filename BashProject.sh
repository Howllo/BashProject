#!/bin/bash

# Global Variables
report=""
name=""
dir="Credit_Reports"
filename=""
fileprefix="Redacted"
newfile=""

if [ ! -d "$dir" ]; then
	mkdir "$dir"
fi

# Create the files for the report with all needed information.
create_report(){
	paragraphs="RandomLatinParagraph.txt"

	# Get random name.
	ran_name=$((1 + RANDOM % (1000)))
	name=$(sed -n "${ran_name}p" "$names")
	
	# Create User Credit Report
	report="$name$credit_cards"
	report="${report// /_}"
	filename=$report
	# Create file.
	touch "$report"
	
	# Get Random Report
	random_report=$((1 + RANDOM % (5)))
	temp_report="Credit_Report$random_report.txt"
	
	# Copy original into new.
	cat $temp_report >> $report
}

redact_report(){
	newFile=$fileprefix$filename
	# Searches for and Redacts the credit card numbers in a new file.
	sed -E "s/([0-9]{4}[ ]){3}[0-9]/XXXX XXXX XXXX XXXX/g" $filename >> $newFile

	# Redacts the Security Code in the new file
	sed -E -i "s/[ ][0-9]{3}/ XXX/g" $newFile

	# Redacts the Expiration Date in the new file
	sed -E -i "s:[0-9][/][0-9]{2}:XX/XX:g" $newFile 
}

# Generate the report with all the data, Credit Card number, 
# expiration date, and security code.
# Replace all the temp data in template with actual data.
generate_report(){
	names="RandomNames.txt"
	credit_cards="CreditCard_Report.txt"
	low=0
	high=9
	count=0

	if [ -f "$credit_cards" ]; then
		rm "$credit_cards"
	fi

	read -p "How many credit reports you want to generate: " total_credit
	
	while [ $count -lt $total_credit ]; do
		# Reset the random number.
		credit_num=""
		
		# Reset Report
		report=""
		
		# Reset the Name
		name=""
		
		# Reset the security number
		security_num=""
		
		# Reset fileName
		fileName=""

		# Create the report file.
		create_report

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
		
		# Get random date. 9/99
		random_year=$((25 + RANDOM % (28-25+1)))
		random_month=$((1 + RANDOM % (12)))
		date="$random_month/$random_year"
		
		# Get random paragraph.
		ran_para=$((1 + RANDOM % (15)))
		para=$(sed -n "${ran_para}p" "$paragraphs")
		
		# Add Paragraph to report.
		echo "$para" >> $report
		
		# Pattern match credit card number.
		sed -i "s/\[credit card number\]/$credit_num/g" "$report"
		
		# Pattern match security code.
		sed -i "s/\[security code\]/$security_num/g" "$report"
		
		# Pattern match name.
		sed -i "s/\[name\]/$name/g" "$report"
		
		# Pattern match date.
		sed -i "s|\[date\]|$date|g" "$report"
		
		# The Redacted file is created
		redact_report

		# Move the finished reports.
		mv $report $dir
		mv $newFile $dir
		
		((count++))
	done
}

echo "Do you want to generate reports (y or n)?" 
read -r user_input

if [[ $user_input == "y" || $user_input == "yes" || $user_input == "Y" ]]; then
	generate_report
fi

exit 0 
