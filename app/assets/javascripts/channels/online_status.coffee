$ ->

  return if App.cable.subscriptions.subscriptions.length > 1

  App.online_status = App.cable.subscriptions.create { channel: "OnlineStatusChannel" },

    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
