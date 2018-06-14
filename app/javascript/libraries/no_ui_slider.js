export default class Slider {
  static call() {
    const slider = document.getElementById('slider-range');
    if (slider) {
      const snapValues = [
        document.getElementById('slider-limit-value-min'),
        document.getElementById('slider-limit-value-max')
      ];

      const uiTarget = $('.noUi-target');
      if (uiTarget.length) {
        return;
      } else {
        noUiSlider.create(slider, {
          start: [
            snapValues[0].value,
            snapValues[1].value
          ],
          step: 1,
          connect: true,
          range: {
            'min': 18,
            'max': 99
          },
          format: wNumb({decimals: 0})
        }
        );
      }

      slider.noUiSlider.on('update', (values, handle) => snapValues[handle].value = values[handle]);

      snapValues[0].addEventListener('change', function() {
        return slider.noUiSlider.set([this.value, null]);
      });

      return snapValues[1].addEventListener('change', function() {
        return slider.noUiSlider.set([null, this.value]);
      });
    }
  }
}
