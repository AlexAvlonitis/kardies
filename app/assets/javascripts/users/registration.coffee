$ ->
  $('#new_user_registration').submit (e) ->
    e.preventDefault()
    valuesToSubmit = $(this).serialize()

    $.ajax('/user',
      type: "POST"
      data: valuesToSubmit
      dataType: "json"
    )
    .done ->
      window.location.href = "/users"
    .fail (xhr, status, error) ->
      errors = JSON.parse(xhr.responseText).errors
      e = ''
      for error of errors
        if errors.hasOwnProperty(error)
          e += ", #{errors[error][0]}"
      swal(
        text: "Κάτι πήγε στραβά#{e}"
        type: 'warning'
      )
      $("#user-registration-submit").removeAttr("disabled")
