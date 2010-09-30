#!/bin/bash
filename="`date +%d-%m-%y`.tar.bz2" 
# у меня бекап происходит на отдельный раздел backup
cd /mnt/backup/System-backup
echo "`date` — Start" >> /mnt/backup/System-backup/backup.log
# перечисляете все каталоги и файлы в корневом каталоги которые хотите забекапить
tar cvpjf $filename /bin /boot /dev /etc /lib /opt /root /sbin /srv /usr /var /initrd.img /vmlinuz
echo "`date` — Finish" >>/mnt/backup/System-backup/backup.log
# удаляем бекап двухдневной давности
day="`date +%d`"
dday=`echo $day-3|bc -l`
dfilename="`printf '%02d' $dday`_`date +%m_%y`.tar.bz2" 
rm /mnt/backup/System-backup/$dfilename

