App.cable.subscriptions.create('CommentsChannel', {
  connected: ->
    @perform 'follow_comments', question_id: gon.question_id
  ,
  
  received: (data) ->
    if (gon.user_id != data.author)
      $('.question_comments').append JST["templates/comment"] ({ comment: data.comment })
})


  
