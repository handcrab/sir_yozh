# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.

# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.

# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.

# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.

# = require jquery
# = require jquery_ujs
# = require materialize-sprockets
# = require turbolinks
# = require_tree .

showProgressBar = -> $('.progress').show()
hideProgressBar = -> $('.progress').hide()

# history change
# window.onpopstate = (event)->     
#   hideProgressBar()
$(document).on 'page:restore', ->
  hideProgressBar()

init = ->
  # $(".button-collapse").sideNav()
  $('.fetch').on 'click', ->
    showProgressBar() #.toggleClass('hide')
  $('.show-posts').on 'click', ->
    showProgressBar()
  $('.tags a').on 'click', ->
    showProgressBar()

  $('.progress').hide()

$(document).ready init
$(document).on 'page:load', ->
  init()
  # $('.progress').hide()
