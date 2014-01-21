# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready.push ->
    getLineNumbers = ->
        line_count = $('#code_code').val().split('\n').length
        line_count = 0 if $('#code_code').val() == ''
        $('#line_info').text ( if line_count>1 then "#{line_count} lines" else "#{line_count} line")
        $('#code-line-num').html ( if line_count > 0 then (i for i in [1..line_count]).join(" <br> ") else "" )

    if $('#code_code').length
        getLineNumbers()

    $('#code_code').keyup ->
        getLineNumbers()
