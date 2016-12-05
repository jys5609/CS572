#!/bin/bash

dirLog='log'
rm -fr $dirLog
mkdir $dirLog
fileLog=$dirLog'/videoConv.log'

dirIn='data'
dirOut='out'
dirTmp='tmp'
dirOrgiImg=$dirTmp'/orgiImg'
dirOptiImg=$dirTmp'/optiImg'


# Out folders 
rm -f -r $dirOut
mkdir -p $dirOut
folders=$(find $dirIn -type d)
for folder in $folders ; do
    mkdir -p $dirOut'/'$folder
done

# movie files 
fileVideos=$(find $dirIn'/' -type f)
fileCountTotal=$(find $dirIn'/' -type f | wc -l)
fileCountCur=1
for fileVideo in $fileVideos; do
    echo "--------------------------------------------- "
    echo "Current file: " $fileVideo "(" $fileCountCur "/" $fileCountTotal ")"
    echo "--------------------------------------------- "
    echo  $fileVideo >> $fileLog
    # removing out tmp files
    rm -f -r $dirTmp
    mkdir $dirTmp
    mkdir $dirOrgiImg
    mkdir $dirOptiImg

    # video -> images 
    echo "----- org.video --> orgi.img-----"
    echo "----- org.video --> orgi.img-----" >> $fileLog
    ffmpeg -i $fileVideo -framerate 30 -f image2 $dirOrgiImg'/'%03d.jpeg &>> $fileLog
    
    # orgi.images -> opti.images
    echo "----- orgi.img --> opti.img -----"
    fileOrgiImgs=`ls $dirOrgiImg`
    #echo ${fileOrgiImgs[1]}
    pre=$(echo $fileOrgiImgs | cut --delimiter " " --fields 1)
    out=0
    for file in $fileOrgiImgs; do
        cur=$file
        fileCur=$dirOrgiImg'/'$cur
        filePre=$dirOrgiImg'/'$pre
        fileOut=$dirOptiImg'/'$(printf %03d $out)'.jpeg'
        if [ "$pre" != "$cur" ]; then
            #echo $pre $cur $fileOut
            python opti.py $filePre $fileCur $fileOut
        fi
        pre=$cur
        out=$[$out+1]
    done
    
    # opti.images -> opti.video
    echo "----- opti.imp --> opti.video -----"
    echo "----- opti.imp --> opti.video -----" >> $fileLog
    ffmpeg -framerate 30 -i $dirOptiImg'/'%03d.jpeg -c:v libx264 -r 30 $dirOut'/'$fileVideo &>> $fileLog

    fileCountCur=$[$fileCountCur+1]
done
