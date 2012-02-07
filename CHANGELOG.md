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
