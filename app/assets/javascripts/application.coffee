# // This is a manifest file that'll be compiled into application.js, which will include all the files
# // listed below.
# //
# // Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# // or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
# //
# // It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# // compiled file. JavaScript code in this file should be added after the last require_* statement.
# //
# // Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# // about supported directives.
# //
#= require jquery
#= require tether
#= require bootstrap
#= require cookies_eu
#= require jquery_ujs
#= require toastr
#= require lazyload
#= require turbolinks
#= require jgallery
#= require tinycolor.min
#= require bootstrap-filestyle
#= require_tree .

$(document).on "turbolinks:load", ->
  $("img").lazyload(
    threshold : 500,
    effect : "fadeIn"
  )

  toastr.options =
    'closeButton': true
    'debug': false
    'positionClass': 'toast-bottom-right'
    'onclick': null
    'showDuration': '300'
    'hideDuration': '1000'
    'timeOut': '3000'
    'extendedTimeOut': '1000'
    'showEasing': 'swing'
    'hideEasing': 'linear'
    'showMethod': 'fadeIn'
    'hideMethod': 'fadeOut'
