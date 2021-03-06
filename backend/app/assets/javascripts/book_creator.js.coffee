# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#
window.textColors = [0x0, 0xffffff, 0xcc0000, 0x00cc00, 0xcc00cc, 0x0000cc]
window.setTextLayout = (id)->
    #Tell flash what changed
    $("#effect")[0].setTextLayout id
    #Update interface
    $("#textTemplates .previewText").each (idx, it) ->
        if idx == id
            $(it).addClass("selected")
        else
            $(it).removeClass("selected")
    #Save value
    $("form .textLayout").val(id);

# Form submission flow
window.submitPage = -> 
    $("#wait").fadeIn(500)
    setTimeout ->
      $("#effect")[0].upload();
    , 500
window.submitTextPage = ->
    return unless confirm "Save your page now?"
    window.location.href = "/book_creator/save_text_template?id=#{ $("#templates img.preview.selected").attr('data-id') }"
window.uploadComplete = ->
    $("#wait").fadeOut()
    window.location.href = "/book_creator/preview_text"
window.uploadFailed = (msg)->
    $("#wait").fadeOut()
    alert msg

# Page setup
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

    # Scroll
    if $("#templates").length > 0
      $("#templates").jScrollPane(showArrows: true)
      $(window).resize ->
        $("#templates").jScrollPane(showArrows: true)

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
        $('html, #textPanel .close').click ->
            $('#textPanel').css(display: 'none');

    $("#textPanel textarea, #textPanel input[type=text]").bind "keyup click blur focus change paste", ->

      $("#textPanel textarea").val($("#textPanel textarea").val().substring(0, 900)) if $("#textPanel textarea").val().length > 900

      wc = titleCount = $("#textPanel textarea").val().length

      # More words then allowed
      maxChars = 900 #See book_creator_controller.rb, around line 42 (title: 100chars / text: 900chars)
      $(".remainingWords").html("#{maxChars - wc} characters remaining")

    #Form validation
    $('#createBook').bind "submit", ->
      has_image = $("#w .userInput img").length == 1 || $("#w input[type=file]").val() != ""
      has_text = $("#user_template_text").val() != "" || $("#user_template_title").val() != ""
      unless has_image
        alert "Clique em W para adicionar uma imagem"
        return false
      unless has_text
        alert "Clique em K para adicionar um texto"
        return false
      return true
        

    #Effect slider change stuff
    slideVal = if typeof(window.effectAmountValue) == 'undefined' then 0.5 else window.effectAmountValue
    $("#effectAmount").slider(value: slideVal, step:0.01, min: 0, max: 1).bind 'slidechange', (event, ui)->
        $("#effect")[0].setAmount ui.value
        #This is the value we will send to the server
        $("form .amount").val(ui.value);

    #Text page resize and interaction
    if $("#textPreview").length > 0
      resize = ->
        t_height = $(document).height() - 150
        $("#textPreview").height(t_height).width(t_height*1.49).css(marginLeft: $(document).width()/2 - t_height*1.5/2)
      $(window).resize resize
      resize();

      $("#templates a").click ->
        #Change style
        $("#swf")[0].setTextLayout $(this).find(".preview").attr("data-frame")
        #Move image
        $("#image").attr "style", $(this).find(".preview").attr("data-crop")
        #Selected item
        $("#templates a img").removeClass "selected"
        $(this).find("img").addClass "selected"


$(document).ready setupFormInteraction
