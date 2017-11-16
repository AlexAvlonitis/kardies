$(document).on "turbolinks:load", ->

  slider = document.getElementById('slider-range')
  snapValues = [
    document.getElementById('slider-limit-value-min'),
    document.getElementById('slider-limit-value-max')
  ]

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
