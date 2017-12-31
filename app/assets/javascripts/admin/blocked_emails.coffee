$ ->

  $('.remove-blocked-email').on 'click', (e) ->
    e.preventDefault()
    that = $(this)

    url = that.context.pathname
    swal(
      text: 'This record will be deleted!'
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
          text: "διαγράφηκε"
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

  $('.add-blocked-email').on 'submit', (e) ->
    e.preventDefault()
    that = $(this)

    valuesToSubmit = that.serialize()
    url = that.context.pathname
    $.ajax(url,
      type: "POST"
      data: valuesToSubmit
      dataType: "json"
    )
    .done (xhr) ->
      swal(
        text: "Η αλλαγή σας σώθηκε"
        type: "success"
      ).then ->
        record = xhr.message
        $(".email-blocked-submit").removeAttr("disabled")
        $('.table tr:last').after(
          '<tr>' +
          "<td> #{record.email} </td>" +
          "<td> #{record.domain} </td>" +
          '</tr>'
          );
    .fail (xhr, status, error) ->
      swal(
        text: "Κάτι πήγε στραβά, #{error}"
        type: 'warning'
      )
