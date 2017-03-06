$(document).ready(function(){
  $(document).keydown(function(e) {
    if (e.keyCode == 37) { // left
      $('.slick-prev').trigger('click');
    }
    else if (e.keyCode == 39) { //right
      $('.slick-next').trigger('click');
    }
    });
});
