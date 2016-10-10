createComment = (comment) ->
  id = comment.commentable_type + '-' + comment.commentable_id
  $('#' + id).append(JST['templates/comment']({ comment: comment }))

deleteComment = (comment) ->
  $("#comment-#{ comment.id }").remove()

updateComment = (comment) ->
  $("#comment_body-#{ comment.id }").replaceWith(comment.body)  

$(document).ready ->
  commentableId = $('.question_comments').data('commentableId')
  console.log(commentableId)
  PrivatePub.subscribe "/questions/#{ commentableId }/comments", (data, channel) ->
    console.log(data)
    comment = $.parseJSON(data['comment'])
    switch data['method']
      when 'delete' then deleteComment(comment)
      when 'update' then updateComment(comment)
      else createComment(comment)