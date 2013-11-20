require 'test/unit'
require_relative 'date_detector'
class DateDectectorTests < Test::Unit::TestCase

  def setup
    @dd = DateDetector.new()
  end

  def teardown
    # Do nothing
  end
  #1/3/12
  #16-Sep-12
  #25.08.2011
  #13/08/2009
  #3/3/12

  #TODO solve these
  #Feb 12 2010  6:02AM
  #2011-05-14 22:16:00 -0400
  #20121111

  def test_broken_str
    assert_equal(nil , @dd.get_ruby_date(""))
    assert_equal(nil , @dd.get_ruby_date("1"))
    assert_equal(nil , @dd.get_ruby_date("1/1"))
    assert_equal(nil , @dd.get_ruby_date("1/1/1"))
    assert_equal(nil , @dd.get_ruby_date("a"))
    assert_equal(nil , @dd.get_ruby_date("1/33/2013"))
    assert_equal(nil , @dd.get_ruby_date("33/1/2013"))
    assert_equal(nil , @dd.get_ruby_date("13/24/2013"))
    assert_equal(nil , @dd.get_ruby_date("24/13/2013"))
  end

  def test_ambigious
    assert_equal(nil , @dd.get_ruby_date("1/3/12"))
    assert_equal(nil , @dd.get_ruby_date("1/12/12"))
    assert_equal(nil , @dd.get_ruby_date("01/13/12"))
    assert_equal(nil , @dd.get_ruby_date("13/1/12"))
  end

  def test_m_d_y
    dateExamples = {
      "1/13/12" => Date.new(2012,1,13),
      "1.13.12" => Date.new(2012,1,13),
      "1 13 12" => Date.new(2012,1,13),
      "01/13/2012" => Date.new(2012,1,13),
      "12/21/2013" => Date.new(2013,12,21),
      "Jan/13/12" => Date.new(2012,1,13),
      "Feb/14/12" => Date.new(2012,2,14),
      "Mar/14/12" => Date.new(2012,3,14),
    }
    i = 0
    dateExamples.each do |dateExample, answer|
      assert_equal(answer , @dd.get_ruby_date(dateExample), "test_m_d_y #"+i.to_s)
      i += 1
    end
  end

  def test_d_m_y
    dateExamples = {
        "13/01/2012" => Date.new(2012,1,13),
        "13-01-2012" => Date.new(2012,1,13),
        "21/12/2013" => Date.new(2013,12,21),
        "13/Apr/2012" => Date.new(2012,4,13),
        "21/May/2013" => Date.new(2013,5,21),
    }
    i = 0
    dateExamples.each do |dateExample, answer|
      assert_equal(answer , @dd.get_ruby_date(dateExample), "test_d_m_y #"+i.to_s)
      i += 1
    end
  end

  def test_y_d_m
    dateExamples = {
        "12/13/1" => Date.new(2012,1,13),
        "2012/13/01" => Date.new(2012,1,13),
        "2013/21/12" => Date.new(2013,12,21),
        "12/13/Jun" => Date.new(2012,6,13),
        "12 13 Jun" => Date.new(2012,6,13),
        "12-13-Jun" => Date.new(2012,6,13),
        "12.13.Jun" => Date.new(2012,6,13),
        "2012/13/Jul" => Date.new(2012,7,13),
        "2013/21/Aug" => Date.new(2013,8,21),
    }
    i = 0
    dateExamples.each do |dateExample, answer|
      assert_equal(answer , @dd.get_ruby_date(dateExample), "test_y_d_m #"+i.to_s)
      i += 1
    end
  end

  def test_y_m_d
    dateExamples = {
        "2012/01/13" => Date.new(2012,1,13),
        "2013/12/21" => Date.new(2013,12,21),
        "2012/Sep/13" => Date.new(2012,9,13),
        "2013/Oct/21" => Date.new(2013,10,21),
    }
    i = 0
    dateExamples.each do |dateExample, answer|
      assert_equal(answer , @dd.get_ruby_date(dateExample), "test_y_m_d #"+i.to_s)
      i += 1
    end
  end


end