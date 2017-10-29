$(document).on "turbolinks:load", ->

  @countChar = () ->
    val = document.getElementById("abouts-description")
    len = val.value.length
    if len >= 1000
      val.value = val.value.substring(0, 1000)
    else
      $('#charNum')
        .css(color: '#287D0B')
        .text( "1000/#{1000 - len}" )
    return
