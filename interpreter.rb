require 'pry'

class Interpreter
  NUM_FUNCTIONS = ["+", "*", "-", "/", "rem", "abs", "max", "min"]

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
    last_item = nil
    token.each_with_index do |bit, index|
      if (last_item && index <= last_item) || (bit == ")")
        next
      elsif bit == "("
        last_item = find_last_item_in_depth(index, token)
        arr.push(convert_to_expression(token[(index+1)..last_item]))
      else
        if is_actually_an_integer?(bit)
          arr.push(bit.to_i)
        else
          arr.push(bit)
        end
      end
    end
    arr
  end

  def drop_outer_layer(array)
    array[0]
  end

  def tokenize(string)
    string.gsub('(', ' ( ').gsub(')', ' ) ').split()
  end

  def typify(arr)
    arr.map! do |bit|
      temp_hash = {}
      temp_hash["value"] = bit
      if bit.respond_to?('each')
        typify(bit)
        temp_hash["type"] = "array"
      elsif bit.is_a? Integer
        temp_hash["type"] = "integer"
      elsif bit.is_a? String
        temp_hash["type"] = "string"
      elsif NUM_FUNCTIONS.include?(bit)
        temp_hash["type"] = "numeric functions"
      else
        temp_hash["type"] = "unknown"
      end
      binding.pry
      temp_hash
    end
    arr
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
        arrayed_token = drop_outer_layer(convert_to_expression(token))
        p typify(arrayed_token)
      end
    end
  end

end

Interpreter.new.parse("code_to_interpret.lisp")