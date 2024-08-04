
use practiceDB;
select * from customers;
select * from products;
select * from employees;
select * from sales

-- [1]. Get the list of all customers who can be contacted either by phone or email. Show 'Can be contacted' as a column for each customer.
     --    If a customer cannot be contacted either by phone or email, show "Cannot be contacted"
select customerName, contactEmail, contactPhone, 
case
	when (contactEmail is not NULL or contactPhone is not NULL)  then "Can be contacted"
    else "Cannot be contacted"
end as contactStatus
from customers;


-- [2]. Modify the previous query to include the number of sales for each customer
select a.customername, b.numofsales, a.contactEmail, a.contactPhone, a.contactStatus
from 
(select customerName, contactEmail, contactPhone, 
case
	when (contactEmail is not NULL or contactPhone is not NULL) then "Can be contacted"
    else "Cannot be contacted"
end as contactStatus
from customers) a 
inner join (select c.customername, count(s.saleid) as numofsales
from customers c inner join sales s on c.customerid = s.customerid
group by (c.customername)) b on a.customername = b.customername
order by customername;


-- [3]. Return the list of customers who have a valid email format. Show "Valid email/invalid email" against each row. If email id does
	 --    does not exist, show "No email". Valid email format is "string@string.com"
select customername, contactEmail, 
case
	when contactEmail like '%@%.com' then 'Valid Email'
    when contactEmail is NUll then 'No Email'
    else 'Invalid Email'
end as emailStatus
from customers;
	
     
-- [4]. Return the list of customers who have a valid phone format. Show valid phone/invalid phone against each row. If phone id does not 
	 --    exist show no phone. Valid phone format is [0-9][0-9][0-9]-[1-9][0-9][0-9][0-9][0-9][0-9]. The area code cannot all be 0
select customerName, contactPhone,
case
	when contactPhone regexp '^[1-9]{3}-[1-9][0-9]{5}' then 'Valid Phone'
    when contactPhone is NULL then 'No Phone'
    else 'Invalid Phone'
end as phoneStatus
from customers;


-- [5]. Categorize the customers under three bins. Prime (sale amount > 2000) , Safe (sale amount betweeen 1000 and 2000) 
--    and Campaign (Sale amount < 1000). The list should contain Customerid, Customer Name, Sale amount and category 
select t.customerID, t.customerName, t.totalAmount, t.category
from
(select c.customerID, c.customerName, s.totalAmount, 
case
	when s.totalAmount > 2000 then "Prime"
    when s.totalAmount >= 1000 and s.totalAmount <= 2000 then "Safe"
    when s.totalAmount < 1000 then "Campaign"
    else "Uncategorized"
end as "category"
from customers c inner join sales s on c.customerID = s.customerID) t
order by category desc;


-- [6]. Prepare a result set showing the list of all the customers and the products purchased by them. The output should have customername, 
--    Productname, Saledate, Saleid. Order of columns have to be maintained. Order the result by Customername, Productname and Saledate
select customerName, productName, saledate, saleid
from
(select c.customerName, s.saleDate, s.saleID, s.productID
from customers c inner join sales s on c.customerID = s.customerID) t 
inner join products p on t.productID = p.productID
order by customerName, productName, saleDate;


-- [7]. In the previous query include the customers who have not made any purchase
select customerName, productName, saledate, saleid
from
(select c.customerName, s.saleDate, s.saleID, s.productID
from customers c left join sales s on c.customerID = s.customerID) t 
left join products p on t.productID = p.productID
order by customerName, productName, saleDate;


-- [8]. Prepare a result set showing the list of all the products and customers to which those have been sold. The output should have  
--    Productname, customername, Saledate, Saleid. Order of colums have to be maintained. 
--    Order the result by Productname, Cusotmername, and Saledate
select productName, customerName, saleDate, saleID
from
(select p.productName, s.saleDate, s.saleID, s.customerID
from products p inner join sales s on p.productID = s.productID) t 
inner join customers c on t.customerID = c.customerID
order by productName, customerName, saleDate;

-- select productName, customerName, saleDate, saleID
-- from
-- (select c.customerName, s.saleDate, s.saleID, s.productID
-- from customers c inner join sales s on c.customerID = s.customerID) t 
-- inner join products p on t.productID = p.productID
-- order by productName, customerName, saleDate;

-- [9]. In the previous query include the products that have not been sold any time
select productName, customerName, saleDate, saleID
from
(select p.productName, s.saleDate, s.saleID, s.customerID
from products p left join sales s on p.productID = s.productID) t 
left join customers c on t.customerID = c.customerID
order by productName, customerName, saleDate;


-- [10]. Get all customers who have made atleast one purchase using the concept "where exists"
select c.customerName
from customers c
where exists (select 1 from sales s where c.customerID = s.customerID); 

select distinct c.customerName
from customers c inner join sales s on c.customerID = s.customerID;


-- [11]. Get all customers who have made no purchases using the concept of "where exists"
select c.customerName
from customers c
where not exists (select 1 from sales s where c.customerID = s.customerID); 


-- [12]. Find Employees Who Earn More Than the Average Salary in Their Department
select t.departmentID, e.EmployeeName, e.Salary, round(t.avgSalary, 2) as avgSalary
from
(select departmentID, avg(salary) as avgSalary
from employees
group by departmentID) t inner join employees e on t.departmentID = e.departmentID
where Salary > avgSalary;

select e.departmentID, e.employeeName, e.salary from employees e
where e.salary > (select avg(salary) as avgSalary
			from employees d
            where d.departmentid = e.departmentid
			group by departmentID); 

-- [13]. Find Customers Who Have Placed More Orders Than the Average Number of Orders
select t.customerName, t.customerID, t.quantity from
(select c.customerName, c.customerID, s.quantity from customers c inner join sales s on c.customerID = s.customerID) t
where t.quantity > (select avg(quantity) from sales as avgQuantity);


-- [14]. Find Customers Who Have Purchased More Than the Average Amount Spent by All Customers
select t.customerName, t.customerID, t.totalAmount from
(select c.customerName, c.customerID, s.totalAmount from customers c left join sales s on c.customerID = s.customerID) t
where t.totalAmount > (select avg(totalAmount) from sales as totalAmount);


-- [15]. List Products That Have Generated More Sales (Amount) Than the Average Sales of All Products
select q.productName, q.productID, q.totalAmount
from (select p.productName, p.productID, s.totalAmount from products p left join sales s on p.productID = s.productID) q
where q.totalAmount > (select avg(t.totalAmount) from
(select p.productName, p.productID, s.totalAmount from products p left join sales s on p.productID = s.productID) t);

-- How do I add the avg sales in every row?


-- [16]. Identify the Most Recent Sale for Each Product
select p.productName, max(s.saleDate) as most_recent_sale
from products p inner join sales s on p.productId = s.productID
group by p.productName;

-- headphones: 2023-09-10
-- laptop: 2023-01-06
-- smartphone: 2023-12-10
-- tablet: 2023-11-10


-- [17]. Find Products That Have Been Sold to More Than 2 Unique Customers
select p.productName, count(distinct c.customerName) as customerCount
from
(select s.customerID, p.productID, p.productName, s.saleDate from products p inner join sales s on p.productId = s.productID
order by p.productName ASC) p
inner join 
(select customerID, customerName from customers) c
on p.customerID = c.customerID
group by p.productName
having count(distinct c.customerName) > 2;

-- [18]. Find Products That Have Never Been Sold
select p.productID, p.productName, s.saleDate from products p left join sales s on p.productId = s.productID
where s.saleDate is NULL
order by p.productName ASC;

-- [19]. List Customers Who Have Not Purchased the Most Expensive Product
select distinct c.customerName from
(select s.customerID, p.price, p.productName, s.saleDate from products p inner join sales s on p.productId = s.productID) a
inner join
(select customerID, customerName from customers) c
on a.customerId = c.customerID
where a.price < (select price from products
order by price DESC
limit 1);

-- [20]. Find Employees Who Earn More Than Their Manager

-- select e.employeeID, m.managerID, e.employee_salary, m.manager_salary, e.employeeName 
-- from
-- (select employeeID, managerID, employeeName, salary as manager_salary from employees
-- where managerID is NULL) m inner join (select employeeID, employeeName, salary as employee_salary, departmentID from employees) e
-- on m.managerID = e.employeeID;

select e.employee, e.employee_salary from
(select e.employeeName as Employee, m.EmployeeName as Manager, e.salary as employee_salary, m.salary as manager_salary
from employees e inner join employees m on e.managerID = m.employeeID) e
where e.employee_salary > e.manager_salary;


SELECT e.EmployeeName as Employee, e.ManagerID, m.EmployeeName as Manager, m.Salary
FROM Employees e INNER JOIN Employees m ON e.ManagerID = m.EmployeeID;

 