$ ->

  $('#imageModal').on('show.bs.modal', (event) ->
    button = $(event.relatedTarget)
    recipient = button.data('whatever')
    modal = $(this)
    modal.find('.profile-pic-modal').attr("src", recipient);
  )
