create table Customers(
    id char(8) primary key,
    name varchar(50) not null,
    surname varchar(50),
    birth_date date,
    phone_number char(10),
    registration_date date not null ,
    earned_bonus int check ( earned_bonus >= 0 )
);

create table Store_Information(
    id char(5) primary key,
    city varchar(100) not null ,
    street varchar(100) not null ,
    building varchar(100) not null,
    open_time time not null ,
    close_time time not null
);

create table Products(
    upc int check ( upc >= 10000000 and upc <= 99999999) primary key ,
    name varchar(100) not null,
    vendor varchar(100),
    brand varchar(100) not null,
    variety varchar(100) not null
);

create table ProductsInStore(
    store_id char(5) references Store_Information(id),
    upc int references Products(upc),
    balance int check ( balance >= 0 ),
    cost float check ( cost > 0 ),
    primary key (store_id, upc)
);

--drop table Products;
--drop table Ordered_items;

create table Orders(
    id char(10) primary key,
    customer_id char(8) references Customers(id) not null,
    total_sum float,
    pay_by_bonus float
);


create table Ordered_items(
    id char(10) REFERENCES Orders(id),
    store_id char(5),
    upc int ,
    count int not null,
    primary key (id, upc),
    foreign key (store_id, upc) references ProductsInStore(store_id, upc)
);

create function change_balance(order_id char) returns integer
    LANGUAGE plpgsql
as $$
DECLARE
    i RECORD;
begin
  for i in (select upc as u, count as c, store_id as s from ordered_items where id = order_id)
  loop
    update productsinstore set balance = balance - i.c where store_id = i.s and upc = i.u;
  end loop;
  RETURN 0;
end
$$;