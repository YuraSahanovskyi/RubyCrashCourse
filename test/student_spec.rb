# test/student_spec.rb
require 'minitest/autorun'
require 'minitest/reporters'
require_relative '../app/student'

Minitest::Reporters.use! [
  Minitest::Reporters::SpecReporter.new,
  Minitest::Reporters::HtmlReporter.new(
    reports_dir: 'test/reports/spec',
    report_filename: 'spec_results.html',
    clean: true,
    add_timestamp: true
  )
]

describe Student do
  before do
    @student1 = Student.new("Doe", "John", "2000-01-15")
    @student2 = Student.new("Smith", "Jane", "1995-05-23")
    @student3 = Student.new("Doe", "John", "2000-01-15")
  end

  describe 'initialize' do
    it 'creates a new student with given attributes' do
      _(@student1).must_be_instance_of Student
      _(@student1.surname).must_equal "Doe"
      _(@student1.name).must_equal "John"
      _(@student1.date_of_birth).must_equal Date.new(2000, 1, 15)
    end

    it 'raises an error if date of birth is in the future' do
      _(proc { Student.new("Doe", "John", Date.today.next_day.to_s) }).must_raise ArgumentError
    end
  end

  describe 'calculate_age' do
    it 'calculates the correct age' do
      student = Student.new("FirstName", "LastName", (Date.today - 4*365).to_s)
      _(student.calculate_age).must_equal 4
    end
  end

  describe 'equality' do
    it 'returns true for students with the same attributes' do
      _(@student1).must_equal @student3
    end

    it 'returns false for students with different attributes' do
      _(@student1).wont_equal @student2
    end
  end

  describe 'to_s' do
    it 'returns the correct string representation' do
      expected_string = "John Doe, Date of Birth: 2000-01-15, Age: #{@student1.calculate_age}"
      _(@student1.to_s).must_equal expected_string
    end
  end

  describe '::add_student' do
    it 'adds a student to the list of students' do
      Student.add_student(@student1)
      _(Student.students).must_include @student1
    end

    it 'raises an error when adding a duplicate student' do
      Student.add_student(@student1)
      _(proc { Student.add_student(@student3) }).must_raise ArgumentError
    end
  end

  describe '::remove_student' do
    it 'removes a student from the list of students' do
      Student.add_student(@student1)
      Student.remove_student(@student1)
      _(Student.students).wont_include @student1
    end
  end

  describe '::get_students_by_age' do
    it 'returns students with the specified age' do
      Student.add_student(@student1)
      Student.add_student(@student2)
      age = @student1.calculate_age
      _(Student.get_students_by_age(age)).must_include @student1
      _(Student.get_students_by_age(age)).wont_include @student2
    end
  end

  describe '::get_students_by_name' do
    it 'returns students with the specified name' do
      Student.add_student(@student1)
      Student.add_student(@student2)
      _(Student.get_students_by_name("John")).must_include @student1
      _(Student.get_students_by_name("John")).wont_include @student2
    end
  end

  after do
    Student.class_variable_set(:@@students, [])
  end
end
