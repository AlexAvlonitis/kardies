$ ->

  $(".delete-convo").click (e) ->
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
          text: "Η συνομιλία διαγράφηκε"
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

  $(".get-convo").click (e) ->
    e.preventDefault()
    url = this.href
    conversationId = this.pathname.split('/')[2]

    $('#messages').html(
      '<p>' +
        'Παρακαλώ περιμένετε...' +
      '</p>'
    )

    App.message.unsubscribe() if App.message

    $(document).unbind()
    App.Message.create(conversationId)

    $.ajax(
      url,
      type: "GET",
      dataType: "json"
    )
    .done (data) ->
      $('#messages').empty()
      for d in data
        $('#messages').append(
          '<li class="friend-message">' +
            '<div class="head">' +
              '<span class="time">' +
                d.created_at +
              '</span>' +
              '<span class="name">' +
                '<img src="' +
                  d.sender.profile_picture +
                '" class="icon-size"/>' +
              '</span>' +
            '</div>' +
            '<div class="message">' +
              d.body +
            '</div>' +
          '</li>'
          )
      App.Message.messages_to_bottom()
    .fail (xhr, status, error) ->
      console.log(error)
