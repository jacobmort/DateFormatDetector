require 'test/unit'
require_relative 'date_detector'
class DateDectectorTests < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @dd = DateDetector.new()
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_broken_str
    assert_equal(-1 , @dd.get_ruby_date(""))
    assert_equal(-1 , @dd.get_ruby_date("1"))
    assert_equal(-1 , @dd.get_ruby_date("1/1"))
    assert_equal(-1 , @dd.get_ruby_date("1/1/1"))
    assert_equal(-1 , @dd.get_ruby_date("a"))
    assert_equal(-1 , @dd.get_ruby_date("1/33/2013"))
    assert_equal(-1 , @dd.get_ruby_date("33/1/2013"))
    assert_equal(-1 , @dd.get_ruby_date("13/24/2013"))
    assert_equal(-1 , @dd.get_ruby_date("24/13/2013"))
  end

  def test_ambigious
    assert_equal(-1 , @dd.get_ruby_date("1/3/12"))
    assert_equal(-1 , @dd.get_ruby_date("1/12/12"))
    assert_equal(-1 , @dd.get_ruby_date("01/13/12"))
  end

  def test_m_d_y
    dateExamples = {
      "1/13/12" => Date.new(2012,1,13),
      "01/13/2012" => Date.new(2012,1,13),
      "12/21/2013" => Date.new(2013,12,21),
    }
    i = 0
    dateExamples.each do |dateExample, answer|
      assert_equal(answer , @dd.get_ruby_date(dateExample), "test_m_d_y #"+i.to_s)
      ++i
    end
  end

  def test_d_m_y
    dateExamples = {
        "1/3/12" => -1,
        "1/12/12" => -1,
        "1/13/12" => Date.new(2012,1,13),
        "01/13/2012" => Date.new(2012,1,13),
    }
    dateExamples.each do |dateExample, answer|
      assert_equal(answer , @dd.get_ruby_date(dateExample))
    end
  end


end