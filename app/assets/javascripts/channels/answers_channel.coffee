App.cable.subscriptions.create('AnswersChannel', {
  connected: ->
    @perform 'follow_question_answers', question_id: gon.question_id
  ,
  
  received: (data) ->
    $('.answers').append JST["templates/answer"] ({ answer: data.answer, author: data.author, type: data.type })
})
