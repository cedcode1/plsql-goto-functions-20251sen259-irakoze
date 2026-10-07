# C2 — Reflection

**Draft: review and personalize this after running the project.**
This text describes the design; it does not claim that execution or
screenshots have already been completed.

The shop payroll scenario connects the assignment tasks to one database.
Departments describe where employees work, while employee records hold
salary, hire date, and status. Keeping these facts in two related tables
allows the functions to use consistent data without repeating department
names in every employee record.

The GOTO examples show how execution can jump to a named label. In the
number classifier and salary review, the conditions choose a destination.
After a result is prepared, another jump reaches the shared display or
ending point. Each label must precede an executable statement, which is
why the final classifier label has a NULL statement.

The illegal example demonstrates a restriction: control cannot jump from
outside directly into an IF statement. Moving the label before the whole
IF statement gives a legal entry point. This also shows why labels must
be considered together with block boundaries.

The structured salary review is easier to follow than its GOTO version.
IF, ELSIF, and ELSE keep the alternatives together, and one display
statement prints the result. Both versions are intended to give the same
review for every employee. GOTO is useful to study control transfer, but
structured conditions make this review easier to maintain.

The stored functions separate reusable calculations from reports. Annual
salary and tax return numbers; the department lookup returns text. The
service function uses a reference date so examples can be repeated without
depending on the day they are run. Exception handling makes missing data
and invalid input explicit. A missing salary is not silently treated as zero.

Payroll validity is separate from calculation. A zero salary can be
multiplied by twelve, but it is rejected by the chosen payroll rule. Future
hires and inactive employees can remain in the database without being
eligible for payment at the report date. The assertion scripts check these
cases as well as tax boundaries and date boundaries.

Before submission, this reflection should be supplemented with actual
execution observations: what the illegal block reported, whether A2 and
A4 matched, and which test results were obtained. AI helped draft this
project, so its use is disclosed in the README Notes section. Understanding
and explaining the final code remains the student's responsibility.
