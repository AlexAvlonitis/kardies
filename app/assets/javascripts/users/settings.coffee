$ ->

  $('#change-password').hide()
  $('#user-form').hide()

  $(".show-user-form").on 'click', (e) ->
    e.preventDefault()
    $("#user-form").toggle("fast")

  $('.state-selection').change ->
    $.getJSON '/cities/' + $(this).val(), (data) ->
      $('.city-selection').empty()
      $.each data, (key, val) ->
        opt = '<option value=' + val[1] + '>' + val[0] + '</option>'
        $('.city-selection').append opt

  $('#edit-submit').on 'click', ->
    $body = $("body")
    $body.addClass("loading");

  $('.change-password-link').on 'click', (e) ->
    e.preventDefault()
    $('#change-password').toggle()

  $('#user-form').submit (e) ->
    e.preventDefault()
    valuesToSubmit = $(this).serialize()

    $.ajax('/user',
      type: "PUT"
      data: valuesToSubmit
      dataType: "json"
    )
    .done ->
      swal(
        text: "Η αλλαγή σας σώθηκε"
        type: "success"
      ).then ->
        $("#user-submit").removeAttr("disabled")
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
      $("#user-submit").removeAttr("disabled")
