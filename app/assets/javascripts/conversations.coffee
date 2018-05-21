$ ->

  $('#conversation-form :input').prop("disabled", true);

  $(".delete-convo").click (e) ->
    e.preventDefault()
    that = $(this)
    url = that.context.pathname
    conversationId = that.context.getAttribute('data-conversation-id')

    swal(
      text: 'Η συνομιλία θα διαγραφεί!'
      type: 'warning'
      showCancelButton: true
      confirmButtonColor: '#3085d6'
      cancelButtonColor: '#d33'
      confirmButtonText: 'OK'
      cancelButtonText: 'Ακύρωση'
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
          App.message.unsubscribe() if App.message
          $('#messages').empty()
          $('#conversation-form :input').prop("disabled", true);
          $("a[data-conversation-id=#{conversationId}]").fadeOut()
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

    $('#conversation-form :input').prop("disabled", false);
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
