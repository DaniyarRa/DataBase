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

INSERT INTO Customers VALUES ('00000000', 'Anonymous', 'Anonymous', '1900-01-01', '0000000000','1900-01-01', 0);
INSERT INTO Customers VALUES ('03100201', 'Daniyar', 'Raiymbekov', '2003-10-02', '7077070707','2019-11-20', 9999);
INSERT INTO Customers VALUES ('89062301', 'Aigul', 'Ganieva', '1989-06-23', '7053960482','2020-04-07', 413);
INSERT INTO Customers VALUES ('72012701', 'Kairat', 'Bolatov', '1972-01-27', '7058769051','2018-07-14', 0);
INSERT INTO Customers VALUES ('95121201', 'Aiym', 'Ganieva', '1995-12-12', '7715814952','2020-02-25', 6890);

INSERT INTO Store_Information VALUES ('02001', 'Almaty', 'Han Shatyr', '273', '00:00:00.0000000', '23:59:59.9999999');
INSERT INTO Store_Information VALUES ('02002', 'Almaty', 'Abay', '44a', '09:00:00.0000000', '22:59:59.9999999');
INSERT INTO Store_Information VALUES ('02003', 'Almaty', 'Rozybakieva', '70', '09:00:00.0000000', '22:59:59.9999999');
INSERT INTO Store_Information VALUES ('01001', 'Astana', 'Turan', '55d', '00:00:00.0000000', '23:59:59.9999999');
INSERT INTO Store_Information VALUES ('01002', 'Astana', 'Konaev', '10', '08:00:00.0000000', '21:59:59.9999999');
INSERT INTO Store_Information VALUES ('01003', 'Astana', 'Satbaev', '25', '09:00:00.0000000', '22:59:59.9999999');
-- Сыр
INSERT INTO Products VALUES (10010001, 'Моцарела', '', 'Golbani','150г');
INSERT INTO Products VALUES (10010002, 'Моцарела', '', 'Golbani','125г');

INSERT INTO productsinstore values ('02001',10010001,30, 779);
INSERT INTO productsinstore values ('02002',10010001,30, 779);
INSERT INTO productsinstore values ('01002',10010001,30, 775);
INSERT INTO productsinstore values ('01003',10010001,30, 775);

INSERT INTO productsinstore VALUES ('02003',10010002,30,665);
INSERT INTO productsinstore VALUES ('02002',10010002,30,665);
INSERT INTO productsinstore VALUES ('01001',10010002,30,659);
INSERT INTO productsinstore VALUES ('01003',10010002,30,659);
INSERT INTO productsinstore VALUES ('01002',10010002,30,659);
INSERT INTO productsinstore VALUES ('02001',10010002,30,665);

INSERT INTO Products VALUES (10010003, 'Плавленный Сыр', '', 'President','400г');
INSERT INTO Products VALUES (10010004, 'Плавленный Сыр', '', 'President','300г');

INSERT INTO productsinstore VALUES ('02003',10010003,50,1489);
INSERT INTO productsinstore VALUES ('02002',10010003,50,1489);
INSERT INTO productsinstore VALUES ('01001',10010003,50,1490);
INSERT INTO productsinstore VALUES ('01003',10010003,50,1490);
INSERT INTO productsinstore VALUES ('01002',10010003,50,1490);
INSERT INTO productsinstore VALUES ('02001',10010003,50,1489);

INSERT INTO productsinstore VALUES ('02003',10010004,50,919);
INSERT INTO productsinstore VALUES ('02002',10010004,50,919);
INSERT INTO productsinstore VALUES ('01001',10010004,50,929);
INSERT INTO productsinstore VALUES ('01003',10010004,50,929);
-- Йогурт
INSERT INTO Products VALUES (10030001, 'Йогурт', '', 'Food Master','110г');
INSERT INTO Products VALUES (10030002, 'Йогурт', '', 'Чудо','290г');

INSERT INTO productsinstore values ('02001',10030001,100, 110);
INSERT INTO productsinstore values ('02002',10030001,100, 109);
INSERT INTO productsinstore values ('01002',10030001,100, 115);
INSERT INTO productsinstore values ('01003',10030001,100, 114);

INSERT INTO productsinstore VALUES ('02003',10030002,30,307);
INSERT INTO productsinstore VALUES ('02002',10030002,30,307);
INSERT INTO productsinstore VALUES ('01001',10030002,30,309);
INSERT INTO productsinstore VALUES ('01003',10030002,30,309);
INSERT INTO productsinstore VALUES ('01002',10030002,30,309);
INSERT INTO productsinstore VALUES ('02001',10030002,30,307);

INSERT INTO Products VALUES (10030003, 'Йогурт', 'Danone', 'Actimel','100г');
INSERT INTO Products VALUES (10030004, 'Йогурт', 'Danone', 'Активиа','120г');

INSERT INTO productsinstore VALUES ('02003',10030003,50,198);
INSERT INTO productsinstore VALUES ('02002',10030003,50,199);
INSERT INTO productsinstore VALUES ('01001',10030003,50,200);
INSERT INTO productsinstore VALUES ('01003',10030003,50,195);
INSERT INTO productsinstore VALUES ('01002',10030003,50,197);
INSERT INTO productsinstore VALUES ('02001',10030003,50,198);

INSERT INTO productsinstore VALUES ('02003',10030004,50,168);
INSERT INTO productsinstore VALUES ('02002',10030004,50,168);
INSERT INTO productsinstore VALUES ('01001',10030004,50,170);
INSERT INTO productsinstore VALUES ('01003',10030004,50,169);

-- Молоко

INSERT INTO Products VALUES (10040001, 'Молоко', 'Food Master', 'Lactel','1000г');
INSERT INTO Products VALUES (10040002, 'Молоко', '', 'Adal','925г');

INSERT INTO productsinstore values ('02001',10040001,100, 435);
INSERT INTO productsinstore values ('02002',10040001,100, 430);
INSERT INTO productsinstore values ('01002',10040001,100, 429);
INSERT INTO productsinstore values ('01003',10040001,100, 435);

INSERT INTO productsinstore VALUES ('02003',10040002,300,369);
INSERT INTO productsinstore VALUES ('02002',10040002,300,370);
INSERT INTO productsinstore VALUES ('01001',10040002,300,365);
INSERT INTO productsinstore VALUES ('01003',10040002,300,375);
INSERT INTO productsinstore VALUES ('01002',10040002,300,369);
INSERT INTO productsinstore VALUES ('02001',10040002,300,367);

INSERT INTO Products VALUES (10040003, 'Молоко', '', 'Мое','1430г');
INSERT INTO Products VALUES (10040004, 'Молоко', '', 'Петропавловское','1000г');

INSERT INTO productsinstore VALUES ('02003',10040003,500,649);
INSERT INTO productsinstore VALUES ('02002',10040003,500,650);
INSERT INTO productsinstore VALUES ('01001',10040003,500,650);
INSERT INTO productsinstore VALUES ('01003',10040003,500,650);
INSERT INTO productsinstore VALUES ('01002',10040003,500,649);
INSERT INTO productsinstore VALUES ('02001',10040003,500,650);

INSERT INTO productsinstore VALUES ('02003',10040004,500,435);
INSERT INTO productsinstore VALUES ('02002',10040004,500,430);
INSERT INTO productsinstore VALUES ('01001',10040004,500,430);
INSERT INTO productsinstore VALUES ('01003',10040004,500,430);


-- Масло и маргарин

INSERT INTO Products VALUES (10050001, 'Масло', 'Food Master', 'President','180г');
INSERT INTO Products VALUES (10050002, 'Маргарин', '3 Желания', 'Пампушка','180г');

INSERT INTO productsinstore values ('02001',10050001,100, 815);
INSERT INTO productsinstore values ('02002',10050001,100, 820);
INSERT INTO productsinstore values ('01002',10050001,100, 800);
INSERT INTO productsinstore values ('01003',10050001,100, 819);

INSERT INTO productsinstore VALUES ('02003',10050002,300,122);
INSERT INTO productsinstore VALUES ('02002',10050002,300,125);
INSERT INTO productsinstore VALUES ('01001',10050002,300,120);
INSERT INTO productsinstore VALUES ('01003',10050002,300,121);
INSERT INTO productsinstore VALUES ('01002',10050002,300,122);
INSERT INTO productsinstore VALUES ('02001',10050002,300,124);

-- Сметана

INSERT INTO Products VALUES (10080001, 'Сметана', 'Food Master', 'President','400г');
INSERT INTO Products VALUES (10080002, 'Сметана', '', 'Простоквашино','315г');

INSERT INTO productsinstore VALUES ('02003',10080001,500,589);
INSERT INTO productsinstore VALUES ('02002',10080001,500,590);
INSERT INTO productsinstore VALUES ('01001',10080001,500,595);
INSERT INTO productsinstore VALUES ('01003',10080001,500,580);
INSERT INTO productsinstore VALUES ('01002',10080001,500,584);
INSERT INTO productsinstore VALUES ('02001',10080001,500,585);
INSERT INTO productsinstore VALUES ('02003',10080002,300,587);
INSERT INTO productsinstore VALUES ('02002',10080002,300,589);
INSERT INTO productsinstore VALUES ('01001',10080002,300,585);
INSERT INTO productsinstore VALUES ('01003',10080002,300,589);
INSERT INTO productsinstore VALUES ('01002',10080002,300,579);
INSERT INTO productsinstore VALUES ('02001',10080002,300,587);

-- Кефир
INSERT INTO Products VALUES (10090001, 'Кефир', 'Food Master', 'БИО-С','1л');
INSERT INTO Products VALUES (10090002, 'Кефир', 'Food Master', 'Кефир','1л');
INSERT INTO Products VALUES (10090003, 'Тан', '', 'Рудненский Тан','1л');

INSERT INTO productsinstore VALUES ('02003',10090001,500,508);
INSERT INTO productsinstore VALUES ('02002',10090001,500,510);
INSERT INTO productsinstore VALUES ('01001',10090001,500,509);
INSERT INTO productsinstore VALUES ('01003',10090001,500,505);
INSERT INTO productsinstore VALUES ('01002',10090001,500,510);
INSERT INTO productsinstore VALUES ('02001',10090001,500,505);
INSERT INTO productsinstore VALUES ('02003',10090002,300,417);
INSERT INTO productsinstore VALUES ('02002',10090002,300,415);
INSERT INTO productsinstore VALUES ('01001',10090002,300,411);
INSERT INTO productsinstore VALUES ('01003',10090002,300,419);
INSERT INTO productsinstore VALUES ('01002',10090002,300,420);
INSERT INTO productsinstore VALUES ('02001',10090002,300,515);
INSERT INTO productsinstore VALUES ('02003',10090003,300,365);
INSERT INTO productsinstore VALUES ('02002',10090003,300,369);
INSERT INTO productsinstore VALUES ('01001',10090003,300,359);
INSERT INTO productsinstore VALUES ('01003',10090003,300,360);
INSERT INTO productsinstore VALUES ('01002',10090003,300,370);
INSERT INTO productsinstore VALUES ('02001',10090003,300,360);

-- Яйца
INSERT INTO Products VALUES (10120001, 'Яйца', '', 'QARQUS','30ш');
INSERT INTO Products VALUES (10120002, 'Яйца', '', 'Казгер-Кус','10ш');
INSERT INTO Products VALUES (10120003, 'Яйца', '', 'Ак-Кус','30ш');

INSERT INTO productsinstore VALUES ('02003',10120001,500,1489);
INSERT INTO productsinstore VALUES ('02002',10120001,500,1489);
INSERT INTO productsinstore VALUES ('01001',10120001,500,1490);
INSERT INTO productsinstore VALUES ('01003',10120001,500,1490);
INSERT INTO productsinstore VALUES ('01002',10120001,500,1490);
INSERT INTO productsinstore VALUES ('02001',10120001,500,1489);
INSERT INTO productsinstore VALUES ('02003',10120002,300,525);
INSERT INTO productsinstore VALUES ('02002',10120002,300,525);
INSERT INTO productsinstore VALUES ('01001',10120002,300,529);
INSERT INTO productsinstore VALUES ('01003',10120002,300,529);
INSERT INTO productsinstore VALUES ('01002',10120002,300,529);
INSERT INTO productsinstore VALUES ('02001',10120002,300,525);
INSERT INTO productsinstore VALUES ('02003',10120003,300,1739);
INSERT INTO productsinstore VALUES ('02002',10120003,300,1739);
INSERT INTO productsinstore VALUES ('01001',10120003,300,1739);
INSERT INTO productsinstore VALUES ('01003',10120003,300,1739);
INSERT INTO productsinstore VALUES ('01002',10120003,300,1739);
INSERT INTO productsinstore VALUES ('02001',10120003,300,1739);

-- Овощи
INSERT INTO Products VALUES (11010001, 'Картофель', '', '','1кг');
INSERT INTO Products VALUES (11010002, 'Морковь', '', '','1кг');
INSERT INTO Products VALUES (11010003, 'Лук', '', '','1кг');
INSERT INTO Products VALUES (11010004, 'Томаты', '', '','1кг');
INSERT INTO Products VALUES (11010005, 'Огурцы', '', '','1кг');
INSERT INTO Products VALUES (11010006, 'Капуста', '', '','1кг');

INSERT INTO productsinstore VALUES ('02003',11010001,5000,115);
INSERT INTO productsinstore VALUES ('02002',11010001,5000,115);
INSERT INTO productsinstore VALUES ('01001',11010001,5000,115);
INSERT INTO productsinstore VALUES ('01003',11010001,5000,115);
INSERT INTO productsinstore VALUES ('01002',11010001,5000,115);
INSERT INTO productsinstore VALUES ('02001',11010001,5000,115);
INSERT INTO productsinstore VALUES ('02003',11010002,3000,120);
INSERT INTO productsinstore VALUES ('02002',11010002,3000,120);
INSERT INTO productsinstore VALUES ('01001',11010002,3000,125);
INSERT INTO productsinstore VALUES ('01003',11010002,3000,125);
INSERT INTO productsinstore VALUES ('01002',11010002,3000,125);
INSERT INTO productsinstore VALUES ('02001',11010002,3000,120);
INSERT INTO productsinstore VALUES ('02003',11010003,3000,95);
INSERT INTO productsinstore VALUES ('02002',11010003,3000,95);
INSERT INTO productsinstore VALUES ('01001',11010003,3000,99);
INSERT INTO productsinstore VALUES ('01003',11010003,3000,99);
INSERT INTO productsinstore VALUES ('01002',11010003,3000,99);
INSERT INTO productsinstore VALUES ('02001',11010003,3000,95);

INSERT INTO productsinstore VALUES ('02003',11010004,5000,1100);
INSERT INTO productsinstore VALUES ('02002',11010004,5000,1100);
INSERT INTO productsinstore VALUES ('01001',11010004,5000,1149);
INSERT INTO productsinstore VALUES ('01003',11010004,5000,1149);
INSERT INTO productsinstore VALUES ('01002',11010004,5000,1149);
INSERT INTO productsinstore VALUES ('02001',11010004,5000,1100);
INSERT INTO productsinstore VALUES ('02003',11010005,3000,850);
INSERT INTO productsinstore VALUES ('02002',11010005,3000,850);
INSERT INTO productsinstore VALUES ('01001',11010005,3000,840);
INSERT INTO productsinstore VALUES ('01003',11010005,3000,840);
INSERT INTO productsinstore VALUES ('01002',11010005,3000,840);
INSERT INTO productsinstore VALUES ('02001',11010005,3000,850);
INSERT INTO productsinstore VALUES ('02003',11010006,3000,100);
INSERT INTO productsinstore VALUES ('02002',11010006,3000,100);
INSERT INTO productsinstore VALUES ('01001',11010006,3000,99);
INSERT INTO productsinstore VALUES ('01003',11010006,3000,99);
INSERT INTO productsinstore VALUES ('01002',11010006,3000,99);
INSERT INTO productsinstore VALUES ('02001',11010006,3000,100);

-- Фрукты
INSERT INTO Products VALUES (11020001, 'Яблоко', '', 'красное','1кг');
INSERT INTO Products VALUES (11020002, 'Банан', '', '','1кг');
INSERT INTO Products VALUES (11020003, 'Апельсин', '', '','1кг');
INSERT INTO Products VALUES (11020004, 'Гранат', '', '','1кг');
INSERT INTO Products VALUES (11020005, 'Груша', '', '','1кг');
INSERT INTO Products VALUES (11020006, 'Яблоко', '', 'зеленое','1кг');

INSERT INTO productsinstore VALUES ('02003',11020001,5000,550);
INSERT INTO productsinstore VALUES ('02002',11020001,5000,550);
INSERT INTO productsinstore VALUES ('01001',11020001,5000,549);
INSERT INTO productsinstore VALUES ('01003',11020001,5000,549);
INSERT INTO productsinstore VALUES ('01002',11020001,5000,549);
INSERT INTO productsinstore VALUES ('02001',11020001,5000,550);
INSERT INTO productsinstore VALUES ('02003',11020002,3000,679);
INSERT INTO productsinstore VALUES ('02002',11020002,3000,679);
INSERT INTO productsinstore VALUES ('01001',11020002,3000,689);
INSERT INTO productsinstore VALUES ('01003',11020002,3000,689);
INSERT INTO productsinstore VALUES ('01002',11020002,3000,689);
INSERT INTO productsinstore VALUES ('02001',11020002,3000,675);
INSERT INTO productsinstore VALUES ('02003',11020003,3000,890);
INSERT INTO productsinstore VALUES ('02002',11020003,3000,890);
INSERT INTO productsinstore VALUES ('01001',11020003,3000,899);
INSERT INTO productsinstore VALUES ('01003',11020003,3000,899);
INSERT INTO productsinstore VALUES ('01002',11020003,3000,899);
INSERT INTO productsinstore VALUES ('02001',11020003,3000,890);

INSERT INTO productsinstore VALUES ('02003',11020004,5000,1350);
INSERT INTO productsinstore VALUES ('02002',11020004,5000,1350);
INSERT INTO productsinstore VALUES ('01001',11020004,5000,1399);
INSERT INTO productsinstore VALUES ('01003',11020004,5000,1399);
INSERT INTO productsinstore VALUES ('01002',11020004,5000,1399);
INSERT INTO productsinstore VALUES ('02001',11020004,5000,1350);
INSERT INTO productsinstore VALUES ('02003',11020005,3000,899);
INSERT INTO productsinstore VALUES ('02002',11020005,3000,899);
INSERT INTO productsinstore VALUES ('01001',11020005,3000,940);
INSERT INTO productsinstore VALUES ('01003',11020005,3000,940);
INSERT INTO productsinstore VALUES ('01002',11020005,3000,940);
INSERT INTO productsinstore VALUES ('02001',11020005,3000,899);
INSERT INTO productsinstore VALUES ('02003',11020006,3000,550);
INSERT INTO productsinstore VALUES ('02002',11020006,3000,550);
INSERT INTO productsinstore VALUES ('01001',11020006,3000,599);
INSERT INTO productsinstore VALUES ('01003',11020006,3000,599);
INSERT INTO productsinstore VALUES ('01002',11020006,3000,599);
INSERT INTO productsinstore VALUES ('02001',11020006,3000,550);

-- Зелень и салат
INSERT INTO Products VALUES (11030001, 'Укроп', '', 'красное','100г');
INSERT INTO Products VALUES (11030002, 'Петрушка', '', '','100г');
INSERT INTO Products VALUES (11030003, 'Салат', '', '','100г');

INSERT INTO productsinstore VALUES ('02003',11030001,5000,200);
INSERT INTO productsinstore VALUES ('02002',11030001,5000,200);
INSERT INTO productsinstore VALUES ('01001',11030001,5000,229);
INSERT INTO productsinstore VALUES ('01003',11030001,5000,229);
INSERT INTO productsinstore VALUES ('01002',11030001,5000,229);
INSERT INTO productsinstore VALUES ('02001',11030001,5000,200);
INSERT INTO productsinstore VALUES ('02003',11030002,3000,150);
INSERT INTO productsinstore VALUES ('02002',11030002,3000,150);
INSERT INTO productsinstore VALUES ('01001',11030002,3000,179);
INSERT INTO productsinstore VALUES ('01003',11030002,3000,179);
INSERT INTO productsinstore VALUES ('01002',11030002,3000,179);
INSERT INTO productsinstore VALUES ('02001',11030002,3000,150);
INSERT INTO productsinstore VALUES ('02003',11030003,3000,150);
INSERT INTO productsinstore VALUES ('02002',11030003,3000,150);
INSERT INTO productsinstore VALUES ('01001',11030003,3000,179);
INSERT INTO productsinstore VALUES ('01003',11030003,3000,179);
INSERT INTO productsinstore VALUES ('01002',11030003,3000,179);
INSERT INTO productsinstore VALUES ('02001',11030003,3000,150);

-- Колбасы
INSERT INTO Products VALUES (12010001, 'Колбаса', '', 'Папа Может','350г');
INSERT INTO Products VALUES (12010002, 'Колбаса', '', 'Риха','450г');


INSERT INTO productsinstore VALUES ('02003',12010001,500,1339);
INSERT INTO productsinstore VALUES ('02002',12010001,500,1339);
INSERT INTO productsinstore VALUES ('01001',12010001,500,1349);
INSERT INTO productsinstore VALUES ('01003',12010001,500,1349);
INSERT INTO productsinstore VALUES ('01002',12010001,500,1349);
INSERT INTO productsinstore VALUES ('02001',12010001,500,1339);
INSERT INTO productsinstore VALUES ('02003',12010002,300,1299);
INSERT INTO productsinstore VALUES ('02002',12010002,300,1299);
INSERT INTO productsinstore VALUES ('01001',12010002,300,1349);
INSERT INTO productsinstore VALUES ('01003',12010002,300,1349);
INSERT INTO productsinstore VALUES ('01002',12010002,300,1349);
INSERT INTO productsinstore VALUES ('02001',12010002,300,1299);

-- Сосиски
INSERT INTO Products VALUES (12020001, 'Сосиски', '', 'Папа Может','400г');
INSERT INTO Products VALUES (12020002, 'Сосиски', '', 'Беккер и К','150г');


INSERT INTO productsinstore VALUES ('02003',12020001,500,1049);
INSERT INTO productsinstore VALUES ('02002',12020001,500,1049);
INSERT INTO productsinstore VALUES ('01001',12020001,500,1099);
INSERT INTO productsinstore VALUES ('01003',12020001,500,1099);
INSERT INTO productsinstore VALUES ('01002',12020001,500,1099);
INSERT INTO productsinstore VALUES ('02001',12020001,500,1049);
INSERT INTO productsinstore VALUES ('02003',12020002,300,574);
INSERT INTO productsinstore VALUES ('02002',12020002,300,574);
INSERT INTO productsinstore VALUES ('01001',12020002,300,599);
INSERT INTO productsinstore VALUES ('01003',12020002,300,599);
INSERT INTO productsinstore VALUES ('01002',12020002,300,599);
INSERT INTO productsinstore VALUES ('02001',12020002,300,574);

-- Птица
INSERT INTO Products VALUES (13010001, 'Тушка ', '', 'Алель','1200г');
INSERT INTO Products VALUES (13010002, 'Филе', '', 'Кус & Вкус','800г');


INSERT INTO productsinstore VALUES ('02003',13010001,500,2638);
INSERT INTO productsinstore VALUES ('02002',13010001,500,2638);
INSERT INTO productsinstore VALUES ('01001',13010001,500,2699);
INSERT INTO productsinstore VALUES ('01003',13010001,500,2699);
INSERT INTO productsinstore VALUES ('01002',13010001,500,2699);
INSERT INTO productsinstore VALUES ('02001',13010001,500,2638);
INSERT INTO productsinstore VALUES ('02003',13010002,300,1779);
INSERT INTO productsinstore VALUES ('02002',13010002,300,1779);
INSERT INTO productsinstore VALUES ('01001',13010002,300,1849);
INSERT INTO productsinstore VALUES ('01003',13010002,300,1849);
INSERT INTO productsinstore VALUES ('01002',13010002,300,1849);
INSERT INTO productsinstore VALUES ('02001',13010002,300,1779);

-- Полуфабрикаты из мяса
INSERT INTO Products VALUES (13020001, 'Наггетсы', '', 'Мираторг','300г');
INSERT INTO Products VALUES (13020002, 'Котлеты', '', 'Кус & Вкус','630г');


INSERT INTO productsinstore VALUES ('02003',13020001,500,875);
INSERT INTO productsinstore VALUES ('02002',13020001,500,875);
INSERT INTO productsinstore VALUES ('01001',13020001,500,899);
INSERT INTO productsinstore VALUES ('01003',13020001,500,899);
INSERT INTO productsinstore VALUES ('01002',13020001,500,899);
INSERT INTO productsinstore VALUES ('02001',13020001,500,875);
INSERT INTO productsinstore VALUES ('02003',13020002,300,3363);
INSERT INTO productsinstore VALUES ('02002',13020002,300,3363);
INSERT INTO productsinstore VALUES ('01001',13020002,300,3499);
INSERT INTO productsinstore VALUES ('01003',13020002,300,3499);
INSERT INTO productsinstore VALUES ('01002',13020002,300,3499);
INSERT INTO productsinstore VALUES ('02001',13020002,300,3363);

-- Мясо
INSERT INTO Products VALUES (13030001, 'Фарш', '', 'Еткон','1кг');
INSERT INTO Products VALUES (13030002, 'Говядина', '', 'Meatking','600г');


INSERT INTO productsinstore VALUES ('02003',13030001,500,3000);
INSERT INTO productsinstore VALUES ('02002',13030001,500,3000);
INSERT INTO productsinstore VALUES ('01001',13030001,500,2950);
INSERT INTO productsinstore VALUES ('01003',13030001,500,2950);
INSERT INTO productsinstore VALUES ('01002',13030001,500,2950);
INSERT INTO productsinstore VALUES ('02001',13030001,500,3000);
INSERT INTO productsinstore VALUES ('02003',13030002,300,1642);
INSERT INTO productsinstore VALUES ('02002',13030002,300,1642);
INSERT INTO productsinstore VALUES ('01001',13030002,300,1750);
INSERT INTO productsinstore VALUES ('01003',13030002,300,1750);
INSERT INTO productsinstore VALUES ('01002',13030002,300,1750);
INSERT INTO productsinstore VALUES ('02001',13030002,300,1642);

-- Рыба
INSERT INTO Products VALUES (14010001, 'Филе судака', '', 'Fishdream','1кг');
INSERT INTO Products VALUES (14010002, 'Филе семги', '', 'Санта Бремор','300г');


INSERT INTO productsinstore VALUES ('02003',14010001,500,2500);
INSERT INTO productsinstore VALUES ('02002',14010001,500,2500);
INSERT INTO productsinstore VALUES ('01001',14010001,500,2750);
INSERT INTO productsinstore VALUES ('01003',14010001,500,2750);
INSERT INTO productsinstore VALUES ('01002',14010001,500,2750);
INSERT INTO productsinstore VALUES ('02001',14010001,500,2500);
INSERT INTO productsinstore VALUES ('02003',14010002,300,4789);
INSERT INTO productsinstore VALUES ('02002',14010002,300,4789);
INSERT INTO productsinstore VALUES ('01001',14010002,300,5150);
INSERT INTO productsinstore VALUES ('01003',14010002,300,5150);
INSERT INTO productsinstore VALUES ('01002',14010002,300,5150);
INSERT INTO productsinstore VALUES ('02001',14010002,300,4789);

-- Полуфабрикаты из рыбы
INSERT INTO Products VALUES (14020001, 'Крабовые палочки', '', 'Vici','200г');
INSERT INTO Products VALUES (14020002, 'Рыбные палочки', '', 'Vici','500г');


INSERT INTO productsinstore VALUES ('02003',14020001,500,429);
INSERT INTO productsinstore VALUES ('02002',14020001,500,429);
INSERT INTO productsinstore VALUES ('01001',14020001,500,449);
INSERT INTO productsinstore VALUES ('01003',14020001,500,449);
INSERT INTO productsinstore VALUES ('01002',14020001,500,449);
INSERT INTO productsinstore VALUES ('02001',14020001,500,429);
INSERT INTO productsinstore VALUES ('02003',14020002,300,949);
INSERT INTO productsinstore VALUES ('02002',14020002,300,949);
INSERT INTO productsinstore VALUES ('01001',14020002,300,949);
INSERT INTO productsinstore VALUES ('01003',14020002,300,949);
INSERT INTO productsinstore VALUES ('01002',14020002,300,949);
INSERT INTO productsinstore VALUES ('02001',14020002,300,949);

-- Морепродукты
INSERT INTO Products VALUES (14030001, 'Креветки', '', 'EliteFish','500г');
INSERT INTO Products VALUES (14030002, 'Мидии', '', 'Vici','500г');


INSERT INTO productsinstore VALUES ('02003',14030001,500,2200);
INSERT INTO productsinstore VALUES ('02002',14030001,500,2200);
INSERT INTO productsinstore VALUES ('01001',14030001,500,2400);
INSERT INTO productsinstore VALUES ('01003',14030001,500,2400);
INSERT INTO productsinstore VALUES ('01002',14030001,500,2400);
INSERT INTO productsinstore VALUES ('02001',14030001,500,2200);
INSERT INTO productsinstore VALUES ('02003',14030002,300,3190);
INSERT INTO productsinstore VALUES ('02002',14030002,300,3190);
INSERT INTO productsinstore VALUES ('01001',14030002,300,2949);
INSERT INTO productsinstore VALUES ('01003',14030002,300,2949);
INSERT INTO productsinstore VALUES ('01002',14030002,300,2949);
INSERT INTO productsinstore VALUES ('02001',14030002,300,3190);

-- Икра
INSERT INTO Products VALUES (14040001, 'Икра лососевая', '', 'Айсберг8','500г');
INSERT INTO Products VALUES (14040002, 'Икра горбуши', '', 'Айсберг8','400г');


INSERT INTO productsinstore VALUES ('02003',14040001,500,24000);
INSERT INTO productsinstore VALUES ('02002',14040001,500,24000);
INSERT INTO productsinstore VALUES ('01001',14040001,500,24000);
INSERT INTO productsinstore VALUES ('01003',14040001,500,24000);
INSERT INTO productsinstore VALUES ('02003',14040002,300,14000);
INSERT INTO productsinstore VALUES ('01003',14040002,300,15000);
INSERT INTO productsinstore VALUES ('01002',14040002,300,15000);
INSERT INTO productsinstore VALUES ('02001',14040002,300,14000);

-- Хлебные изделия
INSERT INTO Products VALUES (15010001, 'Хлеб формовой', '', 'Аксай','550г');
INSERT INTO Products VALUES (15010002, 'Хлеб Ржаной', '', 'Аксай','200г');
INSERT INTO Products VALUES (15010003, 'Лаваш', '', 'Edgar','280г');
INSERT INTO Products VALUES (15010004, 'Батон', '', 'Аксай','400г');

INSERT INTO productsinstore VALUES ('02003',15010001,500,125);
INSERT INTO productsinstore VALUES ('02002',15010001,500,125);
INSERT INTO productsinstore VALUES ('01001',15010001,500,125);
INSERT INTO productsinstore VALUES ('01003',15010001,500,125);
INSERT INTO productsinstore VALUES ('01002',15010001,500,125);
INSERT INTO productsinstore VALUES ('02001',15010001,500,125);
INSERT INTO productsinstore VALUES ('02003',15010002,300,110);
INSERT INTO productsinstore VALUES ('02002',15010002,300,110);
INSERT INTO productsinstore VALUES ('01001',15010002,300,110);
INSERT INTO productsinstore VALUES ('01003',15010002,300,110);
INSERT INTO productsinstore VALUES ('01002',15010002,300,110);
INSERT INTO productsinstore VALUES ('02001',15010002,300,110);

INSERT INTO productsinstore VALUES ('02003',15010003,500,207);
INSERT INTO productsinstore VALUES ('02002',15010003,500,207);
INSERT INTO productsinstore VALUES ('01001',15010003,500,207);
INSERT INTO productsinstore VALUES ('01003',15010003,500,207);
INSERT INTO productsinstore VALUES ('01002',15010003,500,207);
INSERT INTO productsinstore VALUES ('02001',15010003,500,207);
INSERT INTO productsinstore VALUES ('02003',15010004,300,130);
INSERT INTO productsinstore VALUES ('02002',15010004,300,130);
INSERT INTO productsinstore VALUES ('01001',15010004,300,130);
INSERT INTO productsinstore VALUES ('01003',15010004,300,130);
INSERT INTO productsinstore VALUES ('01002',15010004,300,130);
INSERT INTO productsinstore VALUES ('02001',15010004,300,130);

-- Каши,мюсли и готовые завтраки
INSERT INTO Products VALUES (16010001, 'Готовый завтрак', 'Nestle', 'Nesquik','500г');
INSERT INTO Products VALUES (16010002, 'Геркулес', '', 'Царь','400г');

INSERT INTO productsinstore VALUES ('02003',16010001,500,1059);
INSERT INTO productsinstore VALUES ('02002',16010001,500,1059);
INSERT INTO productsinstore VALUES ('01001',16010001,500,1159);
INSERT INTO productsinstore VALUES ('01003',16010001,500,1159);
INSERT INTO productsinstore VALUES ('01002',16010001,500,1159);
INSERT INTO productsinstore VALUES ('02001',16010001,500,1059);
INSERT INTO productsinstore VALUES ('02003',16010002,300,319);
INSERT INTO productsinstore VALUES ('02002',16010002,300,319);
INSERT INTO productsinstore VALUES ('01001',16010002,300,410);
INSERT INTO productsinstore VALUES ('01003',16010002,300,410);
INSERT INTO productsinstore VALUES ('01002',16010002,300,410);
INSERT INTO productsinstore VALUES ('02001',16010002,300,319);

-- Каши,мюсли и готовые завтраки
INSERT INTO Products VALUES (16020001, 'Макароны', '', 'Султан','400г');
INSERT INTO Products VALUES (16020002, 'Макароны', '', 'Makfa','400г');

INSERT INTO productsinstore VALUES ('02003',16020001,500,270);
INSERT INTO productsinstore VALUES ('02002',16020001,500,270);
INSERT INTO productsinstore VALUES ('01001',16020001,500,290);
INSERT INTO productsinstore VALUES ('01003',16020001,500,290);
INSERT INTO productsinstore VALUES ('01002',16020001,500,290);
INSERT INTO productsinstore VALUES ('02001',16020001,500,270);
INSERT INTO productsinstore VALUES ('02003',16020002,300,215);
INSERT INTO productsinstore VALUES ('02002',16020002,300,215);
INSERT INTO productsinstore VALUES ('01001',16020002,300,225);
INSERT INTO productsinstore VALUES ('01003',16020002,300,225);
INSERT INTO productsinstore VALUES ('01002',16020002,300,225);
INSERT INTO productsinstore VALUES ('02001',16020002,300,215);

-- Каши,мюсли и готовые завтраки
INSERT INTO Products VALUES (16030001, 'Рис', '', 'Арнау','5кг');
INSERT INTO Products VALUES (16030002, 'Гречка', '', 'Пассим','800г');

INSERT INTO productsinstore VALUES ('02003',16030001,500,1875);
INSERT INTO productsinstore VALUES ('02002',16030001,500,1875);
INSERT INTO productsinstore VALUES ('01001',16030001,500,1899);
INSERT INTO productsinstore VALUES ('01003',16030001,500,1899);
INSERT INTO productsinstore VALUES ('01002',16030001,500,1899);
INSERT INTO productsinstore VALUES ('02001',16030001,500,1875);
INSERT INTO productsinstore VALUES ('02003',16030002,300,679);
INSERT INTO productsinstore VALUES ('02002',16030002,300,679);
INSERT INTO productsinstore VALUES ('01001',16030002,300,699);
INSERT INTO productsinstore VALUES ('01003',16030002,300,699);
INSERT INTO productsinstore VALUES ('01002',16030002,300,699);
INSERT INTO productsinstore VALUES ('02001',16030002,300,679);

-- Лапшы
INSERT INTO Products VALUES (16040001, 'Лапша быстрого приготовления', '', 'Big Bon','75г');
INSERT INTO Products VALUES (16040002, 'Лапша быстрого приготовления', '', 'Роллтон','60г');

INSERT INTO productsinstore VALUES ('02003',16040001,500,105);
INSERT INTO productsinstore VALUES ('02002',16040001,500,105);
INSERT INTO productsinstore VALUES ('01001',16040001,500,109);
INSERT INTO productsinstore VALUES ('01003',16040001,500,109);
INSERT INTO productsinstore VALUES ('01002',16040001,500,109);
INSERT INTO productsinstore VALUES ('02001',16040001,500,105);
INSERT INTO productsinstore VALUES ('02003',16040002,300,82);
INSERT INTO productsinstore VALUES ('02002',16040002,300,82);
INSERT INTO productsinstore VALUES ('01001',16040002,300,89);
INSERT INTO productsinstore VALUES ('01003',16040002,300,89);
INSERT INTO productsinstore VALUES ('01002',16040002,300,89);
INSERT INTO productsinstore VALUES ('02001',16040002,300,82);


-- Соки, нектары
INSERT INTO Products VALUES (17010001, 'Сок', '', 'DaDa','1.9л');
INSERT INTO Products VALUES (17010002, 'Cок', '', 'Gracia','0.95л');

INSERT INTO productsinstore VALUES ('02003',17010001,500,653);
INSERT INTO productsinstore VALUES ('02002',17010001,500,653);
INSERT INTO productsinstore VALUES ('01001',17010001,500,659);
INSERT INTO productsinstore VALUES ('01003',17010001,500,659);
INSERT INTO productsinstore VALUES ('01002',17010001,500,659);
INSERT INTO productsinstore VALUES ('02001',17010001,500,653);
INSERT INTO productsinstore VALUES ('02003',17010002,300,405);
INSERT INTO productsinstore VALUES ('02002',17010002,300,405);
INSERT INTO productsinstore VALUES ('01001',17010002,300,415);
INSERT INTO productsinstore VALUES ('01003',17010002,300,415);
INSERT INTO productsinstore VALUES ('01002',17010002,300,415);
INSERT INTO productsinstore VALUES ('02001',17010002,300,405);

-- Газированные напитки
INSERT INTO Products VALUES (17020001, 'Газированный напиток', '', 'Coca-Cola','2л');
INSERT INTO Products VALUES (17020002, 'Газированный напиток', '', 'Буратино','2л');
INSERT INTO Products VALUES (17020003, 'Газированный напиток', '', 'Sprite','2л');
INSERT INTO Products VALUES (17020004, 'Газированный напиток', '', 'Fanta','2л');
INSERT INTO productsinstore VALUES ('02003',17020001,500,475);
INSERT INTO productsinstore VALUES ('02002',17020001,500,475);
INSERT INTO productsinstore VALUES ('01001',17020001,500,495);
INSERT INTO productsinstore VALUES ('01003',17020001,500,495);
INSERT INTO productsinstore VALUES ('01002',17020001,500,495);
INSERT INTO productsinstore VALUES ('02001',17020001,500,475);
INSERT INTO productsinstore VALUES ('02003',17020002,300,353);
INSERT INTO productsinstore VALUES ('02002',17020002,300,353);
INSERT INTO productsinstore VALUES ('01001',17020002,300,353);
INSERT INTO productsinstore VALUES ('01003',17020002,300,353);
INSERT INTO productsinstore VALUES ('01002',17020002,300,353);
INSERT INTO productsinstore VALUES ('02001',17020002,300,353);

INSERT INTO productsinstore VALUES ('02003',17020003,500,375);
INSERT INTO productsinstore VALUES ('02002',17020003,500,375);
INSERT INTO productsinstore VALUES ('01001',17020003,500,395);
INSERT INTO productsinstore VALUES ('01003',17020003,500,395);
INSERT INTO productsinstore VALUES ('01002',17020003,500,395);
INSERT INTO productsinstore VALUES ('02001',17020003,500,375);
INSERT INTO productsinstore VALUES ('02003',17020004,300,347);
INSERT INTO productsinstore VALUES ('02002',17020004,300,347);
INSERT INTO productsinstore VALUES ('01001',17020004,300,347);
INSERT INTO productsinstore VALUES ('01003',17020004,300,347);
INSERT INTO productsinstore VALUES ('01002',17020004,300,347);
INSERT INTO productsinstore VALUES ('02001',17020004,300,347);

-- Вода
INSERT INTO Products VALUES (17030001, 'Вода Минеральная', '', 'Borjomi','0.5л');
INSERT INTO Products VALUES (17030002, 'Вода без газа', '', 'Samal','0.5л');

INSERT INTO productsinstore VALUES ('02003',17030001,500,345);
INSERT INTO productsinstore VALUES ('02002',17030001,500,345);
INSERT INTO productsinstore VALUES ('01001',17030001,500,365);
INSERT INTO productsinstore VALUES ('01003',17030001,500,365);
INSERT INTO productsinstore VALUES ('01002',17030001,500,365);
INSERT INTO productsinstore VALUES ('02001',17030001,500,345);
INSERT INTO productsinstore VALUES ('02003',17030002,300,125);
INSERT INTO productsinstore VALUES ('02002',17030002,300,125);
INSERT INTO productsinstore VALUES ('01001',17030002,300,135);
INSERT INTO productsinstore VALUES ('01003',17030002,300,135);
INSERT INTO productsinstore VALUES ('01002',17030002,300,135);
INSERT INTO productsinstore VALUES ('02001',17030002,300,125);

-- Холодные чаи
INSERT INTO Products VALUES (17050001, 'Холодный чай', '', 'Maxi','1.2л');
INSERT INTO Products VALUES (17050002, 'Холодный чай', '', 'Fuse-tea','1л');

INSERT INTO productsinstore VALUES ('02003',17050001,500,269);
INSERT INTO productsinstore VALUES ('02002',17050001,500,269);
INSERT INTO productsinstore VALUES ('01001',17050001,500,289);
INSERT INTO productsinstore VALUES ('01003',17050001,500,289);
INSERT INTO productsinstore VALUES ('01002',17050001,500,289);
INSERT INTO productsinstore VALUES ('02001',17050001,500,269);
INSERT INTO productsinstore VALUES ('02003',17050002,300,239);
INSERT INTO productsinstore VALUES ('02002',17050002,300,239);
INSERT INTO productsinstore VALUES ('01001',17050002,300,249);
INSERT INTO productsinstore VALUES ('01003',17050002,300,249);
INSERT INTO productsinstore VALUES ('01002',17050002,300,249);
INSERT INTO productsinstore VALUES ('02001',17050002,300,239);

-- Конфеты
INSERT INTO Products VALUES (18010001, 'Батончик', '', 'Рахат','300г');
INSERT INTO Products VALUES (18010002, 'Маска', '', 'Рахат','300г');

INSERT INTO productsinstore VALUES ('02003',18010001,500,372);
INSERT INTO productsinstore VALUES ('02002',18010001,500,372);
INSERT INTO productsinstore VALUES ('01001',18010001,500,392);
INSERT INTO productsinstore VALUES ('01003',18010001,500,392);
INSERT INTO productsinstore VALUES ('01002',18010001,500,392);
INSERT INTO productsinstore VALUES ('02001',18010001,500,372);
INSERT INTO productsinstore VALUES ('02003',18010002,300,603);
INSERT INTO productsinstore VALUES ('02002',18010002,300,603);
INSERT INTO productsinstore VALUES ('01001',18010002,300,613);
INSERT INTO productsinstore VALUES ('01003',18010002,300,613);
INSERT INTO productsinstore VALUES ('01002',18010002,300,613);
INSERT INTO productsinstore VALUES ('02001',18010002,300,603);

-- Шоколадные батончики
INSERT INTO Products VALUES (18020001, 'Батончик', '', 'Snickers','50.5г');
INSERT INTO Products VALUES (18020002, 'Плитка шоколада', '', 'Alpen Gold','85г');

INSERT INTO productsinstore VALUES ('02003',18020001,500,155);
INSERT INTO productsinstore VALUES ('02002',18020001,500,155);
INSERT INTO productsinstore VALUES ('01001',18020001,500,160);
INSERT INTO productsinstore VALUES ('01003',18020001,500,160);
INSERT INTO productsinstore VALUES ('01002',18020001,500,160);
INSERT INTO productsinstore VALUES ('02001',18020001,500,155);
INSERT INTO productsinstore VALUES ('02003',18020002,300,387);
INSERT INTO productsinstore VALUES ('02002',18020002,300,387);
INSERT INTO productsinstore VALUES ('01001',18020002,300,390);
INSERT INTO productsinstore VALUES ('01003',18020002,300,390);
INSERT INTO productsinstore VALUES ('01002',18020002,300,390);
INSERT INTO productsinstore VALUES ('02001',18020002,300,387);

-- Печенье
INSERT INTO Products VALUES (18030001, 'Печенье сливочное', '', 'Рахат','300г');
INSERT INTO Products VALUES (18030002, 'Печенье Бенье', '', 'A-Product','300г');

INSERT INTO productsinstore VALUES ('02003',18030001,500,205);
INSERT INTO productsinstore VALUES ('02002',18030001,500,205);
INSERT INTO productsinstore VALUES ('01001',18030001,500,215);
INSERT INTO productsinstore VALUES ('01003',18030001,500,215);
INSERT INTO productsinstore VALUES ('01002',18030001,500,215);
INSERT INTO productsinstore VALUES ('02001',18030001,500,205);
INSERT INTO productsinstore VALUES ('02003',18030002,300,229);
INSERT INTO productsinstore VALUES ('02002',18030002,300,229);
INSERT INTO productsinstore VALUES ('01001',18030002,300,249);
INSERT INTO productsinstore VALUES ('01003',18030002,300,249);
INSERT INTO productsinstore VALUES ('01002',18030002,300,249);
INSERT INTO productsinstore VALUES ('02001',18030002,300,229);
--Мороженое
INSERT INTO Products VALUES (18070001, 'Пломбир', '', 'Золотой Стандарт','86г');
INSERT INTO Products VALUES (18070002, 'Сливочное мороженое', '', 'Coppa Italia','400г');

INSERT INTO productsinstore VALUES ('02003',18070001,500,265);
INSERT INTO productsinstore VALUES ('02002',18070001,500,265);
INSERT INTO productsinstore VALUES ('01001',18070001,500,269);
INSERT INTO productsinstore VALUES ('01003',18070001,500,269);
INSERT INTO productsinstore VALUES ('01002',18070001,500,269);
INSERT INTO productsinstore VALUES ('02001',18070001,500,265);
INSERT INTO productsinstore VALUES ('02003',18070002,300,765);
INSERT INTO productsinstore VALUES ('02002',18070002,300,765);
INSERT INTO productsinstore VALUES ('01001',18070002,300,785);
INSERT INTO productsinstore VALUES ('01003',18070002,300,785);
INSERT INTO productsinstore VALUES ('01002',18070002,300,785);
INSERT INTO productsinstore VALUES ('02001',18070002,300,765);

--Жевательная резина
INSERT INTO Products VALUES (18100001, 'Жевательная резина', '', 'Orbit','10ш');
INSERT INTO Products VALUES (18100002, 'Жевательная резина', '', 'Dirol','10ш');

INSERT INTO productsinstore VALUES ('02003',18100001,500,139);
INSERT INTO productsinstore VALUES ('02002',18100001,500,139);
INSERT INTO productsinstore VALUES ('01001',18100001,500,149);
INSERT INTO productsinstore VALUES ('01003',18100001,500,149);
INSERT INTO productsinstore VALUES ('01002',18100001,500,149);
INSERT INTO productsinstore VALUES ('02001',18100001,500,139);
INSERT INTO productsinstore VALUES ('02003',18100002,300,159);
INSERT INTO productsinstore VALUES ('02002',18100002,300,159);
INSERT INTO productsinstore VALUES ('01001',18100002,300,159);
INSERT INTO productsinstore VALUES ('01003',18100002,300,159);
INSERT INTO productsinstore VALUES ('01002',18100002,300,159);
INSERT INTO productsinstore VALUES ('02001',18100002,300,159);

--Ингредиенты для выпечки
INSERT INTO Products VALUES (19010001, 'Сода', '', '','500г');
INSERT INTO Products VALUES (19010002, 'Разрыхлитель', '', 'Омега','10г');

INSERT INTO productsinstore VALUES ('02003',19010001,500,139);
INSERT INTO productsinstore VALUES ('02002',19010001,500,139);
INSERT INTO productsinstore VALUES ('01001',19010001,500,149);
INSERT INTO productsinstore VALUES ('01003',19010001,500,149);
INSERT INTO productsinstore VALUES ('01002',19010001,500,149);
INSERT INTO productsinstore VALUES ('02001',19010001,500,139);
INSERT INTO productsinstore VALUES ('02003',19010002,300,39);
INSERT INTO productsinstore VALUES ('02002',19010002,300,39);
INSERT INTO productsinstore VALUES ('01001',19010002,300,39);
INSERT INTO productsinstore VALUES ('01003',19010002,300,39);
INSERT INTO productsinstore VALUES ('01002',19010002,300,39);
INSERT INTO productsinstore VALUES ('02001',19010002,300,39);

--Мука
INSERT INTO Products VALUES (19020001, 'Мука', '', 'Цесна','5кг');
INSERT INTO Products VALUES (19020002, 'Мука', '', 'Султан','5кг');

INSERT INTO productsinstore VALUES ('02003',19020001,500,1512);
INSERT INTO productsinstore VALUES ('02002',19020001,500,1512);
INSERT INTO productsinstore VALUES ('01001',19020001,500,1529);
INSERT INTO productsinstore VALUES ('01003',19020001,500,1529);
INSERT INTO productsinstore VALUES ('01002',19020001,500,1529);
INSERT INTO productsinstore VALUES ('02001',19020001,500,1512);
INSERT INTO productsinstore VALUES ('02003',19020002,300,1559);
INSERT INTO productsinstore VALUES ('02002',19020002,300,1559);
INSERT INTO productsinstore VALUES ('01001',19020002,300,1599);
INSERT INTO productsinstore VALUES ('01003',19020002,300,1599);
INSERT INTO productsinstore VALUES ('01002',19020002,300,1599);
INSERT INTO productsinstore VALUES ('02001',19020002,300,1559);

--Декор для выпечки
INSERT INTO Products VALUES (19030001, 'Сахарная пудра', '', 'Омега','200г');
INSERT INTO Products VALUES (19030002, 'Мак пищевой', '', 'Омега','50г');

INSERT INTO productsinstore VALUES ('02003',19030001,500,169);
INSERT INTO productsinstore VALUES ('02002',19030001,500,169);
INSERT INTO productsinstore VALUES ('01001',19030001,500,179);
INSERT INTO productsinstore VALUES ('01003',19030001,500,179);
INSERT INTO productsinstore VALUES ('01002',19030001,500,179);
INSERT INTO productsinstore VALUES ('02001',19030001,500,169);
INSERT INTO productsinstore VALUES ('02003',19030002,300,289);
INSERT INTO productsinstore VALUES ('02002',19030002,300,289);
INSERT INTO productsinstore VALUES ('01001',19030002,300,299);
INSERT INTO productsinstore VALUES ('01003',19030002,300,299);
INSERT INTO productsinstore VALUES ('01002',19030002,300,299);
INSERT INTO productsinstore VALUES ('02001',19030002,300,289);

--Замороженые полуфабрикаты
INSERT INTO Products VALUES (20010001, 'Тесто слоеное', '', 'Алтан Сапа','1кг');
INSERT INTO Products VALUES (20010002, 'Пельмени', '', 'Baron','400г');

INSERT INTO productsinstore VALUES ('02003',20010001,500,567);
INSERT INTO productsinstore VALUES ('02002',20010001,500,567);
INSERT INTO productsinstore VALUES ('01001',20010001,500,599);
INSERT INTO productsinstore VALUES ('01003',20010001,500,599);
INSERT INTO productsinstore VALUES ('01002',20010001,500,599);
INSERT INTO productsinstore VALUES ('02001',20010001,500,567);
INSERT INTO productsinstore VALUES ('02003',20010002,300,675);
INSERT INTO productsinstore VALUES ('02002',20010002,300,675);
INSERT INTO productsinstore VALUES ('01001',20010002,300,695);
INSERT INTO productsinstore VALUES ('01003',20010002,300,695);
INSERT INTO productsinstore VALUES ('01002',20010002,300,695);
INSERT INTO productsinstore VALUES ('02001',20010002,300,675);

--замороженные овощи и т.д.
INSERT INTO Products VALUES (20020001, 'Шампиньоны', '', 'Vici','400г');
INSERT INTO Products VALUES (20020002, 'Мексиканская смесь', '', 'Vici','400г');

INSERT INTO productsinstore VALUES ('02003',20020001,500,745);
INSERT INTO productsinstore VALUES ('02002',20020001,500,745);
INSERT INTO productsinstore VALUES ('01001',20020001,500,775);
INSERT INTO productsinstore VALUES ('01003',20020001,500,775);
INSERT INTO productsinstore VALUES ('01002',20020001,500,775);
INSERT INTO productsinstore VALUES ('02001',20020001,500,745);
INSERT INTO productsinstore VALUES ('02003',20020002,300,885);
INSERT INTO productsinstore VALUES ('02002',20020002,300,885);
INSERT INTO productsinstore VALUES ('01001',20020002,300,895);
INSERT INTO productsinstore VALUES ('01003',20020002,300,895);
INSERT INTO productsinstore VALUES ('01002',20020002,300,895);
INSERT INTO productsinstore VALUES ('02001',20020002,300,885);

--замороженная еда и т.д.
INSERT INTO Products VALUES (20030001, 'Пицца Пепперони', '', 'Vici','300г');
INSERT INTO Products VALUES (20030002, 'Крылышки', '', 'Горячая штучка','300г');

INSERT INTO productsinstore VALUES ('02003',20030001,500,1289);
INSERT INTO productsinstore VALUES ('02002',20030001,500,1289);
INSERT INTO productsinstore VALUES ('01001',20030001,500,1299);
INSERT INTO productsinstore VALUES ('01003',20030001,500,1299);
INSERT INTO productsinstore VALUES ('01002',20030001,500,1299);
INSERT INTO productsinstore VALUES ('02001',20030001,500,1289);
INSERT INTO productsinstore VALUES ('02003',20030002,300,939);
INSERT INTO productsinstore VALUES ('02002',20030002,300,939);
INSERT INTO productsinstore VALUES ('01001',20030002,300,999);
INSERT INTO productsinstore VALUES ('01003',20030002,300,999);
INSERT INTO productsinstore VALUES ('01002',20030002,300,999);
INSERT INTO productsinstore VALUES ('02001',20030002,300,939);

--замороженные ягоды и фрукты и т.д.
INSERT INTO Products VALUES (20040001, 'Смесь Компотная', '', 'Vici','300г');
INSERT INTO Products VALUES (20040002, 'Вишня без косточек', '', 'Hortex','300г');

INSERT INTO productsinstore VALUES ('02003',20040001,500,1189);
INSERT INTO productsinstore VALUES ('02002',20040001,500,1189);
INSERT INTO productsinstore VALUES ('01001',20040001,500,1199);
INSERT INTO productsinstore VALUES ('01003',20040001,500,1199);
INSERT INTO productsinstore VALUES ('01002',20040001,500,1199);
INSERT INTO productsinstore VALUES ('02001',20040001,500,1189);
INSERT INTO productsinstore VALUES ('02003',20040002,300,949);
INSERT INTO productsinstore VALUES ('02002',20040002,300,949);
INSERT INTO productsinstore VALUES ('01001',20040002,300,979);
INSERT INTO productsinstore VALUES ('01003',20040002,300,979);
INSERT INTO productsinstore VALUES ('01002',20040002,300,979);
INSERT INTO productsinstore VALUES ('02001',20040002,300,949);

--соусы и кетчупы и т.д.
INSERT INTO Products VALUES (21010001, 'Соус Кобра', '', 'Цин-Каз','345г');
INSERT INTO Products VALUES (21010002, 'Кетчуп', '', '3 Желания','450г');

INSERT INTO productsinstore VALUES ('02003',21010001,500,389);
INSERT INTO productsinstore VALUES ('02002',21010001,500,389);
INSERT INTO productsinstore VALUES ('01001',21010001,500,399);
INSERT INTO productsinstore VALUES ('01003',21010001,500,399);
INSERT INTO productsinstore VALUES ('01002',21010001,500,399);
INSERT INTO productsinstore VALUES ('02001',21010001,500,389);
INSERT INTO productsinstore VALUES ('02003',21010002,300,349);
INSERT INTO productsinstore VALUES ('02002',21010002,300,349);
INSERT INTO productsinstore VALUES ('01001',21010002,300,379);
INSERT INTO productsinstore VALUES ('01003',21010002,300,379);
INSERT INTO productsinstore VALUES ('01002',21010002,300,379);
INSERT INTO productsinstore VALUES ('02001',21010002,300,349);

--растительные масла и т.д.
INSERT INTO Products VALUES (21020001, 'Подсолнечное Масло', '', 'Шедевр','1л');
INSERT INTO Products VALUES (21020002, 'Оливковое Масло', '', 'Maestro de Oliva','0.25л');

INSERT INTO productsinstore VALUES ('02003',21020001,500,820);
INSERT INTO productsinstore VALUES ('02002',21020001,500,820);
INSERT INTO productsinstore VALUES ('01001',21020001,500,840);
INSERT INTO productsinstore VALUES ('01003',21020001,500,840);
INSERT INTO productsinstore VALUES ('01002',21020001,500,840);
INSERT INTO productsinstore VALUES ('02001',21020001,500,820);
INSERT INTO productsinstore VALUES ('02003',21020002,300,1849);
INSERT INTO productsinstore VALUES ('02002',21020002,300,1849);
INSERT INTO productsinstore VALUES ('01001',21020002,300,1899);
INSERT INTO productsinstore VALUES ('01003',21020002,300,1899);
INSERT INTO productsinstore VALUES ('01002',21020002,300,1899);
INSERT INTO productsinstore VALUES ('02001',21020002,300,1849);

--майонез
INSERT INTO Products VALUES (21040001, 'Майонез', '', '3 Желания','380г');
INSERT INTO Products VALUES (21040002, 'Майонез', '', 'Махеевь','770г');

INSERT INTO productsinstore VALUES ('02003',21040001,500,399);
INSERT INTO productsinstore VALUES ('02002',21040001,500,399);
INSERT INTO productsinstore VALUES ('01001',21040001,500,399);
INSERT INTO productsinstore VALUES ('01003',21040001,500,399);
INSERT INTO productsinstore VALUES ('01002',21040001,500,399);
INSERT INTO productsinstore VALUES ('02001',21040001,500,399);
INSERT INTO productsinstore VALUES ('02003',21040002,300,989);
INSERT INTO productsinstore VALUES ('02002',21040002,300,989);
INSERT INTO productsinstore VALUES ('01001',21040002,300,999);
INSERT INTO productsinstore VALUES ('01003',21040002,300,999);
INSERT INTO productsinstore VALUES ('01002',21040002,300,999);
INSERT INTO productsinstore VALUES ('02001',21040002,300,989);

--Специи и Приправа
INSERT INTO Products VALUES (22010001, 'Перец черный молотый', '', 'Омега','100г');
INSERT INTO Products VALUES (22010002, 'Приправа для плова', '', 'Омега','20г');

INSERT INTO productsinstore VALUES ('02003',22010001,500,359);
INSERT INTO productsinstore VALUES ('02002',22010001,500,359);
INSERT INTO productsinstore VALUES ('01001',22010001,500,359);
INSERT INTO productsinstore VALUES ('01003',22010001,500,359);
INSERT INTO productsinstore VALUES ('01002',22010001,500,359);
INSERT INTO productsinstore VALUES ('02001',22010001,500,359);
INSERT INTO productsinstore VALUES ('02003',22010002,300,49);
INSERT INTO productsinstore VALUES ('02002',22010002,300,49);
INSERT INTO productsinstore VALUES ('01001',22010002,300,49);
INSERT INTO productsinstore VALUES ('01003',22010002,300,49);
INSERT INTO productsinstore VALUES ('01002',22010002,300,49);
INSERT INTO productsinstore VALUES ('02001',22010002,300,49);

--Сахары и заменители
INSERT INTO Products VALUES (22030001, 'Сахар', '', '','1кг');
INSERT INTO Products VALUES (22030002, 'Сахар Рафинад', '', 'Арман','500г');

INSERT INTO productsinstore VALUES ('02003',22030001,500,339);
INSERT INTO productsinstore VALUES ('02002',22030001,500,349);
INSERT INTO productsinstore VALUES ('01001',22030001,500,349);
INSERT INTO productsinstore VALUES ('01003',22030001,500,349);
INSERT INTO productsinstore VALUES ('01002',22030001,500,339);
INSERT INTO productsinstore VALUES ('02001',22030001,500,339);
INSERT INTO productsinstore VALUES ('02003',22030002,300,260);
INSERT INTO productsinstore VALUES ('02002',22030002,300,260);
INSERT INTO productsinstore VALUES ('01001',22030002,300,280);
INSERT INTO productsinstore VALUES ('01003',22030002,300,280);
INSERT INTO productsinstore VALUES ('01002',22030002,300,280);
INSERT INTO productsinstore VALUES ('02001',22030002,300,260);

--Соль
INSERT INTO Products VALUES (22040001, 'Соль', '', 'Аралтуз','1кг');
INSERT INTO Products VALUES (22040002, 'Морская Соль', '', 'Mareman','1кг');

INSERT INTO productsinstore VALUES ('02003',22040001,500,60);
INSERT INTO productsinstore VALUES ('02002',22040001,500,60);
INSERT INTO productsinstore VALUES ('01001',22040001,500,60);
INSERT INTO productsinstore VALUES ('01003',22040001,500,60);
INSERT INTO productsinstore VALUES ('01002',22040001,500,60);
INSERT INTO productsinstore VALUES ('02001',22040001,500,60);
INSERT INTO productsinstore VALUES ('02003',22040002,300,315);
INSERT INTO productsinstore VALUES ('02002',22040002,300,315);
INSERT INTO productsinstore VALUES ('01001',22040002,300,325);
INSERT INTO productsinstore VALUES ('01003',22040002,300,325);
INSERT INTO productsinstore VALUES ('01002',22040002,300,325);
INSERT INTO productsinstore VALUES ('02001',22040002,300,315);

--Овощная Консервация
INSERT INTO Products VALUES (23020001, 'Лечо в Томатном Соусе', '', 'Цин-Каз','680г');
INSERT INTO Products VALUES (23020002, 'Кукуруза Сладкая', '', 'Bonduelle','425мл');

INSERT INTO productsinstore VALUES ('02003',23020001,500,519);
INSERT INTO productsinstore VALUES ('02002',23020001,500,519);
INSERT INTO productsinstore VALUES ('01001',23020001,500,529);
INSERT INTO productsinstore VALUES ('01003',23020001,500,529);
INSERT INTO productsinstore VALUES ('01002',23020001,500,529);
INSERT INTO productsinstore VALUES ('02001',23020001,500,519);
INSERT INTO productsinstore VALUES ('02003',23020002,300,519);
INSERT INTO productsinstore VALUES ('02002',23020002,300,519);
INSERT INTO productsinstore VALUES ('01001',23020002,300,519);
INSERT INTO productsinstore VALUES ('01003',23020002,300,519);
INSERT INTO productsinstore VALUES ('01002',23020002,300,519);
INSERT INTO productsinstore VALUES ('02001',23020002,300,519);

--Варенье и джемы
INSERT INTO Products VALUES (23040001, 'Джем', '', 'Махеевь','300г');
INSERT INTO Products VALUES (23040002, 'Варенье', '', 'Sladovar','510г');

INSERT INTO productsinstore VALUES ('02003',23040001,500,509);
INSERT INTO productsinstore VALUES ('02002',23040001,500,509);
INSERT INTO productsinstore VALUES ('01001',23040001,500,529);
INSERT INTO productsinstore VALUES ('01003',23040001,500,529);
INSERT INTO productsinstore VALUES ('01002',23040001,500,529);
INSERT INTO productsinstore VALUES ('02001',23040001,500,509);
INSERT INTO productsinstore VALUES ('02003',23040002,300,1059);
INSERT INTO productsinstore VALUES ('02002',23040002,300,1059);
INSERT INTO productsinstore VALUES ('01001',23040002,300,1099);
INSERT INTO productsinstore VALUES ('01003',23040002,300,1099);
INSERT INTO productsinstore VALUES ('01002',23040002,300,1099);
INSERT INTO productsinstore VALUES ('02001',23040002,300,1059);

--Томатная Паста
INSERT INTO Products VALUES (23090001, 'Томатная Паста', '', 'Цин-Каз','720г');
INSERT INTO Products VALUES (23090002, 'Томатная Паста', '', 'Масло-Дел','720г');

INSERT INTO productsinstore VALUES ('02003',23090001,500,499);
INSERT INTO productsinstore VALUES ('02002',23090001,500,499);
INSERT INTO productsinstore VALUES ('01001',23090001,500,499);
INSERT INTO productsinstore VALUES ('01003',23090001,500,499);
INSERT INTO productsinstore VALUES ('01002',23090001,500,499);
INSERT INTO productsinstore VALUES ('02001',23090001,500,499);
INSERT INTO productsinstore VALUES ('02003',23090002,300,560);
INSERT INTO productsinstore VALUES ('02002',23090002,300,560);
INSERT INTO productsinstore VALUES ('01001',23090002,300,590);
INSERT INTO productsinstore VALUES ('01003',23090002,300,590);
INSERT INTO productsinstore VALUES ('01002',23090002,300,590);
INSERT INTO productsinstore VALUES ('02001',23090002,300,560);

--Чаи
INSERT INTO Products VALUES (24010001, 'Черный Чай', '', 'Champion','500г');
INSERT INTO Products VALUES (24010002, 'Черный Чай', '', 'Симба','250г');

INSERT INTO productsinstore VALUES ('02003',24010001,500,1886);
INSERT INTO productsinstore VALUES ('02002',24010001,500,1886);
INSERT INTO productsinstore VALUES ('01001',24010001,500,1899);
INSERT INTO productsinstore VALUES ('01003',24010001,500,1899);
INSERT INTO productsinstore VALUES ('01002',24010001,500,1899);
INSERT INTO productsinstore VALUES ('02001',24010001,500,1886);
INSERT INTO productsinstore VALUES ('02003',24010002,300,735);
INSERT INTO productsinstore VALUES ('02002',24010002,300,735);
INSERT INTO productsinstore VALUES ('01001',24010002,300,745);
INSERT INTO productsinstore VALUES ('01003',24010002,300,745);
INSERT INTO productsinstore VALUES ('01002',24010002,300,745);
INSERT INTO productsinstore VALUES ('02001',24010002,300,735);

--Кофе зерновой или молотый
INSERT INTO Products VALUES (24020001, 'Молотый Кофе', '', 'Jacobs','230г');
INSERT INTO Products VALUES (24020002, 'Молотый Кофе', '', 'Carte Noire','230г');

INSERT INTO productsinstore VALUES ('02003',24020001,500,999);
INSERT INTO productsinstore VALUES ('02002',24020001,500,999);
INSERT INTO productsinstore VALUES ('01001',24020001,500,999);
INSERT INTO productsinstore VALUES ('01003',24020001,500,999);
INSERT INTO productsinstore VALUES ('01002',24020001,500,999);
INSERT INTO productsinstore VALUES ('02001',24020001,500,999);
INSERT INTO productsinstore VALUES ('02003',24020002,300,1599);
INSERT INTO productsinstore VALUES ('02002',24020002,300,1599);
INSERT INTO productsinstore VALUES ('01001',24020002,300,1599);
INSERT INTO productsinstore VALUES ('01003',24020002,300,1599);
INSERT INTO productsinstore VALUES ('01002',24020002,300,1599);
INSERT INTO productsinstore VALUES ('02001',24020002,300,1599);

--Кофе растворимый
INSERT INTO Products VALUES (24030001, 'Растворимый Кофе', '', 'Jacobs','15г');
INSERT INTO Products VALUES (24030002, 'Растворимый Кофе', '', 'Nescafe','47.5г');

INSERT INTO productsinstore VALUES ('02003',24030001,500,589);
INSERT INTO productsinstore VALUES ('02002',24030001,500,589);
INSERT INTO productsinstore VALUES ('01001',24030001,500,599);
INSERT INTO productsinstore VALUES ('01003',24030001,500,599);
INSERT INTO productsinstore VALUES ('01002',24030001,500,599);
INSERT INTO productsinstore VALUES ('02001',24030001,500,589);
INSERT INTO productsinstore VALUES ('02003',24030002,300,1599);
INSERT INTO productsinstore VALUES ('02002',24030002,300,1599);
INSERT INTO productsinstore VALUES ('01001',24030002,300,1599);
INSERT INTO productsinstore VALUES ('01003',24030002,300,1599);
INSERT INTO productsinstore VALUES ('01002',24030002,300,1599);
INSERT INTO productsinstore VALUES ('02001',24030002,300,1599);

--Чипсы
INSERT INTO Products VALUES (25010001, 'Чипсы', '', 'Lays','150г');
INSERT INTO Products VALUES (25010002, 'Чипсы', '', 'Doritos','130г');

INSERT INTO productsinstore VALUES ('02003',25010001,500,489);
INSERT INTO productsinstore VALUES ('02002',25010001,500,489);
INSERT INTO productsinstore VALUES ('01001',25010001,500,499);
INSERT INTO productsinstore VALUES ('01003',25010001,500,499);
INSERT INTO productsinstore VALUES ('01002',25010001,500,499);
INSERT INTO productsinstore VALUES ('02001',25010001,500,489);
INSERT INTO productsinstore VALUES ('02003',25010002,300,525);
INSERT INTO productsinstore VALUES ('02002',25010002,300,525);
INSERT INTO productsinstore VALUES ('01001',25010002,300,545);
INSERT INTO productsinstore VALUES ('01003',25010002,300,545);
INSERT INTO productsinstore VALUES ('01002',25010002,300,545);
INSERT INTO productsinstore VALUES ('02001',25010002,300,525);

--Сухарики и гренки
INSERT INTO Products VALUES (25050001, 'Сухарики', '', 'Хрусteam','130г');
INSERT INTO Products VALUES (25050002, 'Сухарики', '', 'Кириешки','40г');

INSERT INTO productsinstore VALUES ('02003',25050001,500,162);
INSERT INTO productsinstore VALUES ('02002',25050001,500,162);
INSERT INTO productsinstore VALUES ('01001',25050001,500,169);
INSERT INTO productsinstore VALUES ('01003',25050001,500,169);
INSERT INTO productsinstore VALUES ('01002',25050001,500,169);
INSERT INTO productsinstore VALUES ('02001',25050001,500,162);
INSERT INTO productsinstore VALUES ('02003',25050002,300,59);
INSERT INTO productsinstore VALUES ('02002',25050002,300,59);
INSERT INTO productsinstore VALUES ('01001',25050002,300,59);
INSERT INTO productsinstore VALUES ('01003',25050002,300,59);
INSERT INTO productsinstore VALUES ('01002',25050002,300,59);
INSERT INTO productsinstore VALUES ('02001',25050002,300,59);

--Сухофрукты
INSERT INTO Products VALUES (25070001, 'Сухофрукт Изюм', '', 'Mcc Trade','200г');
INSERT INTO Products VALUES (25070002, 'Сухофрукт Курага', '', 'Mcc Trade','200г');

INSERT INTO productsinstore VALUES ('02003',25070001,500,389);
INSERT INTO productsinstore VALUES ('02002',25070001,500,389);
INSERT INTO productsinstore VALUES ('01001',25070001,500,399);
INSERT INTO productsinstore VALUES ('01003',25070001,500,399);
INSERT INTO productsinstore VALUES ('01002',25070001,500,399);
INSERT INTO productsinstore VALUES ('02001',25070001,500,389);
INSERT INTO productsinstore VALUES ('02003',25070002,300,635);
INSERT INTO productsinstore VALUES ('02002',25070002,300,635);
INSERT INTO productsinstore VALUES ('01001',25070002,300,645);
INSERT INTO productsinstore VALUES ('01003',25070002,300,645);
INSERT INTO productsinstore VALUES ('01002',25070002,300,645);
INSERT INTO productsinstore VALUES ('02001',25070002,300,635);

-- Purchase
begin;
insert into Orders values ('0000000001','03100201', 0, 0);
insert into ordered_items values ('0000000001', '02003',10040004,1);
insert into ordered_items values ('0000000001', '02003',10010002,2);
insert into ordered_items values ('0000000001', '02003',10030004,4);

select change_balance('0000000001');

-- update total sum
update Orders set total_sum = (select sum(ProductsInStore.cost * Ordered_items.count) from ordered_items, productsinstore
where ordered_items.id = '0000000001' and Ordered_items.store_id = ProductsInStore.store_id
and Ordered_items.upc = ProductsInStore.upc) - pay_by_bonus where id = '0000000001';
-- update bonus
update Customers set earned_bonus = earned_bonus + ((select total_sum from Orders where Orders.id = '0000000001') * 0.01) -
(select pay_by_bonus from Orders where Orders.id = '0000000001') where id = (select customer_id from Orders where Orders.id = '0000000001');
end;
--Receipt
select name, brand, count, cost, count * cost as total from products, Ordered_items, productsinstore
where Ordered_items.id = '0000000002' and ProductsInStore.upc = Products.upc
and Ordered_items.store_id = ProductsInStore.store_id and Ordered_items.upc = Products.upc;

-- Query of products in one group
select name,brand, variety from Products where upc between 16000000 and 17000000;

-- Purchase
begin;
insert into Orders values ('0000000002','00000000', 0, 0);
insert into ordered_items values ('0000000002', '02001',10010003,1);
insert into ordered_items values ('0000000002', '02001',10030003,4);
insert into ordered_items values ('0000000002', '02001',10040001,1);
insert into ordered_items values ('0000000002', '02001',10050001,2);
insert into ordered_items values ('0000000002', '02001',10080002,1);
insert into ordered_items values ('0000000002', '02001',10120001,1);
insert into ordered_items values ('0000000002', '02001',11010001,5);
insert into ordered_items values ('0000000002', '02001',11010002,5);
insert into ordered_items values ('0000000002', '02001',11010003,2);
insert into ordered_items values ('0000000002', '02001',11010004,2);
insert into ordered_items values ('0000000002', '02001',11010006,1);
insert into ordered_items values ('0000000002', '02001',11020002,1);
insert into ordered_items values ('0000000002', '02001',11020006,3);
insert into ordered_items values ('0000000002', '02001',12010001,1);
insert into ordered_items values ('0000000002', '02001',12020001,2);
insert into ordered_items values ('0000000002', '02001',13010001,2);
insert into ordered_items values ('0000000002', '02001',13010002,2);
insert into ordered_items values ('0000000002', '02001',13030001,3);
insert into ordered_items values ('0000000002', '02001',13030002,5);
insert into ordered_items values ('0000000002', '02001',15010001,2);
insert into ordered_items values ('0000000002', '02001',15010004,1);
insert into ordered_items values ('0000000002', '02001',16010001,1);
insert into ordered_items values ('0000000002', '02001',16020001,2);
insert into ordered_items values ('0000000002', '02001',16030001,1);
insert into ordered_items values ('0000000002', '02001',16030002,1);
insert into ordered_items values ('0000000002', '02001',17020001,1);
insert into ordered_items values ('0000000002', '02001',17010001,1);
insert into ordered_items values ('0000000002', '02001',18010002,4);
insert into ordered_items values ('0000000002', '02001',18030001,4);
insert into ordered_items values ('0000000002', '02001',19010002,1);
insert into ordered_items values ('0000000002', '02001',19020001,1);
insert into ordered_items values ('0000000002', '02001',19030001,1);
insert into ordered_items values ('0000000002', '02001',20010001,1);
insert into ordered_items values ('0000000002', '02001',21010002,1);
insert into ordered_items values ('0000000002', '02001',21020001,1);
insert into ordered_items values ('0000000002', '02001',21040001,1);
insert into ordered_items values ('0000000002', '02001',23090001,1);
insert into ordered_items values ('0000000002', '02001',24010001,1);
insert into ordered_items values ('0000000002', '02001',25010001,1);

select change_balance('0000000002');

update Orders set total_sum = (select sum(ProductsInStore.cost * Ordered_items.count) from ordered_items, productsinstore
where ordered_items.id = '0000000002' and Ordered_items.store_id = ProductsInStore.store_id
and Ordered_items.upc = ProductsInStore.upc) - pay_by_bonus where id = '0000000002';

update Customers set earned_bonus = earned_bonus + ((select total_sum from Orders where Orders.id = '0000000002') * 0.01) -
(select pay_by_bonus from Orders where Orders.id = '0000000002') where id = '0000000002';
end;


-- Purchase
--begin;

insert into Orders values ('0000000003','95121201', 0, 0);
insert into ordered_items values ('0000000003', '01002',11020002,1);
insert into ordered_items values ('0000000003', '01002',15010001,1);
insert into ordered_items values ('0000000003', '01002',18020002,1);
insert into ordered_items values ('0000000003', '01002',18100001,1);
insert into ordered_items values ('0000000003', '01002',25010002,1);

select change_balance('0000000003');


update Orders set total_sum = (select sum(ProductsInStore.cost * Ordered_items.count) from ordered_items, productsinstore
where ordered_items.id = '0000000003' and Ordered_items.store_id = ProductsInStore.store_id
and Ordered_items.upc = ProductsInStore.upc) - pay_by_bonus where id = '0000000003';

update Customers set earned_bonus = earned_bonus + ((select total_sum from Orders where Orders.id = '0000000003') * 0.01) -
(select pay_by_bonus from orders where Orders.id = '0000000003')
where id = (select customer_id from Orders where Orders.id = '0000000003');
--end;


-- order number 4
insert into Orders values ('0000000004','72012701', 0, 0);
insert into ordered_items values ('0000000004', '01001',18070001,2);
insert into ordered_items values ('0000000004', '01001',20010002,1);
insert into ordered_items values ('0000000004', '01001',17020001,1);
insert into ordered_items values ('0000000004', '01001',15010001,2);
insert into ordered_items values ('0000000004', '01001',10040004,1);



select change_balance('0000000004');

update Orders set total_sum = (select sum(ProductsInStore.cost * Ordered_items.count) from ordered_items, productsinstore
where ordered_items.id = '0000000004' and Ordered_items.store_id = ProductsInStore.store_id
and Ordered_items.upc = ProductsInStore.upc) - pay_by_bonus where id = '0000000004';

update Customers set earned_bonus = earned_bonus + ((select total_sum from Orders where Orders.id = '0000000004') * 0.01) -
(select pay_by_bonus from orders where Orders.id = '0000000004')
where id = (select customer_id from Orders where Orders.id = '0000000004');
--end;

-- order number 5
insert into Orders values ('0000000005','00000000', 0, 0);
insert into ordered_items values ('0000000005', '02003',18020001,8);
insert into ordered_items values ('0000000005', '02003',18070002,3);
select change_balance('0000000005');

update Orders set total_sum = (select sum(ProductsInStore.cost * Ordered_items.count) from ordered_items, productsinstore
where ordered_items.id = '0000000005' and Ordered_items.store_id = ProductsInStore.store_id
and Ordered_items.upc = ProductsInStore.upc) - pay_by_bonus where id = '0000000005';

update Customers set earned_bonus = earned_bonus + ((select total_sum from Orders where Orders.id = '0000000005') * 0.01) -
(select pay_by_bonus from orders where Orders.id = '0000000005')
where id = (select customer_id from Orders where Orders.id = '0000000005');
--end;


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

insert into Orders values ('0000000006','00000000', 0 ,0);
insert into Orders values ('0000000007','00000000', 0 ,0);
insert into Orders values ('0000000008','00000000', 0 ,0);
insert into Orders values ('0000000009','00000000', 0 ,0);
insert into Orders values ('0000000010','00000000', 0 ,0);
insert into Orders values ('0000000011','00000000', 0 ,0);
--
update Orders set total_sum = (select sum(ProductsInStore.cost * Ordered_items.count) from ordered_items, productsinstore
where ordered_items.id = '00000000014' and Ordered_items.store_id = ProductsInStore.store_id
and Ordered_items.upc = ProductsInStore.upc) - pay_by_bonus where id = '0000000014';
update Orders set total_sum = (select sum(ProductsInStore.cost * Ordered_items.count) from ordered_items, productsinstore
where ordered_items.id = '00000000015' and Ordered_items.store_id = ProductsInStore.store_id
and Ordered_items.upc = ProductsInStore.upc) - pay_by_bonus where id = '0000000015';
update Orders set total_sum = (select sum(ProductsInStore.cost * Ordered_items.count) from ordered_items, productsinstore
where ordered_items.id = '0000000006' and Ordered_items.store_id = ProductsInStore.store_id
and Ordered_items.upc = ProductsInStore.upc) - pay_by_bonus where id = '0000000006';
update Orders set total_sum = (select sum(ProductsInStore.cost * Ordered_items.count) from ordered_items, productsinstore
where ordered_items.id = '0000000007' and Ordered_items.store_id = ProductsInStore.store_id
and Ordered_items.upc = ProductsInStore.upc) - pay_by_bonus where id = '0000000007';
update Orders set total_sum = (select sum(ProductsInStore.cost * Ordered_items.count) from ordered_items, productsinstore
where ordered_items.id = '0000000008' and Ordered_items.store_id = ProductsInStore.store_id
and Ordered_items.upc = ProductsInStore.upc) - pay_by_bonus where id = '0000000008';
update Orders set total_sum = (select sum(ProductsInStore.cost * Ordered_items.count) from ordered_items, productsinstore
where ordered_items.id = '0000000009' and Ordered_items.store_id = ProductsInStore.store_id
and Ordered_items.upc = ProductsInStore.upc) - pay_by_bonus where id = '0000000009';
update Orders set total_sum = (select sum(ProductsInStore.cost * Ordered_items.count) from ordered_items, productsinstore
where ordered_items.id = '0000000010' and Ordered_items.store_id = ProductsInStore.store_id
and Ordered_items.upc = ProductsInStore.upc) - pay_by_bonus where id = '0000000010';
update Orders set total_sum = (select sum(ProductsInStore.cost * Ordered_items.count) from ordered_items, productsinstore
where ordered_items.id = '0000000011' and Ordered_items.store_id = ProductsInStore.store_id
and Ordered_items.upc = ProductsInStore.upc) - pay_by_bonus where id = '0000000011';
update Orders set total_sum = (select sum(ProductsInStore.cost * Ordered_items.count) from ordered_items, productsinstore
where ordered_items.id = '0000000012' and Ordered_items.store_id = ProductsInStore.store_id
and Ordered_items.upc = ProductsInStore.upc) - pay_by_bonus where id = '0000000012';
update Orders set total_sum = (select sum(ProductsInStore.cost * Ordered_items.count) from ordered_items, productsinstore
where ordered_items.id = '0000000013' and Ordered_items.store_id = ProductsInStore.store_id
and Ordered_items.upc = ProductsInStore.upc) - pay_by_bonus where id = '0000000013';
--
insert into Orders values ('0000000012','00000000', 0 ,0);
insert into Orders values ('0000000013','00000000', 0 ,0);
insert into Orders values ('0000000014','00000000', 0 ,0);
insert into Orders values ('0000000015','00000000', 0 ,0);


insert into ordered_items values ('0000000006','02003', 17020004, 3);
insert into ordered_items values ('0000000007','01003', 17020004, 8);
insert into ordered_items values ('0000000008','02002', 17020004, 2);
insert into ordered_items values ('0000000009','01002', 17020004, 3);
insert into ordered_items values ('0000000010','02001', 17020004, 7);
insert into ordered_items values ('0000000011','01001', 17020004, 4);

insert into ordered_items values ('0000000012','02003', 17020001, 2);
insert into ordered_items values ('0000000013','01003', 17020001, 3);
insert into ordered_items values ('0000000014','02002', 17020001, 4);
insert into ordered_items values ('0000000015','01002', 17020001, 1);
--Fanta Outsell Cola
select count(table3.store_id) from (select  table1.store_id, sells_of_Coca_Cola, sells_of_Fanta from (select store_id , sum(count) as sells_of_Coca_Cola from ordered_items where upc = 17020001
group by store_id) as table1 INNER JOIN (select store_id, sum(count) as sells_of_Fanta from ordered_items where upc = 17020004
group by store_id) as table2 ON table1.store_id = table2.store_id) as table3 where table3.sells_of_Fanta > table3.sells_of_Coca_Cola;
-- 3 most products that people buy with milk;
select upc, sum(count) as sell from ordered_items where id in (select id from ordered_items where upc IN (10040001,10040002,10040003,10040004)) and Ordered_items.upc not IN (10040001,10040002,10040003,10040004) group by Ordered_items.upc order by sell desc limit 3;