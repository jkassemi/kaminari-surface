# A Surfacing Pagination Kaminari Extension

Making that last result a little closer.

![screencap](https://raw.githubusercontent.com/jkassemi/kaminari-surface/master/capture.gif)

## Overview

Developers may implement pagination to protect against overzealous result sizes.
With responsible pagination settings a query that returns a large number of
results can be displayed with fewer system resources on both the client and
the server.

For queries that return few results but still trigger pagination, the client
must either navigate via a pagination component to the last page, or make
a modification to the `per` option if it's available.

Both of these operations are unnecessary, and we can enhance the
client experience with an application designed to more intelligently handle
smaller response sets.

Surfacing pagination prevents a second request to the server by sending the
results that the client would ordinarily need to fetch on a subsequent page
request if the number of results is under a threshold. The ideal implementation
would prevent the client from flipping through pages when there's little need to
do so.

tldr; When the result set is sufficiently small, not forcing the client to
page through results can improve performance.

## Installation

### Rails

Place `kaminari-surface` in your Gemfile (if you're sane you'll version it):

    gem 'kaminari-surface'

and bundle:

    $ bundle

## Usage

Configure your query with [Kaminari](https://github.com/amatsuda/kaminari) as
usual:

    results = User.page(1).per(50)
    results.size          # => 50
    results.total_count   # => 100
    results.total_pages   # => 2

Use the `surface` scope to enable surface pagination on a result set. The last
page will now include up to 50 more results:

    results = User.page(1).per(50).surface(50)

    results.size          # => 100
    results.total_count   # => 100
    results.total_pages   # => 1

## Contributing

Fork, address the issue, and submit a pull request. You can reach me through the
tracker or at jkassemi@gmail.com.

### Running Specs

ActiveRecord and DataMapper specs run with an in-memory schema, and don't need
any additional setup.

Get a mongo server up and running on your local system (port 27017) so the
`mongoid` and `mongo_mapper` specs can run. This can be as simple as `$ brew
install mongodb`.

    $ bundle             # to install the gems from the gemspec
    $ bundle exec rspec  # to feel the green

## Integration Goals

This release is a proof of concept and designed as a drop-in implementation
that does not affect the existing kaminari project.

Directly modifying and extending kaminari would be a more maintainable solution.
Once kinks are worked out here then a PR to the kaminari project makes a heck of
a lot of sense.

## Caveats

There are some cases where the use of surfacing pagination may not be
recommended. The following issues may pop up:

1. The total number of results can no longer be determined by the client
   using the last page number or total pages number since the result count per
   page may vary.
1. If a client workflow routinely involves visiting the last page of results
   then filtering through those last results may take longer.
