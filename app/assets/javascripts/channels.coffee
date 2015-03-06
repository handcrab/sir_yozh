$(document).ready -> (new PostsUpdater).update()
$(document).on 'page:load', ->
  (new PostsUpdater).update()