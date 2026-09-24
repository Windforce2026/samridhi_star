"use strict";
$(window).on("scroll", function () {
  var scroll = $(window).scrollTop();
  if (scroll >= 100) {
    $(".sticky-header").addClass("sticked");
  } else {
    $(".sticky-header").removeClass("sticked");
  }
});
document.addEventListener("click", function (e) {
  /* Hamburger menu*/
  if (e.target.classList.contains("hamburger-toggle")) {
    e.target.children[0].classList.toggle("active");
  }
});
$(".kadush a,.kadush button").on("mouseover", function () {
  var value = $(this).attr("data-img-src");
  $("img.typical").attr("src", value);
});

$(".parsley").parsley();
$(function () {
  var url = window.location.href;
  var page = url.substr(url.lastIndexOf("/") + 1);
  $('#navigation a[href*="' + page + '"]').addClass("active");
  $('.sdier a[href*="' + page + '"]')
    .closest("li")
    .addClass("active")
    .siblings()
    .removeClass("active");
  $('#navigation a[href*="' + page + '"]')
    .closest("li")
    .addClass("active")
    .siblings()
    .removeClass("active");
});
$(".inner,.obg").each(function (i, obj) {
  var action = $(obj).attr("data-bg");
  $(obj).css("background-image", "url(" + action + ")");
});

$(document).ready(function () {
  $("#close-btn").click(function () {
    $("#search-overlay").fadeOut();
    $("#search-btn").show();
  });
  $("#search-btn").click(function () {
    $(this).hide();
    $("#search-overlay").fadeIn();
  });
});

$(window).on("load", function () {
  $("#backToTop").on("click", function (e) {
    e.preventDefault();
    $("html, body").animate(
      {
        scrollTop: "0",
      },
      1200
    );
  });
});
$(window).on("scroll", function () {
  var scroll = $(window).scrollTop();
  if (scroll > 300) $("#backToTop").addClass("active");
  if (scroll < 300) $("#backToTop").removeClass("active");
  if (scroll > 150) $(".jaguar").addClass("showme");
  if (scroll < 150) $(".jaguar").removeClass("showme");
  if (window.screen.width <= 575) {
    var scroll = $(window).scrollTop();
  }
});
$(document).ready(function () {
  $(".datepicker").flatpickr({
    dateFormat: "d M, Y",
    minDate: "today",
    allowInput: true,
  });
  $(".sidebar").theiaStickySidebar({
    additionalMarginTop: 70,
  });
});
jQuery("img.svji").each(function () {
  var $img = jQuery(this);
  var imgID = $img.attr("id");
  var imgClass = $img.attr("class");
  var imgURL = $img.attr("src");
  jQuery.get(
    imgURL,
    function (data) {
      /*Get the SVG tag, ignore the rest*/
      var $svg = jQuery(data).find("svg");
      /* Add replaced image's ID to the new SVG*/
      if (typeof imgID !== "undefined") {
        $svg = $svg.attr("id", imgID);
      }
      /* Add replaced image's classes to the new SVG*/
      if (typeof imgClass !== "undefined") {
        $svg = $svg.attr("class", imgClass + " replaced-svg");
      }
      /* Remove any invalid XML tags as per http://validator.w3.org*/
      $svg = $svg.removeAttr("xmlns:a");
      /* Replace image with new SVG*/
      $img.replaceWith($svg);
    },
    "xml"
  );
});
