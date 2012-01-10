# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  doResize= ->
    console.log "resize"
    w=0
    $('.pageHolder .page').each (idx, it)-> 
      $(it).css left: "#{w}px"
      w += $(it).find('.bookImage').width() + 5
    $('.pageHolder').width(w)

  $(window).resize doResize
  $(".pageHolder img").imagesLoaded null, doResize
