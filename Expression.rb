
load 'Clause.rb'

class Expression
    
    attr_accessor :formula, :num_vars, :num_clauses

    def initialize(file)
        raise ArgumentError, 'Argument is not a file' unless File.file?(file)
        raise ArgumentError, 'File does not exist' unless File.exist?(file)
        @num_vars = 0
        @num_clauses = 0
        @formula = Array.[]
        @formula =  getFormula(file)
    end

    private 
        def getFormula(file)
            File.open(file, 'r') do |f1| 
                while line = f1.gets
                    if line.include? "%"
                        break
                    end
                 
                    if line[0] ==  "c"
                        next
                    end

                    tokens = line.split(' ')
                    if tokens.first == 'p' && tokens.count == 4
                         @num_clauses = Integer(tokens[3])
                        @num_vars = Integer(tokens[2])
                        next 
                    end            
                    clause = getClause tokens
                    formula.push(clause) 
                end 
            end
            return formula
        end

    private
        def getClause(tokens)
            
            x1 = Integer(tokens[0])
            x2 = Integer( tokens[1])
            x3 = Integer(tokens[2])
            clause = Clause.new(x1, x2, x3)
            return clause
        end
end        
