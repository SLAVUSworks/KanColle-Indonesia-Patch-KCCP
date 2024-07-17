#!/bin/bash


version_file_name="version.json"

diff="diff.txt"



if [ ! -f "$diff" ]; then
    echo "File diff.txt tidak ada!" >&2
    exit 1
fi

if [ ! -s "$diff" ]; then
    echo "File diff.txt kosong!" >&2
    exit 1
fi

arrayFromFile=()
listDel=()
listAdd=()

echo "Masukan versi yang baru: "
read version


# Membuat sebuah list ke dalam arrayFromFile
while IFS= read -r path || [ -n "$path" ]; do
    arrayFromFile+=("$path")
done < "$diff"

# Memproses setiap baris dari arrayFromFile
for line in "${arrayFromFile[@]}"; do
    type=$(echo "$line" | awk '{print $1}')
    file=$(echo "$line" | awk '{print $2}')

    if [ "$type" == "D" ]; then
        listDel+=("\"$file\"")
    elif [ "$type" == "A" -o "$type" == "M" ]; then
        listAdd+=("\"$file\"")
    fi
done

# Buat separator setiap nama path dengan separator "," 
strDel=$(IFS=,;echo "${listDel[*]}")
strAdd=$(IFS=,;echo "${listAdd[*]}")

# buat object 
objects="{\"version\": \"$version\", \"del\": ["$strDel"], \"add\": ["$strAdd"]}"

# simpan object menjadi file
echo "$objects" > new_object.json

jq '. += [inputs]' version-dev.json new_object.json > temp.json && mv temp.json version-dev.json

rm new_object.json
