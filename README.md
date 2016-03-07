[![Build Status](https://travis-ci.org/davidor/formulita-backend.svg?branch=master)](https://travis-ci.org/davidor/formulita-backend)
[![Code Climate](https://codeclimate.com/github/davidor/formulita-backend/badges/gpa.svg)](https://codeclimate.com/github/davidor/formulita-backend)

# FormulitaBackend

This is the backend of the [Formulita Android app](https://play.google.com/store/apps/details?id=com.formulita).
Formulita is a minimalist app that helps you stay up to date with the Formula 1 world. It is free
and does not have any ads.

## Usage

Install dependencies:

    $ bundle install
    
Import data from Ergast. It only works for seasons from 2015:

    $ bundle exec rake import_season[year]
    
Run the server:

    $ bundle exec ruby -S rackup -w config.ru

To run the tests:

    $ bundle exec rake spec

## License

[MIT License](http://opensource.org/licenses/MIT).
