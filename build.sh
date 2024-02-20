shopt -s globstar


NOTES_FILE=notes.txt
VERSION_FILE=__version__

echo "--- RESOURCES ---" > $NOTES_FILE

count=0

for _ in ./**/*.pdf; do
    count=$(expr $count + 1)
done

total=$count
count=0

for file in ./**/*.pdf; do
    filename="${file##*/}"
    filepath="${file%/*}"
    echo "$filepath $((++count))/$total"
    if [ ! -d "$filepath/thumbs" ]; then
        mkdir "$filepath/thumbs"
    fi
    
    convert "$file"[0] -background white -alpha remove -thumbnail x150 -gravity north -extent x150 -crop 90%x+0+0 "$filepath/thumbs/$filename.jpg"
done

#for file in ./**/*.{pdf,jpg}; do
git reset .
git add .
git ls-files | while read -r file; do
  if [[ "$file" == *.pdf ]]; then
    echo "$file" >> "$NOTES_FILE"
  fi
done

echo $(date +%s) > __version__
