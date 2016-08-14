# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->

  $('.hidden_states').hide()
  $('.hidden_cities').hide()
  $('#place_country').change ->
    $.getJSON '/countries/' + $(this).val(), (data) ->
      $('.hidden_cities').hide()
      $('#place_state').empty()
      $.each data, (key, val) ->
        opt = '<option value=' + key + '>' + val + '</option>'
        $('#place_state').append opt
    $('.hidden_states').show()

  $('#place_state').change ->
    $.getJSON '/cities/' + $(this).val(), (data) ->
      $('#place_city').empty()
      $.each data, (key, val) ->
        opt = '<option value=' + key + '>' + val + '</option>'
        $('#place_city').append opt
    $('.hidden_cities').show()
