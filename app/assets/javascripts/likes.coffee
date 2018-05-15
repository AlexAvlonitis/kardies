$ ->

  $('.card-deck').on "click", ".like-link", (event) ->
    username = this.id
    url = this.href

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
