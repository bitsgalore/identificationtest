#!/bin/bash

# Identify each file in directory tree using Apache Tika running in server mode
# Before running this script you first need to start Tika in server mode, e.g.:
#
# java -jar /home/johan/tika/tika-app-1.5.jar -d --server --port 12345
#
# Problem: randomly the Tika server doesn't return any result, no idea why!
# Better try something based on this: http://wiki.apache.org/tika/TikaJAXRS

# **************
# CONFIGURATION
# **************

port="12345" 

# **************
# USER I/O
# **************

# Check command line args
if [ "$#" -ne 2 ] ; then
  echo "Usage: tikatree.sh rootDirectory outputFile" >&2
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
        # Send file to Tika
        result=$(nc 127.0.0.1 $port < "$i" 2>> stderr.txt)
        # Result to output file
        echo $i": "$result >> $outputFile
    fi
 done
}

recurse $rootDirectory

) 2> timeTikaserver.txt

