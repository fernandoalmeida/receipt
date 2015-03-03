# PdfReceipt

PDF Receipts generator for any ruby application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pdf_receipt'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install pdf_receipt

## Usage

```ruby
receipt = PdfReceipt.new(
  id: 1,
  date: Time.now.strftime('%d/%m/%Y'),
  amount: 100.0,
  currency: '$',
  payer: 'Chucky Norris',
  receiver: 'Fernando Almeida',
  description: 'Transaction #123',
  logo: 'logo.png'
).generate

# send to email
receipt.send_to('payer@email.com')

# send to download
send_data(receipt.data, filename: receipt.filename, type: receipt.type)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `bin/console` for an interactive prompt that will allow you to use it. 

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release` to create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Maintainer

[Fernando Almeida](http://fernandoalmeida.net)

## Contributing

1. Fork it ( https://github.com/fernandoalmeida/pdf_receipt/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
