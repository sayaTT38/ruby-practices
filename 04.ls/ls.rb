#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COLUMN_SIZE = 3
COLUMN_WIDTH_UNIT = 8 # OS標準のlsコマンドの仕様に合わせ、列幅を8の倍数に揃える

def main
  options = parse_options
  files_array = make_files_array(options)
  display_files(files_array)
end

def parse_options
  options = {}
  OptionParser.new do |op|
    op.on('-a') { options[:a] = true }
  end.parse!(ARGV)
  options
end

def make_files_array(options)
  files = options[:a] ? Dir.glob("*", File::FNM_DOTMATCH) : Dir.glob('*')
end

def display_files(files_array)
  return if files_array.empty?

  row_size = files_array.size.fdiv(COLUMN_SIZE).ceil
  file_name_max_length = files_array.max_by(&:length).size
  column_width = (file_name_max_length + 1).ceildiv(COLUMN_WIDTH_UNIT) * COLUMN_WIDTH_UNIT
  row_size.times do |row|
    row_data =
      COLUMN_SIZE.times.map do |col|
        files_array[row + col * row_size]
      end.compact
    puts row_data.map { |x| x.ljust(column_width) }.join
  end
end

main
