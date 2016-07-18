# --------------------------------------------------------
# variable scope: understanding where a variable "lives"
# --------------------------------------------------------
#
# in Ruby there are:
#   - 4 kinds of variable scope:
#
#     - global ($db, $connection, $file)
#     - class (@@total, @@poolsize)
#     - instance (@age, @name) ((including class_instance variables!))
#     - local (counter, element, result)
#
#   - and 1 constant type (MAX_SIZE, Student, Enumerable)

# when you declare a variable you use the first character to indicate it's scope
# as per the examples above.

# knowing when a variable is in (or out) of scope is critical to understanding program flow

# you're suffering from which-scope-itis if you're asking youself questions like these:
# - why doesn't my method see this variable declared before it? should it be an instance variable?
# - does my block know about the variables declared before the block?
# - how do i get the instance variable out of that class?
# - why does this variable always come back as nil?

# while you're learning about this you can use the Object#defined? method to discover the scope of a variable
# but since we're running in <main> here, an instance of Object, you can just call the instance method.
# if the line above was confusing, try printing out self.class at the top of your ruby programs or in IRB

a = 10
p defined? a  #=> 'local-variable'

def print
  p $b
end

puts "&&&&&&&&&&&"
print

$b = 15


p defined? $b  #=> 'global-variable'

puts "--------------------------------------------------------"
puts "--------------------------------------------------------"

# --------------------------------------------------------
# local variables
# --------------------------------------------------------

# local variables start with a lowercase letter or an underscore
_counter = 0

# they are available to the current scope
#   so if you're not inside a method, just right at the top level of a Ruby file ...
until _counter > 3
  puts _counter += 1
end

#   or if you are *already* inside a method, local variables get stuck in there
def say_hello
  me = "Chris P. Bacon"
  puts "hello from #{me}"
end

say_hello

# uncomment the next line to notice that you can't get at the variable 'me' out here
# puts me #!!!=> undefined local variable or method `me' for main:Object (NameError)

puts "--------------------------------------------------------"
puts "--------------------------------------------------------"

# --------------------------------------------------------
# global variables
# --------------------------------------------------------

# global variables start with a dollar sign ($) because they're so boujie
$look_at_me_evreebady = 100

p $look_at_me_evreebady

# the reason people don't like using global variables is easy to understand if you appreciate
# the problems they cause.  imagine a big program, like more than 10,000 lines long, and a few
# hundred global variables floating around all over the place, because that's what they do.  since
# the global variables are available everywhere, they can also be changed from anywhere.  imagine
# how hard it would be to track down every place in your 10,000 lines of code that *might* be changing
# your global variable.  they basically make troubleshooting more complicated.

# in general, anything that's hard to reason about or remember, and anything surprising, is bad for programming
# so these variables can be read and written-to from anywhere without warning.  that's hard to reason about and often confusing.

puts "--------------------------------------------------------"
puts "--------------------------------------------------------"

# --------------------------------------------------------
# interlude ...
# --------------------------------------------------------
# constants (and classes and modules)
# --------------------------------------------------------

# constants start with a capital letter and they're available everywhere, 
# like global variables
FILENAME = 'data.txt'

# but the Ruby intepreter warns you if you try to change them.  that's helpful.
# uncomment the next line to see the warnings
# FILENAME = 'other_data.csv'
  #=> warning: already initialized constant FILENAME
  #=> warning: previous definition of FILENAME was here

# -----------

# surprise, surprise, classes and modules also start with capital letters
# that's because they're constants too!
class Student; end
module Teachable; end

# constants defined in the main scope like FILENAME above are available everywhere
class Student
  DEFAULT_EMAIL = 'student@devbootcamp.com'
  FILENAME = 'HEY'

  def self.hey
    p FILENAME
    p ::FILENAME
  end
end

# but constants defined inside of a module or class are locked in there
# uncomment the next line to see the error
# p DEFAULT_EMAIL
  #!!! uninitialized constant DEFAULT_EMAIL (NameError)

# but we can get at them by appropriated scoping their name like this
puts Student::DEFAULT_EMAIL
puts FILENAME

# --------------------------------------------------------

# modules are used in Ruby to solve 2 problems:
# - organizing behavior of things in the system
# - organizing names of things in the system

# modules are used to organize methods into logical groups that can be "mixed-in" to a class
#   and this is why modules are sometimes called mixins by Rubyists


module Teachable
  def learn!
    "ok, got it, thanks."
  end

  def forget!
    "what were we talking about again?"
  end

  def rejoice!
    "i've never felt so capable and energized!"
  end
end

# note that this class is different from all Student classes declared in the DBC module above
class Student
  include Teachable
end

brighton_early = Student.new
puts brighton_early.learn!  #=> ok, got it, thanks.
puts brighton_early.rejoice!  #=> i've never felt so capable and energized!

# ----------------------

# modules are used to create what are called "namespaces" for classes
#   which means you can have similarly named classes that play nicely together
#   without overriting each other

module SanFrancisco
  class Student
    def play
      "let's go for a hike!"
    end
  end
end

module Chicago
  class Student
    def play
      "let's go for a walk along the lake!"
    end
  end
end

module NewYork
  class Student
    def play
      "let's go for some Brazilian jazz!"
    end
  end
end

shambawesome = SanFrancisco::Student.new
sam = Chicago::Student.new
sunny = NewYork::Student.new

puts shambawesome.play  #=> let's go for a hike!
puts sam.play  #=> let's go for a walk along the lake!
puts sunny.play  #=> let's go for some Brazilian jazz!

# what if we were keeping track of multiple schools in Kaplan?

puts "--------------------------------------------------------"
puts "--------------------------------------------------------"

# --------------------------------------------------------
# instance variables
# --------------------------------------------------------

# instance variables are stored within the instance of a class
# and basically float around anywhere between the words "class" ... and ... "end"
# so you can use them across methods inside the same class
class Pupil
  # Constructor function
  attr_accessor :name

  def initialize(n)
    @name = n
  end

  def say_hello
    "hi, my name is #{@name}"
  end

  # def name
  #   @name
  # end

  # def name=(name)
  #   @name = name
  # end
end

pupil1 = Pupil_A.new('Dee Bugger')
pupil2 = Pupil_A.new('Seymour Code')

puts pupil1.say_hello #=> hi, my name is Dee Bugger
puts pupil2.say_hello #=> hi, my name is Seymour Code

# if you want to get at the instance variables outside of the class 
# then you have to expose them
class Pupil_B
  def get_name
    @name
  end
end

# puts pupil1.get_name #=> Dee Bugger
# puts pupil2.get_name #=> Seymour Code

# but that move is so common among programmers that Ruby has some built-in 
# helpers for it
class PupilC
  attr_reader :name

  # attr_reader does nothing more than generate the method that is commented out
  # below this line
  # def name
  #   @name  # notice that the instance variable is returned by the method
  # end
end

# puts pupil1.name #=> Dee Bugger
# puts pupil2.name #=> Seymour Code

# attr_reader has 2 friends: attr_writer and attr_accessor
class You
  attr_reader :name  # readers are for things the world needs but won't 
  # change in instances of the class
  attr_writer :cohort # writers are for things the world will change in 
  # instances of the class
  attr_accessor :paired_with # accessors are for things that may be read and 
  # written over the life of the class

  # the line ... [attr_reader :name] ... generates this method:
  # def name
  #   @name                 # notice that the instance variable is returned by 
                            # the method
  # end

  # the line ... [attr_writer :cohort] ... generates this method:
  # def cohort=(cohort)
  #   @cohort = cohort        # notice that the instance variable is assigned by
                              # the method
  # end

  # the line ... [attr_accessor :paired_with] ... generates these methods:
  # def paired_with
  #   @paired_with            # notice that the instance variable is returned by 
                              # the method
  # end
  #
  # def paired_with=(pair)
  #   @paired_with = pair     # notice that the instance variable is assigned by 
  #                           # the method
  # end
end

# but you can't get access to the instance variables inside a class from 
# outside the class
p @name  #=> nil (since it's undefined in this scope)

# and if you want two classes to share data they have to communicate through 
# their interface (methods)

class A
  attr_reader :x
  def initialize
    @x = "hello from [class #{self.class.name}]"
  end
end

class B
  def investigate_class_A
    a = A.new
    puts a.x   # this line only works because [A] exposes a reader on [x]
  end
end

class Inject
  def initialize(klass)
    @klass = klass
  end

  def investigate_class
    klass = @klass.new
    puts klass.x   # this line only works because [A] exposes a reader on [x]
  end
end

b = B.new
b.investigate_class_A #=> "hello from [class A]"

i1 = Inject.new(A)
i2 = Inject.new(B)
i1.investigate_class #=> "hello from [class A]"

# -----------------------
# here's another example:

class Suspect
  attr_reader :alibi
  def initialize
    @alibi = "i am not a #{self.class.name.downcase}!"
  end

end

class PrivateEye
  def investigate_suspect
    mr_green = Suspect.new
    puts mr_green.alibi   # this line only works because suspect exposes a reader on @alibi
  end

end

sherlock = PrivateEye.new
sherlock.investigate_suspect  # => "i am not a suspect!"

puts "--------------------------------------------------------"
puts "--------------------------------------------------------"

# --------------------------------------------------------
# class variables and classes 2 ways of living
# --------------------------------------------------------

# class variables are data stored with the class:

class Bike

  attr_reader :year, :color, :brand

  @@bikes = []

  def initialize args={}
    @year = args.fetch(:year, 2016)
    @color = args.fetch(:color, 'undefined')
    @brand = args.fetch(:brand, 'Sebas Bikes')

    # We can move this to the private interface
    store_bikes
    # @@bikes << self
  end

  # self in the context of the instance
  def print_self
    p self
  end

  # self in the context of the class
  def self.print_self
    self
  end

  def self.bikes
    @@bikes
  end

  def Bike.method_name
    
  end

  class << self
    def new_merhod_1
      
    end

    def new_merhod_2
      
    end
  end

  private
  def store_bikes
    @@bikes << self
  end

end


# --------------------------------------------------------
# class instance variables
# --------------------------------------------------------

# say what?!

# this section coulda-shoulda-woulda been included in the section on instance variables
# but it's easier to explain in terms of that and the section on class variables above.

# here's a quick recap:
# - OOP is about organizing your code so that the names of things, the data they hold  (encapsulated
#   variables) and their behavior (methods on their interface), all conspire towards a model of the problem
#   you're trying to solve or whatever system you're trying to mimic.  that's basically it.
# - tools of expression in OOP include:
#   - [classes] are templates that define a logical grouping of data and behavior
#   - [objects] or [instances] are things made from those templates that model one or parts in the system being modeled
#   - [variables] or [attributes] or [properties] are data attached to classes or objects
#     - [class variables] are data attached to classes
#     - [instance variables] are data attached to objects
#   - [methods] or [behavior] or [messages] are named chunks of code attached to classes or objects
#     - [class methods] are behaviors attached to classes
#     - [instance methods] are behaviors attached to objects

# if all the above is clear enough then:
#     - [class instance variables] are like [class variables] in that they are data attached to classes
#       - but class instance variables are not writable throughout the inheritance hierarchy


# --------------------------------------------------------
# resources
# --------------------------------------------------------

# Ruby variables in general
# http://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Variables_and_Constants

# what is Top-Level
# http://banisterfiend.wordpress.com/2010/11/23/what-is-the-ruby-top-level/

# class instance variables
# http://www.railstips.org/blog/archives/2006/11/18/class-and-instance-variables-in-ruby/