Use practiceDB;
Select * from Employees;

--  [1]. Display the max and second max salary from employee table. Display employeename, department and hire date as well.
SELECT Salary, EmployeeName, DepartmentID, HireDate
FROM Employees
ORDER BY Salary DESC
LIMIT 2;

-- [2]. List the employees who do not have a manager
SELECT EmployeeName, ManagerID
FROM Employees
WHERE ManagerID is null;

-- [3]. List the employees who were hired on 1st of January and show the result in increasing order of Salary
SELECT EmployeeName, HireDate
FROM Employees
WHERE DATE(HireDate) = '2023-01-01'
ORDER BY Salary ASC;

SELECT EmployeeName, HireDate
FROM Employees
WHERE DAY(HireDate) = 1 AND MONTH(HireDate) = 1
ORDER BY Salary ASC;

-- [4]. Get the Employees with all their managers. The result should show employee name, manager name and salary 
SELECT e.EmployeeName as Employee, m.EmployeeName as Manager, e.Salary
FROM Employees e INNER JOIN Employees m ON e.ManagerID = m.EmployeeID;

SELECT e.EmployeeName as Employee, e.ManagerID, m.EmployeeName as Manager, e.Salary
FROM Employees e INNER JOIN Employees m ON e.ManagerID = m.EmployeeID;

-- [5]. Get the list of Employees where name does not have an "a" in it
SELECT EmployeeName
FROM Employees
WHERE EmployeeName NOT LIKE '%a%';

-- [6]. Get the list of Employees whose name have more than 1 "a" in it
SELECT * 
FROM Employees
WHERE EmployeeName LIKE '%a%a%';

	-- Got this logic from StackOverflow
	SELECT * 
    FROM Employees
    WHERE (Length(EmployeeName) - Length(Replace(EmployeeName, 'a', ''))) > 1;

-- [7]. Get the list of all employees whose name has more than 3 alphabets
SELECT *
FROM Employees
WHERE Length(EmployeeName) > 3;

-- [8]. Get the list of all employees whose salary is greater than average salary
SELECT e.EmployeeName, e.Salary 
FROM Employees e
WHERE ((SELECT AVG(m.Salary) FROM Employees m) < e.Salary);

-- [9]. Get the list of department with maximum number of employees
SELECT DepartmentID, Count(EmployeeName) as EmployeeCount
FROM Employees
GROUP BY DepartmentID
ORDER BY Count(EmployeeName) DESC
LIMIT 1;

-- [10]. Get the list of all employees whose name starts with a vowel
SELECT EmployeeName
FROM Employees
WHERE EmployeeName LIKE 'a%' OR 
EmployeeName LIKE 'e%' OR
EmployeeName LIKE 'i%' OR 
EmployeeName LIKE '%o' OR 
EmployeeName LIKE '%u';

SELECT * 
FROM (SELECT EmployeeName, substring(EmployeeName, 1, 1) AS FirstChar FROM Employees) e
WHERE e.FirstChar in ('i', 'a', 'e', 'o', 'u');

-- [11]. Get the list of all employess whose name ends with e
SELECT * 
FROM Employees
WHERE EmployeeName like '%e';

-- [12]. Get the list of top 5 highest paid employees
Select EmployeeName, Salary
From Employees 
Order by Salary DESC
Limit 5;

-- [13]. Count the number of employees hired in each quarter. If no employees are hired in a quarter, 
  -- show the employee count as zero for that quarter
Select q.quarter, case 
when e.EmployeeCount is null then 0
else e.EmployeeCount end as EmployeeCount
from
(Select quarter(HireDate) as QuarterCol, count(EmployeeName) as EmployeeCount
From Employees
Group by QuarterCol) e right join 
(select 1 as quarter
union
select 2 as quarter
union
select 3 as quarter
union
select 4 as quarter) q on e.QuarterCol = q.quarter;

-- [14]. Find the quarter in which no employees have been hired
select q.quarter, e.EmployeeCount from
(select quarter(HireDate) as QuarterCol, count(EmployeeName) as EmployeeCount
from Employees
group by quarter(HireDate)) e
right join 
(select 1 as quarter
union
select 2 as quarter
union
select 3 as quarter
union
select 4 as quarter) q on e.QuarterCol = q.quarter
where e.EmployeeCount is null;

-- [15]. Find the total salary paid for each department. Also show the max, min and average salary for each department in the same result set
select DepartmentID, round(sum(Salary), 0) as SalarySum, round(avg(salary), 0) as AvgSalary, round(min(salary), 0) as MinSalary, round(max(salary),0) as MaxSalary
from Employees
group by DepartmentID;

-- [16]. Find all employees who have been hired in the same month. Months having only 1 employee should not show up in the list
select e.Hire_month, m.EmployeeName from
(select EmployeeName, month(HireDate) as Hire_month from Employees) m
inner join
(select month(HireDate) as Hire_month, count(EmployeeName) as Employee_count
from Employees
group by month(HireDate)
having count(EmployeeName) > 1) e 
on e.Hire_month = m.Hire_month;

-- [17]. List out the employees (name, id) with hire year, month, day and quarter. 
select EmployeeName, EmployeeID, year(HireDate) as Year_hired, month(HireDate) as Month_hired, 
quarter(HireDate) as Quarter_hired, day(HireDate) as Day_hired
from Employees;

-- [18]. Show the number of days each employee has served in the company. Also show the number of weeks and months.
select EmployeeName, abs(datediff(HireDate, current_date())) as Days_worked,
timestampdiff(month, HireDate, current_date()) as Months_worked, 
timestampdiff(year, HireDate, current_date()) as Years_worked
from Employees;

-- [19]. Show the exact number of months each employee has worked for. Month should be shown in decimal if emolyee has not worked for the full month
select EmployeeName,
round((timestampdiff(month, HireDate, current_date()) + abs(day(HireDate) - day(current_date()))/30), 2) as Months_worked
from Employees;

-- [20]. Show the hiredates of employees whose name include an 'a' and 'k'. Include them only if they were hired before July. 
select EmployeeName, HireDate
from Employees
where EmployeeName like '%a%k%'
and month(HireDate) < 7;

-- [LEVEL 2]. Show the number of days between each hirings
