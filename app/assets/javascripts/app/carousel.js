function initCarousel() {
  $(".owl-carousel").owlCarousel({
    items: 1,
    nav: true,
    loop: true,
    smartSpeed: 550,
    mouseDrag: true,
    navText: ["Précedent","Suivant"],
  });
}

function Ordercount() {
  $(".owl-carousel").on('changed.owl.carousel', function(event) {
        $(".order-button").attr("disabled", true);
        setTimeout(function() {
          var product_1 = $('.owl-carousel.owl-big .owl-item.active').children().data('id');
          var product_2 = $('.owl-carousel.owl-medium .owl-item.active').children().data('id');
          var product_3 = $('.owl-carousel.owl-small .owl-item.active').children().data('id');
          $("#big").val(product_1);
          $("#medium").val(product_2);
          $("#small").val(product_3);
          $(".order-button").removeAttr("disabled");
        }, 800);
      });
}
