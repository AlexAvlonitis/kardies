$ ->

  $('#messageModal').on('show.bs.modal', (event) ->
    button = $(event.relatedTarget)
    recipient = button.data('username')
    profile_picture = button.data('profile-pic')
    modal = $(this)
    modal.find('.modal-title').html(
        '<img src="' + profile_picture + '" class="d-inline-block mr-2 pic-round-xs" />' +
        "Αποστολή μηνύματος: " + recipient
      )
    modal.find('input[type="hidden"][name="message[username]"]').val(recipient)
  )
