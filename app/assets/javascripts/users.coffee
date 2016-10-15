# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->

  $('.like-link').on("ajax:success", (e, data, status, xhr) ->
    username  = this.id.split("_");
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
