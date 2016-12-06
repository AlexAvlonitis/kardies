$(document).on "turbolinks:load", ->
  count = 0
  # To Count Blank Fields

  ###------------ Validation Function-----------------###
  validate = ->
    input_field = $('.text_field')
    password_field = $('.password_field')
    password_confirmation_field = $('.password_confirmation_field')

    # validations
    if input_field.val() == "" || password_field.val() == "" || password_confirmation_field.val() == ""
      $("#form_errors").html 'Συμπληρώστε όλα τα πεδία'
      return false
    else if password_field.val().length < 6 || password_confirmation_field.val().length < 6
      # password less than 6 chars Validation
      $("#form_errors").html 'O κωδικός πρέπει να είναι πάνω απο 6 χαρακτήρες'
      return false
    else if password_field.val() != password_confirmation_field.val()
      # password less than 6 chars Validation
      $("#form_errors").html 'O κωδικός πρέπει να είναι ίδιος με τον κωδικό επαλήθευσης'
      return false
    else
      return true

  ###---------------------------------------------------------###

  $('.next_btn').click ->
    return if validate() == false
    # Function Runs On NEXT Button Click
    $(this).parent().next().fadeIn 'slow'
    $(this).parent().css 'display': 'none'
    # Adding Class Active To Show Steps Forward;
    $('.active').next().addClass 'active'
    return
  $('.pre_btn').click ->
    # Function Runs On PREVIOUS Button Click
    $(this).parent().prev().fadeIn 'slow'
    $(this).parent().css 'display': 'none'
    # Removing Class Active To Show Steps Backward;
    $('.active:last').removeClass 'active'
    return
