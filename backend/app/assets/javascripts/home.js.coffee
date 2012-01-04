# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  doResize= ->
    w=0
    $('.pageHolder img').each (idx, it)-> w += $(it).width()
    $('.pageHolder').width(w)

  doResize();
  $(window).resize(doResize)
