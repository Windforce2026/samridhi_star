$(document).ready(function () {
  if ($(".bannerowl").length) {
    var myCarousel = $(".bannerowl");
    myCarousel.owlCarousel({
      loop: true,
      items: 1,
      margin: 0,
      dots: false,
      nav: true,
      animateOut: "fadeOut",
      animateIn: "fadeIn",
      smartSpeed: 500,
      autoplay: 5000,
      autoplayHoverPause: true,
      navText: [
        '<i class="bi bi-arrow-left-short"></i>',
        '<i class="bi bi-arrow-right-short"></i>',
      ],
    });
  }
  if ($(".doctorsteam").length) {
    var myCarousel = $(".doctorsteam");
    myCarousel.owlCarousel({
      loop: false,
      items: 2,
      margin: 0,
      dots: false,
      nav: true,
      animateOut: "fadeOut",
      animateIn: "fadeIn",
      smartSpeed: 1000,
      autoplay: false,
      autoplayHoverPause: true,
      navText: [
        '<i class="bi bi-arrow-left-short"></i>',
        '<i class="bi bi-arrow-right-short"></i>',
      ],
      responsiveClass: true,
      responsive: {
        0: {
          items: 1,
        },
        575: {
          items: 2,
          margin: 5,
        },
        768: {
          items: 2,
          margin: 5,
        },
        1200: {
          items: 3,
          margin: 5,
        },
        1440: {
          items: 4,
          margin: 5,
        },
        1600: {
          items: 5,
          margin: 5,
        },
      },
    });
  }
  if ($(".testimonial").length) {
    var myCarousel = $(".testimonial");
    myCarousel.owlCarousel({
      loop: true,
      items: 2,
      margin: 0,
      dots: false,
      nav: true,
      animateOut: "fadeOut",
      animateIn: "fadeIn",
      smartSpeed: 500,
      autoplay: 5000,
      autoplayHoverPause: true,
      navText: [
        '<i class="bi bi-arrow-left-short"></i>',
        '<i class="bi bi-arrow-right-short"></i>',
      ],
      responsiveClass: true,
      responsive: {
        0: {
          items: 1,
        },
        768: {
          items: 2,
          margin: 5,
        },
        1200: {
          items: 3,
          margin: 5,
        },
      },
    });
  }
  if ($(".cardd").length) {
    var myCarousel = $(".cardd");
    myCarousel.owlCarousel({
      loop: false,
      items: 2,
      margin: 0,
      dots: true,
      nav: false,
      animateOut: "fadeOut",
      animateIn: "fadeIn",
      smartSpeed: 500,
      autoplay: 5000,
      autoplayHoverPause: true,
      responsiveClass: true,
      responsive: {
        0: {
          items: 1,
        },
        768: {
          items: 2,
          margin:15,
        },
        1200: {
          items: 3,
          margin:15,
        },
      },
    });
  }
});

$("html, body").animate({
  scrollTop: $(window).scrollTop() + 1,
}),
  300;
/*function lazyLoad() {
    var lazyloadImages;
    if ("IntersectionObserver" in window) {
        lazyloadImages = document.querySelectorAll(".lazy");
        var imageObserver = new IntersectionObserver(function(entries, observer) {
            entries.forEach(function(entry) {
                if (entry.isIntersecting) {
                    var image = entry.target;
                    image.src = image.dataset.src;
                    image.classList.remove("lazy");
                    imageObserver.unobserve(image);
                }
            });
        });
        lazyloadImages.forEach(function(image) {
            imageObserver.observe(image);
        });
    }
};

$(document).ready(function() {
    get_books_list();
});

function get_books_list() {
    var data = "get_blogs=YES&limit=6";
    $.ajax({
        type: "POST",
        url: "https://www.sitename.com/blog/post-api/",
        data: data,
        dataType: "json",
        beforeSend: function() {},
        success: function(data) {
            var skeleton = '';
            $.each(data, function(key, value) {
                skeleton = skeleton + '<div class="col-12 col-md-6 col-lg-6 my-3 parr"><div class="height100 border1 rounded bg-white shadow-sm"><div class="row g-0 height100"><div class="col-12 col-md-12 col-lg-5"><a href="https://www.sitename.com/blog/' + value.post_url + '"><img class="max lazy objectfit object-start" src="https://www.sitename.com/blog/images/blog-placeholder.jpg" data-src="https://www.sitename.com/blog/image/' + value.featured_img + '" data-srcset="https://www.sitename.com/blog/image/' + value.featured_img + '" alt="' + value.post_title + '"></a></div><div class="col-12 col-md-12 col-lg-7"><div class="p-3 height100 d-flex flex-column"><h4 class="font18 fw-400"><a href="https://www.sitename.com/blog/' + value.post_url + '">' + value.post_title + '</a></h4><p class="mt-auto m-0 font14"><i class="bi bi-calendar2"></i> ' + value.beautiful_post_dt + ' <span class="d-inline-block th-color fw-400 float-end">Read More...</span></p></div></div></div></div></div>';
            });
            $('#postholder').html(skeleton);
            lazyLoad();
        }
    });
}

*/
