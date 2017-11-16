$ ->

  $("#abouts-form").hide()

  $(".show-abouts-form").on 'click', (e) ->
    e.preventDefault()
    $("#abouts-form").toggle("fast")

  @countChar = () ->
    val = document.getElementById("abouts-description")
    len = val.value.length
    if len >= 1000
      val.value = val.value.substring(0, 1000)
    else
      $('#charNum')
        .css(color: '#287D0B')
        .text( "1000/#{1000 - len}" )
    return

  $(".delete-confirmation").on 'click', (e) ->
    e.preventDefault()
    swal(
      title: 'Είστε σίγουρος/η?'
      text: "Ο λογαριασμός θα διαγραφεί ολοκληρωτικά!"
      type: 'warning'
      showCancelButton: true
      confirmButtonColor: '#3085d6'
      cancelButtonColor: '#d33'
      confirmButtonText: 'Ναι'
    ).then ->
        $.ajax('/user',
          type: "POST",
          data: {"_method":"delete"}
        )
        .done ->
          location.reload()
        .fail ->
          swal("Κάτι πήγε στραβά, παρακαλούμε ελέγξτε την σύνδεσή σας")

  $('#abouts-form').submit (e) ->
    e.preventDefault()
    valuesToSubmit = $(this).serialize()

    $.ajax('/about',
      type: "PUT"
      data: valuesToSubmit
      dataType: "json"
    )
    .done ->
      swal(
        text: "Η αλλαγή σας σώθηκε"
        type: "success"
      ).then ->
        $("#about-submit").removeAttr("disabled")
    .fail (xhr, status, error) ->
      swal(
        text: "Κάτι πήγε στραβά, #{error}"
        type: 'warning'
      )
      $("#about-submit").removeAttr("disabled")
