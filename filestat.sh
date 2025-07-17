MIN_SIZE_DOC="10000000000"

MIN_SIZE_IMG="10000000000"

MIN_SIZE_MUSIC="10000000000"

MIN_SIZE_OTHER="10000000000"

MIN_SIZE_VIDEO="10000000000"

FILE_SIZE="0"

USERINPUT=""


Help () {
	# Display Help
	echo "Help"
	echo "Available options:"
	echo "-d	print info about document files"
	echo "-g	print info about graphic files"
	echo "-o	print info about other files"
	echo "-p	print info about video files"
	echo "-a	print info about audio files"
}

Invalid () {
	# Display that you chose invalid option
	echo "You have entered an invalid option."
}

Version () {
	# Display current version of a program
	echo "Version 1.0.2"
	echo "Author: Jan Pastucha s193662"
}

print_results () {
	echo -n "Average size of $1 files: "				# print line without going to the next one
	echo "$2" | numfmt --to=iec-i --suffix=B --format="%9.2f"	# print second argument and transform it to human readable format
	echo -n "Maximum size of $1 files: "
	echo "$3" | numfmt --to=iec-i --suffix=B --format="%9.2f"	# print third argument and transform it to human readable format
	if [ "$4" == "10000000000" ]; then
		echo -n "Minimus size of $1 files: 0B"
	else
		echo -n "Minimum size of $1 files: "
	fi
	echo "$4" | numfmt --to=iec-i --suffix=B --format="%9.2f"	# print fourth argument and transform it to human readable format
	echo -n "Median size of $1 files:  "
	echo "$5" | numfmt --to=iec-i --suffix=B --format="%9.2f"	# print fifth argument and transform it to human readable format
	echo " "
}

median () {
	arr=($(printf '%d\n' "${@}" | sort -n)) # add sorted values given as arguments of function to arr
	nel=${#arr[@]}													# number of elements in array
	if (( $nel % 2 == 1 )); then     				# odd number of elements
   		val="${arr[ $(($nel/2)) ]}"					# set val to value in the middle
 	else                            				# even number of elements
   		(( j=nel/2 ))												#
   		(( k=j-1 ))
    		(( val=(${arr[j]} + ${arr[k]})/2 ))
  	fi
 	echo $val
}

# arrays containing names of possible file types
document_types=(ASCII CSV data OpenDocument PHP JSON C++ HTML Java pdf)
graphic_types=(JPEG PNG GIF)
music_types=(Audio)
video_types=(ISO)

document_sizes=()
graphic_sizes=()
music_sizes=()
video_sizes=()
other_sizes=()

echo "Provide a directory path: (if not provided the current directory will be searched)"
read USERINPUT

if [ "$USERINPUT" == "" ]; then
	 CURRENT_DIR=$(pwd)
elif [ ! -d "$USERINPUT" ]; then
	 echo "Directory $USERINPUT DOES NOT exists."
	 CURRENT_DIR=$(pwd)
else
	 CURRENT_DIR="$USERINPUT"
fi

subdircount=$(find $CURRENT_DIR -maxdepth 1 -type d | wc -l)

if [[ "$subdircount" -eq 1 ]]
then
    SUB_DIR=""
else
		SUB_DIR="$CURRENT_DIR/**/*"				# set sub directory variable to path/to/current/directory/**/*
fi

CURRENT_DIR="$CURRENT_DIR/*"			# set current directory variable to path/to/current/directory/*
echo " "
for FILE in $CURRENT_DIR $SUB_DIR;		# iterate through every file in a directory
do

	FILE_SIZE=$(du -k $FILE | cut -f -1)		# determine the file size and cut its name
	FILE_SIZE=$[$FILE_SIZE * 1024]
	FILE_TYPE=$(file $FILE | cut -d ":" -f 2 | cut -d " " -f 2)     # check file type by file command and cut it so it has only 1st word of name

	if [[ " ${music_types[*]} " =~ " ${FILE_TYPE} " ]]; then	# check if file type is in music types array

			if [[ "$FILE_SIZE" -gt "$MAX_SIZE_MUSIC" ]]; then        # check if file size is greater than max
	    	MAX_SIZE_MUSIC="$FILE_SIZE"
			elif [[ "$FILE_SIZE" -lt "$MIN_SIZE_MUSIC" ]]; then 	# check if file size is smaller than min
	    	MIN_SIZE_MUSIC="$FILE_SIZE"
	  	fi

	   	SUM_MUSIC=$[$SUM_MUSIC + $FILE_SIZE]			# add file size to sum of all music files sizes
			COUNT_MUSIC=$[$COUNT_MUSIC + 1]				# add 1 to count of music files
			AVERAGE_MUSIC=$[$SUM_MUSIC / $COUNT_MUSIC]		# count average of music files

			music_sizes+=( $FILE_SIZE )

	elif [[ " ${document_types[*]} " =~ " ${FILE_TYPE} " ]]; then	# check if file type is in document types array

			if [[ "$FILE_SIZE" -gt "$MAX_SIZE_DOC" ]]; then	# check if file size is greater than max
				MAX_SIZE_DOC="$FILE_SIZE"
			elif [[ "$FILE_SIZE" -lt "$MIN_SIZE_DOC" ]]; then	# check if file size is smaller than min
				MIN_SIZE_DOC="$FILE_SIZE"
			fi

			SUM_DOC=$[$SUM_DOC + $FILE_SIZE]			# add file size to sum of all document files sizes
	    COUNT_DOC=$[$COUNT_DOC + 1]				# add 1 to count of document files
			AVERAGE_DOC=$[$SUM_DOC / $COUNT_DOC]			# count average of document files

			document_sizes+=( $FILE_SIZE )

	elif [[ " ${graphic_types[*]} " =~ " ${FILE_TYPE} " ]]; then	# check if file type is in graphic types array

			if [[ "$FILE_SIZE" -gt "$MAX_SIZE_IMG" ]]; then
	            MAX_SIZE_IMG="$FILE_SIZE"
	    elif [[ "$FILE_SIZE" -lt "$MIN_SIZE_IMG" ]]; then
	            MIN_SIZE_IMG="$FILE_SIZE"
	    fi

	 		SUM_IMG=$[$SUM_IMG + $FILE_SIZE]
	 		COUNT_IMG=$[$COUNT_IMG + 1]
			AVERAGE_IMG=$[$SUM_IMG / $COUNT_IMG]

			graphic_sizes+=( $FILE_SIZE )

	elif [[ " ${video_types[*]} " =~ " ${FILE_TYPE} " ]]; then

	    if [[ "$FILE_SIZE" -gt "$MAX_SIZE_VIDEO" ]]; then
	            MAX_SIZE_VIDEO="$FILE_SIZE"
	   	elif [[ "$FILE_SIZE" -lt "$MIN_SIZE_VIDEO" ]]; then
	         	MIN_SIZE_VIDEO="$FILE_SIZE"
	   	fi

	   	SUM_VIDEO=$[$SUM_VIDEO + $FILE_SIZE]
	    COUNT_VIDEO=$[$COUNT_VIDEO + 1]
	    AVERAGE_VIDEO=$[$SUM_VIDEO / $COUNT_VIDEO]

			video_sizes+=( $FILE_SIZE )

	elif [ "$FILE_TYPE" == "directory" ]; then
			continue
	else

			if [[ "$FILE_SIZE" -gt "$MAX_SIZE_OTHER" ]]; then
	           	MAX_SIZE_OTHER="$FILE_SIZE"
	   	elif [[ "$FILE_SIZE" -lt "$MIN_SIZE_OTHER" ]]; then
	           	MIN_SIZE_OTHER="$FILE_SIZE"
	   	fi

	   	SUM_OTHER=$[$SUM_OTHER + $FILE_SIZE]
	   	COUNT_OTHER=$[$COUNT_OTHER + 1]
	    AVERAGE_OTHER=$[$SUM_OTHER / $COUNT_OTHER]

			other_sizes+=( $FILE_SIZE )

	fi

done;
clear

calc_median () {
		if [ ${#document_sizes[@]} -gt 0 ]; then
			MEDIAN_DOC=$(median "${document_sizes[@]}")
		fi
		if [ ${#music_sizes[@]} -gt 0 ]; then
			MEDIAN_MUSIC=$(median "${music_sizes[@]}")
		fi
		if [ ${#graphic_sizes[@]} -gt 0 ]; then
			MEDIAN_graphic=$(median "${graphic_sizes[@]}")
		fi
		if [ ${#video_sizes[@]} -gt 0 ]; then
			MEDIAN_VIDEO=$(median "${video_sizes[@]}")
	 	fi
		if [ ${#other_sizes[@]} -gt 0 ]; then
			MEDIAN_OTHER=$(median "${other_sizes[@]}")
		fi
}




PrintDocument () {
	calc_median
	if [ ${#document_sizes[@]} -gt 0 ]; then
  	print_results "document" $AVERAGE_DOC $MAX_SIZE_DOC $MIN_SIZE_DOC $MEDIAN_DOC
	fi
}

PrintImg () {
	calc_median
	if [ ${#graphic_sizes[@]} -gt 0 ]; then
  	print_results "graphic" $AVERAGE_IMG $MAX_SIZE_IMG $MIN_SIZE_IMG $MEDIAN_graphic
	fi
}

PrintMusic () {
	calc_median
	if [ ${#music_sizes[@]} -gt 0 ]; then
  	print_results "music" $AVERAGE_MUSIC $MAX_SIZE_MUSIC $MIN_SIZE_MUSIC $MEDIAN_MUSIC
	fi
}

PrintVideo () {
	calc_median
	if [ ${#video_sizes[@]} -gt 0 ]; then
  	print_results "video" $AVERAGE_VIDEO $MAX_SIZE_VIDEO $MIN_SIZE_VIDEO $MEDIAN_VIDEO
	fi
}

PrintOther () {
	calc_median
	if [ ${#other_sizes[@]} -gt 0 ]; then
		print_results "other" $AVERAGE_OTHER $MAX_SIZE_OTHER $MIN_SIZE_OTHER $MEDIAN_OTHER
	fi
}

PrintAll () {
	calc_median

	if [ ${#document_sizes[@]} -gt 0 ]; then
  	print_results "document" $AVERAGE_DOC $MAX_SIZE_DOC $MIN_SIZE_DOC $MEDIAN_DOC
	fi
	if [ ${#graphic_sizes[@]} -gt 0 ]; then
		print_results "graphic" $AVERAGE_IMG $MAX_SIZE_IMG $MIN_SIZE_IMG $MEDIAN_graphic
	fi
	if [ ${#music_sizes[@]} -gt 0 ]; then
		print_results "music" $AVERAGE_MUSIC $MAX_SIZE_MUSIC $MIN_SIZE_MUSIC $MEDIAN_MUSIC
	fi
	if [ ${#video_sizes[@]} -gt 0 ]; then
		print_results "video" $AVERAGE_VIDEO $MAX_SIZE_VIDEO $MIN_SIZE_VIDEO $MEDIAN_VIDEO
	fi
	if [ ${#other_sizes[@]} -gt 0 ]; then
		print_results "other" $AVERAGE_OTHER $MAX_SIZE_OTHER $MIN_SIZE_OTHER $MEDIAN_OTHER
	fi
}

while getopts hvftaiop:q OPT; do
        case $OPT in
                h) Help;;
                v) Version;;
                d) PrintDocument;;
                g) PrintImg;;
                o) PrintOther;;
                p) PrintVideo;;
                m) PrintMusic;;
                \? ) Invalid;;
        esac
done

if [ $OPTIND -eq 1 ]; then
	PrintAll
fi
