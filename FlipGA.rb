#!/usr/bin/ruby

load 'Expression.rb'
load 'Population.rb'

raise ArgumentError, 'Enter path to folder containing cnf files' unless ARGV.length == 1

raise ArgumentError, 'Folder #{ARGV[0]}  not found' unless Dir.exists?(ARGV[0])

not_solved = 0

cnffiles = File.join(ARGV[0], "*.cnf")
list_of_files = Dir.glob(cnffiles)
for i in 0...list_of_files.length
    if (File.file?(list_of_files[i]) && list_of_files[i][0].casecmp("u")) then
        puts "Evaluating #{list_of_files[i]}"
        exp = Expression.new(list_of_files[i])
         pop = Population.new(exp)
 
        count = 0

        while (pop.evaluateFitness(pop.population[0].bitString) != exp.num_clauses) 
             pop.select
            pop.crossover
            pop.mutation
            pop.flipHeuristic
        
            count+=1
            if (count == 500) then # stop after 500 generations
                not_solved+= 1
                count = 0
                break
            end
        end
        
        if (count == 500) then
            puts "Not solved"
        else
            puts "Satisfying assignment #{pop.population[0].bitString}"
            puts "Fitness: #{pop.evaluateFitness(pop.population[0].bitString)}"
        end
    end
    end    
    puts "#{not_solved} not solved"

