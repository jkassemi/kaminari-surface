# A Surfacing Pagination Kaminari Extension

Developers may implement pagination to protect against overzealous result sizes.
With responsible pagination settings a query that returns a large number of
results can be displayed with fewer system resources on both the client and
the server.

The client may be able to configure the `per` option to permit more results per
page. Usually this value must be increased from an initially conservative
value, and after the first result set is displayed.

For queries that return few results the client must either make a modification
to the `per` option manually, or must page to a last page containing few
results. Both of these operations are unnecessary, and we can enhance the
client experience with an application designed to more intelligently handle
smaller response sets.

Surfacing pagination prevents a second request to the server by sending the
results that the client would ordinarily need to fetch on a subsequent page
request if the number of results is under a threshhold. The ideal implementation
would prevent the client from flipping through pages when there's little need to
do so.

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

## UX Issues

There are some cases where the use of surfacing pagination may not be
recommended. The following issues may pop up:

1. The total number of results can no longer be determined by the client
   using the last page number or total pages number since the result count per
   page may vary.
1. If a client workflow routinely involves visiting the last page of results
   then filtering through those last results may take longer.
