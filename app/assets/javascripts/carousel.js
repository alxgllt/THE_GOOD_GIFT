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
