(function ($) {
    
    // Init Wow
    wow = new WOW( {
        animateClass: 'animated',
        offset:       100
    });
    wow.init();
    
    // Navigation scrolls

    $(function() {
        $('a[href*="#"]:not([href="#"])').click(function() {
            if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
                var target = $(this.hash);
                target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
                if (target.length) {
                    $('html, body').animate({
                        scrollTop: target.offset().top
                    }, 1000);
                    return false;
                }
            }
        });
    });

    $(document).on('turbolinks:click', function (event) {
        if (event.target.getAttribute('href').charAt(0) === '#') {
            return event.preventDefault()
        }
    })

    //jQuery to collapse the navbar on scroll
    $(window).scroll(function() {
        if ($(".navbar-default").offset().top > 50) {
            $(".navbar-fixed-top").addClass("top-nav-collapse");
        } else {
            $(".navbar-fixed-top").removeClass("top-nav-collapse");
        }
    });
    
    // Testimonials Slider
    $('.bxslider').bxSlider({
      adaptiveHeight: true,
      mode: 'fade'
    });
    
})(jQuery);