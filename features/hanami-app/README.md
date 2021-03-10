# Hanami Bookshelf (example application)

This repository is the result of going through Hanami's
[Getting Started](http://hanamirb.org/guides/getting-started/) guide.

It exists as an example application.

We are *only* interested in Pull Requests keeping this application in sync
with the Getting Started guide.
That is, we do not want to add any features here to build out this application.

## Usage
__Hanami__ supports Ruby (MRI) 2.3+

```bash
git clone git@github.com:hanami/bookshelf.git hanami-bookshelf
cd hanami-bookshelf
bundle install
bundle exec hanami db prepare
bundle exec hanami server # visit http://localhost:2300/books/new
```

## Testing

```bash
HANAMI_ENV=test bundle exec hanami db prepare
bundle exec rake
```

This repository is intended to be used for instructional purposes.

For example,
if you're writing a blog post explaining how to add some library to a Hanami application,
rather than writing your own trivial application,
you can instruct readers to clone this repository as a starting point.
This should make it easier to write guides for Hanami applications.

## Code of Conduct

We have a [Code of Conduct](http://hanamirb.org/community/#code-of-conduct)
that all community members are expected to adhere to.

## Contributing

1. Fork it ( https://github.com/hanami/bookshelf )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Licensing
Released under MIT License.
