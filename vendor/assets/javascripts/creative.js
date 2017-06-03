(function($) {
    "use strict"; // Start of use strict

    // jQuery for page scrolling feature - requires jQuery Easing plugin
    $(document).on('scroll', function() {
      if ($(window).width() > 768) {
        $('.navbar').css('background-color', '#3b5998')
        $('.navbar-brand').css('color', '#FFFFFF')
        $('.navbar a').css('color', '#FFFFFF')
        $('.navbar-brand').css('font-size', '20px')
        if ($(this).scrollTop() > 50) {
          $('.navbar').css('background-color', '#f5f5f5')
          $('.navbar a').css('color', '#F05F40')
          $('.navbar-brand').css('color', '#F05F40')
          $('.navbar-brand').css('font-size', '16px')
        }
      }
    });

})(jQuery); // End of use strict
