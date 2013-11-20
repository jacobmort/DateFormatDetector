require 'set'
require 'date'

class DateDetector
  @@DELIMITERS = [" ","/",'-',"."]
  @@DEFAULT_DELIM = "/"
  @@REGEX_DATE_MAP = {
    /^([0]?[1-9]|1[0-2])([\/\s\.\-])([0-9]|[012]\d|3[0-1])([\/\s\.\-])\d{2}(\s|\z)/ => "%m/%d/%y",
    /^([0]?[1-9]|1[0-2])([\/\s\.\-])([0-9]|[012]\d|3[0-1])([\/\s\.\-])\d{4}(\s|\z)/ => "%m/%d/%Y",
    /^([0-9]|[012]\d|3[0-1])([\/\s\.\-])([0]?[1-9]|1[0-2])([\/\s\.\-])\d{2}(\s|\z)/ => "%d/%m/%y",
    /^([0-9]|[012]\d|3[0-1])([\/\s\.\-])([0]?[1-9]|1[0-2])([\/\s\.\-])\d{4}(\s|\z)/ => "%d/%m/%Y",

    /^\d{2}([\/\s\.\-])([0-9]|[012]\d|3[0-1])([\/\s\.\-])([0]?[1-9]|1[0-2])(\s|\z)/ => "%y/%d/%m",
    /^\d{4}([\/\s\.\-])([0-9]|[012]\d|3[0-1])([\/\s\.\-])([0]?[1-9]|1[0-2])(\s|\z)/ => "%Y/%d/%m",
    /^\d{2}([\/\s\.\-])([0]?[1-9]|1[0-2])([\/\s\.\-])([0-9]|[012]\d|3[0-1])(\s|\z)/ => "%y/%m/%d",
    /^\d{4}([\/\s\.\-])([0]?[1-9]|1[0-2])([\/\s\.\-])([0-9]|[012]\d|3[0-1])(\s|\z)/ => "%Y/%m/%d",

    #Month spelled out ex. Sep
    /^([0-9]|[012]\d|3[0-1])([\/\s\.\-])[a-zA-Z]{3}([\/\s\.\-])\d{2}(\s|\z)/ => "%d/%b/%y",
    /^([0-9]|[012]\d|3[0-1])([\/\s\.\-])[a-zA-Z]{3}([\/\s\.\-])\d{4}(\s|\z)/ => "%d/%b/%Y",
    /^[a-zA-Z]{3}([\/\s\.\-])([0-9]|[012]\d|3[0-1])([\/\s\.\-])\d{2}(\s|\z)/ => "%b/%d/%y",
    /^[a-zA-Z]{3}([\/\s\.\-])([0-9]|[012]\d|3[0-1])([\/\s\.\-])\d{4}(\s|\z)/ => "%b/%d/%Y",


    /^\d{2}([\/\s\.\-])([0-9]|[012]\d|3[0-1])([\/\s\.\-])[a-zA-Z]{3}(\s|\z)/ => "%y/%d/%b",
    /^\d{4}([\/\s\.\-])([0-9]|[012]\d|3[0-1])([\/\s\.\-])[a-zA-Z]{3}(\s|\z)/ => "%Y/%d/%b",
    /^\d{2}([\/\s\.\-])[a-zA-Z]{3}([\/\s\.\-])([0-9]|[012]\d|3[0-1])(\s|\z)/ => "%y/%b/%d",
    /^\d{4}([\/\s\.\-])[a-zA-Z]{3}([\/\s\.\-])([0-9]|[012]\d|3[0-1])(\s|\z)/ => "%Y/%b/%d",

  }

  def determine_delimiter_regex(str)
    @@DELIMITERS.each do |possible_delimter|
      if (str.include? possible_delimter)
        return possible_delimter
      end
    end
    nil
  end

  def does_match(regex, str)
    (str.match regex) != nil
  end

  def replace_delimiter(format, delim)
    format.gsub(@@DEFAULT_DELIM, delim)
  end

  def get_date_format(str)
    @possible_formats = Set.new()
    delimit = determine_delimiter_regex(str)
    unless delimit.nil?
      @@REGEX_DATE_MAP.each do |regex,format|
        @possible_formats.add(replace_delimiter(format,delimit))
      end
      @@REGEX_DATE_MAP.each do |regex,format|
        unless does_match(regex, str)
          @possible_formats.delete(replace_delimiter(format,delimit))
        end
      end
    end
    @possible_formats.to_a
  end

  def get_ruby_date(str)
    format = get_date_format(str)
    if format.length == 0
      #puts "could not determine format of:"+str
      nil
    elsif format.length > 1
      #puts "multiple formats matched:"<<str
      #puts "formats:"<<formats.to_s
      nil
    else
      Date.strptime(str, format[0])
    end
  end
end