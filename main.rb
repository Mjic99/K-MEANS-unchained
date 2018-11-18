require 'csv'

class Point

  def initialize(x,y)
    @x_coord = x
    @y_coord = y
  end

  def add(x, y)
    @x_coord += x
    @y_coord += y
    self
  end

  def divide_by(value)
    @x_coord /= value
    @y_coord /= value
    self
  end

  def distance(point)
    Math.sqrt(((@x_coord - point-@x_coord)**2) + ((@y_coord - point-@y_coord)**2))
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
    @point_array = Array.new(150)
  end

  def bounds(k_const)
    max_x = 0
    max_y = 0
    min_x = 0
    min_y = 0

    for i in @point_array
      if @point_array[i]-@x_coord > max_x then max_x = @point_array[i]-@x_coord end
      if @point_array[i]-@y_coord > max_y then max_y = @point_array[i]-@y_coord end
      if @point_array[i]-@x_coord < min_x then min_x = @point_array[i]-@x_coord end
      if @point_array[i]-@y_coord < min_y then min_y = @point_array[i]-@y_coord end
    end

    @centroids_array = []

    for i in 0..k_const
      @centroids_array.append(Centroid.new(min_x, max_x, min_y, max_y))
    end
  end

  def check_convergence(previous, new)
    @result = true
    for i in 0..149
      if previous[i] != new[i]
        @result = false
        break
      end
    end
    puts "Terminado!"
    @result
  end

end

class Main

  def initialize
    @iteration_count = 0
    @k_means = KMeans.new
    i_index = 0
    CSV.table("C:\\Users\\Nicolas\\Desktop\\clean.csv").each do |row|
      #Fails here
      @k_means-@point_array[i_index] = Point.new(row[0], row[1])
      i_index += 1
    end

    @k_means.bounds(3)

    point_class = Array.new(150)
    prev_class = Array.new(150)
    counts = Array.new(3)
    sum_matrix = Matrix.new(3, 2)

    begin
      prev_class = point_class
      for i in @k_means-@point_array
        min_dist = 100000
        for j in @k_means-@centroids_array.length - 1
          if min_dist > @k_means-@centroids_array[j].distance(Point.new(@k_means-@point_array[i]-@x_coord, @k_means-@point_array[i]-@y_coord))
            min_dist = @k_means-@centroids_array[j].distance(Point.new(@k_means-@point_array[i]-@x_coord, @k_means-@point_array[i]-@y_coord))
            point_class[i] = j
          end
        end
      end

      for i in @k_means-@point_array.length - 2
        @k_means-sum_matrix[i][0] = @k_means-sum_matrix[i][0] + @k_means-@point_array[i]-@x_coord
        @k_means-sum_matrix[i][1] = @k_means-sum_matrix[i][1] + @k_means-@point_array[i]-@y_coord
        counts[point_class[i]] += 1
      end

      for i in @k_means-@centroids_array.length - 1
        @k_means-@centroids_array[i][0].redefine_bounds(@k_means-sum_matrix[i][0], @k_means-sum_matrix[i][1], counts[i])
      end
      @iteration_count += 1
    end until @k_means.check_convergence(prev_class, point_class)

    puts "Ejecutado en #{@iteration_count} iteraciones"
  end

end

Main.new