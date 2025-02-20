require 'io/console'

def clean
  puts "\e[0m\e[H\e[2J", ""
end

def pass
  n = 0
end

def screen_convert(putter)
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
          "Dull これは迷宮から脱出する迷路ゲームです。", 
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
  return maze
end

$dull_letter = [" " * 35, "       ■■■■■          ■■  ■■", "       ■■  ■■         ■■  ■■", "       ■■  ■■  ■■ ■■  ■■  ■■", "       ■■  ■■  ■■ ■■  ■■  ■■", "       ■■  ■■  ■■ ■■  ■■  ■■", "       ■■■■■    ■■■■  ■■  ■■"]
start
putter = $dull_letter + [" " * 35] + $starter.map{|x| x + " " * (35 - x.length)}
screen_convert(putter)
nx, ny = 1, 1