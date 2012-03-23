# encoding: UTF-8
class GsubFilter
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
