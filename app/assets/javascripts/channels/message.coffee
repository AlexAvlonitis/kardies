$ ->
  conversation_id = $('#conversation').attr('conversation-id')

  App.message = App.cable.subscriptions.create { channel: "MessageChannel", conversation_id: conversation_id },
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      $('#messages').append(data['message'])

    speak: (message, convo_id) ->
      @perform 'speak', message: message, conversation_id: convo_id

  $(document).on 'keypress', '[data-behaviour~=message_speaker]', (event) ->
    if event.keyCode is 13
      App.message.speak event.target.value, conversation_id
      event.target.value = ""
      event.preventDefault()

  $('#conversation-form').submit (event) ->
    event.preventDefault()
    message = $('.conversation-message').val()
    App.message.speak message, conversation_id
    $('.conversation-message').val("")
