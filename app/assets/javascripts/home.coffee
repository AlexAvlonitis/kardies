# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "turbolinks:load", ->
  $(':file').filestyle btnClass: 'btn-primary', placeholder: 'Επιλογή φωτογραφίας προφίλ'

  @previewProfilePic = ->
    preview = document.querySelector('img')
    file = document.querySelector('input[type=file]').files[0]
    profPic = $('.previewProfilePic')
    reader = new FileReader
    reader.addEventListener 'load', (->
      image = new Image()
      image.className = 'img-circle'
      image.style.display = "block"
      image.title = file.name
      image.src = this.result
      profPic.html image
    ), false
    if file
      reader.readAsDataURL file
