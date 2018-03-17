# puppet-module-inam

[![Build Status](https://travis-ci.org/treydock/puppet-module-inam.png)](https://travis-ci.org/treydock/puppet-module-inam)

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options](#usage)
3. [Reference - Parameter and detailed reference to all options](#reference)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Overview

Puppet module to manage OSU INAM.

## Usage

### inam

    include inam

## Reference

### Classes

#### Public classes

* `inam`: Installs and configures inam.

#### Private classes

* `inam::install`: Installs inam packages.
* `inam::config`: Configures inam.
* `inam::service`: Manages the inam service.
* `inam::database`: Manages the inam database.
* `inam::apache`: Manage Apache configuration
* `inam::params`: Sets parameter defaults based on fact values.

### Parameters

#### inam

## Limitations

This module has been tested on:

* CentOS 7 x86_64

## Development

### Testing

Testing requires the following dependencies:

* rake
* bundler

Install gem dependencies

    bundle install

Run unit tests

    bundle exec rake test

If you have Vagrant >= 1.2.0 installed you can run system tests

    bundle exec rake beaker
