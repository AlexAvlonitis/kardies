$ ->

  class App.Message
    @create = (conversationId) ->
      submitForm(conversationId)
      listenToKeyboard(conversationId)
      createSubscription(conversationId)

    @messages_to_bottom = () ->
      messages = $('#messages')
      if messages.length > 0
        messages.scrollTop(messages.prop("scrollHeight"))

    createSubscription = (conversationId) ->
      App.message = App.cable.subscriptions.create(
        { channel: "MessageChannel", conversation_id: conversationId },

        connected: ->

        disconnected: ->
          App.cable.subscriptions.remove(this)

        received: (data) ->
          $('#messages').append(data['message'])
          App.Message.messages_to_bottom()

        speak: (message, convo_id) ->
          @perform 'speak', message: message, conversation_id: convo_id
      )

    listenToKeyboard = (conversationId) ->
      $(document).on 'keypress', '[data-behaviour~=message_speaker]', (event) ->
        if event.keyCode is 13
          messageValue = event.target.value
          unless sanitizeInput(messageValue) == ""
            App.message.speak messageValue, conversationId
          event.target.value = ""
          event.preventDefault()

    submitForm = (conversationId) ->
      $('#conversation-form').submit (e) ->
        e.preventDefault()
        messageValue = $('.conversation-message').val()
        unless sanitizeInput(messageValue) == ""
          App.message.speak messageValue, conversationId
        $('.conversation-message').val("")

    sanitizeInput = (data) ->
      regex = /\<|\>/g
      trimmedData = data.replace(regex, "").trim()
      return trimmedData
