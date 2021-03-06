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
	count = new Array
	face = ['>', '^', '<', 'v']

	show = (index) ->
		for delta in match_buffer[index].delta
			node = $("#map_#{delta.x}_#{delta.y}")
			direction = $("#direction_#{delta.x}_#{delta.y}")
			if delta.delta?
				team = node.attr("team")
				count[team] = 0 unless count[team]?
				count[team]--
				$("#cnt_#{team}").text(count[team])
				node.attr("team", delta.delta)
				node.removeClass()
				team = delta.delta
				count[team] = 0 unless count[team]?
				count[team]++
				$("#cnt_#{team}").text(count[team])
				node.addClass("team#{team}") unless team is 0
				direction.text('') if team is 0
			if delta.face?
				direction.text(face[delta.face])

	fetch = ->
		fetching = true
		$.ajax
			url: "/matches/#{$('#match_id').val()}/view"
			type: 'POST'
			data:
				after: buffer_time
				before: buffer_time + buffer_size
			dataType: 'json'
			timeout: 10000
			success: (res) ->
				match_buffer = match_buffer.concat res
				buffer_time += buffer_size
				fetching = false
			error: ->
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

	if $('#match_id').val()?
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

	$('#direction_chk').click ->
		unless $('#direction_chk')[0].checked is true
			$('.viewer-direction').addClass('hide')
		else
			$('.viewer-direction').removeClass('hide')

