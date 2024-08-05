# FunWithBits

A bitset implementation built simply to help me learn about dealing with bits,
not a production-ready library. The API was created by first writing tests that
would mirror the basic functionality from std::bitset from C++20. After that, I
implemented the functionality to make those tests pass.

I had to replace C++ methods like `^=` with functions that were
Ruby-syntax-friendly. They ended up being named with english-language
descriptions, such as `xor!` and `shift_left!`.

There is also some functionality which hasn't been implemented such as allowing
`#to_s` to output characters other than zeroes and ones. Since my main focus is
on working with bits, I have chosen to leave these extra "nice to have"
features out for now.

## Installation

At this time, there isn't a plan for this to go to rubygems.org. Installation must be done by adding the library to a gemfile using a `git` source:

```ruby
# Gemfile

gem "fun_with_bits", git: "https://github.com/brandoncc/fun_with_bits.rb"
```

## Usage

You probably shouldn't use this, but it can be used simply by adding the library to your Gemfile and using the `FunWithBits` class.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/brandoncc/fun_with_bits.rb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/brandoncc/fun_with_bits.rb/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FunWithBits project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/brandoncc/fun_with_bits.rb/blob/main/CODE_OF_CONDUCT.md).
