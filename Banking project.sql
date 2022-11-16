-- A.	Retail Banking Case Study
-- 1. Create DataBase BANK and Write SQL query to create above schema with constraints
create database BANK;

create table Branch_mstr (
Branch_no int primary key,
Name char(50) not null );

create  table Employee (
Emp_no int primary key,
Branch_no int,
Fname char(20),
Mname char(20),
Lname char(20),
Dept char(20),
Designation char(20),
Manager_no int not null,
Foreign key (Branch_no) references Branch_mstr(Branch_no));

create table Customer (
custid int primary key,
fname char(30),
mname char(30),
lname char(30),
occupation char(10),
DOB date );

create table Account (
acnumber int primary key,
custid int not null,
bid int not null,
curbal int,
atype char(10),
opnDT date,
astatus char(10),
foreign key (custid) references customer(custid),
foreign key (bid) references Branch_mstr(Branch_no));


-- 2. Inserting Records into created tables
insert into branch_mstr values 
(1,'Delhi'),
(2,'Mumbai');

insert into customer values
(1,'Ramesh','Chandra','Sharma','Service','1976-12-06'),
(2 ,'Avinash','Sunder','Minha','Business','1974-10-16');

insert into Account values
(1,1,1,10000,'Saving','2012-12-15','Active'),
(2,2,2,5000,'Saving','2012-06-12','Active');
select * from account;

insert into employee values
(1,1,'Mark','Steve','Lara','Account','Accountant',2),
(2,2,'Bella','James','Ronald','Loan','Manager',1);

-- 3.	Select unique occupation from customer table
select distinct occupation from customer;

-- 4.	Sort accounts according to current balance 
select * from account order by curbal asc;

-- 5.	Find the Date of Birth of customer name ‘Ramesh’
select DOB from customer where fname like '%Ramesh%';

-- 6.	Add column city to branch table 
alter table branch_mstr add column City char(20);

-- 7.	Update the mname and lname of employee ‘Bella’ and set to ‘Karan’, ‘Singh’ 

update employee set mname = 'Karan', lname='Singh' where fname = 'Bella';
-- 8.	Select accounts opened between '2012-07-01' AND '2013-01-01'

select * from account where opnDT between '2012-07-01' and '2013-01-01';

-- 9.	List the names of customers having ‘a’ as the second letter in their names 

select * from customer where fname like '_a%';

-- 10.	Find the lowest balance from customer and account table

select acnumber, a.custid,concat(fname,' ',mname,' ',lname) Name, min(curbal) Lowest_Balance from account a join customer c
on a.custid=c.custid ;

-- 11.	Give the count of customer for each occupation

select occupation, count(custid) from customer group by occupation;

-- 12.	Write a query to find the name (first_name, last_name) of the employees who are managers.
select concat(fname,' ',lname) name from employee e1 where Emp_no in (select Manager_no from employee e2 );

-- 13.	List name of all employees whose name ends with a
select * from employee where lname like '%a';

-- 14.	Select the details of the employee who work either for department ‘loan’ or ‘credit’
select * from employee where Dept like 'loan' or Dept like 'Credit';

-- 15.	Write a query to display the customer number, customer firstname, account number for the  
-- customers who are born after 15th of any month.
select c.custid, fname, acnumber from customer c join account a on c.custid=a.custid where day(DOB)>15;

-- 16.	Write a query to display the customer’s number, customer’s firstname, branch id and balance amount for people using JOIN.
select c.custid, fname, bid as Branch_id , curbal as Balance_amount from customer c join account a on c.custid=a.custid ;

-- 17.	Create a virtual table to store the customers who are having the accounts in the same city as they live
alter table customer add column City char(10);
update customer set city='Mumbai' where city is null;
update branch_mstr set city = 'Delhi' where branch_no = 1;
update branch_mstr set city = 'Mumbai' where branch_no = 2;

create view City as
select * from customer where city in (select distinct city from branch_mstr);

-- 18.	A. Create a transaction table with following details 
-- TID – transaction ID – Primary key with autoincrement 
-- Custid – customer id (reference from customer table
-- account no – acoount number (references account table)
-- bid – Branch id – references branch table
-- amount – amount in numbers
-- type – type of transaction (Withdraw or deposit)
-- DOT -  date of transaction
Create table Transaction( 
TID int primary key auto_increment,
Custid int,
account_no int,
bid int,
amount int,
type char(20),
DOT date,
foreign key (custid) references customer(custid),
foreign key (account_no) references account(acnumber),
foreign key (bid) references branch_mstr(branch_no));
-- a. Write trigger to update balance in account table on Deposit or Withdraw in transaction table
-- b. Insert values in transaction table to show trigger success

DELIMITER //
create trigger transaction_details
after insert on transaction
for each row
begin
if new.type = 'Deposit' then update account set curbal = curbal+new.amount where custid=new.custid ;
elseif new.type = 'Withdraw' then update account set curbal = curbal-new.amount where custid=new.custid ;
end if;
end // 
DELIMITER ;

insert into transaction values 
(null,1,1,1,2000,'deposit',now());
select * from transaction;
-- 19.	Write a query to display the details of customer with second highest balance 
select acnumber,custid,bid,curbal,atype,opnDT,astatus from
(select *, dense_rank() over(order by curbal desc) rnk from account)t where rnk=2;


