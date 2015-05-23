# Heroku Slack Integration
This project is under heavy development please do not use it

## Installation

### Configure Slack WebHook
1. Open your slack browser
2. Click the down arrow near your user name and select the "Configure Integratoin"
![](https://dl.dropboxusercontent.com/u/1228036/images/76313e208c6f95af38b1aaf39447ace9.jpg)
3. On the Integrstions tab, click the Incomming WebHooks button
![On the "Configured Integration"](https://dl.dropboxusercontent.com/u/1228036/images/df5fc054dffcf1613c3a5aa2849571c2.jpg)
4. Click the Add button
![](https://dl.dropboxusercontent.com/u/1228036/images/57640a1b96883c4a44b189995c45c946.jpg)
5. Select the channel to post to and click the "Add Incoming WebHooks Integration"
![](https://dl.dropboxusercontent.com/u/1228036/images/ee4d2f02b09806285a4dfeb8da512e0a.jpg)
6. Copy the Webhook URL
![](https://dl.dropboxusercontent.com/u/1228036/images/aa2f391e6b20f3cfd778dd0d4a2a1f94.jpg)
7. Add this line in the .developent.env file under the root dir of the project.
```bash
SLACK_WEBHOOK_URL=<WEBHOOK_URL>
```

### Deployment on Heroku

Configure slack webhook env variable

```bash
heroku config:set SLACK_WEBHOOK_URL=YOUR_WEBHOOK_URL
heroku addons:create heroku-postgresql:hobby-dev
heroku config:set DATABASE_URL=YOUR_DB_NAME
heroku addons:create deployhooks:http --url=https://my_app.herokuapp.com/_deploy
```

### Github configuration

1. Go to Edit profile
![](https://dl.dropboxusercontent.com/u/1228036/images/16fdb2a34173b99bc98e9c4cf1c7f725.jpg)
2. Click on Personnal access tokens

![](https://dl.dropboxusercontent.com/u/1228036/images/f218eaa7a610c897c937f4403ad1404e.jpg)

3. Then generate new token

![](https://dl.dropboxusercontent.com/u/1228036/images/be2ca68429e79b2b036c731fb034f00a.jpg)

4. Type in a token description and click "Generate Token"
![](https://dl.dropboxusercontent.com/u/1228036/images/d5a348fba3f5637aef64f8751545b9a9.jpg)

5  Copy the token

6. Add it to the .developent.env file

GITHUB_OAUTH_TOKEN="PASTE_YOUR_GITHUB_TOKEN_HERE"

7. Add it it to Heroku

```
heroku config:set GITHUB_OAUTH_TOKEN=PASTE_YOUR_GITHUB_TOKEN_HERE
```

