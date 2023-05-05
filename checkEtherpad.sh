#!/bin/bash


shapeFile="skos.shacl.ttl"
shapeUrl="https://raw.githubusercontent.com/skohub-io/shapes/main/skos.shacl.ttl"

if [ -e "$shapeFile" ]; then
  echo "File $shapeFile exists"
else
  echo "File $shapeFile does not exist"
  echo "Downloading $shapeFile from $shapeUrl"
  curl -s -O "$shapeUrl"
fi

while true; do

  echo "Enter a URL:"
  read url

  # Create a temporary file
  temp_file=$(mktemp --suffix=.ttl)

  output=$(curl -s ${url}/export/txt > $temp_file )

  riot --syntax=ttl --validate $temp_file
  shacl validate --shapes $shapeFile --data $temp_file

  # Remove the temporary file
  rm $temp_file

  echo "Do you want to run the script again? [y/n]"
  read answer

  if [ "$answer" != "y" ]; then
    break
  fi
done
