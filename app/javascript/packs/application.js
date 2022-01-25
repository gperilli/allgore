// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

// app/javascript/packs/application.js
//import 'bootstrap';
import Flickity from 'flickity';
localStorage.setItem("carouselState", 0);

// Window page load event listener only fires for complete page load or refresh
window.addEventListener( 'load', function() {
  console.log("Page load with carouselLoader");
  carouselLoader();
});

// Turbolink event listener fires for every page load including a back button click
document.addEventListener('turbolinks:load', () => {
    console.log("Turbolinks Load.");
    console.log(`Carousel State: ${localStorage.getItem("carouselState")}`);
    if (localStorage.getItem("carouselState") == 1) {
      localStorage.setItem("carouselState", 0);
      location.reload();
    }
});

function carouselLoader() {
  localStorage.setItem("carouselState", 1);
  var elem = document.querySelector('.main-carousel');
    if (elem != null) {
        var flkty = new Flickity(elem, {
          // options
          fullscreen: true,
          wrapAround: true,
          prevNextButtons: false,
          autoPlay: 10000,
        });      
    } 
}


// Opacity fade for top nav search bar background
window.addEventListener('scroll', function () {
  var currScrollPos2 = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop || 0;
  if (currScrollPos2 > 25) {
    document.getElementById('test').classList.add('navbar-fadein');
  } else {
    document.getElementById('test').classList.remove("navbar-fadein");
  }
}
);
