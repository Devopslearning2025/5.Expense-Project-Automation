#!/bin/bash

USERID=$(id -u)
SCRIPT_NAME=$(echo $0|cut -d '.' -f1)
DATE=$(date +%F-%H-%M-%S)
LOGFILE=/tmp/$SCRIPT_NAME-$DATE.log
R="\e[31m"
G="\e[32m"
Y="\e[33"
N="\e[0m]"
echo "starting $SCRIPT_NAME shell script  at $DATE"

if [ $USERID -ne 0 ]
then
    echo "please run with root user"
    exit 1
else
    echo "you are with root user"
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo "$2 is .... FAILURE"
    else
        echo "$2 is .... SUCCESS"
    fi        
}

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing mysql"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enabling mysql"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "starting mysql"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "setting root password of mysql"