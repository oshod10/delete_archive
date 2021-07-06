#! /bin/bash



################################
#                              #
#  Developed by Osho Divyang   #
#        version 2.0           #
################################



FOLDER=/home/sigvalue/etc/ftp/Archive
AUTOMATION=/home/sigvalue/automation/delete_archive
TWO=$AUTOMATION/twomonths
rm -f log_one_month log_two_months file dir_two_months > /dev/null


function 2m()
{
echo 'Deleting archives older than 2 months!'
sleep 1
for i in $(cat $TWO)
do
    if [  -d $FOLDER/DirID_$i ]; then 
        var=$FOLDER/DirID_$i
        echo "DirID_$i/" >> dir_two_months
        echo "DirID_$i exsits, clearing up the clutter..."
        find $var -maxdepth 1 -type d | while read -r dir; do printf "%s:\t" "$dir"; find "$dir" -type f -ctime +60| wc -l; done >> $AUTOMATION/log_two_months
#        find . -mindepth 1 -type f -ctime +60 | xargs rm 2> /dev/null
    else echo "DirID_$i does not exist, nothing to delete"
    fi  
done
sleep 1
}

function 1m()
{
echo 'Deleting archives older than 1 month!'
cd $FOLDER
ls -ld */ > $AUTOMATION/file 
cd $AUTOMATION
cat file | awk '{print $9}' > dir_one_month
sed -i "s,/,,g" dir_two_months
sed -i "s,/,,g" dir_one_month
for j in $(cat dir_two_months)
do
    len=`cat dir_one_month | grep $j | wc -l` 
    if [ $len -gt 0 ]; then
        sed -i "/$j/d" dir_one_month
    fi
done
rm file > /dev/null
for z in $(cat dir_one_month); do
    echo "DirID_$z exists, clearing up the clutter..."
    find $FOLDER/$z -maxdepth 1 -type d | while read -r dir; do printf "%s:\t" "$dir"; find "$dir" -type f -ctime +30| wc -l; done >> $AUTOMATION/log_one_month
#    find . -mindepth 1 -type f -ctime +30 | xargs rm 2> /dev/null
done
}


2m
1m
