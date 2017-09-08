# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "turbolinks:load", ->

  $('.gallery').jGallery()
  $('#change-password').hide()

  $('#messageModal').on('show.bs.modal', (event) ->
    button = $(event.relatedTarget)
    recipient = button.data('whatever')
    modal = $(this)
    modal.find('.modal-title').text("Αποστολή μηνύματος: " + recipient)
    modal.find('input[type="hidden"][name="message[username]"]').val(recipient)
  )

  $('.like-link').on("ajax:success", (e, data, status, xhr) ->
    username  = this.id.split("__");
    getID = this.id
    url = this.href
    if url.includes("dislike")
      this.href = '/users/' + username[1] + "/like"
      $('#'+getID).html('<i class="fa fa-heart-o"></i>')
    else
      this.href = '/users/' + username[1] + "/dislike"
      $('#'+getID).html('<i class="fa fa-heart"></i>')
  ).on "ajax:error", (e, xhr, status, error) ->
    getID = this.id
    alert('Something went wrong, check your internet connection')


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
