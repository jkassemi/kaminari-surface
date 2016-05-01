# A Surfacing Pagination Kaminari Extension

Developers may implement pagination as a protection against
overzealous results from a query. With responsible pagination settings
a query that returns a large number of results can be displayed with
fewer system resources.

The client may be able to configure the `per` option to permit more results per
page. Usually this value must be increased from an initially conservative
value, and after the first result set is displayed.

For queries that return few results the client must either make a modification
to the `per` option manually, or must page to a last page containing few
results. Both of these operations are unnecessary, and we can enhance the
client experience with an application designed to more intelligently handle
smaller response sets.

Surfacing pagination prevents a second request to the server by calculating the
number of results that will overrun the expected count. If this value is smaller
than a given value (such as `per * 2`), then all results are displayed and the
user does not need to paginate.

Designers may implement pagination to squeeze content into spaces that are too
small. Surfacing pagination won't help remedy that kind of UX nightmare.

## Installation

Place `kaminari-surface` in your Gemfile (if you're sane you'll version it):

    gem kaminari-surface

and bundle:

    $ bundle

## Usage

Configure your query with [Kaminari](https://github.com/amatsuda/kaminari) as
usual:

    results = User.page(1).per(50)

    results.size          # => 50
    results.total_count   # => 100
    results.total_pages   # => 2
    results.first?        # => true
    results.last?         # => false

Use the `surface` scope to enable surface pagination on a result set.

    results = User.page(1).per(50).surface(50)

    results.size          # => 100
    results.total_count   # => 100
    results.total_pages   # => 1
    results.first?        # => true
    results.last?         # => true

