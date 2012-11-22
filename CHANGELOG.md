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

[1]: http://github.com/theunraveler/taskwarrior-web/wiki/Filters-for-the-task-listing-page

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
