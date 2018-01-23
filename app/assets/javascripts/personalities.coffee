$ ->

  $('#personalities-form').submit (e) ->
    e.preventDefault()
    valuesToSubmit = $(this).serialize()

    $.ajax('/test-prosopikotitas',
      type: "POST"
      data: valuesToSubmit
      dataType: "json"
    )
    .done (xhr) ->
      swal(
        text: "Η αλλαγή σας σώθηκε είστε #{xhr.data}, \nΘα μεταβείτε αυτόματα στο προφίλ σας για να δείτε τις λεπτομέρειες"
        type: "success"
      ).then ->
        currentUser = $("#current-user-name").text()
        window.location.href = "/users/#{currentUser}"
    .fail (xhr, status, error) ->
      e = xhr.responseJSON.error
      swal(
        text: e
        type: 'warning'
      )
      $("#personalities-submit").removeAttr("disabled")
