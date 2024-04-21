#!/bin/bash

USERID=$(id -u)
SCRIPT_NAME=$(echo $0|cut -d '.' -f1)
DATE=$(date +%F-%H-%M-%S)
LOGFILE=/tmp/$SCRIPT_NAME-$DATE.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
#echo "starting $SCRIPT_NAME shell script  at $DATE"
echo "Enter the DB Password"
read -s mysql_password

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
VALIDATE $? "Installing MySQL"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enabling MYSQL"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "starting MySQL"

#mysql -h 172.31.24.255 -uroot -pExpenseApp@1 -e 'show databases;' &>>$LOGFILE
mysql -h db.devopslearning2025.online -uroot -p${mysql_password} -e 'show databases;' &>>$LOGFILE

if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_password} &>>$LOGFILE
    VALIDATE $? "setting root password of MySQL"
else
    echo -e "MySQL passowrd already set ....$Y SKIPPING  $N"
fi  