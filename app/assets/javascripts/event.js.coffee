# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Messenger = (->
	con = null

	connect = ->
		con = new WebSocketRails 'dev.norewar.org:3000/websocket'
		bind 'force_logout', ->
			$(location).attr('href', '/users/logout')
		bind 'msg', (msg) ->
			console.log msg

	bind = (event, callback) ->
		con.bind event, callback

	publish = (event, message) ->
		con.trigger event, message

	push = (event, message, success, failure) ->
		con.trigger event, message, success, failure

	connected = ->
		con?

	exports =
		'connect':		connect
		'bind':			bind
		'publish':		publish
		'push':			push
		'connected':	connected

	return exports
)()