$ ->

  $('.card-deck').on "click", ".like-link", () ->
    that = this
    toggleLikeIcon(that)

  $("#profile-pic-panel").on "click", ".like-link", () ->
    that = this
    toggleLikeIcon(that)

  toggleLikeIcon = (that) ->
    username = that.id
    url = that.href

    $.ajax(
      url,
      type: "PUT"
      dataType: "json"
    )
    .done (data) ->
      $("#" + username).html('<i class="fa ' + data.heart + '"></i>')
    .fail (xhr, status, error) ->
      swal(
        text: "Κάτι πήγε στραβά #{error}"
        type: 'warning'
      )
    return false
