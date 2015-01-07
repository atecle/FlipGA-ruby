class Clause
    
    attr_reader :literals, :clause
    
        
    def initialize(x1, x2, x3)
       
        @literals = Array.new(3)
        @clause = Array.new(3)
 
        raise ArgumentError, 'First argument is not integer' unless x1.is_a? Integer 
        raise ArgumentError, 'Second argument is not an integer' unless x2.is_a? Integer
        raise ArgumentError, 'Third argument is not an integer' unless x3.is_a? Integer

        # indices in input file are 1 based
        @literals[0] = x1.abs - 1
        @literals[1] = x2.abs - 1
        @literals[2] = x3.abs - 1
    
        if x1 > 0
            @clause[0] = 1
        else
            @clause[0] = 0
        end
        
        if x2 > 0
            @clause[1] = 1
        else
            @clause[1] = 0
        end

        if x3 > 0
            @clause[2] = 1
        else
            @clause[2] = 0
        end
    end

end
