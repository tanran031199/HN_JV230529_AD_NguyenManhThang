create schema if not exists QUANLYBANHANG;

-- drop schema QUANLYBANHANG;
use QUANLYBANHANG;

create table if not exists CUSTOMERS(
	customer_id varchar(4) not null primary key,
    name varchar(100) not null,
    email varchar(100) not null unique,
    phone varchar(25) not null,
    address varchar(255) not null
);

create table if not exists ORDERS(
	order_id varchar(4) not null primary key,
    customer_id varchar(4) not null,
    order_date date not null,
    total_amount double not null,
    constraint fk_customer foreign key (customer_id) references CUSTOMERS(customer_id)
);

create table if not exists PRODUCTS(
	product_id varchar(4) not null primary key,
    name varchar(255) not null,
    description text,
    price double not null,
    status bit(1) not null default 1
);

create table if not exists ORDER_DETAILS(
	order_id varchar(4) not null,
    product_id varchar(4) not null,
    quantity int(11) not null,
    price double not null,
    constraint pk_od primary key (order_id, product_id),
    constraint fk_order foreign key (order_id) references ORDERS(order_id),
    constraint fk_product foreign key (product_id) references PRODUCTS(product_id)
);

-- Add customers
insert into CUSTOMERS(customer_id, name, email, phone, address) values
 ('C001', 'Nguyễn Trung Mạnh', 'manhnt@gmail.com', '984756322', 'Cầu Giấy, Hà Nội'),
 ('C002', 'Hồ Hải Nam', 'namhh@gmail.com', '984875926', 'Ba Vì, Hà Nội'),
 ('C003', 'Tô Ngọc Vũ', 'vutn@gmail.com', '904725784', 'Mộc Châu, Sơn La'),
 ('C004', 'Phạm Ngọc Anh', 'anhpn@gmail.com', '984635365', 'Vinh, Nghệ An'),
 ('C005', 'Trương Minh Cường', 'cuongtm@gmail.com', '989735624', 'Hai Bà Trưng, Hà Nội');
 
-- Add products
insert into PRODUCTS(product_id, name, description, price) values
 ('P001', 'Iphone 13 ProMax', 'Bản 512 GB, xanh lá', 22999999),
 ('P002', 'Dell Vostro V3510', 'Core i5, RAM 8GB', 14999999),
 ('P003', 'Macbook Pro M2', '8CPU 10GPU 8GB 256GB', 28999999),
 ('P004', 'Apple Watch Ultra', 'Titanium Alpine Loop Small', 18999999),
 ('P005', 'Airpods 2 2022', 'Spatial Audio', 4090000);
 
-- Add orders
insert into ORDERS(order_id, customer_id, total_amount, order_date) values
 ('H001', 'C001', 52999997, '2023-02-22'),
 ('H002', 'C001', 80999997, '2023-03-11'),
 ('H003', 'C002', 54359998, '2023-01-22'),
 ('H004', 'C003', 102999995, '2023-03-14'),
 ('H005', 'C003', 80999997, '2022-03-12'),
 ('H006', 'C004', 110449994, '2023-02-01'),
 ('H007', 'C004', 78999996, '2023-03-29'),
 ('H008', 'C005', 29999998, '2023-02-14'),
 ('H009', 'C005', 28999999, '2023-01-10'),
 ('H010', 'C005', 149999994, '2023-04-01');
 
-- Add order details
insert into ORDER_DETAILS(order_id, product_id, price, quantity) values
 ('H001', 'P002', 14999999, 1),
 ('H001', 'P004', 18999999, 2),
 ('H002', 'P001', 22999999, 1),
 ('H002', 'P003', 28999999, 2),
 ('H003', 'P004', 18999999, 2),
 ('H003', 'P005', 4090000, 4),
 ('H004', 'P002', 14999999, 3),
 ('H004', 'P003', 28999999, 2),
 ('H005', 'P001', 22999999, 1),
 ('H005', 'P003', 28999999, 2),
 ('H006', 'P005', 4090000, 5),
 ('H006', 'P002', 14999999, 6),
 ('H007', 'P004', 18999999, 3),
 ('H007', 'P001', 22999999, 1),
 ('H008', 'P002', 14999999, 2),
 ('H009', 'P003', 28999999, 1),
 ('H010', 'P003', 28999999, 2),
 ('H010', 'P001', 22999999, 4);

-- Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .
select name as `Tên`, email as `Email`, phone as `Số điện thoại`, address as `Địa chỉ` from CUSTOMERS;

-- Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện
-- thoại và địa chỉ khách hàng).
select C.name as `Tên`, C.phone as `Số điện thoại`, C.address as `Địa chỉ`
from CUSTOMERS as C
join ORDERS as O on O.customer_id = C.customer_id
where concat(year(order_date), '-', month(order_date)) = '2023-3';

-- Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm
-- tháng và tổng doanh thu ).
select month(order_date) as `Tháng`, sum(total_amount) `Doanh thu`
from ORDERS
group by month(order_date)
order by month(order_date);

-- Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách
-- hàng, địa chỉ , email và số điên thoại).
select distinct C.name as `Tên`, C.address as `Địa chỉ`, C.email as `Email`, C.phone as `Số điện thoại`
from CUSTOMERS as C
join ORDERS as O on O.customer_id = C.customer_id
where concat(year(order_date), '-', month(order_date)) <> '2023-2';

-- Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã
-- sản phẩm, tên sản phẩm và số lượng bán ra).
select P.product_id as `Mã sản phẩm`, P.name as `Tên sản phẩm`, sum(OD.quantity) as `Số lượng sản phẩm` from PRODUCTS as p
join ORDER_DETAILS as OD on OD.product_id = P.product_id
join ORDERS as O on O.order_id = OD.order_id
where concat(year(order_date), '-', month(order_date)) = '2023-2'
group by P.product_id, P.name;

-- Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi
-- tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu).
select C.customer_id as `Mã khách hàng`, C.name as `Tên khách hàng`, sum(total_amount) as `Tổng chi tiêu năm 2023`
from CUSTOMERS as C
join ORDERS as O on O.customer_id = C.customer_id
group by C.customer_id, C.name
order by sum(total_amount) desc;

-- Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm
-- tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) .
select C.name as `Tên người mua`, O.total_amount as `Tổng tiền`, O.order_date as `Ngày tạo hóa đơn`, sum(OD.quantity) as `Tổng số lượng`
from ORDERS as O
join CUSTOMERS as C on C.customer_id = O.customer_id
join ORDER_DETAILS as OD on OD.order_id = O.order_id
join PRODUCTS as P on P.product_id = OD.product_id
group by C.name, O.total_amount, O.order_date
having sum(OD.quantity) >= 5;

-- Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng
-- tiền và ngày tạo hoá đơn .
create view view_order as
select C.name as `Tên khách hàng`, C.phone as `Số điện thoại`, C.address as `Địa chỉ`, O.total_amount as `Tổng tiền`, O.order_date as `Ngày tạo hoá đơn`
from CUSTOMERS as C
join ORDERS as O on O.customer_id = C.customer_id;

select * from view_order;

-- Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng
-- số đơn đã đặt.
create view view_customer as
select C.name as `Tên khách hàng`, C.address as `Địa chỉ`, C.phone as `Số điện thoại`, count(O.order_id) as `Tổng số đơn`
from CUSTOMERS as C
join ORDERS as O on O.customer_id = C.customer_id
group by C.name, C.address, C.phone;
 
select * from view_customer;
 
-- Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã
-- bán ra của mỗi sản phẩm.
create view view_product as
select P.name as `Tên sản phẩm`, P.description as `Mô tả`, P.price as `Giá`, sum(OD.quantity) as `Tổng số lượng đã bán`
from PRODUCTS as P
join ORDER_DETAILS as OD on OD.product_id = P.product_id
group by P.name, P.description, P.price;

select * from view_product;

-- Đánh Index cho trường `phone` và `email` của bảng Customer.
create index idx_phone_email on CUSTOMERS(phone, email);

-- Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.
delimiter //
create procedure proc_get_customer(input_id varchar(4))
begin
	select * from CUSTOMERS where customer_id = input_id;
end //
delimiter ;

call proc_get_customer('C001');

-- Tạo PROCEDURE lấy thông tin của tất cả sản phẩm.
delimiter //
create procedure proc_getAll_product()
begin
	select * from PRODUCTS;
end //
delimiter ;

call proc_getAll_product();

-- Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng.
delimiter //
create procedure proc_get_order_byCid(input_id varchar(4))
begin
	select * from ORDERS where customer_id = input_id;
end //
delimiter ;

call proc_get_order_byCid('C001');

-- Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng
-- tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo.
delimiter //
create procedure proc_addNew_order(input_cid varchar(4), input_total_amount double, input_date date)
begin
	declare last_id int;
    declare new_id varchar(4);

	set last_id = (
    SELECT CAST(SUBSTRING(order_id, 2, 4) AS SIGNED)
    FROM ORDERS
    ORDER BY SUBSTRING(order_id, 2, 4) DESC
    LIMIT 1
	);
    
	set new_id = (case
		when (last_id + 1) < 10 then concat('H00', (last_id + 1))
        when (last_id + 1) < 100 then concat('H0', (last_id + 1))
        else concat('H', (last_id + 1))
        end
	);
    
	insert into ORDERS(order_id, customer_id, total_amount, order_date) values 
    (new_id, input_cid, input_total_amount, input_date);
    
    select new_id;
end //
delimiter ;

call proc_addNew_order('C001', 1499999, '2023-03-14');

-- Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng
-- thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc.
delimiter //
create procedure proc_sum_quantity(startDate date, endDate date)
begin
	select P.product_id as `Mã sản phẩm`, P.name as `Tên sản phẩm`, sum(OD.quantity) as `Số lượng` 
    from ORDERS as O
    join ORDER_DETAILS as OD on OD.order_id = O.order_id
    join PRODUCTS as P on P.product_id = OD.product_id
    where O.order_date between startDate and endDate
    group by P.product_id, P.name;
end //
delimiter ;

call proc_sum_quantity('2023-03-01', '2023-03-31');

-- Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự
-- giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê.
delimiter //
create procedure sumQuantityByMonthAndYear(inputYear int(4), inputMonth int(2))
begin
	select P.product_id as `Mã sản phẩm`, P.name as `Tên sản phẩm`, sum(OD.quantity) as `Số lượng`
    from PRODUCTS as P
    join ORDER_DETAILS as OD on OD.product_id = P.product_id
    join ORDERS as O on O.order_id = OD.order_id
    where year(O.order_date) = inputYear and month(O.order_date) = inputMonth
    group by P.product_id, P.name;
end //
delimiter ;

call sumQuantityByMonthAndYear(2023, 03);