# Web Interface for Taskwarrior

A lightweight, Sinatra-based web interface for the
wonderful [Taskwarrior](http://taskwarrior.org/) todo application.

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
* Marking a pending task as done.
* Creating a new task with a due date, project, and tags.

I'm looking to include more features once `task` supports issuing commands via
UUID.
