# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->

  $('.gallery').jGallery()
  $('.city-selection').hide()
  $('.city-selection-label').hide()

  $("#message-modal").dialog({
    autoOpen: false,
    width: 'auto',
    maxWidth: 450,
    height: 'auto',
    modal: true,
    resizable: false,
    draggable: false,
    fluid: true
  })

  $('.like-link').on("ajax:success", (e, data, status, xhr) ->
    username  = this.id.split("__");
    getID = this.id
    url = this.href
    if url.includes("dislike")
      this.href = '/users/' + username[1] + "/like"
      $('#'+getID).html('<i class="fa fa-heart-o fa-2x"></i>')
    else
      this.href = '/users/' + username[1] + "/dislike"
      $('#'+getID).html('<i class="fa fa-heart fa-2x"></i>')
  ).on "ajax:error", (e, xhr, status, error) ->
    getID = this.id
    alert('Something went wrong, check your internet connection')


  $('.state-selection').change ->

    $.getJSON '/cities/' + $(this).val(), (data) ->

      $('.city-selection').empty()
      $('.city-selection-not-hidden').empty()
      $.each data, (key, val) ->
        opt = '<option value=' + val[1] + '>' + val[0] + '</option>'
        $('.city-selection').append opt
        $('.city-selection-not-hidden').append opt
    $('.city-selection').show()
    $('.city-selection-label').show()

  @previewProfilePic = ->
    preview = document.querySelector('img')
    file = document.querySelector('input[type=file]').files[0]
    profPic = $('.previewProfilePic')
    reader = new FileReader
    reader.addEventListener 'load', (->
      image = new Image()
      image.className = 'thumbnail thumb-size'
      image.style.display = "block"
      image.title = file.name
      image.src = this.result
      profPic.html image
    ), false
    if file
      reader.readAsDataURL file

  $('#edit-submit').on 'click', ->
    $body = $("body")
    $body.addClass("loading");
