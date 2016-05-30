//= require ./stellar

$(window).scroll(function() {
  var value = $(this).scrollTop();
  if (value > 80)
    $(".navbar-inverse").css("background", "#111");
  else
    $(".navbar-inverse").css("background", "transparent");
});


// Stellar
$.stellar({
    horizontalOffset: 50,
    verticalOffset: 50,
    responsive: true
});
