#!/usr/bin/ruby

load 'Expression.rb'
load 'Population.rb'

raise ArgumentError, 'Enter path to file' unless ARGV.length == 1

raise ArgumentError, 'File  #{ARGV[0]}  not found' unless File.exists?(ARGV[0])

not_solved = 0

file = ARGV[0]
accepted_format = [".cnf"]

if (File.file?(file) && accepted_format.include?(File.extname(file))) then
    puts "Evaluating #{file}"
    exp = Expression.new(file)
    pop = Population.new(exp)

    count = 0

    while (pop.evaluateFitness(pop.population[0].bitString) != exp.num_clauses) 
        puts "#{pop.evaluateFitness(pop.population[0].bitString)}"
        pop.select
        pop.crossover
        pop.mutation
        pop.flipHeuristic

        count+=1
        if (count == 20) then # stop after 20  generations
            not_solved+= 1
            count = 0
            break
        end
    end

    if (count == 20) then
        puts "Not solved"
    else
        puts "Satisfying assignment #{pop.population[0].bitString}"
        puts "Fitness: #{pop.evaluateFitness(pop.population[0].bitString)}"
    end
end
puts "#{not_solved} not solved"

