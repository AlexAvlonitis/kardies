$(document).on "turbolinks:load", ->
  $("a[data-remote]").on "ajax:success", (e, data, status, xhr) ->
    $(this).closest('tr').fadeOut();
