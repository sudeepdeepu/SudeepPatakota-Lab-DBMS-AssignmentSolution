create Database if not exists `order-directory`;
use `order-directory`;

create table if not exists `supplier`(
`SUPP_ID` int primary key,
`SUPP_NAME` varchar(50),
`SUPP_CITY` varchar(50),
`SUPP_PHONE` varchar(10)
);
create table if not exists `customer`(
`CUS_ID` INT NOT NULL,
`CUS_NAME` varchar(20) NULL DEFAULT NULL,
`CUS_PHONE` varchar(10),
`CUS_CITY` varchar(30),
`CUS_GENDER` char,
PRIMARY KEY (`CUS_ID`)
);
create table if not exists `category`(
`CAT_ID` INT NOT NULL,
`CAT_NAME` varchar(20) NULL DEFAULT NULL,
PRIMARY KEY (`CAT_ID`)
);
create table if not exists `product`(
`PRO_ID` INT NOT NULL,
`PRO_NAME` varchar(20) NULL DEFAULT NULL,
`PRO_DESC` varchar(60) NULL DEFAULT NULL,
`CAT_ID`INT NOT NULL,
PRIMARY KEY (`PRO_ID`),
FOREIGN KEY (`CAT_ID`) REFERENCES CATEGORY (`CAT_ID`)

);
create table if not exists `product_details`(
`PROD_ID` INT NOT NULL,
`PRO_ID` INT NOT NULL,
`SUPP_ID` INT NOT NULL,
`PROD_PRICE` INT NOT NULL,
PRIMARY KEY (`PROD_ID`),
FOREIGN KEY (`PRO_ID`) REFERENCES PRODUCT (`PRO_ID`),
FOREIGN KEY (`SUPP_ID`) REFERENCES SUPPLIER (`SUPP_ID`)
);
create table if not exists `order`(
`ORD_ID` INT NOT NULL,
`ORD_AMOUNT` INT NOT NULL,
`ORD_DATE` DATE,
`CUS_ID` INT NOT NULL,
`PROD_ID` INT NOT NULL,
PRIMARY KEY (`ORD_ID`),
FOREIGN KEY (`CUS_ID`) REFERENCES CUSTOMER (`CUS_ID`),
FOREIGN KEY (`PROD_ID`) REFERENCES PRODUCT_DETAILS (`PROD_ID`)
);
create table if not exists `rating`(
`RAT_ID` INT NOT NULL,
`CUS_ID` INT NOT NULL,
`SUPP_ID` INT NOT NULL,
`RAT_RATSTARS` INT NOT NULL,
PRIMARY KEY (`RAT_ID`),
FOREIGN KEY (`CUS_ID`) REFERENCES CUSTOMER (`CUS_ID`),
FOREIGN KEY (`SUPP_ID`) REFERENCES SUPPLIER (`SUPP_ID`)
);
INSERT INTO `supplier` VALUES(1,"Rajesh Retails","Delhi",'1234567890');
INSERT INTO `supplier` VALUES(2,"Appario Ltd.","Mumbai",'2589631470');
INSERT INTO `supplier` VALUES(3,"Knome products","Bangalore",'9785462315');
INSERT INTO `supplier` VALUES(4,"Bansal Retails","Kochi",'8975463285');
INSERT INTO `supplier` VALUES(5,"Mittal Ltd.","Lucknow",'7898456532');

INSERT INTO `customer` VALUES(1,"AAKASH",'9999999999',"Delhi",'M');
INSERT INTO `customer` VALUES(2,"AMAN",'9785463215',"Noida",'M');
INSERT INTO `customer` VALUES(3,"NEHA",'9999999999',"Mumbai",'F');
INSERT INTO `customer` VALUES(4,"MEGHA",'9994562399',"Kolkata",'F');
INSERT INTO `customer` VALUES(5,"PULKIT",'7895999999',"Lucknow",'M');

INSERT INTO `category` VALUES(1,"BOOKS");
INSERT INTO `category` VALUES(2,"GAMES");
INSERT INTO `category` VALUES(3,"GROCERIES");
INSERT INTO `category` VALUES(4,"ELECTRONICS");
INSERT INTO `category` VALUES(5,"CLOTHES");

INSERT INTO `product` VALUES(1,"GTA V","DFJDJFDJFDJFDJFJF",2);
INSERT INTO `product` VALUES(2,"TSHIRT","DFDFJDFJDKFD",5);
INSERT INTO `product` VALUES(3,"ROG LAPTOP","DFNTTNTNTERND",4);
INSERT INTO `product` VALUES(4,"OATS","REURENTBTOTH",3);
INSERT INTO `product` VALUES(5,"HARRY POTTER","NBEMCTHTJTH",1);

INSERT INTO `product_details` VALUES(1,1,2,1500);
INSERT INTO `product_details` VALUES(2,3,5,30000);
INSERT INTO `product_details` VALUES(3,5,1,3000);
INSERT INTO `product_details` VALUES(4,2,3,2500);
INSERT INTO `product_details` VALUES(5,4,1,1000);

INSERT INTO `order` VALUES(50,2000,"2021-10-06",2,1);
INSERT INTO `order` VALUES(20,1500,"2021-10-12",3,5);
INSERT INTO `order` VALUES(25,30500,"2021-09-16",5,2);
INSERT INTO `order` VALUES(26,2000,"2021-10-05",1,1);
INSERT INTO `order` VALUES(30,3500,"2021-08-16",4,3);

INSERT INTO `rating` VALUES(1,2,2,4);
INSERT INTO `rating` VALUES(2,3,4,3);
INSERT INTO `rating` VALUES(3,5,1,5);
INSERT INTO `rating` VALUES(4,1,3,2);
INSERT INTO `rating` VALUES(5,4,5,4);

-- 3)	Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000.
select customer.cus_gender,count(customer.cus_gender) as count from customer inner join `order` on customer.cus_id=`order`.cus_id where `order`.ord_amount>=3000 group by customer.cus_gender;

-- 4)	Display all the orders along with the product name ordered by a customer having Customer_Id=2.
select `order`.*,product.pro_name from `order`,product_details,product where `order`.cus_id=2 and `order`.prod_id=product_details.prod_id and product_details.prod_id=product.pro_id;

-- 5)	Display the Supplier details who can supply more than one product.
select supplier.* from supplier,product_details where supplier.supp_id in (select product_details.supp_id from product_details group by product_details.supp_id having count(product_details.supp_id)>1) group by supplier.supp_id;

-- 6)	Find the category of the product whose order amount is minimum.
select category.* from `order` inner join product_details on `order`.prod_id=product_details.prod_id inner join 
product on product.pro_id=product_details.pro_id inner join category on category.cat_id = product.cat_id having min(`order`.ord_amount);

-- 7)	Display the Id and Name of the Product ordered after “2021-10-05”.
select product.pro_id,product.pro_name from `order` inner join product_details on product_details.prod_id=`order`.prod_id
 inner join product on product.pro_id=product_details.pro_id where `order`.ord_date>"2021-10-05";

-- 8)	Display customer name and gender whose names start or end with character 'A'.
select customer.cus_name, customer.cus_gender from customer where customer.cus_name like 'A%' or customer.cus_name like '%A';

-- 9)	Create a stored procedure to display the Rating for a Supplier if any along with the Verdict on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”.
select supplier.supp_id,supplier.supp_name,rating.rat_ratstars,
CASE
	WHEN rating.rat_ratstars > 4 THEN 'Genius Supplier'
    WHEN rating.rat_ratstars > 2 THEN 'Average Supplier'
    ELSE 'Supplier should not be considered'
END AS verdict from rating inner join supplier on supplier.supp_id = rating.supp_id;
