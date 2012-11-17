$(document).ready(function() {
	initDatePicker();
	initAutocomplete();
	initTaskCompletion();

	// Fluid-specific stuff.
	refreshDockBadge();

  // Hack to account for navbar when clicking anchor links.
  $('#sidebar .nav li a').click(function(event) {
    event.preventDefault();
    $($(this).attr('href'))[0].scrollIntoView();
    scrollBy(0, -60);
  });
});

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

var initDatePicker = function() {
	$('.date-picker').datepicker({
		autoclose: true
	});
};

var initAutocomplete = function() {
	$('#task-project').typeahead({
		source: function (query, process) {
			return $.get('/ajax/projects/', {query: query}, function (data) {
				process($.parseJSON(data));
			});
		}
	});
};

var initTaskCompletion = function() {
	$('input.complete').click(function() {
		// Cache the checkbox in case we need to restore it.
		var container = $(this).parent(),
		    checkbox = container.html(),
		    row = $(this).closest('tr');
		container.html('<img src="/img/ajax-loader.gif" />');
		$.ajax({
			url: '/ajax/task-complete/' + $(this).data('task-id'),
			type: 'POST',
			success: function(data) {
				refreshPageContents();
				set_message(data === '' ? 'Task marked as completed.' : data, 'alert-success');
				row.fadeOut();
			},
			error: function(data) {
				set_message('There was an error when marking the task as completed.', 'alert-error');
				container.html(checkbox);
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
	if (window.hasOwnProperty('fluid')) {
		getCount(function(data) {
			window.fluid.dockBadge = data;
		});
	}
};

var refreshSubnavCount = function() {
	getCount(function(data) {
		$('#subnav-bar ul li:first-child a span.badge').text(data);
	});
};

function set_message(msg, severity) {
	severity = severity ? severity : 'info';
	$('#flash-messages').append('<div class="alert ' + severity + '">' + msg + '</div>');
}
