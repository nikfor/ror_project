editAnswer = (e) ->
  e.preventDefault()
  $(this).hide()
  answer_id = $(this).data('answerId')
  $('form#edit-answer-' + answer_id).show()

voting = (e, data, status, xhr) ->
  votable = $.parseJSON(xhr.responseText)
  $('#votable-total-' + votable.votable_id).html( votable.total )
  if votable.user_voted
    $('#votable-already-links-' + votable.votable_id).removeClass('hidden')
    $('#votable-not-yet-links-' + votable.votable_id).addClass('hidden')
  else
    $('#votable-already-links-' + votable.votable_id).addClass('hidden')
    $('#votable-not-yet-links-' + votable.votable_id).removeClass('hidden')
  
voteError = (e, data, status, xhr) ->
  errors = $.parseJSON(xhr.responseText)
  $.each errors, (index, value) ->
    $('.messages').append(value)
    
$(document).ready ->
  $(document).on('click', '.edit-answer-link', editAnswer)
  $(document).on('ajax:success', '.voting', voting)
  $(document).on('ajax:error', '.messages', voteError)

