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
        echo -e "$2 is .... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 is .... $G SUCCESS $N"
    fi        
}

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing mysql"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enabling mysql"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "starting mysql"

mysql -h 3.82.25.15 -uroot -pExpenseApp@1 -e 'show databases'; &>>$LOGFILE
if [ $? -ne 0 ]
then
    echo -e "mysql passowrd already set ....$Y SKIPPING  $N"
else
    echo "set the password"
    mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
    VALIDATE $? "setting root password of mysql"
fi