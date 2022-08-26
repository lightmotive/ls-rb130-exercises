# Group 1
my_proc = proc { |thing| puts "This is a #{thing}." }
puts my_proc
# => #<Proc:0x0000ffffa2537210 02_exploring_procs_lambdas_blocks.rb:2>
# - We can see the `Proc` object associates with the line of code where it was defined.
puts my_proc.class
# => Proc
# - A `Proc` object's class is `Proc`
my_proc.call
# => This is a .
# - The `thing` parameter doesn't need a matching argument; simple `Proc`
#   objects like this have lenient arity like blocks.
my_proc.call('cat')
# => This is a cat.

# Group 2
my_lambda = ->(thing) { puts "This is a #{thing}." }
my_second_lambda = ->(thing) { puts "This is a #{thing}." }
puts my_lambda
# => #<Proc:0x0000ffff88a4d9a8 02_exploring_procs_lambdas_blocks.rb:17 (lambda)>
# - Ruby helpfully lets us know when a `Proc` object is a Lambda.
puts my_second_lambda
# => #<Proc:0x0000ffff88a4d980 02_exploring_procs_lambdas_blocks.rb:18 (lambda)>
puts my_lambda.class
# => Proc
# - Lambdas are a specialized `Proc` object (though not a sub-class
#   specialization as some argue it should have been when it was introduced).
#   We know one can determine whether a `Proc` is a lambda using **Proc#lambda?**.
my_lambda.call('dog')
# => This is a dog.
my_lambda.call
# => 02_exploring_procs_lambdas_blocks.rb:17:in `block in <main>': wrong number of arguments (given 0, expected 1) (ArgumentError)
#            from 02_exploring_procs_lambdas_blocks.rb:23:in `<main>'
# - That output demonstrates how Lambdas, like methods, have strict arity.
my_third_lambda = Lambda.new { |thing| puts "This is a #{thing}." }
# => 02_exploring_procs_lambdas_blocks.rb:35:in `<main>': uninitialized constant Lambda (NameError)
# - That call fails because `Lambda` is not a class in Ruby's core library.
#   As explained above, a Lambda is a `Proc` class that behaves differently
#   in terms of arity and explicit `return` statement behavior.

# Group 3
def block_method_1(_animal)
  yield
end

block_method_1('seal') { |seal| puts "This is a #{seal}." }
# - That demonstrates the lenient arity of blocks. `block_method_1` doesn't
#   pass any arguments to a block that defined one parameter; it assigns
#   the parameter value to `nil` when there's no corresponding argument.
block_method_1('seal')
# => 02_exploring_procs_lambdas_blocks.rb:43:in `block_method_1': no block given (yield) (LocalJumpError)
#            from 02_exploring_procs_lambdas_blocks.rb:47:in `<main>'
# - `yield`ing when no block was passed will raise a `LocalJumpError` exception.
#   If one wants to define a method that optionally `yield`s, they can write
#   something like `yield if block_given?` (Kernel#block_given?).

# Group 4
def block_method_2(animal)
  yield(animal)
end

block_method_2('turtle') { |turtle| puts "This is a #{turtle}." }
# => This is a turtle.
# - Our method is now "complete."
block_method_2('turtle') do |turtle, seal|
  puts "This is a #{turtle} and a #{seal}."
end
# => This is a turtle and a .
# - The method `yield`s only one argument, but the block defines two parameters.
#   Due to a block's lenient arity, the block simply initializes and assigns
#   `nil` to any parameters that don't have a corresponding argument.
block_method_2('turtle') { puts "This is a #{animal}." }
# => 02_exploring_procs_lambdas_blocks.rb:66:in `block in <main>': undefined
#    local variable or method `animal' for main:Object (NameError)
# - That demonstrates how blocks don't have access to the yielding method's
#   local variable scope. Blocks only have access to the scope where they were
#   defined.
