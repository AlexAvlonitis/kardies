$ ->

  pathName = window.location.pathname

  if pathName.includes("users")
    $('#users').addClass('border-bottom-nav-link')
  if pathName.includes("conversations")
    $('#conversations').addClass('border-bottom-nav-link')
  if pathName.includes("test-prosopikotitas")
    $('#personalities').addClass('border-bottom-nav-link')
  if pathName.includes("likes")
    $('#likes').addClass('border-bottom-nav-link')
