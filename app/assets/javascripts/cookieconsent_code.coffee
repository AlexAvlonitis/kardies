$(document).on "turbolinks:load", ->
  window.cookieconsent.initialise
    'palette':
      'popup':
        'background': '#edeff5'
        'text': '#838391'
      'button': 'background': '#4b81e8'
    'content':
      'message': 'Τα cookies μας βοηθούν να προσφέρουμε τις υπηρεσίες μας. Με την χρησιμοποίηση των υπηρεσιών μας, συμφωνείτε στην χρήση των cookies.'
      'dismiss': 'OK'
      'link': 'Μάθετε περισσότερα '
      'href': '/terms#cookies'
