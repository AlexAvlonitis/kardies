$ ->

  $('#search').hide()

  slider = document.getElementById('slider-range')
  if slider
    snapValues = [
      document.getElementById('slider-limit-value-min'),
      document.getElementById('slider-limit-value-max')
    ]

    uiTarget = $('.noUi-target')
    if uiTarget.length
      return
    else
      noUiSlider.create slider,
        start: [
          snapValues[0].value
          snapValues[1].value
        ]
        step: 1
        connect: true
        range:
          'min': 18
          'max': 99
        format: wNumb(decimals: 0)

    slider.noUiSlider.on 'update', (values, handle) ->
      snapValues[handle].value = values[handle]

    snapValues[0].addEventListener 'change', ->
      slider.noUiSlider.set([this.value, null])

    snapValues[1].addEventListener 'change', ->
      slider.noUiSlider.set([null, this.value])

  $('#search-collapse').on 'click', ->
    $('#search').toggle('fast')
    $('.search-icon').toggleClass('fa-search-plus fa-search-minus')

  $('#search-collapse').hover ->
    $(this).css('cursor','pointer')