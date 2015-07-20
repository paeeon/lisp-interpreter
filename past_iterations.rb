# 1. Looks at a character
# 2. Determine whether to create a new level of depth (if char == "("), 
#    close the current level of depth (if char == ")"), or continue adding 
#    to the current level of depth (neither). 
# 3. If we create a new level of depth, add a new object to arr[position] 
#    that is basically another array ( [] ). 
# 4. If we close the current level of depth, increment position. 
# 5. If we continue adding to the current level of depth, add the char to 
#    arr[position] via string concatenation (i guess << might work?)
# 6. Afterwards, we make an extra check to see if the char is 
#    actually an integer (check if to_i changes it to 0 I guess? or I can #    check if there are no alphabetical chars and symbol chars), and if 
#    it is, convert it to an integer via to_i. 

# 1. arr = []
# 2. arr[position] = arr[0] = []
# 3. arr[0] = [].push

#  def array_split(contents)
#    @position = 0
#    @arr = []
#    @depth = 0
#    binding.pry
#    contents.kind_of?(Array) ? contents : contents.scan(/(\w+|\S)/) do |bit|
#      bit = bit[0]
#      if bit == "("
#        binding.pry
#        @depth += 1
#        if @inner_array_position
#          @inner_array_position += 1
#        else
#          # @inner_array_position is usually 0 
#          @inner_array_position = 0
#        end
#        create_new_level_of_depth
#      elsif bit == ")"
#        # Close level of depth
#        binding.pry
#        @depth -= 1
#        @position += 1
#      else
#        binding.pry
#        if @depth >= 1
#          @arr[@position]
#        elsif @arr[@position].kind_of?(Array)
#          @arr[@position].push(bit)
#          @inner_array_position += 1
#        elsif @arr[@position] == nil
#          @arr.push(bit)
#        end
#      end
#      @arr
#    end
#  end

#  def array_split(contents)
#    arr = []
#    depth = 0
#    contents.scan(/(\w+|\S)/) do |bit|
#      bit = bit[0]
#      if bit == "("
#        depth += 1 if hsh.has_key?(0)
#        hsh[depth] = []
#      elsif bit == ")"
#        depth -= 1
#      else
#        hsh[depth] << bit
#      end
#      binding.pry
#    end
#  end

require 'pry'

class Interpreter
  def is_actually_an_integer?(obj)
    Float(obj) != nil rescue false
  end

  def is_a_list?(code)
    code.start_with?("'")
  end

  def handle_inner_array(token, idx)
    binding.pry
    inner_arr = []
    position_of_next_level_change = (token[(idx+1)...-1].index{|x| x == "(" || x == ")" }) + idx
    token[(idx+1)..position_of_next_level_change].each do |x|
      inner_arr << x
    end
    binding.pry
    if token[(position_of_next_level_change + 1)] == "("
      inner_arr << handle_inner_array(token, position_of_next_level_change + 1)
      
      binding.pry
      inner_arr
    else #if ")"
      inner_arr
    end
  end

  def convert_to_expression(token, idx=nil)
    @arr = []
    @depth = 0
    token.each_with_index do |bit, index|
      if index == 0
        next
      elsif bit == "("
        binding.pry
        @depth += 1
        @arr.push(handle_inner_array(token, index)) #returns an array
        index = @new_index
      elsif bit == ")"
        @arr[depth]
        @depth -= 1
      else
        binding.pry
        @arr.push(bit)
      end
      binding.pry
    end
    @arr
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