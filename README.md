# Heroku Slack Integration

## Installation
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
