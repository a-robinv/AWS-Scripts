:loop
curl -I http://xxxxxxxxxxxxxxxxxxxxxx.ap-southeast-1.elb.amazonaws.com:8080/ >> sitelog.txt
timeout /t 2
goto loop