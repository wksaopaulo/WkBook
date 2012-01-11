# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  doResize= ->
    w=0
    $('.pageHolder .page').each (idx, it)-> 
      pageWidth = $(it).find('.bookTextTemplate, .cover').width()
      $(it).css left: "#{w}px", width: pageWidth
      w += pageWidth + 5 #margin
    $('.pageHolder').width(w)

  $(window).resize doResize
  $(".pageHolder img").imagesLoaded null, doResize
