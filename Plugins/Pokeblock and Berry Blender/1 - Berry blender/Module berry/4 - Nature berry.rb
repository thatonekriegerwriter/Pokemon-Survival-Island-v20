module BerryBlender
  
  module_function
  
  # Return array after multiply
  # Some pokemon like nor dislike any poffins
  # Hardy: 0; Docile: 6; Bashful: 18; Quirky: 24; Serious: 12
  def nature(nature, arr)
    # Like
    case nature
    when  1,  2,  3,  4 then arr[0] *= 1.1
    when 15, 16, 17, 19 then arr[1] *= 1.1
    when 10, 11, 13, 14 then arr[2] *= 1.1
    when 20, 21, 22, 23 then arr[3] *= 1.1
    when  5,  7,  8,  9 then arr[4] *= 1.1
    end
    # Dislike
    case nature
    when 20, 15, 10,  5 then arr[0] *= 0.9
    when 23, 13,  8,  3 then arr[1] *= 0.9
    when 22, 17,  7,  2 then arr[2] *= 0.9
    when 19, 14,  9,  4 then arr[3] *= 0.9
    when 21, 16, 11,  1 then arr[4] *= 0.9
    end
    return arr.map { |i| i.round }
  end
  
end