# kanpai-server
API Server for kanpai project. This API is supposed to run on heroku.

## How to set up

    $ git push heroku master
    $ heroku config:set ACCOUNT_SID='[Account SID of Twilio account]'
    $ heroku config:set AUTH_TOKEN='[Auth Token of Twilio account]'
    $ heroku config:set FROM_PHONE_NUMBER='[Phone number of Twilio account]'
    $ heroku run rake db:migrate
