#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMN_SIZE = 3
COLUMN_WIDTH_UNIT = 8 # OS標準のlsコマンドの仕様に合わせ、列幅を8の倍数に揃える
PERMISSIONS = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

FILE_TYPES = {
  'file' => '-',
  'directory' => 'd',
  'link' => 'l',
  'characterSpecial' => 'c',
  'blockSpecial' => 'b'
}.freeze

def main
  options = parse_options
  files_array = make_files_array(options)
  display_files(files_array, options)
end

def parse_options
  options = {}
  OptionParser.new do |op|
    op.on('-a') { options[:a] = true }
    op.on('-r') { options[:r] = true }
    op.on('-l') { options[:l] = true }
  end.parse!(ARGV)
  options
end

def make_files_array(options)
  flags = options[:a] ? File::FNM_DOTMATCH : 0
  files = Dir.glob('*', flags)
  options[:r] ? files.reverse : files
end

def display_files(files_array, options)
  return if files_array.empty?

  if options[:l]
    display_long_option_format(files_array)
  else
    display_normal_format(files_array)
  end
end

def display_normal_format(files_array)
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

def display_long_option_format(files_array)
  file_stats = files_array.map { |file| [file, File.stat(file)] }
  puts "total #{file_stats.sum { |_, stat| stat.blocks }}"
  max_lengths = {
    nlink: file_stats.map { |_, stat| stat.nlink.to_s.length }.max,
    uname: file_stats.map { |_, stat| Etc.getpwuid(stat.uid).name.length }.max,
    gname: file_stats.map { |_, stat| Etc.getgrgid(stat.gid).name.length }.max,
    size: file_stats.map { |_, stat| stat.size.to_s.length }.max
  }
  file_stats.each do |file, stat|
    puts make_long_option_format(file, stat, max_lengths)
  end
end

def make_long_option_format(file, stat, max_lengths)
  mode = stat.mode.to_s(8)
  [
    file_type_to_string(stat.ftype) + permission_to_string(mode[-3, 3]),
    stat.nlink.to_s.rjust(max_lengths[:nlink] + 1),
    Etc.getpwuid(stat.uid).name.ljust(max_lengths[:uname] + 1),
    Etc.getgrgid(stat.gid).name.ljust(max_lengths[:gname] + 1),
    stat.size.to_s.rjust(max_lengths[:size]),
    stat.mtime.strftime('%b %e %H:%M'),
    file
  ].join(' ')
end

def permission_to_string(permission)
  permission.chars.map { |num| PERMISSIONS[num] }.join
end

def file_type_to_string(file_type)
  FILE_TYPES[file_type]
end

main
