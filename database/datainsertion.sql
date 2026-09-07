INSERT INTO customers (customer_id, customer_name, gender, city, signup_date) VALUES
(1,'Neha Kumar','Female','Thrissur','2024-08-16'),
(2,'Anjali Nair','Male','Delhi','2025-03-08'),
(3,'Rahul Kumar','Male','Thrissur','2024-08-26'),
(4,'Sanjay Reddy','Male','Mumbai','2024-07-22'),
(5,'Priya Joseph','Male','Hyderabad','2025-08-26');


INSERT INTO products (product_id, product_name, category, sub_category, price) VALUES
(1,'Laptop Product 01','Electronics','Laptop',69606.49),
(2,'Laptop Product 02','Electronics','Laptop',39671.78),
(3,'Laptop Product 03','Electronics','Laptop',78764.06),
(4,'Laptop Product 04','Electronics','Laptop',73347.74),
(5,'Laptop Product 05','Electronics','Laptop',22997.12);

INSERT INTO orders (order_id, customer_id, order_date, order_status) VALUES
(1,638,'2025-09-09','Delivered'),
(2,329,'2025-01-10','Delivered'),
(3,51,'2025-10-01','Delivered'),
(4,191,'2025-02-22','Delivered'),
(5,276,'2025-03-06','Returned'),
(6,449,'2025-01-05','Delivered');

INSERT INTO order_details (order_detail_id, order_id, product_id, quantity, discount) VALUES
(1,2509,21,5,0.05),
(2,531,70,1,0),
(3,146,128,5,0),
(4,2664,90,4,0.05),
(5,1243,59,1,0),
(6,108,199,2,0.1),
(7,2491,98,1,0.1),
(8,1975,14,4,0.2),
(9,1546,179,2,0.05);
  
INSERT INTO payments (payment_id, order_id, payment_method, payment_status, payment_amount) VALUES
(1,1,'Cash','Paid',56137.24),
(2,2,'Net Banking','Paid',53172.52),
(3,3,'Cash','Paid',69329.7),
(4,4,'Net Banking','Paid',17842.21),
(5,5,'Debit Card','Paid',76788.53),
(6,6,'Credit Card','Paid',6350.09),
