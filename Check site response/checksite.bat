:loop
curl -I http://adab4b8475b94428c90c54bf9e11d32c-1362173143.ap-southeast-1.elb.amazonaws.com:8080/ >> sitelog.txt
timeout /t 2
goto loop