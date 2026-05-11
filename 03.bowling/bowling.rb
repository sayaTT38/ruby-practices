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
i = 0
9.times do
  frames << shots[i, 2]
  i += 2
end
# 10フレーム目 ※10フレーム目だけ、配列の長さが3以上の可能性がある
frames << shots[i..]

point = 0
frames.each_with_index do |frame, index|
  if index == 9
    point += frame.sum
  elsif frame[0] == 10
    next_frame = frames[index + 1]
    next_next_frame = frames[index + 2]
    bonus = if next_frame[0] == 10
              if index == 8 # 9フレーム目で次がストライクの場合、ボーナス2投は10フレーム目内から取得する
                next_frame[0] + next_frame[2]
              else
                next_frame[0] + next_next_frame[0]
              end
            else
              next_frame[0] + next_frame[1]
            end
    point += (frame.sum + bonus)
  elsif frame.sum == 10
    next_frame = frames[index + 1]
    point += (frame.sum + next_frame[0])
  else
    point += frame.sum
  end
end

puts point
