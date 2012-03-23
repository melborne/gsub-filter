# GsubFilter

This is a text filter for gsub chain. You can set or replace as many gsub filters as you like, then run them through a given text.

## Installation

Add this line to your application's Gemfile:

    gem 'gsub_filter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gsub_filter

## Usage

    require "gsub_filter"

    gs = GsubFilter.new("ruby is a fantastic language!\nI love ruby.")

    # make each words capitalize
    gs.filter(/\w+/) {|md| md.to_s.capitalize }

    # add asterisks only to the first 'ruby'
    gs.filter(/ruby/i, global:false) { |md| "*#{md.to_s}*" }

    # a MatchData object passes to the block as its first parameter
    gs.filter(/a(.)/) { |md| "a-#{md[1]}" }

    # excecute the above filters with run method
    gs.run # => "*Ruby* Is A Fa-nta-stic La-ngua-ge!\nI Love Ruby."

GsubFilter#run can take another text for these filters.

    gs.run("hello, world of ruby!") # => "Hello, World Of *Ruby*!"

Each filter can be replaced with GsubFilter#replace.

    gs.replace(1, /ruby/i) { |md| "###{md.to_s}##" }

    gs.run # => "##Ruby## Is A Fa-nta-stic La-ngua-ge!\nI Love ##Ruby##."

The MatchData object can be stocked through the second parameter of the block, which is accessed with GsubFilter#stocks.

    gs.filter(/#(\w+)#/) { |md, stocks| stocks[:lang] << md[1]; "+#{md[1]}+" }

    gs.run # => "#+Ruby+# Is A Fa-nta-stic La-ngua-ge!\nI Love #+Ruby+#."
    gs.stocks # => {:lang=>["Ruby", "Ruby"]}

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
