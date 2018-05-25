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
          $("li[data-conversation-id=#{conversationId}]").fadeOut()
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
    username = $('.container-fluid').attr('data-username')

    $('#messages').html(
      '<div class="d-flex justify-content-center">' +
        '<div class="loader">' +
        '</div>' +
      '</div>'
    )

    removeLeftMenu() if mobileView()
    $('#conversation-form :input').prop("disabled", false);
    App.message.unsubscribe() if App.message

    $(document).unbind('.myEvents')
    App.Message.create(conversationId)

    $.ajax(
      url,
      type: "GET",
      dataType: "json"
    )
    .done (data) ->
      $('#messages').empty()
      date = new Date();
      for d in data
        $('#messages').append(
          '<li class="message-bubble">' +
            '<div class="head">' +
              '<div class="name">' +
                '<a href="/users/' + d.sender.username + '">' +
                  '<img src="' +
                    d.sender.profile_picture +
                  '" class="icon-size"/>' +
                '</a>' +
              '</div>' +
              '<div class="time">' +
                date.toDateString(d.created_at) +
              '</div>' +
            '</div>' +
            '<div class="message">' +
              '<p>' +
                d.body +
              '</p>' +
            '</div>' +
          '</li>'
          )
      App.Message.messages_to_bottom()
    .fail (xhr, status, error) ->
      console.log(error)

  $('.left-menu-toggle-icon').click ->
    removeLeftMenu()

  removeLeftMenu = () ->
    $('#left-menu').fadeToggle()

  mobileView = () ->
    if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) )
      return true
    return false
