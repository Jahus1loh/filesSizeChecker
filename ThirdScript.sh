while true; do
	MENU=("Name: $FILENAME" "Catalog: $CATALOG" "Extension: $EXTENSION" "Permissions: $PERMISSIONS" "Size: $SIZE" "File content: $CONTENT" "Search" "Finish")
	ANSWEAR=$(zenity --list --column=Menu "${MENU[@]}" --height 300)

	if [ "$ANSWEAR" == "Name: $FILENAME" ]; then
		FILENAME=$(zenity --forms --title "File name" --add-entry="File name")
		if [ "$FILENAME" != "" ]; then
			NAME_FIND="-type f -name "*$FILENAME*" "
		fi

	elif [ "$ANSWEAR" == "Catalog: $CATALOG" ]; then
                CATALOG=$(zenity --forms --title "Catalog name" --add-entry="Catalog name")

        elif [ "$ANSWEAR" == "Extension: $EXTENSION" ]; then
		EXTENSION=$(zenity --forms --title "File extension" --add-entry="File extension")
		if [ "$EXTENSION" != "" ]; then
			EXTENSION_FIND="-type f -name "*.$EXTENSION" "
		fi

	elif [ "$ANSWEAR" == "Permissions: $PERMISSION" ]; then
                PERMISSIONS=$(zenity --forms --title "File permissions" --add-entry="File permissions") 
		if [ "$PERMISSIONS" != "" ]; then
			PERMISSION_FIND="-perm $PERMISSIONS"
		fi

	elif [ "$ANSWEAR" == "Size: $SIZE" ]; then
		HEL_OPTIONS=("1. Larger" "2. Equal" "3. Lower")
		HEL=$(zenity --list --column=Menu "${HEL_OPTIONS[@]}" --height 300)
                SIZE=$(zenity --forms --title "File size" --add-entry="File size")
		
		if [ "$HEL" == "1. Larger" ]; then
			SIGN="+"
		elif [ "$HEL" == "2. Equal" ]; then
			SIGN=""
		elif [ "$HEL" == "3. Lower" ]; then
			SIGN="-"
		fi

		if [ "$SIZE" != "" ]; then
			SIZE_FIND="-type f -size $SIGN$SIZE"
		fi


	elif [ "$ANSWEAR" == "File content: $CONTENT" ]; then
		CONTENT=$(zenity --forms --title "Content of file" --add-entry="Content of file")
		if [ "$CONTENT" != "" ]; then
			CONTENT_FIND="-type f -exec grep -Ril $CONTENT {} + "
		fi

	elif [ "$ANSWEAR" == "Search" ]; then
		if [ "$CATALOG" == "" ]; then
			DICTONARY="./"
		else
			DICTONARY=$(find ./ -type d -name "$CATALOG")
		fi
	
		FINAL_COMMAND="find $DICTONARY $NAME_FIND $EXTENSION_FIND $PERMISSION_FIND $SIZE_FIND $CONTENT_FIND | zenity --list --title 'Search result' --text 'Finding all files matching criteria' --column 'Files'"
		eval "$FINAL_COMMAND"
	elif [ "$ANSWEAR" == "Finish" ]; then
		break;

	fi
done
