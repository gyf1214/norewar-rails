# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready.push ->
    getLineNumbers = ->
        lines = $('#code_code').val().split('\n').length
        lines = 0 if $('#code_code').val() == ''
        $('#line_info').text lines
        $('#code-line-num').html ( if lines > 0 then (i for i in [1..lines]).join(" <br> ") else "" )

    if $('#code_code').length
        getLineNumbers()

    $('#code_code').keyup ->
        getLineNumbers()
