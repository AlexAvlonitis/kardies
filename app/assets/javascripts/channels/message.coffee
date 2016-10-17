App.message = App.cable.subscriptions.create "MessageChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('#messages').append(data['message'])

  speak: (message, convo_id) ->
    @perform 'speak', message: message, conversation_id: convo_id

$(document).on 'keypress', '[data-behaviour~=message_speaker]', (event) ->
  conversation_id = $('#conversation').attr('conversation-id')
  if event.keyCode is 13
    App.message.speak event.target.value, conversation_id
    event.target.value = ""
    event.preventDefault()
