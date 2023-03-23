--Restore Company DB:
--1.Display all the employees Data.
select * from Employee

--2.Display the employee First name, last name, Salary and Department number.
select Fname, Lname, Salary, Dno from Employee

--3.Display all the projects names, locations and the department which is responsible about it.
select Pname, Plocation, Dnum from Project

--4.If you know that the company policy is to pay an annual commission for each employee with specific percent equals 10% of his/her annual salary .Display each employee full name and his annual commission in an ANNUAL COMM column (alias).
select Fname + ' ' + Lname as fullname , Salary * 12 * 0.1 as annual from Employee

--5.Display the employees Id, name who earns more than 1000 LE monthly.
select SSN , Fname from Employee where Salary > 1000 

--6.Display the employees Id, name who earns more than 10000 LE annually.
select SSN, Fname from Employee where salary * 12 > 10000

--7.Display the names and salaries of the female employees 
select Fname, Salary from Employee where Sex = 'F'

--8.Display each department id, name which managed by a manager with id equals 968574.
Select Dnum, Dname from Departments where MGRSSN = 968574

--9.Dispaly the ids, names and locations of  the pojects which controled with department 10.
Select Pname, Pnumber, Plocation from Project where Dnum = 10

--------------------------------------------------------------------------------------------

--1.Display the Department id, name and id and the name of its manager.
select Dnum, Dname, MGRSSN, Fname
from Employee e , Departments d
where e.SSN = d.MGRSSN

--2.Display the name of the departments and the name of the projects under its control.
select Dname, Pname 
from Departments d, Project P
where d.Dnum = p.Dnum

--3.Display the full data about all the dependence associated with the name of the employee they depend on him/her.
select d.*, Fname as employeeName
from Dependent d INNER JOIN Employee e
ON d.ESSN = e.SSN

--4.Display the Id, name and location of the projects in Cairo or Alex city.
Select Pname, Pnumber, Plocation 
from Project
where City = 'Cairo' or City = 'Alex'

--5.Display the Projects full data of the projects with a name starts with "a" letter.
select * from Project
where Pname like 'a%'

--6.display all the employees in department 30 whose salary from 1000 to 2000 LE monthly
select Fname as employeeNames 
from Employee e, Departments d
where e.Dno= d.Dnum and d.Dnum=30 and e.Salary between 1000 and 2000

--7.Retrieve the names of all employees in department 10 who works more than or equal10 hours per week on "AL Rabwah" project.
select Fname
from Employee, Works_for, Project
where Employee.SSN = Works_for.ESSn and Project.Pnumber = Works_for.Pno
and Dno = 10 and Works_for.Hours >= 10 and Project.Pname = 'AL Rabwah'

--8.Find the names of the employees who directly supervised with Kamel Mohamed.
select e.Fname as emp 
from Employee e, Employee s
where s.SSN = e.Superssn and s.Fname='Kamel' and s.Lname='Mohamed'

--9.Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.
select Fname, Pname
from Employee e, Works_for w, Project p
where e.SSN = w.ESSn and w.Pno = p.Pnumber
order by Pname

--10.For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate.
select Pnumber, Dname, Lname , Bdate
from Project p, Departments d, Employee e
where p.Dnum = d.Dnum  
and d.MGRSSN = e.SSN
and p.city='Cairo'

--11.Display All Data of the managers.
select e.*
from Employee e, Departments d
where e.SSN = d.MGRSSN

--12.Display All Employees data and the data of their dependents even if they have no dependents.
select *
from Employee left outer join Dependent
on Employee.SSN= Dependent.ESSN

--13.Insert your personal data to the employee table as a new employee in department number 30, SSN = 102672, Superssn = 112233, salary=3000.
Insert into Employee
values( 'Hadeer', 'Mohamed', 102672,8/7/1999, 'cairo', 'F', 3000, 112233, 30)

--14.Insert another employee with personal data your friend as new employee in department number 30, SSN = 102660, but don’t enter any value for salary or supervisor number to him.
Insert into Employee( Fname, Lname, SSN, Bdate, Address, Sex, Dno)
values( 'Maya', 'Elawady', 102660, 5/6/1999, 'Doki', 'F', 10)

--15.Upgrade your salary by 20 % of its last value.
update Employee
set Salary = Salary + (0.2*Salary)
where SSN= 102672

--------------------------------------------------------------------------------------------

--1.Display (Using Union Function)
--a.The name and the gender of the dependence that's gender is Female and depending on Female Employee.
--b. And the male dependence that depends on Male Employee.
select d.Dependent_name, d.Sex
from Dependent d, Employee e
where e.SSN = d.ESSN and d.Sex= 'F' and e.Sex='F'
union
select d.Dependent_name, d.Sex
from Dependent d, Employee e
where e.SSN=d.ESSN and d.Sex='M' and e.sex='M'

--2.For each project, list the project name and the total hours per week (for all employees) spent on that project.
select p.Pname [project Name] , sum(hours) as [Total hours per week]
from Project p, Works_for w
where p.Pnumber=w.Pno
group by p.Pname

--3.Display the data of the department which has the smallest employee ID over all employees' ID.
select d.*
from Employee e, Departments d
where e.Dno = d.Dnum and e.SSN = (select min(SSN) from Employee)

--4.For each department, retrieve the department name and the maximum, minimum and average salary of its employees.
select d.Dname [Department Name], max(salary) [Max Salary], min(salary) [Min Salary],
avg(salary) [Avg Salary]
from Departments d, Employee e
where d.Dnum = e.Dno
group by d.Dname

--5.List the full name of all managers who have no dependents.
select Fname+ ''+ Lname as FullName
from Employee e inner join Departments D 
on e.SSN=D.MGRSSN 
left join Dependent
on e.SSN= Dependent.ESSN 
where ESSN is null

select Fname+ ''+ Lname as FullName
from Employee e, Departments D
where e.SSN=D.MGRSSN and MGRSSN not in ( select ESSN from Dependent )

--6.For each department-- if its average salary is less than the average salary of all employees-- display its number, name and number of its employees.
select d.Dnum, d.Dname, count(e.SSN) [Count emps]
from Departments d, Employee e
where e.Dno=d.Dnum
group by Dnum, Dname
having avg(Salary) < (select avg(Salary) from Employee)

--7.Retrieve a list of employees names and the projects names they are working on ordered by department number and within each department, ordered alphabetically by last name, first name.
select Fname+' '+ Lname [Full Name] ,Pname
from Employee e, Works_for w, Project p
where e.SSN=w.ESSn and w.Pno=p.Pnumber
order by Dno,Fname,Lname

--8.Try to get the max 2 salaries using subquery.
select max(Salary) [Max salary] from Employee
union all
select max(Salary) from Employee 
where Salary not in (select max(Salary) from Employee)

--9.Get the full name of employees that is similar to any dependent name.
select Fname+' '+Lname [Full Name]
from Employee 
intersect
select Dependent_name
from Dependent

select Fname+' '+Lname [Full Name]
from Employee, Dependent
where Employee.SSN = Dependent.ESSN and Fname = Dependent_name

--10.Display the employee number and name if at least one of them have dependents (use exists keyword) self-study.
select SSN, Fname
from Employee where exists
(select e.SSN from Employee e, Dependent d  
where e.SSN=d.ESSN)

--11.In the department table insert new department called "DEPT IT" , with id 100, employee with SSN = 112233 as a manager for this department. The start date for this manager is '1-11-2006'.
insert into Departments
values('DEPT_IT', 100, 112233,11/1/2006)

--12.Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574)  moved to be the manager of the new department (id = 100), and they give you(your SSN =102672) her position (Dept. 20 manager).
--a.First try to update her record in the department table.
--b.Update your record to be department 20 manager.
--c.Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672).
update Departments set MGRSSN=968574 where Dnum=100
update Departments set MGRSSN= 102672 where Dnum= 20
update Employee set Superssn=102672 where SSN= 102660 

--13.Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344) so try to delete his data from your database in case you know that you will be temporarily in his position.
--Hint: (Check if Mr. Kamel has dependents, works as a department manager, supervises any employees or works in any projects and handle these cases).
delete Dependent where ESSN=223344
delete Works_for where ESSn=223344
update Employee set Superssn= 102672 where Superssn=223344
update Departments set MGRSSN=102672 where MGRSSN=223344
delete Employee where SSN=223344

--14.Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30%.
update Employee set Salary= (Salary*0.3) + Salary
where SSN in (
select Essn
from Works_for w, Project p
where w.Pno=p.Pnumber and p.Pname='Al Rabwah')

----------------------------------------------------------------------------------------------------

--Restore ITI and adventureworks2012 DBs to Server:
--Part(1): Use ITI DB
--1.Retrieve number of students who have a value in their age. 
select count(*) as NoOStudents
from Student
where St_Age is not null

--2.Get all instructors Names without repetition.
select distinct Ins_Name
from Instructor

--3.Display student with the following Format (use isNull function).
--Student ID	Student Full Name	Department name
select s.St_Id, 
isnull(s.St_Fname,' ')+' '+ isnull(s.St_Lname,' ') as FullName,
isnull(d.Dept_Name, 'No Data') as DepartmentName
from Student s, Department d
where s.Dept_Id=d.Dept_Id

--4.Display instructor Name and Department Name.
--Note: display all the instructors if they are attached to a department or not.
select i.Ins_Name, d.Dept_Name
from Instructor i left outer join Department d
on i.Dept_Id=d.Dept_Id

--5.Display student full name and the name of the course he is taking For only courses which have a grade.
select s.St_Fname+''+s.St_Lname [Full Name], c.Crs_Name [Course Name]
from Student s, Stud_Course sc, Course c
where s.St_Id=sc.St_Id and sc.Crs_Id=c.Crs_Id and sc.Grade is not null

--6.Display number of courses for each topic name.
select  t.Top_Name, count(c.Crs_Id) No
from Topic t, Course c
where t.Top_Id=c.Top_Id 
group by t.Top_Name

--7.Display max and min salary for instructors.
select max(Salary) as Max, min(Salary) as Min
from Instructor

--8.Display instructors who have salaries less than the average salary of all instructors.
select Ins_Name
from Instructor
where Salary < (select AVG(Salary) from Instructor)

--9.Display the Department name that contains the instructor who receives the minimum salary.
select d.Dept_Name
from Department d, Instructor i
where d.Dept_Id=i.Dept_Id and Salary = (select min(Salary) from Instructor)

--10.Select max two salaries in instructor table. 
select top(2) Salary
from Instructor
order by Salary DESC

--11.Select instructor name and his salary but if there is no salary display instructor bonus keyword. “use coalesce Function”.
select Ins_Name, coalesce(convert(varchar(20),Salary), 'Bonus') as Salary
from Instructor

--12.Select Average Salary for instructors.
select AVG(Salary) [AVG Salary For Instructors]
from Instructor

--13.Select Student first name and the data of his supervisor.
select s.St_Fname, sv.*
from Student s, Student sv
where sv.St_Id=s.St_super

--14.Write a query to select the highest two salaries in Each Department for instructors who have salaries. “using one of Ranking Functions”.
select Salary 
from (select Salary, ROW_NUMBER() over(partition by Dept_id order by Salary desc) as r
from Instructor) as t
where r<=2

--15.Write a query to select a random  student from each department.  “using one of Ranking Functions”.
select st_fname
from (select st_fname, ROW_NUMBER() over(partition by Dept_id order by newid()) as r
from Student) as t
where r=1

--Part(2): Use AdventureWorks DB.
--1.Display the SalesOrderID, ShipDate of the SalesOrderHeader table (Sales schema) to show SalesOrders that occurred within the period ‘7/28/2002’ and ‘7/29/2014’.
select SalesOrderID, ShipDate
from Sales.SalesOrderHeader
where OrderDate between '7/28/2002' and '7/29/2014' 

--2.Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only).
select ProductID,Name
from Production.Product
where StandardCost < 110

--3.Display ProductID, Name if its weight is unknown.
select ProductID,Name
from Production.Product
where Weight is null

--4.Display all Products with a Silver, Black, or Red Color.
select Name
from Production.Product
where Color= 'Black' or Color='Silver' or Color='Red'

--5.Display any Product with a Name starting with the letter B.
select Name
from Production.Product
where Name like 'b%'

--6.Run the following Query
/*UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3*/
--Then write a query that displays any Product description with underscore value in its description.
UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3

select Description
from Production.ProductDescription
where Description like '%[_]%'

--7.Calculate sum of TotalDue for each OrderDate in Sales.SalesOrderHeader table for the period between  '7/1/2001' and '7/31/2014'.
select SUM(TotalDue) as SUM , OrderDate
from Sales.SalesOrderHeader
where OrderDate between '7/1/2001' and '7/31/2014'
group by OrderDate

--8.Display the Employees HireDate (note no repeated values are allowed).
select distinct HireDate
from HumanResources.Employee

--9.Calculate the average of the unique ListPrices in the Product table.
select avg(distinct ListPrice) as AVG
from Production.Product

--10.Display the Product Name and its ListPrice within the values of 100 and 120 the list should has the following format "The [product name] is only! [List price]" (the list will be sorted according to its ListPrice value).
select concat('the ',name,' is only! ',listprice ) as plp
from Production.Product
where ListPrice in (100, 120)
order by ListPrice

--11 
--a)Transfer the rowguid ,Name, SalesPersonID, Demographics from Sales.Store table  in a newly created table named [store_Archive]
--Note: Check your database to see the new table and how many rows in it?
--b)Try the previous query but without transferring the data? 

select rowguid, Name, SalesPersonID, Demographics 
into store_Archive
from Sales.Store
--note: the creation ill be done without data.
select rowguid, Name, SalesPersonID, Demographics 
into store_Archive2
from Sales.Store
where 1=2

--12.Using union statement, retrieve the today’s date in different styles using convert or format funtion.
select convert(varchar(20),getdate())
union
select convert(varchar(50),getdate(),101)
union
select format(getdate(),'dd-MM-yyyy')
union
select format(getdate(),'dddd MMMM yyyy')
union
select format(getdate(),'hh tt')

--------------------------------------------------------------------------------------

/*
a.Create the following database using wizard Consists of 2 File Groups { SeconderyFG (has two data files) and ThirdFG (has two data files) } 

Database Name: SD
Location: (Default path)
Initial size for mdf: 25MB
File Group for mdf: Primary
File Growth for mdf: 10%
Max. File Size for mdf: 400	MB
Log File Name: SD-Log
Location for Log: (Default Path)
Initial Size for Log: 15MB
File Growth: 20%
Log File Max Size: 400 MB
*/

--1.Create the following tables with all the required information and load the required data as specified in each table using insert statements[at least two rows].
create table department
(
DeptNo varchar(3) primary key ,
DeptName varchar(20),
Location varchar(5)
)
insert into department values
('d1','Research','NY'),('d2','Accounting','DS'),('d3','Markiting','KW')

sp_addtype loc,'nchar(2)'
create default def1 as 'NY'
create rule rule1 as @r in ('NY','DS','KW')
sp_bindrule rule1, loc
sp_bindefault def1,loc

alter table department alter column Location loc

create table employee 
(
EmpNo int primary key,
EmpFname varchar(20) not null,
EmpLname varchar(20) not null,
DeptNo varchar(3),
Salary int ,
constraint c1 foreign key(DeptNo) references department(DeptNo),
constraint c2 unique(Salary),
)
create rule rule2 as @rr<6000
sp_bindrule rule2, 'employee.Salary'

--Testing Referential Integrity:
--1.Add new employee with EmpNo =11111 In the works_on table [what will happen]
insert into Works_on(EmpNo,ProjectNo)values(11111, 'p2') -- ERROR "conflicted with the FOREIGN KEY constraint"

--2.Change the employee number 10102  to 11111  in the works on table [what will happen].
update Works_on set EmpNo =11111 where EmpNo=10102  -- ERROR "conflicted with the FOREIGN KEY constraint"

--3.Modify the employee number 10102 in the employee table to 22222. [what will happen].
update employee set EmpNo=22222 where EmpNo=10102   -- ERROR "conflicted with the FOREIGN KEY constraint"

--4.Delete the employee with id 10102.
delete from employee where EmpNo=10102 -- ERROR "conflicted with the FOREIGN KEY constraint"
delete from Works_on where EmpNo=10102
delete from employee where EmpNo=10102

--Table modification
--1.Add TelephoneNumber column to the employee table[programmatically].
alter table employee add TelephoneNumber int
--2.drop this column[programmatically].
alter table employee drop column TelephoneNumber
--3.Bulid A diagram to show Relations between tables.
----------------------------------------------------------------------------
--2.Create the following schema and transfer the following tables to it. 
--a.Company Schema.
--i.Department table (Programmatically).
--ii.Project table (using wizard).
--b.Human Resource Schema.
--i.Employee table (Programmatically).
create schema Company
alter schema Company transfer department

create schema HumanResource
alter schema HumanResource transfer employee 
------------------------------------------------------------------------------
--3.Write query to display the constraints for the Employee table.
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME='employee'

--4.Create Synonym for table Employee as Emp and then run the following queries and describe the results.
create synonym Emp for HumanResource.employee
--a.Select * from Employee
Select * from employee -- error "No Output"
--b.Select * from [Human Resource].Employee
Select * from HumanResource.employee
--c.Select * from Emp
Select * from Emp
--d.Select * from [Human Resource].Emp
Select * from HumanResource.Emp -- error "No Output"

--5.Increase the budget of the project where the manager number is 10102 by 10%.
update Company.Project
set Budget+=(.1*Budget)
from Company.Project p inner join works_on w
on p.ProjectNo=w.ProjectNo
where EmpNo=10102 and Job='Manger'

--6.Change the name of the department for which the employee named James works.The new department name is Sales.
update Company.department
set DeptName='sales'
from Company.department d inner join HumanResource.employee e
on d.DeptNo=e.DeptNo
where EmpFname='James'

--7.Change the enter date for the projects for those employees who work in project p1 and belong to department ‘Sales’. The new date is 12.12.2007.
update Works_on
set enter_date='12/12/2007'
from Company.department d,HumanResource.employee e,Works_on w
where d.DeptNo=e.DeptNo and e.EmpNo=w.EmpNo and d.DeptName='sales' and ProjectNo='p1'

--8.Delete the information in the works_on table for all employees who work for the department located in KW.
delete from works_on
where EmpNo in 
(select EmpNo from HumanResource.employee e,Company.department d where d.DeptNo=e.DeptNo and d.Location='kw') 

--9 (wizard)Try to Create Login Named(ITIStud) who can access Only student and Course tablesfrom ITI DB then allow him to select and insert data into tables and deny Delete and update .(Use ITI DB)

-------------------------------------------------------------------------------------------------------------

--1 Create a scalar function that takes date and returns Month name of that date.
create function getNameOfMonth(@date date)
returns varchar(20)
begin
declare @nameofmonth varchar(20)
select @nameofmonth= (format(@date,'MMMM') )
return @nameofmonth
end
--calling
begin try
    select dbo.getNameOfMonth('3/5/2010') as month_name
end try
begin catch
select 'Wrong from 1:12 only in the month field' as [error_message]
end catch

--2 Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
create function get_values_between(@x int,@y int)
returns @t table (valuesBetween int)
          as
              begin
              declare @middle int = @x+1
              while  @middle<@y 
              begin
              insert into @t select @middle
              select @middle+=1
              end
              return
              end
--Calling
select * from dbo.get_values_between(11,15) 

--3 Create inline function that takes Student No and returns Department Name with Student full name.
create function stdinfo(@sid int)
returns table
	 as
	 return
	 (
	 select d.Dept_Name,S.St_Fname+' '+s.St_Lname as fullname
	 from Department d,Student s
	 where d.Dept_Id=s.Dept_Id and St_Id=@sid
	 )
--calling
select * from stdinfo(10)

--4 Create a scalar function that takes Student ID and returns a message to user 
--a.	If first name and Last name are null then display 'First name & last name are null'
--b.	If First name is null then display 'first name is null'
--c.	If Last name is null then display 'last name is null'
--d.	Else display 'First name & last name are not null'
create function user_messagee(@sid int)
returns varchar(30)
begin
declare @messagee varchar(50)
declare @firstname varchar(20)
declare @lastname varchar(20)
select @firstname=st_fname from Student where St_Id=@sid
select @lastname=St_Lname from Student where St_Id=@sid
if @firstname is null and @lastname is null
select @messagee= 'First name & last name are null'
if @firstname is null
select @messagee= 'First name is null'
if @lastname is null
select @messagee= 'last name is null'
else
select @messagee= 'First name & last name are not null'
return @messagee
end
--calling
select dbo.user_messagee(8)

--5 Create inline function that takes integer which represents manager ID and displays department name, Manager Name and hiring date 
create function managerdata (@mid int)
returns table
as
return
(
select ins_name,dept_name,manager_hiredate
from Instructor i,Department d
where i.Ins_Id=d.Dept_Manager and d.Dept_Manager=@mid
)
--calling
select * from managerdata(10)

--6 Create multi-statements table-valued function that takes a string
--If string='first name' returns student first name
--If string='last name' returns student last name 
--If string='full name' returns Full Name from student table 
create function studentName(@name varchar(20))
returns @t table
(
name varchar(30)
)
as 
begin
if @name='first name'
insert into @t
select ISNULL(st_fname,' ')from Student
else if @name='last name'
insert into @t
select ISNULL(St_Lname,' ')from Student
else if @name='full name'
insert into @t
select ISNULL(St_Fname+' '+St_Lname,' ')from Student
return
end
select * from studentName('full name')

--7 Write a query that returns the Student No and Student first name without the last char.
select st_id,LEFT(St_Fname,len(St_Fname)-1) as NewFirstName from Student

--8 Wirte query to delete all grades for the students Located in SD Department.
delete sc
from Stud_Course sc, Student S, Department D
where S.Dept_Id = D.Dept_Id and  SC.St_Id = S.St_Id and d.Dept_Name = 'SD'
--8
delete from Stud_Course
where Stud_Course.Crs_Id in (
	select sc.Crs_Id from Stud_Course sc, Student S, Department D
where S.Dept_Id = D.Dept_Id and  SC.St_Id = S.St_Id and d.Dept_Name = 'SD' )

--Bouns
--1 Give an example for hierarchyid Data type
--2 Create a batch that inserts 3000 rows in the student table(ITI database). 
--The values of the st_id column should be unique and between 3000 and 6000. 
--All values of the columns st_fname, st_lname, should be set to 'Jane', ' Smith' respectively.
--1
begin try
drop table SimpleDemo
end try
begin catch
print 'something went wrong with drop table for SimpleDemo'
end catch
go
 
create table SimpleDemo  
(Node hierarchyid not null,  
[Geographical Name] nvarchar(30) not null,  
[Geographical Type] nvarchar(9) NULL);
 
insert SimpleDemo  
values
-- second level data 
 ('/1/1/','China','Country')
,('/1/2/','Japan','Country')
,('/1/3/','South Korea','Country')
,('/2/1/','South Africa','Country')
,('/2/2/','Egypt','Country')
,('/3/1/','Australia','Country')
 
-- first level data
,('/1/','Asia','Continent')
,('/2/','Africa','Continent')
,('/3/','Oceania','Continent')
 
-- third level data
,('/1/1/1/','Beijing','City')
,('/1/2/1/','Tokyo','City')
,('/1/3/1/','Seoul','City')
,('/2/1/1/','Pretoria','City')
,('/2/2/1/','Cairo','City')
,('/3/1/1/','Canberra','City')
 
-- root level data
,('/', 'Earth', 'Planet')  
 
-- display without sort order returns rows in input order.
select 
 Node
,Node.ToString() AS [Node Text]
,Node.GetLevel() [Node Level]
,[Geographical Name]
,[Geographical Type]   
from SimpleDemo	

--2
declare @counter integer, @St_id integer
declare @St_Fname varchar(20), @St_Lname varchar(20)
set @counter = 3000
set @St_Fname = 'Jane'
set @St_Lname = 'Smith'
while @counter < 6001
begin
      insert into Student (St_id,St_Fname,St_Lname)
      values (@counter, @St_Fname, @St_Lname)
      set @counter = @counter+1
end

--------------------------------------------------------------------------------------------

--1.Create a view that displays student full name, course name if the student has a grade more than 50. 
create view displying_std_info(StudentFullName,CourseName)
as
	select s.St_Fname+''+s.St_Lname ,c.Crs_Name
	from student s,Stud_Course sc, Course c
	where s.St_Id=sc.St_Id and sc.Crs_Id=c.Crs_Id and sc.Grade>50

select * from displying_std_info

--2.Create an Encrypted view that displays manager names and the topics they teach. 
CREATE VIEW displying_manger_info(MangerName,TopicName)
WITH ENCRYPTION
as
SELECT i.Ins_Name,t.Top_Name
from Department d, Instructor i,Ins_Course ic,Course c, Topic t
where D.Dept_Manager=i.Ins_Id and i.Ins_Id=ic.Ins_Id and ic.Crs_Id=c.Crs_Id and c.Top_Id=t.Top_Id

select * from displying_manger_info

--3.Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department 
Alter VIEW displaying_Instructor_info(InstructorName,DepartmentName)
WITH ENCRYPTION
AS
SELECT i.Ins_Name, d.Dept_Name
FROM Instructor i, Department d
where i.Dept_Id=d.Dept_Id and d.Dept_Name in ('SD','Java')

select * from displaying_Instructor_info

--4.Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
--Note: Prevent the users to run the following query 
--Update V1 set st_address=’tanta’ Where st_address=’alex’;
create view v1 
as
select * from Student where St_Address in ('alex','cairo')
with check option

select * from v1
--try
update v1 
set St_Address='tanta'
where St_Address='alex'

--5.Create a view that will display the project name and the number of employees work on it. “Use SD database”
use SD
create view displying_project_info(ProjectName,NoOfEmps)
as
select cp.ProjectName, count(w.EmpNo)
from Company.Project cp, Works_on w
where cp.ProjectNo= w.ProjectNo
group by cp.ProjectName

select * from displying_project_info

--6.Create index on column (Hiredate) that allow u to cluster the data in table Department. What will happen? 
create clustered index hd_dept
on Department(manager_hiredate)
--we will get an error becuase already there's an clustered index on dept_id.

--7.Create index that allow u to enter unique ages in student table. What will happen? 
create unique index ages_std
on Student(st_age)
-- we will get an error becuase there are a duplicate values in ages col

--8.Using Merge statement between the following two tables [User ID, Transaction Amount]
create table daily_transaction(userId int, transAmount int)
insert into daily_transaction values(1,1000),(2,2000),(3,1000)

create table last_transaction(userId int, transAmount int)
insert into last_transaction values(1,4000),(4,2000),(2,10000)

merge into last_transaction as l
using daily_transaction as d
on l.userId=d.userId
when matched then
update  set l.transAmount=d.transAmount
when not matched then
insert values(d.userId,d.transAmount)
output $action;

--9.Create a cursor for Employee table that increases Employee salary by 10% if Salary <3000 and increases it by 20% if Salary >=3000. Use company DB
use Company_SD
declare emp_c cursor
for select Salary from Employee
for update 
declare @sal int
open emp_c
fetch emp_c into @sal
while @@FETCH_STATUS=0
	begin 
		if @sal>=3000
			update Employee
				set salary=@sal*1.20
			where current of emp_c
		else if @sal<3000
			update Employee
				set salary=@sal*1.10
			where current of emp_c
		fetch emp_c into @sal
	end
close emp_c
deallocate emp_c

--10.Display Department name with its manager name using cursor. Use ITI DB
use ITI
declare dept_mrg_c cursor
for select ins_name,dept_name
from Instructor i inner join Department d
on i.Ins_Id=d.Dept_Manager
for read only
declare @x varchar(50),@y varchar(50)
open dept_mrg_c
fetch dept_mrg_c into @x,@y
while @@FETCH_STATUS=0
     begin
        select @x,@y
        fetch dept_mrg_c into @x,@y
     end
close dept_mrg_c
deallocate dept_mrg_c

--11.Try to display all students first name in one cell separated by comma. Using Cursor 
declare std_names_c cursor
for select st_fname from Student
for read only
declare @all_names varchar(50),@name varchar(20)
open std_names_c
fetch std_names_c into @name
while @@FETCH_STATUS=0
begin
set @all_names=concat(@all_names,',',@name)
fetch std_names_c into @name
end
select @all_names
close std_names_c
deallocate std_names_c

--Part2
-- 1.Create view named  “v_clerk” that will display employee#,project#, the date of hiring of all the jobs of the type 'Clerk'.
use SD
create view v_clerk
as
select EmpNo,ProjectNo,Enter_Date
from Works_on 
where Job='clerk'

select * from v_clerk

--2.Create view named  “v_without_budget” that will display all the projects data without budget
create view v_without_budget
as
select *
from Company.Project
where Budget is null

select * from v_without_budget

--3.Create view named “v_count“ that will display the project name and the # of jobs in it.
create view v_count
as
select cp.ProjectName, COUNT(w.Job) as JobsNo
from Company.Project cp, Works_on w
where cp.ProjectNo=w.ProjectNo
group by cp.ProjectName

select * from v_count

--4.Create view named ” v_project_p2” that will display the emp#  for the project# ‘p2’.
--use the previously created view  “v_clerk”.
create view v_project_p2
as
select EmpNo from v_clerk
where ProjectNo='p2'

select * from v_project_p2

--5.Modifey the view named  “v_without_budget”  to display all DATA in project p1 and p2.
alter view v_without_budget
as
select * from Company.Project
where ProjectNo='p1' or ProjectNo='p2'

select * from v_without_budget

--6.Delete the views  “v_ clerk” and “v_count”.
drop view v_clerk
drop view v_count

--7.Create view that will display the emp# and emp lastname who works on dept# is ‘d2’.
alter view displying_emp_info(employeeName,EmployeeNo)
WITH ENCRYPTION
as
select he.EmpLname, he.EmpNo
from HumanResource.employee he
where he.DeptNo='d2' 

select * from displying_emp_info

--8 Display the employee lastname that contains letter “J”
--Use the previous view created in Q#7
select employeeName
from displying_emp_info
where employeeName like '%j%'

--9.Create view named “v_dept” that will display the department# and department name.
create view v_dept
as
select cd.DeptNo, cd.DeptName
from Company.department cd

--10.using the previous view try enter new department data where dept# is ’d4’ and dept name is ‘Development’
insert into v_dept(DeptNo,DeptName)
values('d4','development')

--11.Create view name “v_2006_check” that will display employee#, the project# where he works and the date of joining the project which must be from the first of January and the last of December 2006.
create view v_2006_check
as
select w.EmpNo, w.ProjectNo, w.Enter_Date
from Works_on w
where w.Enter_Date between '1/1/2006' and '12/31/2006'
with check option

select * from v_2006_check

---------------------------------------------------------------------------------------------------------------------

--1.Create a stored procedure without parameters to show the number of students per department name.[use ITI DB]
create Procedure getstdcount
as
select d.Dept_Name, count(s.St_Id) as NoOfStd
from Student s, Department d
where s.Dept_Id=d.Dept_Id
group by d.Dept_Name
--calling
getstdcount

--2.Create a stored procedure that will check for the # of employees in the project p1 
--if they are more than 3 print message to the user “'The number of employees in the project p1 is 3 or more'” 
--if they are less display a message to the user “'The following employees work for the project p1'” 
--in addition to the first name and last name of each one. [Company DB]
create Procedure check_no_of_emp
as
declare @NOE int
select @NOE=count(SSN) 
from Employee e, Works_for w
where e.SSN=w.ESSn and w.Pno=100
if (@NOE>=3)
    select 'The number of employees in the project p1 is 3 or more'
else
    select 'The following employees work for the project p1' as result, e.Fname,e.Lname
	from Employee e, Works_for w
	where e.SSN=w.ESSn and w.Pno=100
--calling
check_no_of_emp

--3.Create a stored procedure that will be used in case there is an old employee has left the project and a new one become instead of him. 
--The procedure should take 3 parameters (old Emp. number, new Emp. number and the project number) 
--and it will be used to update works_on table. [Company DB].
create proc empchange @oldempid int, @newempid int, @pno int
as
begin try
update Works_for
set ESSn=@newempid
where ESSn=@oldempid and Pno=@pno
end try
begin catch
      select 'Not allowed'as result
end catch
--calling
empchange 112233,123,101

--4.Add column budget in project table and insert any draft values in it then Create an Audit table with the following structure:
--ProjectNo 	UserName 	ModifiedDate 	Budget_Old 	Budget_New 
--   p2 	       Dbo 	     2008-01-31	      95000 	  200000 
--This table will be used to audit the update trials on the Budget column (Project table, Company DB).
--Example: If a user updated the budget column then the project number, user name that made that update, the date of the modification and the value of the old and the new budget will be inserted into the Audit table.
--Note: This process will take place only if the user updated the budget column.
ALTER TABLE project
ADD budget int;

create table update_info
(
ProjectNo varchar(20),
UserName varchar(20),
ModifiedDate date,
Budget_Old int,
Budget_New int
)
select * from update_info

alter trigger auditUpdateBudget
on project
for update
as  
   if update(budget)
   begin
        declare @pnum int, @old_budget int, @new_budget int
		select @pnum=Pnumber from inserted
		select @new_budget=budget from inserted
		select @old_budget=budget from deleted
	insert into update_info values(@pnum,suser_name(),getdate(),@old_budget,@new_budget)
   end
--testing
update Project set budget=7000 where Pnumber=600
select * from update_info

--5.Create a trigger to prevent anyone from inserting a new record in the Department table [ITI DB]
--“Print a message for user to tell him that he can’t insert a new record in that table”
create trigger preventInsert
on department
instead of insert
as
    select 'You cannot insert a new record in that table.'as Result
--testing
insert into Department
values(200,'test','desc','cairo',10,'10/10/2002')

--6.Create a trigger that prevents the insertion Process for Employee table in March [Company DB].
alter trigger preventInsertEmp
on employee
after insert 
as 
   if (format(getdate(),'MMMM') = 'March')
   begin
       select 'You cannot insert in March'
   end
   else
   begin
   delete from Employee where SSN=(select SSN from inserted)
   select * from inserted
   end
--Testing
insert into Employee
values('Hadeeer','Mooo',111262,'7-8-1999','egypt','f',50000,102660,10)

--7.Create a trigger on student table after insert to add Row in Student Audit table (Server User Name , Date, Note) where note will be “[username] Insert New Row with Key=[Key Value] in table [table name]”
--ServerUser Name	Date  Note 
create table student_audit
 (
 ServerUserName varchar(50),
 Datee date,
 Note varchar(50)
 )
alter trigger st_audit
on student
after insert 
as
declare @note int
select  @note =st_id from inserted
insert into student_audit
values(suser_name(),getdate(),@note)

--Testing		
insert into Student
values
(100,'hadeer','mohamed','cairo',23,10,1)
select * from student_audit

--8.Create a trigger on student table instead of delete to add Row in Student Audit table (Server User Name, Date, Note) where note will be“ try to delete Row with Key=[Key Value]”
alter trigger st_audit2
on student
instead of delete  
as
declare @note int
select  @note=st_id from deleted
insert into student_audit
values(suser_name(),getdate(),@note)

--Testing
delete from Student where St_Id=2
select * from student_audit

-------------------------------------------------------------------------------------
