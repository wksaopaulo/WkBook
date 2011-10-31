# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

setupFormInteraction = ->
    # 'Upload field' surprise image
    $('#w').hover ->
        images = $('#w .userInput img')
        # Picking an image
        surpriseImage = Math.floor Math.random()*(images.length)
        # Showing the picked image
        for i in [0..images.length-1]
            $(images[i]).css(display: if surpriseImage == i then 'block' else 'none');
    , ->
        $("#w .userInput img").hide();
        $("#w input:file").css {top: 0, left: 0}

    # Select file on click
    $('#w').mousemove (e)-> 
        pos = $('#w').offset();
        posX = e.pageX - pos.left
        posY = e.pageY - pos.top

        if(posX < 0 || posY < 0 || posX > 260 || posY > 275)
            posX = posY = 0

        $('#w input:file').css {top: posY - 5, left: posX - 5};

    # Text surprise image
    $('#k').hover ->
        images = $('#k .userInput img')
        # Picking an image
        surpriseImage = Math.floor Math.random()*(images.length)
        # Showing the picked image
        for i in [0..images.length-1]
            $(images[i]).css(display: if surpriseImage == i then 'block' else 'none');
    , ->
        $("#k .userInput img").hide();
    
    # Avoid hide qhen clicking in itself
    $('#k').click (e)->
        # show text editing panel
        $("#textPanel").css(display: 'block');
        e.stopPropagation();
        # Make it hide when needed
        $('#textPanel').click (clickEvent)->
            clickEvent.stopPropagation();
        $('html').click ->
            $('#textPanel').css(display: 'none');

    #Slider change stuff
    slideVal = if typeof(window.effectAmountValue) != 'undefined' then 0.5 else window.effectAmountValue
    $("#effectControls .jslider").slider(value: slideVal, step:0.01, min: 0, max: 1).bind 'slidechange', (event, ui)->
        val = ui.value
        $("#effect")[0].setAmount val
        

$(document).ready setupFormInteraction;
