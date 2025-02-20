require 'io/console'

def clean
  puts "\e[0m\e[H\e[2J", ""
end

def pass
  n = 0
end

def wait_for_space
  while true
    if keyin == "space"
      break
    end
  end
end

def keyin
  $stdin.raw do |io|
    ch = io.readbyte
    keyinboards = [["a", "s", "d", "w", "space", "enter"], [97, 115, 100, 119, 32, 13]]
    if keyinboards[1].include?(ch.to_i)
      return keyinboards[0][keyinboards[1].index(ch.to_i)]
    else
      return ""
    end
  end
end

def start
  clean
  $starter = ["Start Game", "About Game", "Settings  ", "Exit      "]
  cursol_status = 0
  while true
    clean
    puts $dull_letter
    for i in 0..$starter.length - 1
      if i == cursol_status
        $starter[i] = "           > " + $starter[i].slice(-10..-1)
      else
        $starter[i] = "             " + $starter[i].slice(-10..-1)
      end
    end
    puts "", $starter
    key = keyin
    if key == "w"
      cursol_status = [0, cursol_status - 1].max
    elsif key == "s"
      cursol_status = [$starter.length - 1, cursol_status + 1].min
    elsif key == "space"
      case cursol_status
        when 0
          break
        when 1
          clean
          puts("<About Game>", 
          "Dull これは迷宮から抜け出す迷路ゲームです。", 
          "", 
          "操作方法:", 
          "移動 : WASD", 
          "決定 : space", 
          "", 
          "> Exit")
          wait_for_space
        when 2
          clean
          puts("<Settings>", 
          "~~~未開発~~~",
          "", 
          "> Exit")
          wait_for_space
        when 3
          $exiter = 0
          key = ""
          while key != "space"
            clean
            puts("<Exit>", 
            "本当に終了しますか？", 
            "")
            if key == "w"
              $exiter = 1
            elsif key == "s"
              $exiter = 0
            end
            if $exiter == 1
              puts "> Yes"
              puts "  No"
            else
              puts "  Yes"
              puts "> No"
            end
            key = keyin
          end
        if $exiter == 1
          clean
          puts "<Exit>"
          puts "終了しました。"
          exit
        end
      end
    end
  end
end

$dull_letter = [" " * 35, "       ■■■■■          ■■  ■■", "       ■■  ■■         ■■  ■■", "       ■■  ■■  ■■ ■■  ■■  ■■", "       ■■  ■■  ■■ ■■  ■■  ■■", "       ■■  ■■  ■■ ■■  ■■  ■■", "       ■■■■■    ■■■■  ■■  ■■"]
start
putter = $dull_letter + [" " * 35] + $starter.map{|x| x + " " * (35 - x.length)}
clean
for y in 0..11 + 2
  for x in 0..34
    if y > 1
      putter[y - 2][x] = " "
    end
    if y < 11
      putter[y][x] = "■"
    end
  end
  clean
  puts putter
  sleep(0.05)
end