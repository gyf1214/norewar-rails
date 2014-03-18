# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready.push ->
	$('#login_lst').click ->
		$('#login_form').slideToggle()

	show_welcome = (name) ->
		$('#welcome_txt').text "Welcome, #{name}!"
		$('#login_form').hide()
		$('#login_lst').hide()
		$('#welcome_span').show()
		$('#username_txt').val ''
		$('#password_txt').val ''

	login = ->
		name = $('#username_txt').val()
		$.ajax
			url: '/users/login'
			type: 'POST'
			data:
				name:			$('#username_txt').val()
				password:		$('#password_txt').val()
				recaptcha_response_field: $('#recaptcha_response_field').val()
			dataType: 'json'
			timeout: 10000
			success: (res) ->
				show_welcome name if res.success

	$('#log_btn').click ->
		login()

	$('#login_form').keypress (e) ->
		if (e.keyCode == 13)
			login()

	$('#reg_btn').click ->
		$.ajax
			url: '/users'
			type: 'POST'
			data:
				name:		$('#username_txt').val()
				password:	$('#password_txt').val()
				recaptcha_response_field: $('#recaptcha_response_field').val()
			dataType: 'json'
			timeout: 10000
			success: (res) ->
				show_welcome $('#username_txt').val() if res.success

	$('#recaptcha_image').click ->
		Recaptcha.reload()
