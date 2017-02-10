$(document).on('turbolinks:load', function(){

  $('body').on('ajax:success', 'form#new_comment', 1,function(e, data, status, xhr){
    var result = $.parseJSON(xhr.responseText);
    if (result.commentable_type == 'Question'){
      $('.question_comments').append("<p>" + result.body + "</p>");
      $('#comment_body').val('');
    }
    else{
      $('#answer_' + result.commentable_id + '_comments').append("<p>" + result.body + "</p>");
      $('#answer_' + result.commentable_id + '_comments').find('#comment_body').val('')
    }
  }).bind('ajax:error', function(e, xhr, status, error){
    alert(2);
  });
});
