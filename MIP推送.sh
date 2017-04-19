# MIP页面推送脚本
# 更新，MIP不支持单个单个推送，不用持续运行脚本了，每天整理好发布的新闻，保存为urls.txt文件，一次性推送

if [[ -e posted ]]
then
	sleep 0.5
else
	touch posted
fi

echo '---采集近期发布文章'
for page in `seq 10`
do
	curl -s "http://m.to8to.com/mip/?page=${page}" |
	grep 'm.to8to.com/mip/article' |
	sed -r 's/^.*(m.to8to.com.*?html).*$/http:\/\/\1/g' >> news
done

echo '---剔除已推送URL'
sort -o posted posted
sort -o news news
comm -13 posted news >>urls
#cat news | while read url
#do
#	PUSHSTATU=`grep -c ${url} posted`
#	if [[ ${PUSHSTATU} != 0 ]]
#	then
#		continue
#	else
#		echo "${url}" >>urls
#	fi
#done
rm news

echo '--推送'
MSG=`curl -s -H 'Content-Type:text/plain' --data-binary @urls "http://data.zz.baidu.com/urls?site=m.to8to.com&token=VzF8UZfWVdwKGYuR&type=mip"`
STATU=`echo ${MSG} | grep -c 'success'`
if [[ ${STATU} == 1 ]]
then
	echo -e "${MSG}"
	cat urls >>posted
	rm urls
else
	echo -e "${MSG}\n"
fi