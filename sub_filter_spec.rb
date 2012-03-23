# encoding: UTF-8
require "rspec"
require_relative "sub_filter"

describe SubFilter do
  before do
    str = <<EOS
*p1*こんにちは世界
hello, world
*123*I love Ruby
ruby is a lang.
EOS
    @sf = SubFilter.new(str)
  end

  context "run" do
    it "should convert a string with one filter" do
      res = <<EOS
##こんにちは世界
hello, world
##I love Ruby
ruby is a lang.
EOS
      @sf.filter(/^\*p?\d+\*(.*)$/) { |md| "###{md[1]}" }
      @sf.run.should == res
    end

    it "should convert a string given to run method" do
      str =<<EOS
my friend is Tom.
He is very nice guy.
EOS
      res =<<EOS
My Friend Is Tom.
He Is Very Nice Guy.
EOS
      @sf.filter(/\w+/) { |md| md.to_s.capitalize }
      @sf.run(str).should == res
    end

    it "should convert a string with two filters" do
      res =<<EOS
##こんにちは世界
HELLO, WORLD
##I LOVE RUBY
RUBY IS A LANG.
EOS
      @sf.filter(/^\*p?\d+\*(.*)$/) { |md| "###{md[1]}" }
      @sf.filter(/\w+/) { |md| md.to_s.upcase }
      @sf.run.should == res
    end

    it "should add a line with captured words" do
      res =<<EOS
---こんにちは世界---
HELLO, WORLD
---I LOVE RUBY---
RUBY IS A LANG.
こんにちは世界,I love Ruby
EOS
      @sf.filter(/^\*p?\d+\*(.*)$/) do |md, stocks|
        stocks[:title] << md[1]
        "---#{md[1]}---"
      end
      @sf.filter(/\w+/) { |md| md.to_s.upcase }
      line = @sf.run
      last = @sf.stocks[:title].join(',') + "\n"
      (line + last).should == res
    end
  end

  context "filter 'at' option" do
    it "should add a filter at the last" do
      regexps = [/\w+/, /\d+/]
      @sf.filter(regexps[0]) { |md| md.to_s.upcase }
      @sf.filter(regexps[1]) { |md| md.to_s.upcase }
      @sf.filters.map(&:first) == regexps
    end

    it "should add a filter at the top" do
      regexps = [/\w+/, /\d+/, /[_]/]
      @sf.filter(regexps[0]) { |md| md.to_s.upcase }
      @sf.filter(regexps[1], at: 0) { |md| md.to_s.upcase }
      @sf.filters.map(&:first) == regexps.reverse
    end
  end

  context "filter 'global' option" do
    it "should act as gsub without global option" do
      sf = SubFilter.new("hello, world")
      sf.filter(/\w+/) { |md| md.to_s.upcase }
      sf.run.should eql "HELLO, WORLD"
    end

    it "should act as sub" do
      sf = SubFilter.new("hello, world")
      sf.filter(/\w+/, global:false) { |md| md.to_s.upcase }
      sf.run.should eql "HELLO, world"
    end
  end

  context "replace method" do
    it "should replace a filter" do
      sf = SubFilter.new("hello, world")
      sf.filter(/\w+/) { |md| md.to_s.upcase }
      sf.filter(/\d+/) { |md| md.to_s.upcase }
      sf.replace(0, /[,]/) { |md| ":" }
      sf.filters.map(&:first).should eql [/[,]/, /\d+/]
    end
  end
end