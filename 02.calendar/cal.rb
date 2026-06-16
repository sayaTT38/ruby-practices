#!/usr/bin/env ruby

require 'date'
require 'optparse'

#オプションの値を取得
options = ARGV.getopts('y:','m:')
year = options['y']&.to_i || Date.today.year    #オプションが指定されていなければ今年のカレンダーを表示する
month = options['m']&.to_i || Date.today.month  #オプションが指定されていなければ今月のカレンダーを表示する

#月初日、月末日の取得
first_day = Date.new(year, month, 1)
last_day = Date.new(year, month, -1)

#カレンダーのヘッダー部分の出力
puts "      #{month}月 #{year}"
puts "日 月 火 水 木 金 土"

#カレンダー冒頭の空白を出力
first_day_wday = first_day.wday
print "   " * first_day_wday

#日付の出力
(first_day..last_day).each do |date|
  printf('%2d ', date.day)
  #土曜日または月末日の場合改行する
  if date.saturday? || date == last_day
    print "\n"
  end
end
