$ ->

  $('#messageModal').on('show.bs.modal', (event) ->
    button = $(event.relatedTarget)
    recipient = button.data('whatever')
    modal = $(this)
    modal.find('.modal-title').text("Αποστολή μηνύματος: " + recipient)
    modal.find('input[type="hidden"][name="message[username]"]').val(recipient)
  )
