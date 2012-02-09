$(document).ready(function() {
	initPolling();
	initTooltips();
	initDatePicker();
	initAutocomplete();

	// Fluid-specific stuff.
	if (window.fluid) {
		refreshDockBadge();
	}
});

var initPolling = function() {
	var polling = $.cookie('taskwarrior-web-polling');
	if (polling) {
		var pollingInterval = startPolling();
	} else {
		$('#polling-info a').text('Start polling');
	}

	$('#polling-info a').click(function(e) {
		if (polling) {
			window.clearInterval(pollingInterval);
			polling = false;
			$(this).text('Start polling');
			$.cookie('taskwarrior-web-polling', null);
		} else {
			pollingInterval = startPolling();
			polling = true;
			$(this).text('Stop polling');
			$.cookie('taskwarrior-web-polling', true);
		}
		e.preventDefault();
	});
};

var startPolling = function() {
	var pollingInterval = window.setInterval('refreshPageContents()', 3000);
	return pollingInterval;
};

var refreshPageContents = function() {
	$.ajax({
		url: window.location,
		success: function(data) {
			$('#listing').replaceWith($('#listing', data));
			refreshSubnavCount();
			refreshDockBadge();
		}
	});
};

var initTooltips = function() {
	$('.tooltip').tipsy({
		title: 'data-tooltip',
		gravity: 's'
	});
};

var initDatePicker = function() {
	$('.datefield input').datepicker({
		dateFormat: $('.datefield input').data('format'),
		autoSize: true
	});
};

var initAutocomplete = function() {
	$('#task-project').autocomplete({
		source: '/ajax/projects'
	});

	$('#task-tags').tagsInput({
		autocomplete_url: '/ajax/tags',
		defaultText: ''
	});
};

// Count updating.

var getCount = function(callback) {
	$.ajax({
		url: '/ajax/count',
		success: callback
	});
};

var refreshDockBadge = function() {
	getCount(function(data) {
		window.fluid.dockBadge = data;
	});
};

var refreshSubnavCount = function() {
	getCount(function(data) {
		$('#subnav-bar ul li:first-child a').text('Pending ('+data+')');
	});
};

function set_message(msg, severity) {
	severity = severity ? severity : 'info';
	$('#flash-messages').append('<div class="message ' + severity + '">' + msg + '</div>');
}
