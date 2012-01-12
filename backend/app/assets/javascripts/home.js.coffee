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

  # Balloons
  $(".balloon").each (idx, it)->
    vert = if $(it).hasClass("top") then "top" else "bottom"
    hori = if $(it).hasClass("right") then "right" else "left"

    $(it).append("<img src='/assets/balloon_#{vert}_#{hori}.png' style='#{hori}:0; #{vert}: -30px'>")

    hover = $(it).attr("data-hover")
    if hover
      $(hover).hover ->
        $(it).fadeIn(200)
      , ->
        $(it).fadeOut(200)
      $(it).hide()
