#!/bin/bash

USERID=$(id -u)
SCRIPT_NAME=$(echo $0|cut -d '.' -f1)
DATE=$(date +%F-%H-%M-%S)
LOGFILE=/tmp/$SCRIPT_NAME-$DATE.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]
then
    echo "Please run with root user"
    exit 1
else
    echo "you are with root user"
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo  -e "$2 is ... $R FAILURE $N"
        #exit 1
    else
        echo -e "$2 is ... $G SUCCESS $N"
    fi   
}

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "installing my sql server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enabling my sql server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "startng my sql server"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "settign the password"