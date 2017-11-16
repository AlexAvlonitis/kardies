$ ->

  $("#email-preferences-form").hide()

  $(".show-email-preferences-form").on 'click', (e) ->
    e.preventDefault()
    $('#email-preferences-form').toggle("fast")

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
