window.ready = new Array

$('document').ready ->
	for func in ready
		func()