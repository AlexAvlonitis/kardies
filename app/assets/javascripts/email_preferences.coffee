$ ->

  $("#email-preferences-form").hide()

  $("#show-email-preferences-form").click ->
    $('#email-preferences-form').slideToggle("fast")
    $('.email-toggle-icon').toggleClass("fa-chevron-circle-down fa-chevron-circle-up")

  $("#show-email-preferences-form").hover ->
    $(this).css('cursor','pointer')

  $('#email-preferences-form').submit (e) ->
    e.preventDefault()
    valuesToSubmit = $(this).serialize()

    $.ajax('/email_preferences',
      type: "PUT"
      data: valuesToSubmit
      dataType: "json"
    )
    .done ->
      swal(
        text: "Η αλλαγή σας σώθηκε"
        type: "success"
      ).then ->
        $("#email-preferences-submit").removeAttr("disabled")
    .fail (xhr, status, error) ->
      swal(
        text: "Κάτι πήγε στραβά, #{error}"
        type: 'warning'
      )
