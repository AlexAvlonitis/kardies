$ ->
  conversation_id = $('#conversation').attr('conversation-id')

  App.message = App.cable.subscriptions.create { channel: "MessageChannel", conversation_id: conversation_id },
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      @uninstall()

    received: (data) ->
      $('#messages').append(data['message'])
      messages_to_bottom()

    speak: (message, convo_id) ->
      @perform 'speak', message: message, conversation_id: convo_id

  $(document).on 'keypress', '[data-behaviour~=message_speaker]', (event) ->
    if event.keyCode is 13
      messageValue = event.target.value
      unless messageValue.trim() == ""
        App.message.speak messageValue, conversation_id
      event.target.value = ""
      event.preventDefault()

  $('#conversation-form').submit (event) ->
    event.preventDefault()
    message = $('.conversation-message').val()
    App.message.speak message, conversation_id
    $('.conversation-message').val("")

  messages = $('#messages')
  if $('#messages').length > 0
    messages_to_bottom = -> messages.scrollTop(messages.prop("scrollHeight"))

    messages_to_bottom()

  uninstall: ->
    $(document).off(".appearance")
    $(buttonSelector).hide()
