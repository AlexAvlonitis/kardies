$ ->

  $('#reportModal').on('show.bs.modal', (event) ->
    button = $(event.relatedTarget)
    recipient = button.data('whatever')
    modal = $(this)
    modal.find('.modal-title').text("Αναφορά: " + recipient)
    modal.find('input[type="hidden"][name="report[username]"]').val(recipient)
  )
