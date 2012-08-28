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
