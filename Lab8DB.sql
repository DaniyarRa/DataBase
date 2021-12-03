--1
--a
create function increment_by_1(val int) returns integer
    LANGUAGE plpgsql
as $$
begin
  RETURN val + 1;
end
$$;
select increment_by_1(100);

--b
create function sum_of_2(val1 int, val2 int) returns integer
    LANGUAGE plpgsql
as $$
begin
  RETURN val1+val2;
  RETURN 0;
end
$$;
select sum_of_2(1, 1);

--c
create function divisible_by_2(val int) returns bool
    LANGUAGE plpgsql
as $$
begin
    val:=val%2;
    return 1 - val;
end
$$;
select divisible_by_2(500);

--d
create function valid_password(password varchar) returns bool
    LANGUAGE plpgsql
as $$
begin
if char_length(password) >= 8 then return true;
else return false;
end if;
end;
$$;
select valid_password('1234');

--e
CREATE TYPE increm AS
(
    val_plus_one int,
    val_plus_two int
);

CREATE function increm2(val int) RETURNS increm
    language plpgsql
as $$
DECLARE
  result increm;
BEGIN
  result.val_plus_one = val + 1;
  result.val_plus_two = val + 2 ;
  return result ;
END
$$;
select increm2(98);

--2
--a
CREATE TABLE student(
    name varchar(300),
    last_date timestamp
);

CREATE FUNCTION time_stamp() RETURNS trigger
    LANGUAGE plpgsql
AS $$
    BEGIN
        NEW.last_date := current_timestamp;
        RETURN NEW;
    END;
$$;

CREATE TRIGGER time_stamp BEFORE INSERT OR UPDATE ON student
    FOR EACH ROW EXECUTE FUNCTION time_stamp();

insert into student values ('Bolat');

--b
CREATE TABLE student2(
    name varchar(300),
    date_of_birth date,
    age int
);

CREATE FUNCTION age2() RETURNS trigger
    LANGUAGE plpgsql
AS $$
    BEGIN
        NEW.age := date_part('year',age(NEW.date_of_birth)) ;
        RETURN NEW;
    END;
$$;

CREATE TRIGGER age2 BEFORE INSERT OR UPDATE ON student2
    FOR EACH ROW EXECUTE FUNCTION age2();

insert into student2 values ('Daniyar', '2003.10.02');

--c
create table shop(
    name varchar(50),
    price float
);

CREATE FUNCTION tax() RETURNS trigger
    LANGUAGE plpgsql
AS $$
    BEGIN
        NEW.price := NEW.price * 1.12;
        RETURN NEW;
    END;
$$;

CREATE TRIGGER tax BEFORE INSERT OR UPDATE ON shop
    FOR EACH ROW EXECUTE FUNCTION tax();

insert into shop values ('Bread', 70);

--d
--C A U T I O N
create table shop2(
    name varchar(50),
    price float
);
insert into shop2 values ('Cola', 450);
CREATE FUNCTION noDeletion() RETURNS trigger
    LANGUAGE plpgsql

AS $$
BEGIN
    if 1 + 1 = 2 then
        Raise exception 'Did not allowed';
    end if;
    return old;
END;
$$;

CREATE TRIGGER noDeletion BEFORE DELETE ON shop2
    FOR EACH ROW EXECUTE FUNCTION noDeletion();

delete from shop2 where name ='Cola';

--e
create table shop3(
    name varchar(50),
    price float
);

insert into shop3 values ('PEPSI', 450);

--3
--In a function, it is mandatory to use the RETURNS and RETURN arguments,
-- whereas in a stored procedure is not necessary. In few words,
-- a stored procedure is more flexible to write any code that you want,
-- while functions have a rigid structure and functionality.

--4
create table emp(
    id int primary key,
    name varchar(50),
    date_of_birth date,
    age int,
    salary int,
    workexp int,
    discount int
);
--a
insert into emp values (1, 'Daniyar','2003-10-02', 18, 400000, 12, 10);

create procedure emp2()
    LANGUAGE plpgsql
as $$
declare
    i record;
    exp int;
begin
    for i in (select * from emp)
    loop
        exp = i.workexp / 2;
        while(exp > 0)
        loop
            update emp set salary = 1.1 * salary , discount = discount + 10 where id = i.id;
            exp = exp - 1;
        end loop;

    end loop;
end
$$;
call emp2();

--b
create procedure emp3()
    LANGUAGE plpgsql
as $$
declare
    i record;

begin
    for i in (select * from emp)
    loop
        if i.age >= 40 then
            update emp set salary = 1.15 * salary where id = i.id;
        end if;
        if i.workexp >= 8 then
            update emp set salary = 1.15 * salary where id = i.id;
        end if;


    end loop;
end
$$;
call emp3();

--5

create table members(
    memid integer primary key,
    surname varchar(200),
    firstname varchar(200),
    address varchar(300),
    zipcode int,
    telephone varchar(20),
    recommendedby int,
    joindate timestamp
);
insert into members values (1, 'Raiymbekov','Daniyar','Abai 156',1, '7777777777',0);
insert into members values (2, 'Raiymbekov','Daniyar','Abai 156',1, '7777777777',1);
insert into members values (3, 'Raiymbekov','Daniyar','Abai 156',1, '7777777777',1);
insert into members values (4, 'Raiymbekov','Daniyar','Abai 156',1, '7777777777',2);
insert into members values (5, 'Raiymbekov','Daniyar','Abai 156',1, '7777777777',2);

WITH Pair(mid, recommby) AS
(
    SELECT memid, recommendedby FROM members
)

select mid, recommby from Pair ORDER BY mid asc,recommby desc;







