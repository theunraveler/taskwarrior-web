$(document).ready(function() {
	initPolling();
	initTooltips();
	initCompleteTask();
});

var initPolling = function() {
	var polling;
	if (polling = $.cookie('taskwarrior-web-polling')) {
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
		}
	});
};

var initTooltips = function() {
	$('.tooltip').tipsy({
		title: 'data-tooltip',
		gravity: 's'
	});
};

var initCompleteTask = function() {
	$('input.pending').live('change', function() {
		var checkbox = $(this);
		var row = checkbox.closest('tr');
		var task_id = $(this).data('task');
		$.ajax({
			url: '/tasks/' + task_id + '/complete',
			type: 'post',
			beforeSend: function() {
				checkbox.replaceWith('<img src="/images/ajax-loader.gif" />');
			},
			success: function(data) {
				row.fadeOut('slow', function() {
					row.remove();
					// TODO: Wow. This is nasty.
					var subnavItem = $('#subnav-bar ul li:first-child a');
					var oldCount = subnavItem.text().match(/((\d))/);
					var newCount = parseInt(oldCount[0]) - 1
					var newVal = subnavItem.text().replace(oldCount[0], newCount);
					console.log(newVal);
					subnavItem.text(newVal);
				});
			}
		});
	});
};

var initInPlaceEditing = function() {
	// Hide it initially.
	$('.inplace-edit').hide();
	$('#listing table td').live('mouseover mouseout', function(e) {
		if (e.type == 'mouseover')  {
			$('.inplace-edit', this).show();
		} else {
			$('.inplace-edit', this).hide();
		}
	});

	$('.inplace-edit').live('click', function() {
		var field = $($(this).siblings('span')[0]);
		var formElement = '<input type="text" class="inplace-text" value="'+field.text()+'" />';
		formElement += '<button type="submit" class="inplace-submit">Update</button>';
		formElement += '<a href="javascript:void(0);" class="inplace-cancel">Cancel</a>';
		field.replaceWith(formElement);
		$(this).remove();
	});

	$('.inplace-cancel').live('click', function() {
		var td = $(this).closest('td');
		var oldField = '<span class="description">'+$($(this).siblings('.inplace-text')[0]).val()+'</span>';
		oldField += '<a class="inplace-edit" href="javascript:void(0);">Edit</a>';
		td.html(oldField);
	});
};

function set_message(msg, severity) {
	severity = severity ? severity : 'info';
	$('#flash-messages').append('<div class="message ' + severity + '">' + msg + '</div>');
}
