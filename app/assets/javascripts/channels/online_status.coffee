$(document).on "turbolinks:load", ->

  App.online_status = App.cable.subscriptions.create { channel: "OnlineStatusChannel" },

    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
