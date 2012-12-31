# A Web Interface for Taskwarrior

A lightweight, Sinatra-based web interface for the
wonderful [Taskwarrior](http://taskwarrior.org/) todo application.

![TaskwarriorWeb screenshot](https://dl.dropbox.com/u/107599300/screenshot.png)

## Requirements

* `ruby` >= 1.9 (support for `ruby` < 1.9 is very unlikely, but pull requests
  are gladly accepted).

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

* Viewing tasks sorted and grouped in various ways.
* Creating a new task with a due date, project, and tags.
* Editing and deleting tasks (only task >= 2.0).
* `task-web` will pull your `task` config (from `.taskrc`) and use it to
  determine date formatting and when an upcoming task should be marked as
  "due".
* If you are on a Mac and use Fluid.app, you get a dock badge showing the
  number of pending tasks.
* [Optional HTTP Basic authentication][1].

[1]: https://github.com/theunraveler/taskwarrior-web/wiki/Additional-.taskrc-options

## Reporting Bugs

To report a bug, use the [Github issue tracker][2]. Since `taskwarrior-web`
works with several different versions of `task`, using many different
configurations, please include the output from `task _version` and either the
output of `task show` or a copy of your `.taskrc` file when filing a bug. This helps me reproduce bugs easier.

Here is an example of a [good bug report][3].

[2]: http://github.com/theunraveler/taskwarrior-web/issues
[3]: http://github.com/theunraveler/taskwarrior-web/issues/26

## Marginalia

This project is not developed by the Taskwarrior team. Obviously,
taskwarrior-web extends Taskwarrior, but the projects are separate.

[![Build Status](https://secure.travis-ci.org/theunraveler/taskwarrior-web.png)](http://travis-ci.org/theunraveler/taskwarrior-web)
