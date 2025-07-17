USERINPUT="0"
FILENAME=""
CATALOG=""
EXTENSION=""
PERMISSIONS=""
SIZE=""
HEL=""
DICTONARY=""
FINAL_COMMAND=""

while true; do

	echo "1. File name: $FILENAME"
	echo "2. Catalog: $CATALOG"
	echo "3. Extenstion: $EXTENSION"
	echo "4. Permissions: $PERMISSIONS"
	echo "5. Size: $SIZE"
	echo "6. File content: $CONTENT"
	echo "7. Search"
	echo "8. Finish"

	read USERINPUT

	if [ "$USERINPUT" == "1" ]; then
		echo "Enter the file name: "; read FILENAME;
		if [ "$FILENAME" != "" ]; then
			NAME_FIND="-type f -name "*$FILENAME*"	"
		fi
	elif [ "$USERINPUT" == "2" ]; then
		echo "Enter the catalog name: "; read CATALOG;
	elif [ "$USERINPUT" == "3" ]; then
		echo "Enter the extension of a file: "; read EXTENSION;
		if [ "$EXTENSION" != "" ]; then
			EXTENSION_FIND="-type f -name "*.$EXTENSION" "
		fi
	elif [ "$USERINPUT" == "4" ]; then
		echo "Enter the permissions of a file: "; read PERMISSIONS;
		if [ "$PERMISSIONS" != "" ]; then
			PERMISSION_FIND="-perm $PERMISSIONS"
		fi
	elif [ "$USERINPUT" == "5" ]; then
		echo "Enter if size of a file should be higher, equal or lower: ";
		echo "1. Higher"
		echo "2. Equal" 
		echo "3. Lower"; read HEL;
		echo "Enter the size of a file: "; read SIZE;

		if [ "$HEL" == "1" ]; then
			SIGN="+"
		elif [ "$HEL" == "2" ]; then
			SIGN=""
		elif [ "$HEL" == "3" ]; then
			SING="-"
		fi
		if [ "$SIZE" != "" ]; then
			SIZE_FIND="-type f -size $SIGN$SIZE" 	
		fi
		echo "$SIZE_FIND"
	elif [ "$USERINPUT" == "6" ]; then
		echo "Enter text to be found in a file: "; read CONTENT;
		if [ "$CONTENT" != "" ]; then
			CONTENT_FIND="-type f -exec grep -Ril $CONTENT {} + "
		fi
	elif [ "$USERINPUT" == "7" ]; then
		
		if [ "$CATALOG" == "" ]; then
			DICTONARY="./"
		else 
			DICTONARY=$(find ./ -type d -name "$CATALOG")
		fi
	 	
		FINAL_COMMAND="find $DICTONARY $NAME_FIND $EXTENSION_FIND $PERMISSION_FIND $SIZE_FIND $CONTENT_FIND"
		eval "$FINAL_COMMAND"

	elif [ "$USERINPUT" == "8" ]; then
		break
	fi
done

