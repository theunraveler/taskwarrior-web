## v1.1.11 (7/15/13)

* Rethinking the tasks that are included in project lists. Now, they include
  completed and waiting tasks as well, with visual distinctions.
* Misc small fixes

## v1.1.10 (6/28/13)

* Added ability to specify "wait" property for tasks
* Added more comprehensive help popup
* Fixing a couple particularly annoying issues

## v1.1.9 (5/21/13)

* Sorting by priority sorts intelligently (http://github.com/theunraveler/taskwarrior-web/issues/39)
* Fixes updating tasks in taskwarrior 2.2.0+ (http://github.com/theunraveler/taskwarrior-web/issues/36)

## v1.1.8 (1/15/13)

* Support for adding and removing annotations on tasks.
* Tasks are now sorted by the `urgency` property by default.
* Miscellanous fixes and improvements.

## v1.1.7 (12/24/12)

* Small hotfix for JS load order.

## v1.1.6 (12/16/12)

* Added sort options to all task listings.

## v1.1.5 (12/13/12)

* Adding [hotkeys][3]. Within taskwarrior-web, press the `h` key or click the
  "Hotkeys" link in the footer to see available hotkeys.
* Fixed date formatting issue in date picker that prevented tasks from being
  saved.
* Fixed issue where multiple tasks could not be marked as completed without
  refreshing the page.
* Updated to Twitter Bootstrap 2.2.2.
* Added a special surprise when you have no pending tasks.

[3]: http://github.com/theunraveler/taskwarrior-web/issues/32

## v1.1.4 (12/11/12)

* Fixing JS issue.

## v1.1.3 (12/11/12)

* Added CRUD links to waiting tab
* Set rack-protection dependency version (to fix weird static assets 404 issue)

## v1.1.2 (12/7/12)

* Fixed dumb but annoying timezone issue
* Added progress bars to project pages
* Added priority field to task form

## v1.1.1 (12/7/12)

* Fixing small issue with blank status messages.

## v1.1.0 (12/7/12)

* Editing and deleting tasks! (If you are using task >= 2.0).
* Fixing status messages. They should now be consistent.
* Added safeguards for xterm.title and color .taskrc settings. You should now
  be able to safely set both of those options.

## v1.0.14 (11/22/12)

* Fixed a bug when colorizing tasks based on "due" setting.
* Fixed bugs that may result from differences between Taskwarrior's date format
  strings and those of Ruby.

## v1.0.13 (11/22/12)

* Added support for `task-web.filter.badge` option to control the Fluid badge
  count. See [the wiki][2] for more information.

[2]: http://github.com/theunraveler/taskwarrior-web/wiki/Additional-.taskrc-options

## v1.0.12 (11/22/12)

* Miscellaneous styling fixes and improvements

## v1.0.11 (11/21/12)

* Nicer badges in the "Pending" menu item
* Fixed stripping of non-word characters from tags when adding a new task

## v1.0.10 (11/20/12)

* Adding ability to specify a filter for the task listing. See [the wiki][1]
  for more information.
* Added the SimpleNavigation library for navigation, and moved a bunch of stuff
  to ActiveSupport.

[1]: http://github.com/theunraveler/taskwarrior-web/wiki/Additional-.taskrc-options

## v1.0.9 (11/19/12)

* Fixed bug on projects listing page where projects with no pending tasks were
  being shown.
* Updated datepicker library, much better

## v1.0.8 (11/18/12)

* Better layout for projects listing page.

## v1.0.7 (11/17/12)

* Moving `task` version parsing to Verionomy library. Should be much more
  flexible and stable.
* Removing tag input widget from new task form, and changed parsing to split
  tags on spaces, commas, or any combination thereof. So something like
  "these,will all,  be  , tags now" should result in tags of "these", "will",
  "all", "be", "tags", and "now". Hopefully this is easier to use and less
  confusing.
* Adding basic support for `task` < 1.9.2
* Moved to thin gem as a server for speed and stability.

## v1.0.6 (11/15/12)

* Fixed escaping issue when viewing or adding projects with spaces.
* Updating Twitter Bootstrap library.
* Fixing active trail in top menu.

## v1.0.5 (11/6/12)

* Fixed missing "require" statement for shellwords library.

## v1.0.4 (9/25/12)

* Added TokenInput plugin for tagging tasks
* Fixed form validation when saving a task

## v1.0.3 (8/27/12)

* Moved to new theme based on Twitter Bootstrap. Hopefully, this will make
  a mobile theme easier.
* Fixed bug when completing tasks

## v1.0.2 (4/3/12)

* Hotfix for error in JS file.

## v1.0.1 (4/3/12)

* Added fadeOut animation to task completion.

## v1.0.0 (3/19/12)

* Refactored for taskwarrior 2.0 compatibility.
* Re-added task completion for both v1 and v2.

## v0.0.15 (3/12/12)

* Fixed error in http auth
* Moved views and public folders into lib

## v0.0.14 (2/9/12)

* Merged in major refactoring to allow for easier support of task 2 and
  1 simultaneously. Note that taskwarrior-web still only supports task 1, but
  adding support for task 2 should now be easier.
* Removed the ability to mark a task as complete. This was really buggy to
  begin with, and will need to wait until task 2.
* Fixed project autocomplete. Now it should actually work.
* Added a new tab for "Waiting" tasks (where status:waiting)

## v0.0.13 (2/6/12)

* Adding Fluid app dock icon. The dock icons should now show a number of
  pending tasks.

## v0.0.11 (1/10/12)

* Added annotations to task listing, complete with autolinking (turns URLs into
  links)

## v0.0.10 (12/30/11)

* Quick release to fix JSON parse error when there are no tasks.

## v0.0.9 (12/30/11)

* Added check to make sure property exists on Task model before assigning.
* Removing some unused properties from the Task model

## v0.0.5 (6/5/11)

* Added "depends" method to task model so that tasks that use depends will not
  throw errors.

## v0.0.4 (5/9/11)

* Quick bugfix to remove checkboxes from project page. Race conditions prevent
  the IDs from actually being correct, so the wrong task would be marked as
  done.

## v0.0.3 (5/9/11)

* Fixed floating issue in FF4 on /projects page
* Added "priority" to list of attributes (no more errors)
* Added sorting by priority first
* Added column for priority to all listings
