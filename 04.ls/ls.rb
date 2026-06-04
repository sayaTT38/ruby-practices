#!/usr/bin/env ruby
# frozen_string_literal: true

COLUMN_SIZE = 3
TAB_SIZE = 8 # 列幅計算に使用するタブサイズ

def make_files_array
  Dir.foreach('.').to_a.reject { |dir| dir.start_with?('.') }.sort
end

def display_files
  files_array = make_files_array
  row_size = files_array.size.fdiv(COLUMN_SIZE).ceil
  file_name_max_length = files_array.max_by(&:length).size
  column_width =
    if (file_name_max_length % TAB_SIZE).zero?
      file_name_max_length + TAB_SIZE
    else
      file_name_max_length.fdiv(TAB_SIZE).ceil * TAB_SIZE
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
