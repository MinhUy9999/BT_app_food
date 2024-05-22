
CREATE DATABASE BT1

CREATE TABLE user (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255),
    email VARCHAR(255),
    password VARCHAR(255)
);

CREATE TABLE restaurant (
    res_id INT PRIMARY KEY AUTO_INCREMENT,
    res_name VARCHAR(255),
    image VARCHAR(255),
    `desc` VARCHAR(255)
);

CREATE TABLE food_type (
    type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(255)
);

CREATE TABLE food (
    food_id INT PRIMARY KEY AUTO_INCREMENT,
    food_name VARCHAR(255),
    image VARCHAR(255),
    price FLOAT,
    `desc` VARCHAR(255),
    type_id INT,
    FOREIGN KEY (type_id) REFERENCES food_type(type_id)
);

CREATE TABLE sub_food (
    sub_id INT PRIMARY KEY AUTO_INCREMENT,
    sub_name VARCHAR(255),
    sub_price FLOAT,
    food_id INT,
    FOREIGN KEY (food_id) REFERENCES food(food_id)
);

CREATE TABLE `order` (
    user_id INT,
    food_id INT,
    amount INT,
    code VARCHAR(255),
    arr_sub_id VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (food_id) REFERENCES food(food_id)
);

CREATE TABLE rate_res (
    user_id INT,
    res_id INT,
    amount INT,
    date_rate DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);

CREATE TABLE like_res (
    user_id INT,
    res_id INT,
    date_like DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);

-- Insert data into user table
INSERT INTO user (full_name, email, password) VALUES 
('John Doe', 'john.doe@example.com', 'password123'),
('Jane Smith', 'jane.smith@example.com', 'securepass456');

-- Insert data into restaurant table
INSERT INTO restaurant (res_name, image, `desc`) VALUES 
('Pizza Place', 'pizza_place.jpg', 'A cozy place for pizza lovers'),
('Burger Joint', 'burger_joint.jpg', 'Best burgers in town');

-- Insert data into food_type table
INSERT INTO food_type (type_name) VALUES 
('Pizza'),
('Burger'),
('Pasta');

-- Insert data into food table
INSERT INTO food (food_name, image, price, `desc`, type_id) VALUES 
('Margherita Pizza', 'margherita.jpg', 8.99, 'Classic cheese pizza', 1),
('Pepperoni Pizza', 'pepperoni.jpg', 9.99, 'Pepperoni pizza with extra cheese', 1),
('Cheeseburger', 'cheeseburger.jpg', 5.99, 'Juicy cheeseburger with fries', 2);

-- Insert data into sub_food table
INSERT INTO sub_food (sub_name, sub_price, food_id) VALUES 
('Extra Cheese', 1.50, 1),
('Bacon', 2.00, 3);

-- Insert data into order table
INSERT INTO `order` (user_id, food_id, amount, code, arr_sub_id) VALUES 
(1, 1, 2, 'ORD001', '1,2'),
(2, 3, 1, 'ORD002', '2');

-- Insert data into rate_res table
INSERT INTO rate_res (user_id, res_id, amount, date_rate) VALUES 
(1, 1, 5, '2024-05-20 12:34:56'),
(2, 2, 4, '2024-05-21 14:22:30');

-- Insert data into like_res table
INSERT INTO like_res (user_id, res_id, date_like) VALUES 
(1, 1, '2024-05-20 10:00:00'),
(2, 2, '2024-05-21 15:00:00');

-- Tìm 5 người đã like nhà hàng nhiều nhất.
SELECT 
    u.user_id,
    u.full_name,
    COUNT(lr.res_id) AS like_count
FROM 
    like_res lr
JOIN 
    user u ON lr.user_id = u.user_id
GROUP BY 
    lr.user_id, u.full_name
ORDER BY 
    like_count DESC
LIMIT 5;

-- Tìm 2 nhà hàng có lượt like nhiều nhất.
SELECT 
    r.res_id,
    r.res_name,
    COUNT(lr.user_id) AS like_count
FROM 
    like_res lr
JOIN 
    restaurant r ON lr.res_id = r.res_id
GROUP BY 
    lr.res_id, r.res_name
ORDER BY 
    like_count DESC
LIMIT 2;

-- Tìm người đã đặt hàng nhiều nhất.
SELECT 
    u.user_id,
    u.full_name,
    COUNT(o.food_id) AS order_count
FROM 
    `order` o
JOIN 
    user u ON o.user_id = u.user_id
GROUP BY 
    o.user_id, u.full_name
ORDER BY 
    order_count DESC
LIMIT 1;

--Tìm người dùng không hoạt động trong hệ thống
--(không đặt hàng, không like, không đánh giá nhà
--hàng).
SELECT 
    u.user_id,
    u.full_name,
    u.email
FROM 
    user u
LEFT JOIN 
    `order` o ON u.user_id = o.user_id
LEFT JOIN 
    like_res lr ON u.user_id = lr.user_id
LEFT JOIN 
    rate_res rr ON u.user_id = rr.user_id
WHERE 
    o.user_id IS NULL
    AND lr.user_id IS NULL
    AND rr.user_id IS NULL;



