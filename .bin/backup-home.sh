#!/bin/bash
filename="`date +%d-%m-%y`.tar.bz2" 
# у меня бекап происходит на отдельный раздел backup
cd /mnt/backup/Home-backup
echo "`date` — Start" >> /mnt/backup/Home-backup/backup.log
# перечисляете все каталоги и файлы в корневом каталоги которые хотите забекапить
tar cvpjf $filename /home/enko
echo "`date` — Finish" >>/mnt/backup/Home-backup/backup.log
# удаляем бекап двухдневной давности
day="`date +%d`"
dday=`echo $day-3|bc -l`
dfilename="`printf '%02d' $dday`_`date +%m_%y`.tar.bz2" 
rm /mnt/backup/Home-backup/$dfilename

