-- The most 20 popular products in each store;

select Products.upc, name, brand, variety, sum(count) as count_of_realised_items
from products,Ordered_items where Products.upc = Ordered_items.upc
and Ordered_items.store_id = '02001'
group by Products.upc order by count_of_realised_items desc limit 20;

select Products.upc, name, brand, variety, sum(count) as count_of_realised_items
from products,Ordered_items where Products.upc = Ordered_items.upc
and Ordered_items.store_id = '02002'
group by Products.upc order by count_of_realised_items desc limit 20;

select Products.upc, name, brand, variety, sum(count) as count_of_realised_items
from products,Ordered_items where Products.upc = Ordered_items.upc
and Ordered_items.store_id = '02003'
group by Products.upc order by count_of_realised_items desc limit 20;

select Products.upc, name, brand, variety, sum(count) as count_of_realised_items
from products,Ordered_items where Products.upc = Ordered_items.upc
and Ordered_items.store_id = '01001'
group by Products.upc order by count_of_realised_items desc limit 20;

select Products.upc, name, brand, variety, sum(count) as count_of_realised_items
from products,Ordered_items where Products.upc = Ordered_items.upc
and Ordered_items.store_id = '01002'
group by Products.upc order by count_of_realised_items desc limit 20;

select Products.upc, name, brand, variety, sum(count) as count_of_realised_items
from products,Ordered_items where Products.upc = Ordered_items.upc
and Ordered_items.store_id = '01003'
group by Products.upc order by count_of_realised_items desc limit 20;
-- The most 20 popular products in each state;
--Almaty
select Products.upc, name, brand, variety, sum(count) as count_of_realised_items
from products,Ordered_items, store_information where Products.upc = Ordered_items.upc
and Ordered_items.store_id = Store_Information.id and Store_Information.city ='Almaty'
group by Products.upc order by count_of_realised_items desc limit 20;
--Astana
select Products.upc, name, brand, variety, sum(count) as count_of_realised_items
from products,Ordered_items where Products.upc = Ordered_items.upc
and (Ordered_items.store_id = '01001' or Ordered_items.store_id = '01002' or Ordered_items.store_id = '01003')
group by Products.upc order by count_of_realised_items desc limit 20;

--The 5 top-selling shops:
select Ordered_items.store_id, sum(Ordered_items.count * productsinstore.cost) as sell
from ordered_items, productsinstore
where Ordered_items.store_id = ProductsInStore.store_id
and Ordered_items.upc = ProductsInStore.upc group by Ordered_items.store_id order by sell desc limit 5;

--
--Fanta Outsell Cola
select count(table3.store_id) from (select  table1.store_id, sells_of_Coca_Cola, sells_of_Fanta from (select store_id , sum(count) as sells_of_Coca_Cola from ordered_items where upc = 17020001
group by store_id) as table1 INNER JOIN (select store_id, sum(count) as sells_of_Fanta from ordered_items where upc = 17020004
group by store_id) as table2 ON table1.store_id = table2.store_id) as table3 where table3.sells_of_Fanta > table3.sells_of_Coca_Cola;
-- 3 most products that people buy with milk;
select upc, sum(count) as sell from ordered_items where id in (select id from ordered_items
where upc IN (10040001,10040002,10040003,10040004))
and Ordered_items.upc not IN (10040001,10040002,10040003,10040004)
group by Ordered_items.upc order by sell desc limit 3;