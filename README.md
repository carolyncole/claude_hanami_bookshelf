# Bookshelf

🌸 Welcome to your Hanami app!

## Getting started

- Set up the project with `bin/setup`
- Run the server with `bin/dev`
- View the app at [http://localhost:2300](http://localhost:2300)
- Run the tests with `bundle exec rake spec`

## Testing

The suite is RSpec. Database-backed specs run against a separate `*_test`
database (`db/bookshelf_test.sqlite`, created automatically by `HANAMI_ENV=test`)
and are tagged `type: :db` so each example starts from a clean table:

```bash
bundle exec rake spec             # the whole suite
bundle exec rspec spec/repos/book_repo_spec.rb   # one file
```

The DB layer is covered by `spec/repos`, `spec/structs`, and `spec/relations`.

## API docs

The model layer (`Book`, `BookRepo`, `BookRelation`) is documented with YARD. The
globs and options live in `.yardopts` (comment-free: YARD shell-splits that file,
so it cannot hold `#` comments). Generate the HTML docs and open `tmp/docs/index.html`:

```bash
bundle exec rake docs:generate    # HTML into tmp/docs (alias of `docs`)
```

> **Note:** YARD prints two `Undocumentable mixin` warnings for the
> `include Dry::Monads[:result]` lines in `Action` and `BookRepo`. These are
> benign: the mixin module is built at runtime, so YARD cannot introspect it.
> The docs still fully generate (exit 0).

## Useful links

- [Hanami](https://hanakai.org/hanami)
- [Hanami guides](https://hanakai.org/learn#hanami)
