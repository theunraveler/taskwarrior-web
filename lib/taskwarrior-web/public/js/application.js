$(document).ready(function() {
	initPolling();
	initTooltips();
	initDatePicker();
	initAutocomplete();
	initTaskCompletion();

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

var initTaskCompletion = function() {
	$('input.complete').click(function() {
		// Cache the checkbox in case we need to restore it.
		var row = $(this).closest('tr');
		$(this).parent().html('<img src="/images/ajax-loader.gif" />');
		$.ajax({
			url: '/ajax/task-complete/' + $(this).data('task-id'),
			type: 'POST',
			success: function(data) {
				var message = (data === '') ? 'Task marked as completed.' : data;
				set_message(message, 'success');
				row.remove();
			},
			error: function(data) {
				set_message('There was an error when marking the task as completed.', 'error');
				// TODO: Re-insert the checkbox.
			}
		});
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
