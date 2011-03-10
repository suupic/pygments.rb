# coding: utf-8

require 'test/unit'
require 'pygments'

class PygmentsLexerTest < Test::Unit::TestCase
  include Pygments

  RUBY_CODE = "#!/usr/bin/ruby\nputs 'foo'"

  def test_lexer_by_content
    assert_equal 'rb', lexer_name_for(RUBY_CODE)
  end
  def test_lexer_by_mimetype
    assert_equal 'rb', lexer_name_for(:mimetype => 'text/x-ruby')
  end
  def test_lexer_by_filename
    assert_equal 'rb', lexer_name_for(:filename => 'test.rb')
  end
  def test_lexer_by_name
    assert_equal 'rb', lexer_name_for(:lexer => 'ruby')
  end
  def test_lexer_by_filename_and_content
    assert_equal 'rb', lexer_name_for(RUBY_CODE, :filename => 'test.rb')
  end
end

class PygmentsCssTest < Test::Unit::TestCase
  include Pygments

  def test_css
    assert_match /^\.err \{/, css
  end
  def test_css_prefix
    assert_match /^\.highlight \.err \{/, css('.highlight')
  end
  def test_css_options
    assert_match /^\.codeerr \{/, css(:classprefix => 'code')
  end
  def test_css_prefix_and_options
    assert_match /^\.mycode \.codeerr \{/, css('.mycode', :classprefix => 'code')
  end
  def test_css_default
    assert_match '.c { color: #408080; font-style: italic }', css
  end
  def test_css_colorful
    assert_match '.c { color: #808080 }', css(:style => 'colorful')
  end
end

class PygmentsConfigTest < Test::Unit::TestCase
  include Pygments

  def test_styles
    assert styles.include?('colorful')
  end
  def test_filters
    assert filters.include?('codetagify')
  end
  def test_lexers
    list = lexers
    assert list.has_key?('Ruby')
    assert list['Ruby'][:aliases].include?('duby')
  end
  def test_formatters
    list = formatters
    assert list.has_key?('Html')
    assert list['Html'][:aliases].include?('html')
  end
end

class PygmentsHighlightTest < Test::Unit::TestCase
  include Pygments

  RUBY_CODE = "#!/usr/bin/ruby\nputs 'foo'"

  def test_highlight_defaults_to_html
    code = highlight(RUBY_CODE)
    assert_match '<span class="c1">#!/usr/bin/ruby</span>', code
  end

  def test_highlight_works_on_utf8
    code = highlight('# ø', :lexer => 'rb')
    assert_match '<span class="c1"># ø</span>', code
  end

  def test_highlight_formatter_bbcode
    code = highlight(RUBY_CODE, :formatter => 'bbcode')
    assert_match '[i]#!/usr/bin/ruby[/i]', code
  end

  def test_highlight_formatter_terminal
    code = highlight(RUBY_CODE, :formatter => 'terminal')
    assert_match "\e[37m#!/usr/bin/ruby\e[39;49;00m", code
  end

  def test_highlight_options
    code = highlight(RUBY_CODE, :options => {:full => true, :title => 'test'})
    assert_match '<title>test</title>', code
  end
end