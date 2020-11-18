#!/bin/bash

VAR=$(cat years.txt)
URL="https://raw.githubusercontent.com/JeffSackmann/tennis_atp/master/atp_matches_"

for i in ${VAR}
  do
	echo "(o) Download dataset year: ${i}"
	wget ${URL}${i}.csv
	echo "(o) Done downloading year: ${i}"

  done
