#!/bin/bash
printf "\xEF\xBB\xBF长尾词,标题,描述,大类,小类" >shell已分类.csv
printf "\xEF\xBB\xBF" >shell无分类.csv

iconv -f GBK -t UTF-8 $1 >WENTI

cat 词根.txt | while read line
do
A=(`echo $line | sed 's/,/ /g'`)
CIGEN=${A[0]}
grep $CIGEN WENTI | 
sed -r "s/^/${A[1]},${A[2]},/g" |
awk -F, '{print $3,$4," ",$1,$2}' OFS="," >>shell已分类.csv
sed -i "/${CIGEN}/d" WENTI
done 

cat WENTI >>shell无分类.csv