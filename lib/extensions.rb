class Array
  def count
    k = Hash.new(0)
    self.each{|x| k[x] += 1 }
    k
  end #count
end #array


class Float
  #round off to the nearest decimal places
  def roundf(places)
    sprintf("%#{self.to_s.length}.#{places}f", self).to_f
  end
end

