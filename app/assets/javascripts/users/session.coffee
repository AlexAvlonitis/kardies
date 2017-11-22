$ ->

  $('#new_user_session').submit (e) ->
    e.preventDefault()
    valuesToSubmit = replaceWords($(this).serialize())

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

  replaceWords =(attrs) ->
    attrs
      .replace('email', 'user%5Bemail%5D')
      .replace('password', 'user%5Bpassword%5D')
