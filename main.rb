require 'io/console'

$Japanese = [["\"Dull\"これは迷宮から脱出する迷路ゲームです。", "スタートは左上で、ゴールは右下にあります。", "辺りは暗くなっているので、", "近くしか見ることはできません。", "アイテムを駆使してゴールにたどり着きましょう。", "(アイテムは未実装です。)"], "<操作方法>", "移動　　", "決定　　", "本当に終了しますか？", "終了しました", "言語 : 日本語", "終了する", "やり直し", "キー", "キー", ["<迷路>", "プレイヤー　: \"@\"", "壁　　　　　: \"■\"", "道　　　　　: \"□\"", "ゴール　　　: \"\#\""], "スクロールできます", ["ゲームを始める", "Dullについて", "設定", "終了する"], ["本当に    ", "終了し    ", "ますか?   "], "はい", "いいえ", ["本当に    ", "やり直し   ", "ますか?   "]]
$English = [["\"Dull\" This is a maze game where", "you escape from a labyrinth.", "The start is at the top left and", "the goal is at the bottom right.", "It's dark, so you can only", "see up close.", "Use items to reach the goal.", "(Item is not yet implemented.)"], "<Way to play>", "Move  ", "Deside", "Are you sure you want to exit?", "Ended", "Language : English", "Exit  ", "Retry ", "key", "keys", ["<Maze>", "Player : \"@\"", "Block  : \"■\"", "Route  : \"□\"", "Goal   : \"\#\""], "You can scroll", ["Start Game", "About Game", "Settings", "Exit"], ["Are you", "sure   ", "you    ", "want to",  "exit?  "], "Yes", "No", ["Are you", "sure   ", "you    ", "want to",  "retry? "]]
$words = [$English, $Japanese]

def clean
  puts "\e[0m\e[H\e[2J", ""
end

def pass
  n = 0
end

def screen_convert_to_blank(putter)
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
end

def screen_convert_from_blank(inter)
  clean
  putter = []
  for y in 0..11
    putter.push([])
    for x in 0..34
      putter[y].push(" ")
    end
  end

  for y in 0..11 + 2
    for x in 0..34
      if y > 1
        putter[y - 2][x] = inter[y - 2][x]
      end
      if y < 11
        putter[y][x] = "■"
      end
    end
    clean
    for y in 0..11
      puts putter[y].join
    end
    sleep(0.05)
  end
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
    keyinboards = [["a", "s", "d", "w", "space", "enter", "e", "r"], [97, 115, 100, 119, 32, 13, 101, 114]]
    if keyinboards[1].include?(ch.to_i)
      return keyinboards[0][keyinboards[1].index(ch.to_i)]
    else
      return ""
    end
  end
end

def start
  clean
  cursol_status = 0
  starter_hozon = []
  for i in 0..$words.length - 1
    starter_hozon.push($words[i][13].clone)
  end
  while true
    clean
    $starter = $words[$language][13].clone
    puts $dull_letter
    for i in 0..$starter.length - 1
      if i == cursol_status
        $starter[i] = "           > " + $starter[i].slice(starter_hozon[$language][i].length * -1..-1)
      else
        $starter[i] = "             " + $starter[i].slice(starter_hozon[$language][i].length * -1..-1)
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
          cutter = 0
          putter_hozon = ["<#{$words[$language][13][1]}>", 
          *$words[$language][0], 
          "", 
          *$words[$language][11], 
          "", 
          "#{$words[$language][1]}", 
          "#{$words[$language][2]} : WASD #{$words[$language][10]}", 
          "#{$words[$language][3]} : Space #{$words[$language][9]}", 
          "#{$words[$language][7]} : E #{$words[$language][9]}", 
          "#{$words[$language][8]} : R #{$words[$language][9]}", 
          "", 
          "> #{$words[$language][13][3]}"]
          key = ""
          while key != "space"
            putter = putter_hozon.clone
            if cutter != 0
              putter[0 + cutter] = "↑   ↑   ↑   ↑  (#{$words[$language][12]})"
            end
            if cutter != putter.length - 12
              putter[11 + cutter] = "↓   ↓   ↓   ↓  (#{$words[$language][12]})"
            end
            clean
            puts putter[cutter..11 + cutter]
            key = keyin
            if key == "w" && cutter != 0
              cutter -= 1
            end
            if key == "s" && cutter != putter.length - 12
              cutter += 1
            end
          end
        when 2
          up_down_status = 1
          clean
          puts("<#{$words[$language][13][2]}>", 
          "",
          "> #{$words[$language][6]}", 
          "  #{$words[$language][13][3]}")
          key = ""
          while true
            clean
            if up_down_status == 1
              puts("<#{$words[$language][13][2]}>", 
              "",
              "> #{$words[$language][6]}", 
              "  #{$words[$language][13][3]}")
            else
              puts("<#{$words[$language][13][2]}>", 
              "",
              "  #{$words[$language][6]}", 
              "> #{$words[$language][13][3]}")
            end
            key = keyin
            if key == "w"
              up_down_status = 1
            elsif key == "s"
              up_down_status = 0
            elsif key == "space"
              if up_down_status == 1
                $language += 1
                if $language == $words.length
                  $language = 0
                end
              else
                break
              end
            end
          end
        when 3
          $exiter = 0
          key = ""
          while key != "space"
            clean
            puts("<#{$words[$language][13][3]}>", 
            "#{$words[$language][4]}", 
            "")
            if key == "w"
              $exiter = 1
            elsif key == "s"
              $exiter = 0
            end
            if $exiter == 1
              puts "> #{$words[$language][15]}"
              puts "  #{$words[$language][16]}"
            else
              puts "  #{$words[$language][15]}"
              puts "> #{$words[$language][16]}"
            end
            key = keyin
          end
        if $exiter == 1
          clean
          puts "<#{$words[$language][13][3]}>"
          puts "#{$words[$language][5]}"
          exit
        end
      end
    end
  end
end
$language = 0

def make_maze(x, y)
  maze = []
  for ky in 0..y - 1
    maze.push([])
    for kx in 0..x - 1
      maze[ky].push(1)
    end
  end
  mx, my = 1, 1
  maze[my][mx] = 0
  while true
    while true
      way = [[2, 0], [-2, 0], [0, 2], [0, -2]]
      can_way = way.select{|a| ((mx == 1 && a[0] == -2) || (my == 1 && a[1] == -2) || (mx == x - 2 && a[0] == 2) || (my == y - 2 && a[1] == 2)) == false && maze[my + a[1]][mx + a[0]] == 1}
      if can_way == []
        break
      end
      to_way = can_way[rand(can_way.length)]
      maze[my + to_way[1]][mx + to_way[0]] = 0
      maze[my + to_way[1] / 2][mx + to_way[0] / 2] = 0
      mx, my = mx + to_way[0], my + to_way[1]
    end
    next_plots = []
    for ky in 0..y - 1
      for kx in 0..x - -1
        if maze[ky][kx] == 0 && ky % 2 == 1 && kx % 2 == 1
          next_plots.push([kx, ky])
        end
      end
    end
    if next_plots.length == ((x - 1) / 2) * ((y - 1) / 2)
      break
    end
    next_plot = next_plots[rand(next_plots.length)]
    mx, my = next_plot[0], next_plot[1]
  end
  maze[-2][-2] = 9
  return maze
end

def screen(maze, nx, ny, cx, cy)
  inter = []
  for y in cy..11 + cy
    putter = ""
    for x in cx..24 + cx
      if x == nx && y == ny
        putter += "@"
      else
        if (nx - x).abs > 6 or (ny - y).abs > 3
          putter += "-"
        else
          if maze[y][x] == 9
            putter += "\#"
          elsif maze[y][x] == 1
            putter += "■"
          else
            putter += "□"
          end
        end
      end
    end
    putter += " :"
    inter.push(putter)
  end
  return inter
end

ender = 0
retryer = 0
while true
  $dull_letter = [" " * 35, "       ■■■■■          ■■  ■■", "       ■■  ■■         ■■  ■■", "       ■■  ■■  ■■ ■■  ■■  ■■", "       ■■  ■■  ■■ ■■  ■■  ■■", "       ■■  ■■  ■■ ■■  ■■  ■■", "       ■■■■■    ■■■■  ■■  ■■"]
  start
  putter = $dull_letter + [" " * 35] + $starter.map{|x| x + " " * (35 - x.length)}
  screen_convert_to_blank(putter)
  clean
  puts [""] * 11 + [" " * 20 + "Loading..."]
  nx, ny = 1, 1
  cx, cy = 0, 0
  maze = make_maze(37, 23)
  puts [""] * 11 + [" " * 19 + "Game Start!"]
  sleep(0.5)
  inter = screen(maze, nx, ny, cx, cy)
  inter = inter.map{|x| x + " " * 8}
  screen_convert_from_blank(inter)
  while true
    if nx < 12
      cx = 0
    elsif nx >= maze[0].length - 12
      cx = maze[0].length - 25
    else
      cx = nx - 12
    end
    if ny < 6
      cy = 0
    elsif ny >= maze.length - 6
      cy = maze.length - 12
    else
      cy = ny - 6
    end
    # if nx > maze[0].length - 6
    #   nx = maze[0].length - 6
    # end
    # if ny > maze.length - 6
    #   ny = maze.length - 6
    # end
    clean
    inter_hozon = inter.clone
    inter = screen(maze, nx, ny, cx, cy)
    i = -1
    inter = inter.map do |x|
      i = i + 1
      x = x + inter_hozon[i][27..34]
    end
    puts inter
    if nx == maze[0].length - 2 && ny == maze.length - 2
      break
    end
    key = keyin
    if key == "w" && maze[ny - 1][nx] != 1 && ender == 0 && retryer == 0
      ny -= 1
    elsif key == "s" && maze[ny + 1][nx] != 1 && ender == 0 && retryer == 0
      ny += 1
    elsif key == "a" && maze[ny][nx - 1] != 1 && ender == 0 && retryer == 0
      nx -= 1
    elsif key == "d" && maze[ny][nx + 1] != 1 && ender == 0 && retryer == 0
      nx += 1
    elsif key == "e" || ender != 0 && retryer == 0
      if ender == 0
        ender = 2
      elsif key == "s"
        ender = 2
      elsif key == "w"
        ender = 1
      elsif key == "space"
        if ender == 1
          ender = 0
          break
        else
          for i in 0..12 - 1
            inter[i][27..34] = " " * 7
          end
        end
        ender = 0
      end
      if ender != 0
        for i in 0..$words[$language][14].length - 1
          inter[i][27..34] = $words[$language][14][i]
        end
        if ender == 1
          inter[10][27..34] = "> #{$words[$language][15]}"
          inter[11][27..34] = "  #{$words[$language][16]}"
        else
          inter[10][27..34] = "  #{$words[$language][15]}"
          inter[11][27..34] = "> #{$words[$language][16]}"
        end
      end
    elsif key == "r" || ender == 0 && retryer != 0
      if retryer == 0
        retryer = 2
      elsif key == "s"
        retryer = 2
      elsif key == "w"
        retryer = 1
      elsif key == "space"
        if retryer == 1
          retryer = 0 
          nx, ny = 1, 1
          for i in 0..12 - 1
            inter[i][27..34] = " " * 7
          end
        else
          for i in 0..12 - 1
            inter[i][27..34] = " " * 7
          end
        end
        retryer = 0
      end
      if retryer != 0
        for i in 0..$words[$language][17].length - 1
          inter[i][27..34] = $words[$language][17][i]
        end
        if retryer == 1
          inter[10][27..34] = "> #{$words[$language][15]}"
          inter[11][27..34] = "  #{$words[$language][16]}"
        else
          inter[10][27..34] = "  #{$words[$language][15]}"
          inter[11][27..34] = "> #{$words[$language][16]}"
        end
      end
    end
  end
  sleep(0.5)
  screen_convert_to_blank(inter)
  $dull_letter = [" " * 35, "       ■■■■■          ■■  ■■", "       ■■  ■■         ■■  ■■", "       ■■  ■■  ■■ ■■  ■■  ■■", "       ■■  ■■  ■■ ■■  ■■  ■■", "       ■■  ■■  ■■ ■■  ■■  ■■", "       ■■■■■    ■■■■  ■■  ■■"]
  putter = $dull_letter + [" " * 35] + $starter.map{|x| x + " " * (35 - x.length)}
  screen_convert_from_blank(putter)
end