#!/bin/bash

# Identify each file in directory tree using Unix File


# **************
# USER I/O
# **************

# Check command line args
if [ "$#" -ne 2 ] ; then
  echo "Usage: filetree.sh rootDirectory outputFile" >&2
  exit 1
fi

if ! [ -d "$1" ] ; then
  echo "rootDirectory must be a directory" >&2
  exit 1
fi

# Root directory
rootDirectory="$1"

# Output file
outputFile="$2"

# Remove output files if it exists already (writing to them will be done in append mode!)

if [ -f $outputFile ] ; then
    rm $outputFile
fi

# **************
# MAIN PROCESSING LOOP
# **************

# Record time needed to process all files
time(
recurse() {
 for i in "$1"/*;do
    if [ -d "$i" ];then
        recurse "$i"
    elif [ -f "$i" ]; then
        # Run Tika
        result=$(file --mime-type "$i" 2>> stderr.txt)
        # Result to output file
        echo $result >> $outputFile
    fi
 done
}

recurse $rootDirectory

) 2> timeFile.txt

