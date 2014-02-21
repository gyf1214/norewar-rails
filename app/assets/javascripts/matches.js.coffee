# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready.push ->
	buffer_size = 1024
	match_buffer = new Array
	buffer_time = -1
	now = -1
	index = 0
	fetching = false
	playing = false
	timer = null
	interval = 50

	show = (index) ->
		for delta in match_buffer[index].delta
			node = $("#map_#{delta.x}_#{delta.y}")
			if delta.delta?
				node.removeClass()
				node.addClass("team#{delta.delta}") unless delta.delta is 0

	fetch = ->
		fetching = true
		$.ajax
			url: "/matches/#{$('#match_id').val()}/view"
			type: 'POST'
			data:
				after: buffer_time
				before: buffer_time + buffer_size
			dataType: 'json'
			success: (res) ->
				match_buffer = match_buffer.concat res
				buffer_time += buffer_size
				fetching = false

	next = ->
		if now <= buffer_time
			show index
			++now
		if !fetching && now > buffer_time - buffer_size / 1.2
			fetch()
		if match_buffer[index + 1]? && match_buffer[index + 1].time <= now
			++index

	speed = (delta) ->
		return if interval + delta <= 0
		interval += delta
		$('#speed_span').html "#{Math.floor(100000 / interval) / 100}"
		return unless playing
		clearInterval timer
		timer = setInterval next, interval

	fetch()

	$('#play_btn').click ->
		return if playing
		playing = true
		timer = setInterval next, interval

	$('#pause_btn').click ->
		return unless playing
		playing = false
		clearInterval timer

	$('#fast_btn').click ->
		speed -5

	$('#slow_btn').click ->
		speed 5
