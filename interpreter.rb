require 'pry'

class Interpreter
  def is_actually_an_integer?(obj)
    Float(obj) != nil rescue false
  end

  def is_a_list?(code)
    code.start_with?("'")
  end

  def find_last_item_in_depth(position, token)
    (token[position..-2].rindex{|x| x == ")"}) + 1
  end

  def convert_to_expression(token)
    arr = []
    token.each_with_index do |bit, index|
      if bit == "("
        last_item = find_last_item_in_depth(index, token)
        inner_arr = []
        binding.pry
        arr.push(convert_to_expression(token[(index+1)..last_item]))
      else
        arr.push(bit)
        binding.pry
      end
    end
    arr
  end

  def tokenize(string)
    string.gsub('(', ' ( ').gsub(')', ' ) ').split()
  end

  def parse(filename)
    File.open(filename, 'r') do |file|  
      # First, it looks to see if there is a quote before the list.
      contents = file.read

      if is_a_list?(contents)
        # If there is a quote, just dump the list.
        puts contents
      else
        # If there isn't a quote, look at the first element and see if it 
        # has a function definition.
        token = tokenize(contents)
        convert_to_expression(token)
      end
    end
  end

end

Interpreter.new.parse("code_to_interpret.lisp")