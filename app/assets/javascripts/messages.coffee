# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->

  $('#messageModal').on('show.bs.modal', (event) ->
    button = $(event.relatedTarget)
    recipient = button.data('whatever')
    modal = $(this)
    modal.find('.modal-title').text("Αποστολή μηνύματος: " + recipient)
    modal.find('input[type="hidden"][name="message[username]"]').val(recipient)
  )
