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

window.PostsUpdater = class PostsUpdater
  # constructor: -> @url = ''
  fetchPosts: ->
    # $.get({url: $('#posts').data('url').toString(), dataType: 'script'})
    $.ajax
      url: $('#posts.channel-posts').data('url').toString()
      type: 'get'
      dataType: 'script'

  update: ->
    # @url = $('#posts').data('url').toString()
    if $('#posts.channel-posts').data('url')
      setTimeout @fetchPosts, 5000
      setInterval @fetchPosts, 30000


showProgressBar = -> $('.progress').show()
hideProgressBar = -> $('.progress').hide()

# turbolinks: history change
# window.onpopstate = (event)->
$(document).on 'page:restore', ->
  hideProgressBar()

init = ->  
  $('.fetch').on 'click', ->
    showProgressBar() #.toggleClass('hide')
  $('.show-posts').on 'click', ->
    showProgressBar()
  $('.tags a').on 'click', ->
    showProgressBar()

  $('.progress').hide()
 
  $(".button-collapse").sideNav()
  
  # popup flash msg
  $('#alert').ready -> 
    msg = $('#alert .message').data('notice')
    if msg
      # console.log $('#alert').data('notice')
      $('#alert').hide()
      toast msg, 4000

  # fix cards vertical stack
  # $('#posts .col:nth-child(3n)').css({clear: 'left'})
  # $(window).resize ->
  #   viewportWidth = $(window).width()    
  #   console.log viewportWidth    
  # if viewportWidth <= 600 
  # else if viewportWidth <= 992 and viewportWidth > 600
  #   # $('#posts .col:nth-child(4n)').toggleClass 'clear-left'
  
  # setCardsHeights = ->
  #   heights = $(".card").map -> $(@).height()
  #   max_height = Math.max.apply null, heights.get() 
  #   $(".card").height max_height

$(document).ready init
$(document).on 'page:load', ->
  init()
