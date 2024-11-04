require "minitest/autorun"
require "minitest/reporters"
require_relative '../app/student'

Minitest::Reporters.use! [
  Minitest::Reporters::HtmlReporter.new(
    reports_dir: 'test/reports/unit',
    report_filename: 'test_results.html',
    clean: true,
    add_timestamp: true
  )
]

class StudentTest < Minitest::Test
  def setup
    @student1 = Student.new("Doe", "John", "2000-01-15")
    @student2 = Student.new("Smith", "Jane", "1995-05-23")
    @student3 = Student.new("Doe", "John", "2000-01-15")
  end

  def test_initialize
    assert_instance_of Student, @student1
    assert_equal "Doe", @student1.surname
    assert_equal "John", @student1.name
    assert_equal Date.new(2000, 1, 15), @student1.date_of_birth
  end

  def test_invalid_date_of_birth
    assert_raises(ArgumentError) { Student.new("Doe", "John", Date.today.next_day.to_s) }
  end

  def test_calculate_age
    student = Student.new("FirstName", "LastName", (Date.today - 4*365).to_s)
    assert_equal 4, student.calculate_age
  end

  def test_equality
    assert @student1 == @student3
    refute @student1 == @student2
  end

  def test_to_s
    expected_string = "John Doe, Date of Birth: 2000-01-15, Age: #{@student1.calculate_age}"
    assert_equal expected_string, @student1.to_s
  end

  def test_add_student
    Student.add_student(@student1)
    assert_includes Student.students, @student1

    assert_raises(ArgumentError) { Student.add_student(@student3) }
  end

  def test_remove_student
    Student.add_student(@student1)
    Student.remove_student(@student1)
    refute_includes Student.students, @student1
  end

  def test_get_students_by_age
    Student.add_student(@student1)
    Student.add_student(@student2)
    age = @student1.calculate_age
    assert_includes Student.get_students_by_age(age), @student1
    refute_includes Student.get_students_by_age(age), @student2
  end

  def test_get_students_by_name
    Student.add_student(@student1)
    Student.add_student(@student2)
    assert_includes Student.get_students_by_name("John"), @student1
    refute_includes Student.get_students_by_name("John"), @student2
  end

  def teardown
    Student.class_variable_set(:@@students, [])
  end
end
