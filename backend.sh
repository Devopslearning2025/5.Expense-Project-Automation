
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
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is .... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 is .... $G SUCCESS $N"
    fi        
}

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Dsiabled nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "enabled nodejs:20"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "install nodejs"

id expense &>>$LOGFILE
if [ $? -ne 0 ]
then
    useradd expense &>>$LOGFILE
    VALIDATE $? "user created"
else
    echo -e "User is already there .... $Y SKIPPING $N"
fi    

mkdir -p /app &>>$LOGFILE
VALIDATE $? "directory is created"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "download is completed"

cd /app 
rm -rf /app/*
unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "unzipped completed"

npm install &>>$LOGFILE
VALIDATE $? "npm dependices install completed"

cp /home/ec2-user/Project-Automation/backend.service /etc/systemd/system/backend.service  &>>$LOGFILE
VALIDATE $? "copied backend.servce"

systemctl daemon-reload  &>>$LOGFILE
VALIDATE $? "daemon-reload"

systemctl start backend  &>>$LOGFILE
VALIDATE $? "started backend"

systemctl enable backend  &>>$LOGFILE
VALIDATE $? "enabled backend"

dnf install mysql -y  &>>$LOGFILE
VALIDATE $? "installed mysql client"

mysql -h db.devopslearning2025.online -uroot -pExpenseApp@1 < /app/schema/backend.sql  &>>$LOGFILE
VALIDATE $? "schema loaded"

systemctl restart backend  &>>$LOGFILE
VALIDATE $? "restarted backend"