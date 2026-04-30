#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X' # strike
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

# フレームごとにshotsを分解
frames = []
i = 0
# 1〜9フレーム
9.times do
  frames << shots[i, 2]
  i += 2
end
# 10フレーム目（残り全部） ※10フレーム目だけ、配列の長さが3以上の可能性がある
frames << shots[i..]

# ポイントの計算
point = 0
frames.each_with_index do |frame, index|
  if index < 9 # 1~9フレーム目の処理
    if frame[0] == 10 # strike
      # 次の2投の点を加算する
      if frames[index + 1][0] != 10 # 次の1投目がストライクじゃない
        point += (frame.sum + frames[index + 1][0] + frames[index + 1][1])
      elsif frames[index + 2].nil? # 次の1投がストライクかつ、次の次のフレームが存在しない（＝10フレーム目内で2投取る）
        point += (frame.sum + frames[index + 1][0] + frames[index + 1][2])
      else # 次の1投がストライクかつ、次の次のフレームが存在する
        point += (frame.sum + frames[index + 1][0] + frames[index + 2][0])
      end
    elsif frame.sum == 10 # spare
      # 次の1投の点を加算する
      point += (frame.sum + frames[index + 1][0])
    else
      point += frame.sum
    end
  else # 10フレーム目の処理
    point += frame.sum
  end
end

puts point
