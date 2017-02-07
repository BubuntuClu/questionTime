$(document).on('turbolinks:load', function(){
  var votes = $('.votes');

  votes.bind('ajax:success', function(e, data, status, xhr){
    var result = $.parseJSON(xhr.responseText);
    $('#' + result.id).html("<p>Rating: " + result.rating + "</p>");
    if (result.action == "vote"){
      $('#' + result.id).parent().find('.vote_up').addClass('hidden')
      $('#' + result.id).parent().find('.vote_down').addClass('hidden')
      $('#' + result.id).parent().find('.unvote').removeClass('hidden')
    }
    if (result.action == "unvote"){
      $('#' + result.id).parent().find('.vote_up').removeClass('hidden')
      $('#' + result.id).parent().find('.vote_down').removeClass('hidden')
      $('#' + result.id).parent().find('.unvote').addClass('hidden')
    }
  }).bind('ajax:error', function(e, xhr, status, error){
    alert(2);
  });
});
