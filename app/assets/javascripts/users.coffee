$(document).on "turbolinks:load", ->

  $('#change-password').hide()

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
    e.preventDefault
    $('#change-password').toggle()
