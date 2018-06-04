$ ->

  $("#blocked-users-form").hide()

  $("#show-blocked-users-form").click ->
    $("#blocked-users-form").slideToggle("fast")
    $('.blocked-users-toggle-icon').toggleClass("fa-chevron-circle-down fa-chevron-circle-up")

  $("#show-blocked-users-form").hover ->
    $(this).css('cursor','pointer')

  $(".unblock-user").on 'click', ->
    that = $(this)
    url = this.href

    swal(
      text: "Ο χρήστης θα αφαιρεθεί απο την λίστα"
      type: 'warning'
      showCancelButton: true
      confirmButtonColor: '#3085d6'
      cancelButtonColor: '#d33'
      confirmButtonText: 'Ναι'
      cancelButtonText: 'Ακύρωση'
    ).then ->
        $.ajax(
          url,
          type: "DELETE",
          dataType: "json"
        )
        .done (data) ->
          swal(
            text: "Ο χρήστης αφαιρέθηκε"
            type: 'success'
          ).then ->
            that.closest('li').fadeOut()
        .fail (xhr, status, error) ->
          error = xhr.responseJSON.errors
          swal(
            text: error
            type: 'warning'
          )
    return false

  $("#block-user").submit (e) ->
    e.preventDefault()
    that = $(this)
    blocked_user_id = that.find('input[id="blocked_user_id"]').val()
    url = that.context.action

    swal(
      title: 'Αποκλεισμός χρήστη'
      text: "Ο χρήστης θα μπλοκαριστεί"
      type: 'warning'
      showCancelButton: true
      confirmButtonColor: '#3085d6'
      cancelButtonColor: '#d33'
      confirmButtonText: 'Ναι'
      cancelButtonText: 'Ακύρωση'
    ).then ->
        $.ajax(
          url,
          type: "POST",
          dataType: "json",
          data: {
            blocked_user_id: blocked_user_id
          }
        )
        .done (data) ->
          swal(
            text: "Ο χρήστης αποκλείστηκε"
            type: 'success'
          ).then ->
            window.location.href = "/"
        .fail (xhr, status, error) ->
          error = xhr.responseJSON.errors
          swal(
            text: error
            type: 'warning'
          )
