#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage : ./output2xml.sh output.txt output.xml"
    exit 1
fi

#create empty file (overwrite if it exists!)
> $2

#append declaration to xml file
echo '<!-- This XML declaration can be simply copied and is necessary for all longtail. -->' >> $2
echo '<?xml version="1.0" encoding="UTF-8"?>' >> $2
echo '<add allowDups="true">' >> $2
printf "\n" >> $2

echo '<!-- Each result is contained inside a <doc> element. -->' >> $2
#read each line of the fathead output.txt file
while IFS='' read -r line || [[ -n "$line" ]]; do
  
  #split line into an indexed array of words
  read -a line
  

  #start result definition inside <doc> element
  echo '<doc>' >> $2
  #write title
  echo '<!-- The title field is used in the zeroclickinfo header, and is the heaviest weighted string used for query matching. -->' >> $2
  echo '<!-- The CDATA entity is used for all content that might contain unsafe data -->' >> $2
  echo '<field name="title"><![CDATA['${line[0]}']]></field>' >> $2
  #write lx_sec fields
  #echo '<!-- The lx_sec fields are also used for query matching, with decreasing precedence. They can be omitted. -->' >> $2
  #echo '<field name="l2_sec"><![CDATA[]]></field>' >> $2
  #echo '<field name="l3_sec"><![CDATA[]]></field>' >> $2
  #echo '<field name="l4_sec"><![CDATA[]]></field>' >> $2
  #write paragraph field
  echo '<!-- The paragraph field contains the text/HTML that will be displayed inside the zeroclickinfo box. -->' >> $2
  echo '<field name="paragraph"><![CDATA['${line[2]}']]></field>' >> $2
  #write p_count field
  #echo '<!-- The p_count field is used to break ties on exact title matches. This should be used when the data is too long to be displayed without being broken into separate paragraphs. It can be omitted. -->' >> $2
  #echo '<field name="p_count">1</field>' >> $2
  #write source field
  echo '<!-- The source should match the ID from the instant answer page you created - https://duck.co/ia/dev/pipeline -->' >> $2
  echo '<field name="source"><![CDATA['${line[3]}']]></field>' >> $2
  #close doc element
  echo '</doc>' >> $2
  printf "\n" >> $2
done < "$1"