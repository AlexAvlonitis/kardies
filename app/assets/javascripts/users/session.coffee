$ ->
  $('#new_user_session').submit (e) ->
    e.preventDefault()
    valuesToSubmit = $(this).serialize()

    $.ajax('/user/sign_in',
      type: "POST"
      data: valuesToSubmit
      dataType: "json"
    )
    .done ->
      window.location.href = "/users"
    .fail (xhr, status, error) ->
      e = JSON.parse(xhr.responseText).error
      swal(
        text: e
        type: 'warning'
      )
      $("#user-session-submit").removeAttr("disabled")
