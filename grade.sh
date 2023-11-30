

# Define the classpath
CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

# Clean up previous grading data
rm -rf student-submission
rm -rf grading-area

# Create a fresh grading area
mkdir grading-area

# Clone the student's submission
git clone $1 student-submission
echo 'Finished cloning'

if [ ! -f "student-submission/ListExamples.java" ]; then 
    echo "file not found."
    exit 1
fi

# Move the student's code to the grading area
cp student-submission/* grading-area/
cp TestListExamples.java grading-area/
cp -r lib grading-area/


# Navigate to the grading area
cd grading-area || { echo "Failed to navigate to grading area."; exit 1; }

# Compile the student's code and the test file
javac -cp "$CPATH" *.java || { echo "Compilation failed"; exit 1; }
java -cp "$CPATH" org.junit.runner.JUnitCore TestListExamples > test_results.txt


# Analyze test results and provide feedback
if grep -q -i "OK" test_results.txt; then
    echo "All passed"
elif grep -q -i "Failures:" test_results.txt; then
    echo "Some tests failed"
elif grep -q -i "Errors:" test_results.txt; then
    echo "There were errors when running the tests."
else
    echo "There was a problem running the tests. Check the test file and your code for issues."
fi

exit 0
