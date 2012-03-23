# encoding: UTF-8
require "rspec"
require_relative "gsub_filter"

describe GsubFilter do
  before do
    str = <<EOS
*p1*こんにちは世界
hello, world
*123*I love Ruby
ruby is a lang.
EOS
    @gs = GsubFilter.new(str)
  end

  context "run" do
    it "should convert a string with one filter" do
      res = <<EOS
##こんにちは世界
hello, world
##I love Ruby
ruby is a lang.
EOS
      @gs.filter(/^\*p?\d+\*(.*)$/) { |md| "###{md[1]}" }
      @gs.run.should == res
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
      @gs.filter(/\w+/) { |md| md.to_s.capitalize }
      @gs.run(str).should == res
    end

    it "should convert a string with two filters" do
      res =<<EOS
##こんにちは世界
HELLO, WORLD
##I LOVE RUBY
RUBY IS A LANG.
EOS
      @gs.filter(/^\*p?\d+\*(.*)$/) { |md| "###{md[1]}" }
      @gs.filter(/\w+/) { |md| md.to_s.upcase }
      @gs.run.should == res
    end

    it "should add a line with captured words" do
      res =<<EOS
---こんにちは世界---
HELLO, WORLD
---I LOVE RUBY---
RUBY IS A LANG.
こんにちは世界,I love Ruby
EOS
      @gs.filter(/^\*p?\d+\*(.*)$/) do |md, stocks|
        stocks[:title] << md[1]
        "---#{md[1]}---"
      end
      @gs.filter(/\w+/) { |md| md.to_s.upcase }
      line = @gs.run
      last = @gs.stocks[:title].join(',') + "\n"
      (line + last).should == res
    end
  end

  context "filter 'at' option" do
    it "should add a filter at the last" do
      regexps = [/\w+/, /\d+/]
      @gs.filter(regexps[0]) { |md| md.to_s.upcase }
      @gs.filter(regexps[1]) { |md| md.to_s.upcase }
      @gs.filters.map(&:first) == regexps
    end

    it "should add a filter at the top" do
      regexps = [/\w+/, /\d+/, /[_]/]
      @gs.filter(regexps[0]) { |md| md.to_s.upcase }
      @gs.filter(regexps[1], at: 0) { |md| md.to_s.upcase }
      @gs.filters.map(&:first) == regexps.reverse
    end
  end

  context "filter 'global' option" do
    it "should act as gsub without global option" do
      gs = GsubFilter.new("hello, world")
      gs.filter(/\w+/) { |md| md.to_s.upcase }
      gs.run.should eql "HELLO, WORLD"
    end

    it "should act as sub" do
      gs = GsubFilter.new("hello, world")
      gs.filter(/\w+/, global:false) { |md| md.to_s.upcase }
      gs.run.should eql "HELLO, world"
    end
  end

  context "replace method" do
    it "should replace a filter" do
      gs = GsubFilter.new("hello, world")
      gs.filter(/\w+/) { |md| md.to_s.upcase }
      gs.filter(/\d+/) { |md| md.to_s.upcase }
      gs.replace(0, /[,]/) { |md| ":" }
      gs.filters.map(&:first).should eql [/[,]/, /\d+/]
    end
  end
end