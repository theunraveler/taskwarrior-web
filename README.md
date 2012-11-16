# A Web Interface for Taskwarrior

A lightweight, Sinatra-based web interface for the
wonderful [Taskwarrior](http://taskwarrior.org/) todo application.

**Now compatible with Taskwarrior 1.9.3 and up, including 2.x**
**Also, now including a NEW theme based on Twitter Bootstrap. Mobile version
forthcoming!**

[![Build Status](https://secure.travis-ci.org/theunraveler/taskwarrior-web.png)](http://travis-ci.org/theunraveler/taskwarrior-web)

## Requirements

* `ruby` >= 1.9 (support for `ruby` < 1.9 is very unlikely, but pull requests
  are gladly accepted).
* `task` >= 1.9.3 (compatibility with `task` < 1.9.3 is in the works)

## Installation

`gem install taskwarrior-web`

This will install an executable called `task-web`

## Usage

`task-web` at your terminal to start it up. This will start the process,
background it, and open the URL in your browser.

It uses [Vegas](https://github.com/quirkey/vegas/) to make the Sinatra app into
an executable, so all options for Vegas are valid for `task-web`. Type
`task-web -h` for more options.

## Features

The current featureset includes:

* Viewing tasks (duh) sorted and grouped in various ways.
* Creating a new task with a due date, project, and tags.
* `task-web` will pull your `task` config (from `.taskrc`) and use it to
  determine date formatting and when an upcoming task should be marked as
  "due".
* If you are on a Mac and use Fluid.app, you get a dock badge showing the
  number of pending tasks.
* Optional Basic HTTP Auth protection. To enable, set `task-web.user` and
  `task-web.passwd` in your `.taskrc` file.

## Reporting Bugs

To report a bug, use the [Github issue tracker][1]. Since `taskwarrior-web`
works with several different versions of `task`, using many different
configurations, please include the output from `task _version` and `task show`
when filing a bug. This helps me reproduce bugs easier.

[1]: http://github.com/theunraveler/taskwarrior-web/issues
## Marginalia

This project is not developed by the Taskwarrior team. Obviously,
taskwarrior-web extends Taskwarrior, but the projects are separate.
