# Description:
#   A simple demo script to show off Hubot
#
# Dependencies:
#   none
#
# Commands:
#   hubot okcjs - send thoughtful message about OKC.js and/or Lightning Talks
#   hubot okcjs demoget - return info about simple HTTP GET request
#   thunder plains - send Thunder Plains info
#   want to attend Backyard.js - emote Backyard.js tix
#   hubot okcjs help - send this list of help
#
# URLS:
#   GET /hubot/okcjs?msg=<msg>[&room=<room>]
#   POST /hubot/incident
#     msg = <msg>
#     [room = <room>]
#
# Notes:
#   Presented at OKC.js Lightning Talks on Aug 19, 2014
#
# Author:
#   ryoe
querystring = require 'querystring'
greetings   = require './okcjs-demo-greetings'

help = [
  'hubot okcjs - send thoughtful message about OKC.js and/or Lightning Talks'
  'hubot okcjs demoget - return info about simple HTTP GET request'
  'thunder plains - send Thunder Plains info'
  'want to attend Backyard.js - emote Backyard.js tix'
  'hubot okcjs help - send this list of help'
]
demoGetUrl = 'https://api.canary.io/checks/https-github.com/measurements'

module.exports = (robot) ->
  robot.router.get '/hubot/okcjs', (req, res) ->
    q = querystring.parse req._parsedUrl.query
    user = {}
    user.type = 'groupchat'
    user.room = q.room or '109614_playground@conf.hipchat.com'

    robot.send user, q.msg
    res.end "GET: received '#{q.msg}'"

  robot.router.post '/hubot/okcjs', (req, res) ->
    data = req.body
    user = {}
    user.type = 'groupchat'
    user.room = data.room or '109614_playground@conf.hipchat.com'

    robot.send user, data.msg
    res.end "POST: received '#{data.msg}'"

  robot.respond /okcjs(\s*)?(\S*)?/i, (msg) ->
    cmd = msg.match[2] or null
    if 'demoget'.localeCompare(cmd) is 0
      robot.http(demoGetUrl)
        .get() (err, res, body) ->
          if err
            msg.send "Oh, noes! We got an error. #{err}"
            return
          if res.statusCode == 200
            msg.send JSON.parse(body).length + " records received"
          else
            msg.send "Things are not 200 OK. Received status code: #{res.statusCode}"
    else if 'help'.localeCompare(cmd) is 0
      msg.send help.join '\n'
    else
      console.log greetings
      msg.send msg.random greetings()

  robot.hear /thunder plains/i, (msg) ->
    msg.send 'Get all the deets on Thunder Plains:' +
    ' http://thunderplainsconf.com/'
    msg.reply 'You should ask about after the party.'

  robot.hear /want to attend Backyard.js/i, (msg) ->
    msg.emote 'sends Backyard.js tix'
