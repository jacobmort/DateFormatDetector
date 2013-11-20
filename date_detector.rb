require 'set'
require 'date'

class DateDetector
  @@dDELIMITERS = [ /\s+/, /\//, /\-/, /\./ ]
  @@REGEX_DATE_MAP = {
    /^([0]?[1-9]|1[0-2])(\/)([0-9]|[012]\d|3[0-1])(\/)\d{2}(\s|\z)/ => "%m/%d/%y",
    /^([0]?[1-9]|1[0-2])(\/)([0-9]|[012]\d|3[0-1])(\/)\d{4}(\s|\z)/ => "%m/%d/%Y",
    /^([0-9]|[012]\d|3[0-1])(\/)([0]?[1-9]|1[0-2])(\/)\d{2}(\s|\z)/ => "%d/%m/%y",
    /^([0-9]|[012]\d|3[0-1])(\/)([0]?[1-9]|1[0-2])(\/)\d{4}(\s|\z)/ => "%d/%m/%Y",

    /^\d{2}(\/)([0-9]|[012]\d|3[0-1])(\/)([0]?[1-9]|1[0-2])(\s|\z)/ => "%y/%d/%m",
    /^\d{4}(\/)([0-9]|[012]\d|3[0-1])(\/)([0]?[1-9]|1[0-2])(\s|\z)/ => "%Y/%d/%m",
    /^\d{2}(\/)([0]?[1-9]|1[0-2])(\/)([0-9]|[012]\d|3[0-1])(\s|\z)/ => "%y/%m/%d",
    /^\d{4}(\/)([0]?[1-9]|1[0-2])(\/)([0-9]|[012]\d|3[0-1])(\s|\z)/ => "%Y/%m/%d",

    #Month spelled out ex. Sep
    /^([0-9]|[012]\d|3[0-1])(\/)[a-zA-Z]{3}(\/)\d{2}(\s|\z)/ => "%d/%b/%y",
    /^([0-9]|[012]\d|3[0-1])(\/)[a-zA-Z]{3}(\/)\d{4}(\s|\z)/ => "%d/%b/%Y",
    /^[a-zA-Z]{3}(\/)([0-9]|[012]\d|3[0-1])(\/)\d{2}(\s|\z)/ => "%b/%d/%y",
    /^[a-zA-Z]{3}(\/)([0-9]|[012]\d|3[0-1])(\/)\d{4}(\s|\z)/ => "%b/%d/%Y",


    /^\d{2}(\/)([0-9]|[012]\d|3[0-1])(\/)[a-zA-Z]{3}(\s|\z)/ => "%y/%d/%b",
    /^\d{4}(\/)([0-9]|[012]\d|3[0-1])(\/)[a-zA-Z]{3}(\s|\z)/ => "%Y/%d/%b",
    /^\d{2}(\/)[a-zA-Z]{3}(\/)([0-9]|[012]\d|3[0-1])(\s|\z)/ => "%y/%b/%d",
    /^\d{4}(\/)[a-zA-Z]{3}(\/)([0-9]|[012]\d|3[0-1])(\s|\z)/ => "%Y/%b/%d",

  }

  def does_match(regex, str)
    (str.match regex) != nil
  end

  def get_date_format(str)
    @possible_formats = Set.new()
    @@REGEX_DATE_MAP.each do |regex,format|
      @possible_formats.add(format);
    end
    @@REGEX_DATE_MAP.each do |regex,format|
      unless does_match(regex, str)
        @possible_formats.delete(format)
      end
    end
    @possible_formats.to_a
  end

  def get_ruby_date(str)
    format = get_date_format(str)
    if format.length == 0
      #puts "could not determine format of:"+str
      -1
    elsif format.length > 1
      #puts "multiple formats matched:"<<str
      #puts "formats:"<<formats.to_s
      -1
    else
      Date.strptime(str, format[0])
    end
end

end
#1/3/12
#16-Sep-12
#25.08.2011
#Feb 12 2010  6:02AM
#2011-05-14 22:16:00 -0400
#13/08/2009
#3/3/12
#20121111
dd = DateDetector.new()
date = dd.get_ruby_date("12/13/Jun")