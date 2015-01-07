require 'bigdecimal'
load 'Individual.rb'

class Population
   

    attr_reader :expression, :next_gen, :selected, :crossover, :num_vars, :num_clauses, :fitness_sum, :num_flips
    attr_accessor :population 
    
    #Population is initially random. Constructor makes 10 random bit strings of length n, number of variables.
    #Bit strings correspond to an assignment of variables.
    def initialize(exp)
        
        @expression = exp
        @num_vars = @expression.num_vars
        @num_clauses = @expression.num_clauses
        @fitness_sum = 0
        @num_flips = 0
        @population = Array.new()
        @selected = Array.new()
        @crossover = Array.new()
        @next_gen = Array.new()
        for i in 0...10
        
           bString = " "
        
           for j in 0...@num_vars
                bit = rand(2)
                if bit == 1 then
                    bString<<"1"
                else
                    bString<<"0"
                end
            end
        
            @fitness = evaluateFitness bString
            @fitness_sum += @fitness
            indiv = Individual.new(bString, @fitness)
            @population.push(indiv)
         end
        @population.sort!.reverse!
        normalize! @population
        # elitism
        @next_gen[0] =  @population[0].dup
        @next_gen[1] =  @population[1].dup
        
        @ar = Array.new(@num_vars)
        for i in 0...@num_vars
            @ar[i] = i
        end
        shuffleArray! @ar
    end
    
    def select
        for i in 0...8
            r = rand()
            for j in 0...10
                if @population[j].accumulated_normalized_fitness > r then
                    @selected[i] =  @population[j].bitString
                    break
                end
            end
        end
    end

    def crossover
        for i in 0...8
            x = rand(8)
            y = rand(8)
            offspring = " "
            for j in 0...@num_vars
                r = rand(2)
                if r == 0 then
                    offspring << @selected[x][j]
                else
                    offspring << @selected[y][j]
                end
            end
         @crossover[i] =  offspring.strip!
        end
    end

    def mutation
        for i in 0...8            
            tempString = ""
            x = rand(11)
            if x == 10 then
                next                #indicates 90% probability of mutation
            end
            for j in 0...@num_vars
                y = rand(2)
                
                 if (y == 0 || (y == 1 && j == (@num_vars - 1))) then
                    tempString = @crossover[i]
                     f = "0"
                     if @crossover[i][j] == "0" then
                         f = "1"
                     end
                    tempString[j] = f
                 end
            end
        @crossover[i] = tempString
        end
    end

    def flipHeuristic
        new_fitness_sum = @next_gen[0].fitness + @next_gen[1].fitness
        k = 2
        for i in 0...8
            assignment = @crossover[i]
            assignment_flipped = flip assignment
            before = evaluateFitness assignment
            after = evaluateFitness assignment_flipped
            while (after - before > 0) 
                @crossover[i] = assignment_flipped
                assignment = @crossover[i]
                assignment_flipped = flip assignment
                before = evaluateFitness assignment
                after = evaluateFitness  assignment_flipped
            end
            
            @next_gen[k] = Individual.new(@crossover[i], before)
            k+=1
            new_fitness_sum+=before
        end
        
        @population = @next_gen
        @fitness_sum = new_fitness_sum
        @population.sort!.reverse!
        normalize! @population
        #elitism
        @next_gen[0] = @population[0]
        @next_gen[1] = @population[1]

    end

        def flip(bString)
            shuffleArray! @ar
            for i in 0...@num_vars
                temp = bString.dup
                f = "0"
                if temp[@ar[i]] == "0" then
                    f = "1"
                end
            
                temp[@ar[i]] = f
                before = evaluateFitness bString
                after = evaluateFitness temp
                if (after - before >= 0) then
                    bString = temp
                    @num_flips+=1
                end
            end
            return bString
        end
    
    def evaluateFitness(bString)
        fitness = 0
        
        for i in 0...@num_clauses
           # indices in candidate solution bString which we are substituting into clause
           i0 =  @expression.formula[i].literals[0]
           i1 =  @expression.formula[i].literals[1]
           i2 =  @expression.formula[i].literals[2]
            # converting into truth values 0 or 1
            l0 = bString[i0] == '1' ? 1 : 0
            l1 = bString[i1] == '1' ? 1 : 0
            l2 = bString[i2] == '1' ? 1 : 0

            # if e is 0, the index at i0/1/2 is negated
            e0 = @expression.formula[i].clause[0]
            e1 = @expression.formula[i].clause[1]
            e2 = @expression.formula[i].clause[2]
           
            e0 = (e0 == 0) ? l0^1 : l0
            e1 = (e1 == 0) ? l1^1 : l1
            e2 = (e2 == 0) ? l2^1 : l2
             
            if (e0 + e1 + e2 > 0) then
                fitness+=1
            end
        end    
    return fitness
    end

        def normalize!(population)
            
            for i in 0...population.length
                population[i].normalized_fitness = population[i].fitness.to_f.quo(@fitness_sum)
                 accum = 0.0
                for j in 0...i+1
                    accum+=population[j].normalized_fitness
                end
                population[i].accumulated_normalized_fitness = accum
            end
        end

    def shuffleArray!(ar)
        i = ar.length - 1
        while (i > 0)
            index = rand(i + 1)
            a = ar[index]
            ar[index] = ar[i]
            ar[i] = a
            i -= 1
        end
    end 
    private :shuffleArray!, :normalize!, :flip
end

