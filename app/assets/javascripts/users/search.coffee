$ ->

  $('#search').hide()

  $('#search-collapse').on 'click', ->
    $('#search').slideToggle('fast')
    $('.search-icon').toggleClass('fa-search-plus fa-search-minus')

  $('#search-collapse').hover ->
    $(this).css('cursor','pointer')
