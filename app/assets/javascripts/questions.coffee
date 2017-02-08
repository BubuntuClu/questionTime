# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

edit_question = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId')
    $('form#edit-question-' + question_id).show()

$(document).ready(edit_question)
$(document).on('page:load', edit_question)
$(document).on('page:update', edit_question)


App.cable.subscriptions.create('QuestionsChannel', {
  connected: ->
    @perform 'follow'
  ,
  
  received: (data) ->
    $('.questions').append JST["templates/question"] data.question
})
