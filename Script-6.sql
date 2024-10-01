Задача
1.Напишите запросы к базе данных.
  a.Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price.
  b.Найдите среднюю скорость ПК.
  c.Найдите производителя, продающего ПК, но не ноутбуки.
2.Загрязните специально датасет (вставьте новые значения с уникальным кодом, но всеми остальными дублирующими полями).
3.Напишите оконную функцию, которая поможет вам обнаружить эти строки-редиски.
4.Обновите название колонки в таблице printer с color на color_type и поменяйте тип поля.
5.В последнем пункте выполните слияние двух запросов из таблиц PC и Laptop, выбрав только те значения, у которых цена больше 500, а ram = 64.


insert into product
select *
from product_laptop
union all 
select *
from product_printer;


a. находим модели принтеров, имеющих самую высокую цену. Вывести: model, price

select model, price
from printer p
join (
	select max(price) maxvalue
	from printer) m
on p.price = m.maxvalue;


b. находим среднюю скорость ПК.

select avg(speed) as avg_speed
from pc;

select sum(speed)/count(*) as avg_speed
from pc;

c. находим производителя, продающего ПК, но не ноутбуки.

select maker
from product
where type = 'PC'  and maker not in (
	select maker
	from product
	where type = 'LT')
group by maker
order by maker;


2. Загрязним специально датасет (вставим новые значения с уникальным кодом, но всеми остальными дублирующими полями).

insert into pc 
values
(193, 1213, 800, 96, 10.0, '24x', 350.00),
(194, 1214, 600, 32, 10.0, '36x', 800.00),
(195, 1215, 500, 32, 5.0, '44x', 650.00),
(196, 1216, 800, 32, 20.0, '36x', 600.00),
(197, 1217, 900, 32, 10.0, '12x', 1000.00),
(198, 1218, 500, 96, 10.0, '40x', 1000.00),
(199, 1219, 600, 128, 15.0, '20x', 700.00),
(1100, 1220, 700, 32, 15.0, '36x', 900.00),
(1101, 1221, 600, 32, 20.0, '44x', 500.00),
(1102, 1222, 800, 32, 10.0, '24x', 900.00);


3. Напишим оконную функцию, которая поможет нам обнаружить эти строки.

select *
from (
	select code, 
	row_number () over(partition by model order by code) as rn
	from pc
	)a1
where a1.rn > 1;

4. Обновим название колонки в таблице printer с color на color_type. 

alter table printer
rename column color to color_type;

и поменяем тип поля.

alter table printer 
alter column color_type type varchar(20);

проверим что тип столбца изменился
 
select 
	table_catalog,
    table_name, 
    column_name, 
    udt_name,
    character_maximum_length 
from information_schema.columns
where table_name = 'printer';

5. Выполним слияние двух запросов из таблиц PC и Laptop, выбрав только те значения, у которых цена больше 500, а ram = 64.

select code, p.model, speed, ram, hd, price, type
from pc p
join product p2 on p2.model = p.model
where p.price > 500 and p.ram = 64
union all
select code, l.model, speed, ram, hd, price, type
from laptop l
join product p2 on p2.model = l.model
where l.price > 500 and l.ram = 64
order by price desc;




