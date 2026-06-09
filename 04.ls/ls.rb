#!/usr/bin/env ruby
# frozen_string_literal: true

COLUMN_SIZE = 3
COLUMN_WIDTH_UNIT = 8 # OS標準のlsコマンドの仕様に合わせ、列幅を8の倍数に揃える

def make_files_array
  Dir.glob('*').sort
end

def display_files
  files_array = make_files_array
  return if files_array.empty?

  row_size = files_array.size.fdiv(COLUMN_SIZE).ceil
  file_name_max_length = files_array.max_by(&:length).size
  column_width =
    if (file_name_max_length % COLUMN_WIDTH_UNIT).zero?
      file_name_max_length + COLUMN_WIDTH_UNIT
    else
      file_name_max_length.ceildiv(COLUMN_WIDTH_UNIT) * COLUMN_WIDTH_UNIT
    end
  row_size.times do |row|
    row_data =
      COLUMN_SIZE.times.map do |col|
        files_array[row + col * row_size]
      end.compact
    puts row_data.map { |x| x.ljust(column_width) }.join
  end
end

display_files
