$(document).ready(function() {
	initPolling();
});

var initPolling = function() {
	var pollingInterval = startPolling();
	var polling = true;
	$('#polling-info a').click(function(e) {
		if (polling) {
			window.clearInterval(pollingInterval);
			polling = false;
			$(this).text('Start polling');
		} else {
			pollingInterval = startPolling();
			polling = true;
			$(this).text('Stop polling');
		}
		e.preventDefault();
	});
};

var startPolling = function() {
	var pollingInterval = window.setInterval('refreshPageContents()', 2000);
	return pollingInterval;
};

var refreshPageContents = function() {
	$.ajax({
		url: '/pending',
		success: function(data) {
			$('#listing').replaceWith($('#listing', data));
		}
	});
};
