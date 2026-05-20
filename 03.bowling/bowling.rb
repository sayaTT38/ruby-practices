#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
9.times do |n|
  frames << shots[n * 2, 2]
end
# 10フレーム目 ※10フレーム目だけ、配列の長さが3以上の可能性がある
frames << shots[18..]

point = frames.each_with_index.sum do |frame, index|
  next_frame = frames[index + 1]
  if index == 9
    frame.sum
  elsif frame[0] == 10
    next_next_frame = frames[index + 2]
    bonus =
      next_frame[0] +
      if next_frame[0] == 10
        # 9フレーム目で次がストライクの場合、ボーナス2投は10フレーム目内から取得する
        index == 8 ? next_frame[2] : next_next_frame[0]
      else
        next_frame[1]
      end
    frame.sum + bonus
  elsif frame.sum == 10
    frame.sum + next_frame[0]
  else
    frame.sum
  end
end

puts point
