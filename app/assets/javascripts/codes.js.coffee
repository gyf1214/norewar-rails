# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready.push ->
	$('#code_code').keyup ->
		lines = $('#code_code').val().split('\n').length
		lines = 0 if $('#code_code').val() == ''
		$('#line_info').text lines;