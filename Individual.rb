class Individual
    include Comparable
    attr_accessor :bitString, :fitness, :normalized_fitness, :accumulated_normalized_fitness

    def initialize(bString, fit)
        @bitString = bString
        @fitness = fit
        @normalized_fitness = 0
        @accumulated_normalized_fitness = 0
    end
    
    def <=>(another_individual)
        self.fitness <=> another_individual.fitness
    end
end
