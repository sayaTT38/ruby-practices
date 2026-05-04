#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X' # ストライク
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

# フレームごとにshotsを分ける
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
  # 10フレーム目の処理
  if index == 9
    point += frame.sum
    next
  end

  # 1~9フレーム目の処理(ストライクとスペア以外)
  if frame[0] != 10 && frame.sum != 10 # ストライクでもスペアでもない
    point += frame.sum
    next
  end

  # 1~9フレーム目の処理(ストライクとスペア)
  if frame[0] == 10 # ストライク
    next_frame = frames[index + 1]
    next_next_frame = frames[index + 2]
    # 次の2投の点を加算する
    bonus = if next_frame[0] != 10 # 次の1投がストライクじゃない
              next_frame[0] + next_frame[1]
            elsif next_next_frame.nil? # 次の1投がストライクかつ、次の次のフレームが存在しない（＝10フレーム目内で2投取る）
              next_frame[0] + next_frame[2]
            else # 次の1投がストライクかつ、次の次のフレームが存在する
              next_frame[0] + next_next_frame[0]
            end
    point += (frame.sum + bonus)
  elsif frame.sum == 10 # スペア
    next_frame = frames[index + 1]
    # 次の1投の点を加算する
    point += (frame.sum + next_frame[0])
  end
end

puts point
