# puppet-module-inam

[![Build Status](https://travis-ci.org/treydock/puppet-module-inam.png)](https://travis-ci.org/treydock/puppet-module-inam)

####Table of Contents

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

Configuration example:

    inam::version: 0.9.2
    inam::source_url: "http://mvapich.cse.ohio-state.edu/download/mvapich/inam/osu-inam-%{hiera('inam::version')}.el%{::operatingsystemmajrelease}.tar.gz"

## Reference

### Classes

#### Public classes

* `inam`: Installs and configures inam.

#### Private classes

* `inam::install`: Installs inam packages.
* `inam::config`: Configures inam.
* `inam::service`: Manages the inam service.
* `inam::database`: Manages the inam database.
* `inam::params`: Sets parameter defaults based on fact values.

### Parameters

#### inam

##### `version`

Version of INAM to install. Default is `0.9.2`.

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
