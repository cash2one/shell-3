#!/bin/zsh

cookies=''  #手动填写

cat $1 | while read line
do
    A=(`echo $line`)
    name=`echo ${A[1]}`
    word=`echo ${A[2]}`
    title=`echo "${A[3]} - ${A[5]}"`
    desc=`echo ${A[6]}`
    bd=`echo ${A[7]}`
    
    #echo $name $title $word $bd
    http -b -f POST 'http://www.to8to.com/trdn/sotage_manage.php?act=add' "Cookie:${cookies}" bq_name=${name} title=${title} keywords=${word} desc=${desc} baidu_index=${bd} < /dev/tty > /dev/null
    echo $name "添加成功"
    sleep 2
done