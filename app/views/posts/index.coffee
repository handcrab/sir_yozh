$('#posts').html "<%=j render @posts %>"
$('.badge').text "<%= @posts.size %>"
