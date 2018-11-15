MAX_TRIES = 100

class Point
  def initialize(x,y)
    @x, @y = x, y
  end

  def getX
    @x
  end

  def getY
    @y
  end

  def distance(point)
    Math.sqrt(((@x - point-@x)**2) + ((@y - point-@y)**2))
  end
end

class KMeans

  def initialize(data, cluster)

  end

  def stopKMeans(old, new, count)
    if count > MAX_TRIES
      true
    end
    old == new
  end
end
