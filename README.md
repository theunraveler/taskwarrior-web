# A Web Interface for Taskwarrior

A lightweight, Sinatra-based web interface for the
wonderful [Taskwarrior](http://taskwarrior.org/) todo application.

Check out the [Live Demo](http://35.196.114.51).

[![Gem Version](https://badge.fury.io/rb/taskwarrior-web.png)](http://badge.fury.io/rb/taskwarrior-web)
[![Build Status](https://secure.travis-ci.org/theunraveler/taskwarrior-web.png)](http://travis-ci.org/theunraveler/taskwarrior-web)

## Table of Contents

* [Screenshots](#screenshots)
* [Requirements](#requirements)
* [Installation](#installation)
* [Usage](#usage)
* [Features](#features)
* [Docker](#docker)
* [Reporting Bugs](#reporting-bugs)
* [Marginalia](#marginalia)

## Screenshots

### Pending Tasks
<img src="https://raw.githubusercontent.com/theunraveler/taskwarrior-web/master/docs/img/readme/pending_tasks_list.jpg">

### Waiting Tasks
<img src="https://raw.githubusercontent.com/theunraveler/taskwarrior-web/master/docs/img/readme/waiting_tasks_list.jpg">

### Completed Tasks
<img src="https://raw.githubusercontent.com/theunraveler/taskwarrior-web/master/docs/img/readme/completed_tasks_list.jpg">

### New Task w/ Project Autocomplete
<img src="https://raw.githubusercontent.com/theunraveler/taskwarrior-web/master/docs/img/readme/project_autocomplete.jpg">

### Parent Project Information
<img src="https://raw.githubusercontent.com/theunraveler/taskwarrior-web/master/docs/img/readme/parent_project_info.jpg">

### Projects Overview
<img src="https://raw.githubusercontent.com/theunraveler/taskwarrior-web/master/docs/img/readme/projects_overview.jpg">

### Help Popup
<img src="https://raw.githubusercontent.com/theunraveler/taskwarrior-web/master/docs/img/readme/help_popup.jpg">

## Requirements

* `ruby` >= 1.9 (support for `ruby` < 1.9 is very unlikely, but pull requests
  are gladly accepted).

For building native extensions on Linux could be required the following packages:

 * ruby-dev
 * make
 * gcc

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

## Docker

You can also run taskwarrior-web using docker.
This approach requires [docker](https://www.docker.com) and
[docker-compose](https://github.com/docker/compose) to be installed.

The command below builds new image from the source and runs service.

```sh
make run
```

By default task-web is listening on `5678` port.
Adjust service configuration in `docker/docker-compose.yml`.


## Reporting Bugs

To report a bug, use the [Github issue tracker][2]. Since `taskwarrior-web`
works with several different versions of `task`, using many different
configurations, please include the output from `task _version` and either the
output of `task show` or a copy of your `.taskrc` file when filing a bug. This helps us reproduce bugs easier.

Here is an example of a [good bug report][3].

[2]: http://github.com/theunraveler/taskwarrior-web/issues
[3]: http://github.com/theunraveler/taskwarrior-web/issues/26

## Marginalia

* This project is not developed by the Taskwarrior team. Obviously, taskwarrior-web extends Taskwarrior, but the projects are separate.
* `task-web` is mostly designed to run locally. As such, security is not of the highest priority. You may find that things such as CSRF protection are lacking. If things like this are important to you, please file an issue or a pull request.
