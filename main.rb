require 'date'

class Student
  attr_accessor :surname, :name, :date_of_birth

  @@students = []

  def initialize(surname, name, date_of_birth)
    @surname = surname
    @name = name
    date = Date.parse(date_of_birth)
    validate_date_of_birth(date)
    @date_of_birth = date
  end

  def validate_date_of_birth(date)
    raise ArgumentError, 'Date of birth must be in the past' if date > Date.today
  end

  def calculate_age
    today = Date.today
    age = today.year - @date_of_birth.year
    age -= 1 if today < @date_of_birth + age*365
    age
  end

  def ==(other)
    @surname == other.surname && @name == other.name && @date_of_birth == other.date_of_birth
  end

  def to_s
    "#{@name} #{@surname}, Date of Birth: #{@date_of_birth}, Age: #{calculate_age}"
  end

  def self.add_student(student)
    unless @@students.include?(student)
      @@students << student
    else
      raise ArgumentError, 'Duplicate student'
    end
  end

  def self.remove_student(student)
    @@students.delete(student)
  end

  def self.get_students_by_age(age)
    @@students.select { |student| student.calculate_age == age }
  end

  def self.get_students_by_name(name)
    @@students.select { |student| student.name == name }
  end

  def self.students
    @@students
  end

  def self.print_students
    self.students.each do |student|
      puts student
    end
  end

end


st1 = Student.new('Surname1', 'Name1', '2000-1-1')
st2 = Student.new('Surname2', 'Name2', '2002-2-2')
Student.add_student(st1)
Student.add_student(st2)

begin
  Student.new('Surname3', "Name3", "2025-1-1")
rescue ArgumentError => e
  puts "Error: #{e.message}"
end

begin
  st4 = Student.new('Surname2', 'Name2', '2002-2-2')
  Student.add_student(st4)
rescue ArgumentError => e
  puts "Error: #{e.message}"
end

students_named = Student.get_students_by_name("Name1")
puts "Student with name Name1"
puts students_named
puts

st5 = students_named.first
age = st5.calculate_age
puts "Age #{age}\n\r"

students_aged = Student.get_students_by_age(age)
puts "Student with age #{age}"
puts students_aged
puts

Student.remove_student(st2)


Student.print_students
