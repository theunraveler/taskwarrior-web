$(document).ready(function() {
  initDatePicker();
  initAutocomplete();
  initTaskCompletion();
  initHotkeys();
  initTablesort();
  initAnnotationsModal();
  initUjs();
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
      initTaskCompletion();
			refreshSubnavCount();
			refreshDockBadge();
		}
	});
};

var initDatePicker = function() {
	$('.date-picker').datepicker({
		autoclose: true,
    todayBtn: 'linked'
	});
};

var initAutocomplete = function() {
  if ($('#task-project').length) {
    $('#task-project').typeahead({
      source: function (query, process) {
        return $.get('/ajax/projects/', {query: query}, function (data) {
          process($.parseJSON(data));
        });
      }
    });
  }
};

var initTaskCompletion = function() {
	$('input.complete').not('.task-completion-processed').each(function(index, element) {
    $(this).addClass('task-completion-processed');
    $(this).click(function(e) {
      e.preventDefault();

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
          set_message(data === '' ? 'Task marked as completed.' : data);
          row.fadeOut();
        },
        error: function(data) {
          set_message('There was an error when marking the task as completed.', 'error');
          container.html(checkbox);
        }
      });
    });
  });
};

var initHotkeys = function() {
  $('#hotkeys').modal({show: false});

  // "n" goes to new task form.
  $(document).bind('keyup', 'n', function() {
    window.location.href = '/tasks/new';
  });

  // "1-*" go to tabs in main nav.
  $(document).bind('keyup', '1', function() {
    window.location.href = '/tasks';
  });
  $(document).bind('keyup', '2', function() {
    window.location.href = '/projects';
  });

  // "h" displays a list of hotkeys.
  $(document).bind('keyup', 'h', function() {
    $('#hotkeys').modal('toggle');
  });
};

var initTablesort = function() {
  $.extend($.fn.dataTableExt.oStdClasses, {
    sWrapper: "dataTables_wrapper form-inline"
  });

  $('.table-sortable').each(function(index, el) {
    // Find out which columns are sortable.
    var aoColumns = [], element = $(el);
    element.find('thead th').each(function () {
      var def = $(this).hasClass('no-sort') ? { "bSortable": false } : null;
      aoColumns.push(def);
    });

    // Initialze the sorter.
    element.dataTable({
      sDom: "t",
      bInfo: false,
      bPaginate: false,
      aaSorting: [],
      aoColumns: aoColumns
    });
  });
};

var initAnnotationsModal = function() {
  $(document).on('click', 'a.annotation-add', function(event) {
    event.preventDefault();
    $.get($(this).attr('href') + '.json', function(data) {
      $('#annotations-modal')
        .html(data)
        .modal('show');
    });
  });
};

var initUjs = function() {
  $('[data-method]').click(function(e) {
    e.preventDefault();
    var link = $(this);
    if (confirm(link.data('confirm') || 'Are you sure?')) {
      $('<form action="' + link.attr('href') + '" method="POST" style="display: none;">')
        .append('<input type="hidden" name="_method" value="' + link.data('method') + '" />')
        .insertAfter(link)
        .submit();
    }
  });
};

// Count updating.

var refreshDockBadge = function() {
  $.get('/ajax/badge', function(data) {
    Tinycon.setBubble(data);
    if (window.hasOwnProperty('fluid')) {
      window.fluid.dockBadge = data;
    }
  });
};

var refreshSubnavCount = function() {
	$.get('/ajax/count', function(data) {
		$('#subnav-bar ul li:first-child a span.badge').text(data);
	});
};

/**
 * Set a flash message for user feedback.
 *
 * @param string msg The text of the message.
 * @param string [severity] The severity of the message.
 */
function set_message(msg, severity) {
	$('<div style="display: none;" class="alert">')
    .addClass('alert-' + (severity || 'success'))
    .append('<button type="button" class="close" data-dismiss="alert">&times;</button>')
    .append(msg)
    .appendTo('#flash-messages')
    .fadeIn();
}
