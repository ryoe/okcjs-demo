# Description:
#   A simple demo script to show to require your own script
#
# Dependencies:
#   none
#
# Commands:
#   none
#
# Notes:
#   Presented at OKC.js Lightning Talks on Aug 19, 2014
#
# Author:
#   ryoe
greetings = [
  'Yay! Lightning Talks!'
  'The 1st rule of OKC.js is you must talk about OKC.js!'
  'Yay! OKC.js!'
  'Woot! OKC.js!'
]

module.exports = ->
  return greetings

