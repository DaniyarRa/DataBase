create table customers (
    id integer primary key,
    name varchar(255),
    birth_date date
);

create table accounts(
    account_id varchar(40) primary key ,
    customer_id integer references customers(id),
    currency varchar(3),
    balance float,
    "limit" float
);

create table transactions (
    id serial primary key ,
    date timestamp,
    src_account varchar(40) references accounts(account_id),
    dst_account varchar(40) references accounts(account_id),
    amount float,
    status varchar(20)
);

INSERT INTO customers VALUES (201, 'John', '2021-11-05');
INSERT INTO customers VALUES (202, 'Anny', '2021-11-02');
INSERT INTO customers VALUES (203, 'Rick', '2021-11-24');

INSERT INTO accounts VALUES ('NT10204', 201, 'KZT', 1000, null);
INSERT INTO accounts VALUES ('AB10203', 202, 'USD', 100, 0);
INSERT INTO accounts VALUES ('DK12000', 203, 'EUR', 500, 200);
INSERT INTO accounts VALUES ('NK90123', 201, 'USD', 400, 0);
INSERT INTO accounts VALUES ('RS88012', 203, 'KZT', 5000, -100);

INSERT INTO transactions VALUES (1, '2021-11-05 18:00:34.000000', 'NT10204', 'RS88012', 1000, 'commited');
INSERT INTO transactions VALUES (2, '2021-11-05 18:01:19.000000', 'NK90123', 'AB10203', 500, 'rollback');
INSERT INTO transactions VALUES (3, '2021-06-05 18:02:45.000000', 'RS88012', 'NT10204', 400, 'init');

-- 1)
-- We can store large objects by 2 ways. There are :
-- 1. blob: binary large object -- object is a large collection of uninterpreted binary data
-- (whose interpretation is left to an application outside of the database system)
-- 2. clob: character large object -- object is a large collection of character data


--2)
-- 1. Privilege - the method, when you may authorize the user all, none,
-- or a combination of these types of privileges on specified parts of a database, such as a relation or a view
-- 2. Role - a way to distinguish among various users
-- as far as what  these users can access/update in the database
-- 3. User - need to be assigned to the role

--2.1)
create role accountant;
create role administrator;
create role support;
grant select on accounts, transactions to accountant;
grant all privileges on accounts, customers, transactions to administrator;
grant select on accounts, customers, transactions to support;
--2.2)
create user Bahyt;
create user Daniyar;
create user Ayym;
grant accountant to Bahyt;
grant administrator to Daniyar;
grant support to Ayym;
--2.3)
grant accountant, support to administrator;
--2.4)
revoke select on transactions from Bahyt;


--5)
--5.1)
create unique index unique_account on accounts (account_id, customer_id, currency);
--5.2)
create index trans on accounts (account_id, currency, balance);
--6)

begin;
update accounts SET balance = balance - 4000
    where customer_id = 203 and currency = 'KZT' and balance - 4000 >= accounts.limit;
update accounts SET balance = balance + 4000
    where customer_id = 201 and currency = 'KZT';
insert into transactions values (4,'2021-11-11 00:00:01.000000', 'RS88012', 'NT10204', 4000, 'commited');
commit;




