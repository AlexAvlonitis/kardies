$ ->

  $('.gallery').jGallery()
  @previewFiles = ->

    preview = document.querySelector('#preview')
    files   = document.querySelector('input[type=file]').files

    readAndPreview = (file) ->

      if /\.(jpe?g|png|gif)$/i.test(file.name)
        reader = new FileReader();

        reader.addEventListener "load", (->
          image = new Image()
          image.className = 'thumbnail thumb-size'
          image.style.display = "block"
          image.title = file.name
          image.src = this.result
          preview.appendChild image
        ), false
        reader.readAsDataURL(file)

    if (files)
      [].forEach.call(files, readAndPreview)

  $('#imageModal').on('show.bs.modal', (event) ->
    button = $(event.relatedTarget)
    recipient = button.data('whatever')
    modal = $(this)
    modal.find('.profile-pic-modal').attr("src", recipient);
  )

  $('#gallery-submit').on 'click', ->
    $body = $("body")
    $body.addClass("loading");

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

  $('.slick-images').slick
    lazyLoad: 'ondemand',
    dots: true,
    infinite: true,
    speed: 300,
    slidesToShow: 1,
    centerMode: true,
    variableWidth: true
    adaptiveHeight: true
