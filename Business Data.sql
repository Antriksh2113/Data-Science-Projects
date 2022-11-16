-- 1. Display the product details as per the following criteria and sort them in descending order of category:
   #a.  If the category is 2050, increase the price by 2000
   #b.  If the category is 2051, increase the price by 500
   #c.  If the category is 2052, increase the price by 600 
   select * , case
   when PRODUCT_CLASS_CODE=2050 then PRODUCT_PRICE+2000
   when PRODUCT_CLASS_CODE=2051 then PRODUCT_PRICE+500
   when PRODUCT_CLASS_CODE=2052 then PRODUCT_PRICE+600
   else PRODUCT_PRICE
   end New_price from product order by new_price desc;
-- 2. List the product description, class description and price of all products which are shipped.
select PRODUCT_DESC, PRODUCT_CLASS_DESC, PRODUCT_PRICE from product p join product_class pc
 on p.PRODUCT_CLASS_CODE=pc.PRODUCT_CLASS_CODE
 join order_items ot on ot.PRODUCT_ID=p.PRODUCT_ID
 join order_header oh on oh.ORDER_ID=ot.ORDER_ID
 join shipper s on s.SHIPPER_ID=oh.SHIPPER_ID group by p.PRODUCT_ID,PRODUCT_DESC, PRODUCT_CLASS_DESC, PRODUCT_PRICE; 
-- 3. Show inventory status of products as below as per their available quantity:
#a. For Electronics and Computer categories, if available quantity is < 10, show 'Low stock', 11 < qty < 30, show 'In stock', > 31, 
-- show 'Enough stock'
#b. For Stationery and Clothes categories, if qty < 20, show 'Low stock', 21 < qty < 80, show 'In stock', > 81, show 'Enough stock'
#c. Rest of the categories, if qty < 15 – 'Low Stock', 16 < qty < 50 – 'In Stock', > 51 – 'Enough stock'
#For all categories, if available quantity is 0, show 'Out of stock'.
select PRODUCT_ID, PRODUCT_DESC, PRODUCT_CLASS_DESC, PRODUCT_QUANTITY_AVAIL , case
when PRODUCT_QUANTITY_AVAIL=0 then 'Out of Stock'
when PRODUCT_QUANTITY_AVAIL between 1 and 15 then 'Low Stock'
when PRODUCT_QUANTITY_AVAIL between 16 and 50 then 'In Stock'
when PRODUCT_QUANTITY_AVAIL > 50 then 'Enough Stock'
when (PRODUCT_CLASS_DESC in ('Electronics','Computer')) and (PRODUCT_QUANTITY_AVAIL <10) then 'Low Stock'
when (PRODUCT_CLASS_DESC in ('Electronics','Computer')) and (PRODUCT_QUANTITY_AVAIL between 10 and 30 ) then 'In Stock'
when (PRODUCT_CLASS_DESC in ('Electronics','Computer')) and (PRODUCT_QUANTITY_AVAIL > 30) then 'Enough Stock'
when (PRODUCT_CLASS_DESC in ('Stationery','Clothes')) and (PRODUCT_QUANTITY_AVAIL <20) then 'Low Stock'
when (PRODUCT_CLASS_DESC in ('Stationery','Clothes')) and (PRODUCT_QUANTITY_AVAIL between 20 and 80 ) then 'In Stock'
when (PRODUCT_CLASS_DESC in ('Stationery','Clothes')) and (PRODUCT_QUANTITY_AVAIL >80) then 'Enough Stock'
end Inventory_Status from product p join product_class pc on p.PRODUCT_CLASS_CODE=pc.PRODUCT_CLASS_CODE;

-- 4. List customers from outside Karnataka who haven’t bought any toys or books 
select oc.CUSTOMER_ID, concat(CUSTOMER_FNAME,' ',customer_lname) Customer_name, STATE  from online_customer oc 
join address a on oc.ADDRESS_ID=a.ADDRESS_ID join order_header oh on oh.CUSTOMER_ID=oc.CUSTOMER_ID 
join order_items ot on ot.ORDER_ID=oh.ORDER_ID join product p on p.PRODUCT_ID=ot.PRODUCT_ID join product_class pc
on pc.PRODUCT_CLASS_CODE=p.PRODUCT_CLASS_CODE where PRODUCT_CLASS_DESC not in ('Toys' ,'Books') and (state <> 'Karnataka' or state is null)
group by oc.CUSTOMER_ID, state;

select distinct p.product_id, PRODUCT_DESC, PRODUCT_PRICE from product p join order_items o 
on p.PRODUCT_ID=o.PRODUCT_ID where PRODUCT_PRICE in (select min(PRODUCT_PRICE) from product);

select * from product where PRODUCT_ID not in (select  distinct PRODUCT_ID from order_items);

