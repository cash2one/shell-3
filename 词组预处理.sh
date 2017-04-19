#关键词组合预处理

echo "#去重"
sort -u $1 -o $1

echo "#组合参数重新排列"
cat $1 | while read line
do
	echo ${line} |
	sed 's/+/\n/g' |
	sort -u |
	sed ':a;N;s/\n/+/;ba;'
done >> tmp

echo "#再次去重"
sort -u tmp -o tmp

echo "#去掉单个参数组合"
sed -i -r '/^[^+]+$/d' tmp

echo "#去掉包含组合"
cp tmp 2tmp
cat tmp | while read line
do
	grep "${line}" 2tmp | 
	head -1 >>result.txt && sed -i "/${line}/d" 2tmp
done

rm tmp 2tmp 2> /dev/null