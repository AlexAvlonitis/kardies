# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "turbolinks:load", ->
  $('.hidden-gallery-form').hide()

  @previewFiles = ->

    preview = document.querySelector('#preview')
    files   = document.querySelector('input[type=file]').files

    readAndPreview = (file) ->

      if /\.(jpe?g|png|gif)$/i.test(file.name)
        reader = new FileReader();

        reader.addEventListener "load", (->
          image = new Image()
          image.className = 'thumbnail thumb-size'
          image.style.display = "block"
          image.title = file.name
          image.src = this.result
          preview.appendChild image
        ), false
        reader.readAsDataURL(file)

    if (files)
      [].forEach.call(files, readAndPreview)

  $('#gallery-submit').on 'click', ->
    $body = $("body")
    $body.addClass("loading");

  $('.create-gallery').on 'click', (e) ->
    e.preventDefault()
    $('.hidden-gallery-form').toggle()
