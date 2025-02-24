module GameData
  class Diseases
    attr_reader :id

    DATA = {}
    DATA_FILENAME = "diseases.dat"
    PBS_BASE_FILENAME = "diseases"

    SCHEMA = {
      "Name" => [:name,        "s"],
      "Cause" => [:cause, "q"],
      "Symptoms" => [:symptoms, "q"],
      "Cure" => [:cure, "q"],
      "CureItem" => [:cureitem, "e", :Item],
      "Flags"         => [:flags,       "*s"]
    }

    extend ClassMethodsSymbols
    include InstanceMethods
  

    def initialize(hash)
      @id               = hash[:id]
      @name             = hash[:name]        || "Unnamed"
      @cause             = hash[:cause] || "???"
      @symptoms          = hash[:symptoms] || "???"
      @cure             = hash[:cure] || "???"
      @cureitem          = hash[:cureitem] || :NO
      @flags            = hash[:flags]       || []
    end
	

    def name
      return @name
    end

    def cause
      return @cause
    end

    def symptoms
      return @symptoms
    end

    def cure
      return @cure
    end

    def item
      return @cureitem.to_sym
    end

    def has_flag?(flag)
      return @flags.any? { |f| f.downcase == flag.downcase }
    end
end
end

class Disease
  attr_accessor :disease
  attr_accessor :length
  attr_accessor :severity


  def initialize(disease,length,severity)
   @disease = disease
   @length = length
   @severity = severity
  end

   def id
     return @disease.id
   end

   def name
     return @disease.name
   end

    def cause
      return @disease.cause
    end

    def symptoms
      return @disease.symptoms
    end

    def cure
      return @disease.cure
    end

    def item
      return @disease.cureitem.to_sym
    end

    def has_flag?(flag)
      return @disease.flags.any? { |f| f.downcase == flag.downcase }
    end

end

