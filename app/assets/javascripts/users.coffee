$(document).on "turbolinks:load", ->

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
