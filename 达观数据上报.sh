COOKIES=''

if [[ $# == 0 || $1 == "1" ]]
then
	date=1
elif [[ $1 == "2" || $1 == "3" || $1 == "4" || $1 == "5" ]]
then
	date=$1
else
	echo -e "参数输入有误\n1:今天 2:昨天 3:前天 4:一周内 5:一月内"
fi


while true
do
    echo "#获取文章URL"
	
	v_tmp=`curl -s "http://www.to8to.com/trdn/goodinfo_admin.php?date=${date}" -H $"Cookie:${COOKIES}" | egrep -o '共找到<em>[0-9]+</em>条记录' | sed -r 's/[^0-9]//g'`
	vpage=`echo "${v_tmp}/10+1"|bc`
	z_tmp=`curl -s "http://www.to8to.com/trdn/know_zxcs.php?date=${date}" -H $"Cookie:${COOKIES}" | egrep -o '共找到<em>[0-9]+</em>条记录' | sed -r 's/[^0-9]//g'`
	zpage=`echo "${z_tmp}/10+1"|bc`
	
    for page in `seq ${vpage}`
    do
        curl -s "http://www.to8to.com/trdn/goodinfo_admin.php?date=${date}&page=${page}" -H $"Cookie:${COOKIES}" | egrep '<td><a href="/yezhu/[zv].php\?id=[0-9]+' | sed -r 's/^.*([zv]).php\?id=([0-9]+).*blank">(.*)<\/a>.*$/\1_\2 \3/g' >>new_art
        sleep 1
	done
	
	for page in `seq ${zpage}`
	do
        curl -s "http://www.to8to.com/trdn/know_zxcs.php?date=${date}&page=${page}" -H $"Cookie:${COOKIES}" | egrep '<td><a href="/yezhu/[zv].php\?id=[0-9]+' | sed -r 's/^.*([zv]).php\?id=([0-9]+).*blank">(.*)<\/a>.*$/\1_\2 \3/g' >>new_art
		sleep 1
    done
	
    echo "#获取文章URL结束"

    urlcount=`cat new_art | wc -l`
    if [[ ${urlcount} == 0 ]]
    then
        echo "#无新发布文章 or cookies失效，请在浏览器重新登陆后重试"
    else
        cat new_art | while read data
        do
            A=(`echo ${data}`)
            ID=${A[0]}
            TITLE=${A[@]:1}
			CATE=`echo ${ID} | awk -F _ '{print $1}'`
			TIME=`date +%s`
            ifposted=`grep -c "${data}" posted`

            if [[ ${ifposted} == 0 ]]
            then
                echo ${ID} ${TITLE} `curl -s -X POST -H "Content-Type: application/json" -d "{\"appid\":2537032, \"table_name\" : \"item\", \"table_content\": [{\"cmd\":\"add\", \"fields\": {\"itemid\": \"${ID}\",  \"title\": \"${TITLE}\",\"cateid\": \"${CATE}\",\"item_modify_time\": \"${TIME}\"}}]}" 'http://datareportapi.datagrand.com/data/to8to' | grep -o 'OK'`
                echo "${data}" >>posted
                sleep 0.5
            else
                continue
            fi
        done
        echo -e "#\e[47m\e[31m"`date +"%Y-%m-%d %H:%M:%S"`" 上报成功\e[0m\n"
    fi

    rm new_art 2>/dev/null
    sleep 30m
done
