# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready.push ->
    getLineNumbersAndResize = ->
        line_count = $('#code_code').val().split('\n').length
        line_count = 0 if $('#code_code').val() == ''
        $('#line_info').text ( if line_count>1 then "#{line_count} lines" else "#{line_count} line")
        $('.code-line-num').html ( if line_count > 0 then (i for i in [1..line_count]).join(" <br> ") else "" )
        $('.editor-area-container').height(original_container_height + $('#code_code').height() - original_height)
        $('.code-line-num-container').height($('.editor-area-container').height())
        $('.code-line-num').height($('#code_code').height())

    if $('#code_code').length
        original_height = $('#code_code').height()
        original_container_height = $('.editor-area-container').height()
        $('#code_code').autosize()
        getLineNumbersAndResize()

    $('#code_code').keyup ->
        getLineNumbersAndResize()
