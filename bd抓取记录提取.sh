#!/bin/bash
rm rst.log &>/dev/null
dos2unix $1 &>/dev/null
sed -i -r 's/https*:\/\///g' $1
for i in `cat $1`
do
A=(`echo $i | sed 's/com/com /g'`)
R1=`zgrep -a "^${A[0]}.*${A[1]}" $2 | head -1`
if [[ $R1 != "" ]]
then
	echo `echo $R1 | awk '{print $10}'`",${i}" >>rst.log
else
	echo "未抓取,${i}" >>rst.log
fi
done

awk -F, '{print $1}' rst.log | sort | uniq -c | sort -r