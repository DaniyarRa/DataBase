create table dealer (
    id integer primary key ,
    name varchar(255),
    location varchar(255),
    charge float
);

INSERT INTO dealer (id, name, location, charge) VALUES (101, 'Ерлан', 'Алматы', 0.15);
INSERT INTO dealer (id, name, location, charge) VALUES (102, 'Жасмин', 'Караганда', 0.13);
INSERT INTO dealer (id, name, location, charge) VALUES (105, 'Азамат', 'Нур-Султан', 0.11);
INSERT INTO dealer (id, name, location, charge) VALUES (106, 'Канат', 'Караганда', 0.14);
INSERT INTO dealer (id, name, location, charge) VALUES (107, 'Евгений', 'Атырау', 0.13);
INSERT INTO dealer (id, name, location, charge) VALUES (103, 'Жулдыз', 'Актобе', 0.12);

create table client (
    id integer primary key ,
    name varchar(255),
    city varchar(255),
    priority integer,
    dealer_id integer references dealer(id)
);

INSERT INTO client (id, name, city, priority, dealer_id) VALUES (802, 'Айша', 'Алматы', 100, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (807, 'Даулет', 'Алматы', 200, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (805, 'Али', 'Кокшетау', 200, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (808, 'Ильяс', 'Нур-Султан', 300, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (804, 'Алия', 'Караганда', 300, 106);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (809, 'Саша', 'Шымкент', 100, 103);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (803, 'Маша', 'Семей', 200, 107);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (801, 'Максат', 'Нур-Султан', null, 105);

create table sell (
    id integer primary key,
    amount float,
    date timestamp,
    client_id integer references client(id),
    dealer_id integer references dealer(id)
);

INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (201, 150.5, '2012-10-05 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (209, 270.65, '2012-09-10 00:00:00.000000', 801, 105);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (202, 65.26, '2012-10-05 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (204, 110.5, '2012-08-17 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (207, 948.5, '2012-09-10 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (205, 2400.6, '2012-07-27 00:00:00.000000', 807, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (208, 5760, '2012-09-10 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (210, 1983.43, '2012-10-10 00:00:00.000000', 804, 106);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (203, 2480.4, '2012-10-10 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (212, 250.45, '2012-06-27 00:00:00.000000', 808, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (211, 75.29, '2012-08-17 00:00:00.000000', 803, 107);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (213, 3045.6, '2012-04-25 00:00:00.000000', 802, 101);

-- drop table client;
-- drop table dealer;
-- drop table sell;

-- 1
-- a)
select * from dealer, client
-- b)
select client.name, city, priority as grade, sell.id, date, amount from client, sell, dealer
where dealer.id = client.dealer_id and client.id = sell.client_id
-- c)
select dealer.id, dealer.name, client.name from dealer, client
where dealer.location = client.city and dealer.id = client.dealer_id
-- d)
select sell.id, sell.amount, client.name, client.city from sell, client
where sell.client_id = client.id and sell.amount >= 100 and sell.amount <= 500
-- e)
--select dealer.id as id, dealer.name as name, count(client) as cnt from dealer, client where client.dealer_id = dealer.id group by dealer.id, dealer.name
(select dealers_clients.id, dealers_clients.name, 'Dealer has 1 or more clients' as cnt_cl from (select dealer.id as id, dealer.name as name, count(client) as cnt
                                    from dealer,
                                         client
                                    where client.dealer_id = dealer.id
                                    group by dealer.id, dealer.name
                                   ) as dealers_clients where dealers_clients.cnt >= 1) union
(select dealers_clients.id, dealers_clients.name, 'Dealer has not clients' as cnt_cl from (select dealer.id as id, dealer.name as name, count(client) as cnt
                                    from dealer,
                                         client
                                    where client.dealer_id = dealer.id
                                    group by dealer.id, dealer.name
                                   ) as dealers_clients where dealers_clients.cnt = 0)
-- f)
select client.name, client.city, dealer.name, dealer.charge as commission
from client, dealer where client.dealer_id = dealer.id
-- g)
select client.name, client.city, dealer.name, dealer.charge as commission
from client, dealer where client.dealer_id = dealer.id and dealer.charge > 0.12
-- h)
create view Orders as select client.name as cl_name, client.city as city, sell.id as order_id,
sell.date as date, sell.amount as amount, dealer.name as de_name, dealer.charge as commission
from client, sell, dealer where client.id = sell.client_id and dealer.id = client.dealer_id
-- i)
select client.name, client.priority, dealer.name, sell.id, sell.amount
from dealer, client, sell where client.dealer_id = dealer.id and client.id = sell.client_id and sell.amount >= 2000 and client.priority IS  NOT NULL

-- 2
-- a)

select distinct count(client) as num_unique_clients, date, avg(amount), sum(amount)
from sell, client where sell.client_id = client.id group by date
-- b)
select query.date, query.total_amount from(
    select date, sum(amount) as total_amount from sell group by date) as query
    order by query.total_amount desc limit 5
-- c)
select count(sell) as num_sales, dealer.id, dealer.name, avg(amount), sum(amount)
from sell, dealer where sell.dealer_id = dealer.id group by dealer.id
-- d)
select dealer.id, dealer.name, sum(amount) * dealer.charge
from sell, dealer where sell.dealer_id = dealer.id group by dealer.id
-- e)
select distinct location , count(sell), avg(amount), sum(amount)
from dealer, sell where sell.dealer_id = dealer.id group by location
-- f)
select distinct client_id , count(sell), avg(amount), sum(amount)
from sell group by client_id
-- g

