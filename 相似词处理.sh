#!/bin/bash

cat $1 >副本  #复制一份本地词

cat 相似词.txt |
while read line
do
	XSC=(`echo ${line}`) #把一组相似词转为一个数组
	for i in ${XSC[@]}  #逐个操作数组中的词
	do
		#如何自动控制替换的次数，暂时没有想到更好的办法，先用这种简单粗暴的方式
		if [[ ${#XSC} == 2 ]]
		then
			grep $i 副本 |
			sed -r "s/(.*)${i}(.*)/\1${XSC[0]}\2|\1${XSC[1]}\2/g" >>新词
            sed -i "/${i}/d" 副本
		elif [[ ${#XSC} == 3 ]]
        then 
            grep $i 副本 |
            sed -r "s/(.*)${i}(.*)/\1${XSC[0]}\2|\1${XSC[1]}\2|\1${XSC[2]}\2/g"  >>新词
            sed -i "/${i}/d" 副本
		elif [[ ${#XSC} == 4 ]]
        then 
            grep $i 副本 |
            sed -r "s/(.*)${i}(.*)/\1${XSC[0]}\2|\1${XSC[1]}\2|\1${XSC[2]}\2|\1${XSC[3]}\2/g"  >>新词
            sed -i "/${i}/d" 副本
		elif [[ ${#XSC} == 5 ]]
        then 
            grep $i 副本 |
            sed -r "s/(.*)${i}(.*)/\1${XSC[0]}\2|\1${XSC[1]}\2|\1${XSC[2]}\2|\1${XSC[3]}\2|\1${XSC[4]}\2/g"  >>新词
            sed -i "/${i}/d" 副本
        fi
    done
done

cat 新词 副本 >相似词结果.txt
rm 副本 新词 &>/dev/null
