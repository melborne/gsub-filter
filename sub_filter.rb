# encoding: UTF-8
class SubFilter
  VERSION = '0.1.0'
  attr_reader :stocks, :filters
  def initialize(input=nil)
    @input = input
    @filters = []
    @stocks = Hash.new{ |h,k| h[k] = [] }
  end

  # default opt: {global: true, at: -1, replace: false}
  def filter(pattern, opt={}, &replace)
    opt = opt_parse_for_filter(opt)
    @filters[opt[:at], opt[:replace]] = [[pattern, replace, opt[:global]]]
    nil
  end

  def replace(at, pattern, opt={}, &replace)
    opt = {at: at, replace: true}.update(opt)
    filter(pattern, opt, &replace)
  end

  def run(str=nil)
    str ||= @input
    @filters.compact.each do |pattern, replace, meth|
      str = str.send(meth, pattern) { replace[$~, @stocks] }
    end
    str
  end

  def opt_clear
    @stocks.clear
  end

  private
  def opt_parse_for_filter(opt)
    opt = {global: true, at: -1, replace: false}.update(opt)
    opt[:global] = opt[:global] ? :gsub : :sub
    opt[:replace] = opt[:replace] ? 1 : 0
    if opt[:replace].zero? && opt[:at] < 0
      opt[:at] = @filters.size + opt[:at] + 1
    end
    opt
  end
end

if __FILE__ == $0
  str =<<EOS
hello, world
this is title.
Goodbye, universe
that is also title.
EOS
  sf = SubFilter.new(str)
  sf.filter(/\b(t\w+)/) { |md, stocks| stocks[:from_t] << md[1]; md[1].capitalize }
  sf.filter(/\b(\w+e)([^\w])/) { |md, stocks| stocks[:end_e] << md[1]; md[1].upcase + md[2]}

  p sf.run
  p sf.stocks
end
