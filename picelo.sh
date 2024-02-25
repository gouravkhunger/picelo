#!/bin/bash

function compress_image() {
  suffix=$(echo "$1" | sed "s|^$init_folder||")
  local path="$init_folder/assets/images$suffix"

  mkdir -p "$(dirname $path)"

  if [[ "$file" =~ \.(gif)$ || "$url" =~ \.gif$ ]]; then
    gif2webp -q 80 -quiet "$1" -o "${path%.*}.webp"
  else
    cwebp -q 80 -quiet "$1" -o "${path%.*}.webp"
  fi

  return
}

function loop_files() {
    local init_folder="$1"
    local skip_pattern="$2"

    for file in *; do
        if [[ "$file" =~ $skip_pattern ]]; then
            continue
        fi

        if [ -d "$file" ]; then
            cd "$file"
            loop_files "$init_folder" "$skip_pattern"
            cd ..
        else
            if [[ "$file" =~ \.(jpg|jpeg|png|gif)$ ]]; then
              echo "processing $file"
              compress_image "$(pwd)/${file}"
            fi

            if [[ "$file" =~ \.(htm|html|md|mdx)$ ]]; then
              echo "processing $file"
              grep -Eo '(http|https)://[^)"]+\.(png|jpg|jpeg|gif)' "$file" | sed 's/#.*//' | sort -u | while read url; do
                url=$(curl -sd "link=$url&concise=true" https://deref.gourav.sh/api)

                extension="${url##*.}"
                path=$(echo "$(pwd)/$file" | grep -o '^[^.]*')

                filename=$(basename "$url" | sed 's/\.[^.]*$//')
                newPath="$path/$filename.$extension"

                local relativePath=$(echo "$newPath" | sed "s|^$init_folder||")
                if [ ! -f "$init_folder/assets/images${relativePath%.*}.webp" ]; then
                  curl -sS "$url" -o "$newPath" --create-dirs
                  compress_image "$newPath"
                  rm -rf "$path"
                else
                  echo "    $filename.$extension already processed"
                fi
              done
            fi
        fi
    done
}

while getopts "e:" opt; do
  case $opt in
    e) skip_pattern="$OPTARG";;
    \?) exit 1;;
  esac
done

echo "Current directory: $(pwd)"
echo ""
loop_files "$(pwd)" "$skip_pattern"
