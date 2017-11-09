$(document).on "turbolinks:load", ->

  $(".delete-convo").on 'click', (e) ->
    e.preventDefault()
    that = $(this)
    url = that.context.pathname
    swal(
      text: 'Η συνομιλία θα διαγραφεί!'
      type: 'warning'
      showCancelButton: true
      confirmButtonColor: '#3085d6'
      cancelButtonColor: '#d33'
      confirmButtonText: 'OK'
    ).then ->
      $.ajax(url,
        type: "DELETE"
        dataType: "json"
      )
      .done ->
        swal(
          text: "Η συνομιλία μεταφέρθηκε στον κάδο ανακύκλωσης"
          type: "success"
        ).then ->
          that.closest('tr').fadeOut()
      .fail (xhr, status, error) ->
        errors = JSON.parse(xhr.responseText).errors
        e = ''
        for error of errors
          if errors.hasOwnProperty(error)
            e += ", #{errors[error][0]}"
        swal(
          text: "Κάτι πήγε στραβά#{e}"
          type: 'warning'
        )
        $(".delete-convo").removeAttr("disabled")
