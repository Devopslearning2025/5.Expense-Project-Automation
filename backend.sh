
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

useradd expense &>>$LOGFILE
VALIDATE $? "user created"

#mkdir /app &>>$LOGFILE
#cd /app 
#curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
#unzip /tmp/backend.zip