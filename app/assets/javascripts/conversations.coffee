$(document).on "turbolinks:load", ->

  $("a[data-remote]").on("ajax:success", (e, data, status, xhr) ->
    e.preventDefault
    $(this).closest('tr').fadeOut();
  ).on "ajax:error", (e, xhr, status, error) ->
    alert('Something went wrong, please refresh the page')
