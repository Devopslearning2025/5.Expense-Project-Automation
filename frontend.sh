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
    echo "please run with root user"
    exit 1
else
    echo "you are with root user"
fi

VALIDATE(){
    if [ $1 is -ne 0 ]
    then
        echo -e "$2 is ... $R FAILURE $N"
    else
        echo -e "$2 is ... $G SUCCESS $N"
    fi
}

dnf install nginx -y  &>>$LOGFILE
VALIDATE $? "Installing nginx"

systemctl enable nginx  &>>$LOGFILE
VALIDATE $? "Enabling nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "starting the nginx"

rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip  &>>$LOGFILE
VALIDATE $? "Dowling the frontend file"

cd /usr/share/nginx/html
rm -rf /usr/share/nginx/html/* 
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "Extracting the zip file"