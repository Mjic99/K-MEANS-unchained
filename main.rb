MAX_TRIES = 100

class Point

  def initialize(x,y)
    @x_coord = x
    @y_coord = y
  end

  def add(point)
    @x_coord += point-@x_coord
    @y_coord += point-@y_coord
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

  @@coord_array = Array.new(2) { Array.new(150) }

  def initialize(min_x, max_x, min_y, max_y)
    @centroid_array = Array.new(3) { Array.new(2) }
    for i in 0..2
      @centroid_array[i,0] = Random.new.rand(min_x..max_x)
      @centroid_array[i,0] = Random.new.rand(min_y..max_y)
    end
  end

  def bounds
    @max_x = 0
    @min_y = 0
    @min_x = @@coord_array[0, 0]
    @min_y = @@coord_array[0, 1]
    for i in 0..148
      if @@coord_array[i, 0] > @max_x then @max_x = @@coord_array[i, 0] end
      if @@coord_array[i, 1] > @max_y then @max_y = @@coord_array[i, 1] end
      if @@coord_array[i, 0] < @min_x then @min_x = @@coord_array[i, 0] end
      if @@coord_array[i, 1] < @min_y then @min_y = @@coord_array[i, 1] end
    end
  end

  def check_convergence
    @equal = true
    for i in 0...149
      if
    end
  end

end

class KMeans

  def initialize(data_array = [], cluster_array = [])
    @data_array = data_array
    @cluster_array = cluster_array
  end

  def calculate(constant)
    for i in 0..constant
      @random = Point.new(Random.new.rand, Random.new.rand)
      @cluster_array.append(i)
    end

    @lesser_distance_array = []

    for i in 0..@data_array.length

      @point_array = []

      for j in 0..@cluster_array.length
        @euclidean = "xd"
      end

    end

  end

  def insert(data)
    @data_array.append(data)
  end

  def stop(old, new, count)
    if count > MAX_TRIES
      true
    end
    old == new
  end

end

class Main

  def initialize()
    file_obj = File.new("C:\\Users\\Nicolas\\Desktop\clean.csv", "r")
    while (line = file_obj.gets)
      puts(line)
    end
    file_obj.close
  end

end