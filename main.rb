require 'csv'

class Point

  def initialize(x,y)
    @x_coord = x
    @y_coord = y
  end

  def get_x
    @x_coord
  end

  def get_y
    @y_coord
  end

  def distance(point)
    Math.sqrt(((@x_coord - point.get_x)**2) + ((@y_coord - point.get_y)**2))
  end

end

class Centroid < Point

  def initialize(min_x, max_x, min_y, max_y)
    @x_coord = Random.new.rand(min_x..max_x)
    @y_coord = Random.new.rand(min_y..max_y)
  end

  def redefine_bounds(x_sum, y_sum, total)
    @x_coord = x_sum / total
    @y_coord = y_sum / total
  end

end

class KMeans

  def initialize
    @point_array = []
    @centroids_array = []
  end

  def get_point_array
    @point_array
  end

  def get_centroids_array
    @centroids_array
  end

  def bounds(k_const)
    max_x = 0
    max_y = 0
    min_x = @point_array[0].get_x
    min_y = @point_array[0].get_y

    for i in @point_array
      if i.get_x > max_x then max_x = i.get_x end
      if i.get_y > max_y then max_y = i.get_y end
      if i.get_x < min_x then min_x = i.get_x end
      if i.get_y < min_y then min_y = i.get_y end
    end

    for i in 0...k_const
      @centroids_array.append(Centroid.new(min_x, max_x, min_y, max_y))
    end
  end

  def check_convergence(previous, new)
    result = true
    for i in 0...@point_array.length
      if previous[i] != new[i]
        result = false
        break
      end
    end
    if result
      puts "Terminado!"
    end
    result
  end

end

class Main

  def initialize
    @iteration_count = 0
    @k_means = KMeans.new
    CSV.table("C:\\Users\\Nicolas\\Desktop\\SW-PW.csv").each do |row|
      @k_means.get_point_array.append(Point.new(row[0], row[1]))
    end

    @k_means.bounds(3)

    point_class = []
    prev_class = []
    counts = [0, 0, 0]
    sum_matrix = [[0,0], [0,0], [0,0]]

    start = Time.now
    begin
      prev_class.replace(point_class)
      for i in 0...@k_means.get_point_array.length
        min_dist = 100000
        for j in 0...@k_means.get_centroids_array.length
          if min_dist > @k_means.get_centroids_array[j].distance(@k_means.get_point_array[i])
            min_dist = @k_means.get_centroids_array[j].distance(@k_means.get_point_array[i])
            point_class[i] = j
          end
        end
      end

      for i in 0...@k_means.get_point_array.length
        sum_matrix[point_class[i]][0] = sum_matrix[point_class[i]][0] + @k_means.get_point_array[i].get_x
        sum_matrix[point_class[i]][1] = sum_matrix[point_class[i]][1] + @k_means.get_point_array[i].get_y
        counts[point_class[i]] = counts[point_class[i]] + 1
      end

      for i in 0...@k_means.get_centroids_array.length
        if counts[i] == 0 then counts[i] = 1 end
        @k_means.get_centroids_array[i].redefine_bounds(sum_matrix[i][0], sum_matrix[i][1], counts[i])
      end
      @iteration_count += 1
    end until @k_means.check_convergence(prev_class, point_class)
    finish = Time.now

    puts "Ejecutado en #{@iteration_count} iteraciones en #{(finish - start) * 1000} ms"

    puts "Resultado:"
    for i in point_class
      puts i
    end

  end

end

Main.new