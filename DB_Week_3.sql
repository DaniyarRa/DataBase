create database employee;

create table Employee(
    id integer PRIMARY KEY,
    person_name text NOT NULL,
    street text NOT NULL,
    city text
);

create table Job(
    id integer PRIMARY KEY REFERENCES Employee(id),
    company_name text REFERENCES Company(company_name),
    salary integer CHECK (salary >= 60000)
);

create table Company(
    company_name text PRIMARY KEY,
    city text NOT NULL

);
/* 1 */
INSERT INTO Employee VALUES (00001, 'Daniyar Raiymbekova','Zhumabekova 12a','Almaty');
INSERT INTO Company VALUES ('Kaspi','Almaty');
INSERT INTO JOB VALUES ('00001','Kaspi', 100000);
INSERT INTO JOB VALUES ('00001','Kaspi', 42500);
INSERT INTO Employee VALUES (00002,'Nazym Raiymbekova','Zhumabekova 12a','Almaty');
INSERT INTO JOB VALUES (00002,'Kaspi', 100000);
UPDATE JOB SET salary = case when id = 00001 then 150000 else 135000 end;
DELETE FROM Job where id = 00002;
DELETE FROM Employee where id = 00002;

CREATE DATABASE Shop;
drop table Order_items;
create database employee;
/* 2 */

CREATE DATABASE Shop;

create table Customers(
    id numeric(6,0) PRIMARY KEY ,
    full_name varchar(60) NOT NULL ,
    timestamp timestamp NOT NULL,
    delivery_address text NOT NULL
);

create table Orders(
    code integer PRIMARY KEY,
    customer_id integer REFERENCES Customers(id),
    total_sum double precision NOT NULL,
    is_paid boolean

);

create table Products(
    id varchar(10) PRIMARY KEY,
    name varchar(30) UNIQUE,
    description text,
    price double precision NOT NULL
);

create table Order_items(
    order_code integer references Orders(code),
    product_id varchar(10) references Products(id),
    quantity integer NOT NULL,
    PRIMARY KEY (order_code,product_id)
);

/* 4 */
INSERT INTO Customers VALUES (000001,'Daniyar Raiymbekov','2021-09-22 15:30:00','Zhumabekova 12a')

INSERT INTO Orders VALUES (123456789, 000001, 2000,true)

INSERT INTO Products VALUES (4561237890,'Milk 1.5 l 3,2%','No gmo,organic',500)
INSERT INTO Products VALUES (4561237891,'Bread 400g','Aksai Nan',100)
INSERT INTO Products VALUES (9999999987,'Shubat 0.7l','',800)

INSERT INTO Order_items values (123456789,4561237890,2)
INSERT INTO Order_items values (123456789,4561237891,2)
INSERT INTO Order_items values (123456789,9999999987,1)

Delete from Order_items where order_code = 123456789
Delete from Orders where customer_id = 000001 and code = 123456789
Update Customers set full_name = 'Raiymbekov D.A.' where id = 000001


/* 3*/

Create database Univercity;
CREATE TABLE Student(
    id char(10) PRIMARY KEY ,
    full_name varchar(30) NOT NULL,
    cource smallint CHECK ( cource >= 0 ) NOT NULL ,
    age smallint CHECK ( age > 0 ),
    birth_date date NOT NULL ,
    gender varchar(6) CHECK(gender = 'Male' or gender = 'Female'),
    avg_grade numeric(3,2),
    extra_in text,
    dorm_need boolean NOT NULL
);

CREATE TABLE Instructors(
    id char(4) PRIMARY KEY ,
    full_name varchar(30) UNIQUE NOT NULL ,
    speaking_lang varchar(200) NOT NULL,
    work_expr smallint NOT NULL,
    on_lesson_poss boolean NOT NULL

);

DROP TABLE Student;

CREATE TABLE Lesson_part(
    id char(6) PRIMARY KEY ,
    lesson_title varchar(50),
    instructor_name varchar(30) UNIQUE NOT NULL references Instructors(full_name),
    all_students text NOT NULL,
    room_num int


);

INSERT INTO Student VALUES ('20BD030477','Raiymbekov Daniyar Akimzhanuly',2,17, '2003-10-02','Male',3.25,'',false);

INSERT INTO Student Values('19BD040231', 'Mahatov Arman Amandykuly',3,19,'2002-02-02','Male',0,'',true);

INSERT INTO Instructors VALUES ('1010','Sovethan Murat Sovetovich','kazakh , russian , english',25,true);

INSERT INTO Lesson_part Values ('21F021','Philosophy and Rights','Sovethan Murat Sovetovich','Raiymbekov Daniyar Akimzhanuly , Mahatov Arman Amandykuly', 325);

