#!/bin/bash

# Script for uploading images to itmages.ru
# written by opkdx

LOGIN=enko5206
PASSWD=love66
SCRIPT=$0
IMAGE=$1
COMMENT=$2
NEED_LOGIN=1
LOGINED=
DIRMODE=$DIRMODE

print_message() {
    [ "$LANG" = "ru_RU.UTF-8" ] && echo $1 || echo $2
}

[ ! -z "$LOGIN" -o -z "$COMMENT" ] || (print_message "Вы не можете добавлять комментарии в анонимном режиме" "You can't add comments being anonymous"; exit 1) || exit 1

print_help() {
    echo "itmages script, v0.06"
    print_message "использование:" "usage:"
    echo "itmages (help|register|configure)"
    echo "itmages image.png \"comment\""
    echo "itmages /any/directory/with/pictures/inside"
    echo -n "   help - "
    print_message "вывести эту справку" "show this help"
    echo -n "   configure - "
    print_message "выбрать режим загрузки: анонимный или с введенными логином и паролем" "select the way of uploading: anonymous or with specified login and password"
    echo -n "   register - "
    print_message "зарегистрировать новый аккаунт" "register a new account"
    echo -n "   File.{png, jpeg, gif} [\"Commentary\"] - "
    print_message "загрузить картинку на itmages.ru, и, если необходимо, добавить комментарий к ней" "upload the image to itmages.ru (and add comment if necessary)"
    echo -n "   /directory - "
    print_message "загрузить все картинки из директории" "upload all images from specified directory (not recursively)"
    exit 0
}

replace_this() {
    mv /tmp/itmages-script $SCRIPT
    chmod +x $SCRIPT
}

anonymous_mode() {
    cat $SCRIPT | sed -e 's/^LOGIN=.*$/LOGIN=/'|sed -e 's/^PASSWD=.*$/PASSWD=/' > /tmp/itmages-script
    replace_this
    return 0
}

logining_mode() {
    cat $SCRIPT | sed -e "s/^LOGIN=.*$/LOGIN=$LOGIN/"|sed -e "s/^PASSWD=.*$/PASSWD=$PASSWD/" > /tmp/itmages-script
    replace_this
    return 0
}

configure() {
    print_message "-+- Конфигурация скрипта" "-+- Configuration of itmages.sh"
    print_message "-*- Введите ваш логин (или оставьте пустым, если вы хотите использовать анонимный режим)" "-*- Enter your login (or leave blank if you are going to use anonymous mode)"
    read LOGIN
    if [[ -z $LOGIN ]];then
	print_message "-+- Скрипт настроен для анонимной загрузки" "-+- Script is now configured for anonymous upload"
	anonymous_mode
	exit 0
    fi
    print_message "-*- Введите пароль для вашего аккаунта (ВНИМАНИЕ: пароль хранится в скрипте в открытом виде" "-*- Enter your password (WARNING: password is stored in script as a plaintext)"
    read PASSWD
    logining_mode
    print_message "-+- Скрипт настроен для загрузки из вашего аккаунта" "-+- Script is now configured to use your account for uploading"
    exit 0
}

register() {
    print_message "itmages.ru теперь использует reCaptcha, из-за чего регистрация скриптом стала невозможна" "Registration by script is now impossible (the reason is reCaptcha)"
    # print_message "-+- Регистрация нового аккаунта" "-+- Regestration of a new account"
    # print_message "-+- Нажмите Ctrl-C, если вам это не нужно" "-+- Press Ctrl-C to cancel registration"
    # print_message "-*- Введите логин" "-*- Enter new login"
    # read LOGIN
    # print_message "-*- Введите пароль (ВНИМАНИЕ: пароль будет показан" "-*- Enter password (WARNING: it won't be hidden)"
    # read PASSWD
    # print_message "-+- Регистрация..." "-+- Registration..."
    # curl -s -L -A "itmages script" -c /tmp/itmages-cookie -F "name=$LOGIN" -F "passwd=$PASSWD" -F "passwd2=$PASSWD" -F "act=reg" -F "submit=Поехали!" 'http://itmages.ru/index.php?action=register' -o /tmp/itmages-result
    # ERRREASON=$(cat /tmp/itmages-result|grep Ошибка >/dev/null && echo 1)
    # rm /tmp/itmages-result
    # if [[ ! -z $ERRREASON ]];then
    # 	print_message "-+- Ошибка при регистрации, возможно, данный аккаунт уже зарегистрирован" "-+- Registration error, maybe account with this name is already registered"
    # 	exit 1
    # fi
    # curl -# -L -A "itmages script" -b /tmp/itmages-cookie -F "submit=Выйти" 'http://itmages.ru/index.php?action=logout' -o /dev/null
    # rm /tmp/itmages-cookie
    # print_message "-*- Аккаунт успешно зарегистрирован. Использовать его для загрузки картинок? [y/n]" "-*- Account has been registered successfully. Do you want to use this account for uploading pictures? [y/n]"
    # read -n1
    # echo
    # [ "$REPLY" = "y" -o "$REPLY" = "Y" ] && logining_mode
}

case "$1" in
    configure)
	configure
	;;
    register)
	register
	;;
    help)
	print_help
	;;
    "")
	print_help
	;;
    *)
	if [[ ! -e $IMAGE ]];then
	    echo file "$IMAGE" not found
	    exit 1
	fi
	if test -d "$IMAGE"; then
	    for img in "$IMAGE"/*.png "$IMAGE"/*.jpg "$IMAGE"/*.jpeg "$IMAGE"/*.gif ;do
		if [[ -e $img ]];then
		    DIRMODE=1 $SCRIPT "$img"
		fi
	    done
	    rm /tmp/itmages-result 2>/dev/null
	    rm /tmp/itmages-cookie 2>/dev/null
	    exit 0
	fi
	if [[ ! -z $LOGIN ]]; then
	    curl -s -F "name=$LOGIN" -F "passwd=$PASSWD" -F "submit=Войти" --cookie-jar /tmp/itmages-cookie 'http://itmages.ru/sys/login'
	    LOGINED=1
# два раза exit 1 - это единственный способ нормально выйти :)
	    [ -f /tmp/itmages-cookie ] || (print_message "Ошибка при входе, проверьте корректность логина и пароля" "Can't login: check correctness of your login and password"; exit 1) || exit 1
	fi
	if [[ -z $DIRMODE ]];then
	    curl -# -L -A "itmages script" -F "img=@${IMAGE};type=image/png" -F 'filename=true.png' -b /tmp/itmages-cookie 'http://itmages.ru/add' -o /tmp/itmages-result
	else
	    curl -s -L -A "itmages script" -F "img=@${IMAGE};type=image/png" -F 'filename=true.png' -b /tmp/itmages-cookie 'http://itmages.ru/add' -o /tmp/itmages-result
	fi
	
	LINK=$(cat /tmp/itmages-result|grep -A1 Ссылка\ на\ картинку|grep -oE 'http[^"]+')
	[ -z $LINK ] && ERRREASON=$(cat /tmp/itmages-result|grep -A2 Ошибка|tail -n1| sed -e 's/\t//g'| sed -e 's/^[^>]*>//g'|sed -e 's/<.*$//g')
	# rm /tmp/itmages-result
	ID=$(echo $LINK | sed -e 's/http:\/\///' | cut -d '/' -f4)
	KEY=$(echo $LINK| sed -e 's/http:\/\///' | cut -d '/' -f5)
	# комментарий :)
	if [[ ! -z $COMMENT ]]; then
	    print_message "На данный момент (14.03.2010) возможность добавления комментариев недоступна" "For some time comments are disabled (because of technical reasons)" 
	    # print_message "Добавление комментария..." "Adding the comment..."
	    # curl -# -L -A "itmages script" -F 'act=update' -F "text=${COMMENT}" -F "submit=Добавить коммент" -b /tmp/itmages-cookie "http://itmages.ru/view.php?action=preview&id=${ID}&key=${KEY}" -o /dev/null
	    # echo "http://itmages.ru/thread.php?id=$ID"
	fi
	[ -z "$DIRMODE" ] && rm /tmp/itmages-result
	[ -z "$LINK" ] && print_message "Ошибка при загрузке изображения: $ERRREASON" "Can't load image: $ERRREASON" || echo $LINK
	if [[ ! -z $LOGIN ]]; then
	    curl -s -A 'itmages script' -b /tmp/itmages-cookie 'http://itmages.ru/user/logout'
	    rm /tmp/itmages-cookie
	fi
esac
exit 0

