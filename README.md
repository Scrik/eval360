[![Build Status](https://travis-ci.org/rockwoodleadership/eval360.svg?branch=master)](https://travis-ci.org/rockwoodleadership/eval360)
##Rockwood 360 Eval Software

###Requirements
- Ruby 2.3.0
- Rails 4.2.6
- Postgresql 9.4

####Setup
1 Fork the repo [https://help.github.com/articles/fork-a-repo/](https://help.github.com/articles/fork-a-repo/)  
2 Run the below script
```
./script/newb
```
3 Create a .env file with the following using the associated keys:
```
MANDRILL_APIKEY="MANDRILL_APIKEY"
DATABASEDOTCOM_CLIENT_ID="1234"
DATABASEDOTCOM_CLIENT_SECRET="secret"
DATABASEDOTCOM_HOST="test.salesforce.com"
INBOUND_SALESFORCE_KEY="example"
SALESFORCE_PASSWORD="passwordsecuritytoken"
SALESFORCE_USERNAME="example@email.com"
``` 
####Start
```
thin start --ssl
```
####Test
```
rake
```
