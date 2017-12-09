$ ->

  $("#gallery-form").hide()

  $("#show-gallery-form").click ->
    $('#gallery-form').toggle("fast")
    $('.gallery-toggle-icon').toggleClass("fa-caret-down fa-caret-up")

  $("#show-gallery-form").hover ->
    $(this).css('cursor','pointer')

  $('#fileupload').fileupload(
    dataType: 'json'
    add: (e, data) ->
      data.context = $('<button/>').text('Αποθηκεύστε').addClass('btn btn-success')
        .appendTo("#progress")
      .click ->
        data.context = $('#progress').text('Παρακαλώ περιμένετε...').addClass('loading-gif')
        data.submit()
    done: (e, data) ->
      swal(
        text: "Η αλλαγή σας σώθηκε"
        type: "success"
      ).then ->
        data.context.text('Αποθηκεύτηκε!').removeClass('loading-gif')
    fail: (e, data) ->
      swal(
        text: "Κάτι πήγε στραβά, #{data.errorThrown}"
        type: 'warning'
      )
  )

  $('#gallery-fileupload').fileupload(
    dataType: 'json'
    add: (e, data) ->
      data.context = $('<button/>').text('Αποθηκεύστε').addClass('btn btn-success')
        .appendTo("#gallery-progress")
      .click ->
        data.context = $('#gallery-progress').text('Παρακαλώ περιμένετε...').addClass('loading-gif')
        data.submit()
    done: (e, data) ->
      url = data.result.url
      swal(
        text: "Η αλλαγή σας σώθηκε"
        type: "success"
      ).then ->
        $('#galleries-table tr:last')
          .after(
            '<tr>' +
            '<td>' +
            "<img class='pic-round-sm' src=" + url + "/>"
            '<td>' +
            '</tr>'
          )
        data.context.text('Αποθηκεύτηκε!').removeClass('loading-gif')
    fail: (e, data) ->
      swal(
        text: "Κάτι πήγε στραβά, #{data.errorThrown}"
        type: 'warning'
      )
  )

  $(".delete-picture").on 'click', (e) ->
    e.preventDefault()
    that = $(this)
    url = that.context.pathname
    swal(
      text: 'Η φωτογραφία θα διαγραφεί!'
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
          text: "Η φωτογραφία διαγράφηκε"
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
        $(".delete-picture").removeAttr("disabled")

  $('.slick-images').slick
    lazyLoad: 'ondemand'
    dots: true
    infiniteScroll: true
    slidesToShow: 3
    slidesToScroll: 1
    adaptiveHeight: true

  $('.swipebox').swipebox()
