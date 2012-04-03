# A Web Interface for Taskwarrior

A lightweight, Sinatra-based web interface for the
wonderful [Taskwarrior](http://taskwarrior.org/) todo application.

**Now compatible with ALL versions of Taskwarrior, including the new 2.0.0**

[![Build Status](https://secure.travis-ci.org/theunraveler/taskwarrior-web.png)](http://travis-ci.org/theunraveler/taskwarrior-web)

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

## Known Issues

* taskwarrior-web requires Ruby >= 1.9. It will not work with 1.8 and lower.
  Support for 1.8 will happen at some point.

## Marginalia

This project is not developed by the Taskwarrior team. Obviously,
taskwarrior-web extends Taskwarrior, but the projects are separate.
