CREATE DATABASE IF NOT EXISTS airlines;
USE airlines;

DROP TABLE IF EXISTS customer;
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    gender VARCHAR(5)
);

DROP TABLE IF EXISTS routes;
CREATE TABLE routes (
    route_id INT,
    flight_num INT,
    origin_airport VARCHAR(10),
    destination_airport VARCHAR(10),
    aircraft_id VARCHAR(20),
    distance_miles INT
);

DROP TABLE IF EXISTS ticket_details;
CREATE TABLE ticket_details (
    p_date DATE,
    customer_id INT,
    aircraft_id VARCHAR(20),
    class_id VARCHAR(20),
    no_of_tickets INT,
    a_code VARCHAR(10),
    price_per_ticket INT,
    brand VARCHAR(50)
);

DROP TABLE IF EXISTS passengers_on_flights;
CREATE TABLE passengers_on_flights (
    customer_id INT,
    aircraft_id VARCHAR(20),
    route_id INT,
    depart VARCHAR(10),
    arrival VARCHAR(10),
    seat_num VARCHAR(10),
    class_id VARCHAR(20),
    travel_date DATE,
    flight_num INT
);

-- Load customer.csv, routes.csv, ticket_details.csv and
-- passengers_on_flights.csv from the Datasets folder into the four
-- tables above using the Table Data Import Wizard before running
-- the tasks below. Note that date fields are stored in DD-MM-YYYY
-- format in the CSV files and should be converted to DATE type on import.


-- ------------------------------------------------------------
-- Task 1: Create the route_details table with constraints
-- ------------------------------------------------------------
CREATE TABLE route_details (
    route_id INT UNIQUE,
    flight_num INT,
    origin_airport VARCHAR(10),
    destination_airport VARCHAR(10),
    aircraft_id VARCHAR(20),
    distance_miles INT,
    CONSTRAINT chk_flight_num CHECK (flight_num > 0),
    CONSTRAINT chk_distance_miles CHECK (distance_miles > 0)
);

-- Load the real route data in to prove the table structure works
INSERT INTO route_details (route_id, flight_num, origin_airport, destination_airport, aircraft_id, distance_miles)
SELECT route_id, flight_num, origin_airport, destination_airport, aircraft_id, distance_miles FROM routes;

-- The two lines below are expected to fail, proving the constraints work
INSERT INTO route_details VALUES (999, 9999, 'ABC', 'XYZ', 'TEST', -100);
INSERT INTO route_details VALUES (1, 9999, 'ABC', 'XYZ', 'TEST', 500);

-- ------------------------------------------------------------
-- Task 2: Passengers who travelled on routes 1 to 25
-- ------------------------------------------------------------
SELECT *
FROM passengers_on_flights
WHERE route_id BETWEEN 1 AND 25;

-- ------------------------------------------------------------
-- Task 3: Business class passenger count and revenue
-- ------------------------------------------------------------
SELECT SUM(no_of_tickets) AS NUMBER_OF_PASSENGERS,
       SUM(no_of_tickets * price_per_ticket) AS TOTAL_REVENUE
FROM ticket_details
WHERE class_id = 'Bussiness';

-- ------------------------------------------------------------
-- Task 4: Customer full name
-- ------------------------------------------------------------
SELECT customer_id, CONCAT(first_name, ' ', last_name) AS FULL_NAME
FROM customer;

-- ------------------------------------------------------------
-- Task 5: Customers who have registered and booked a ticket
-- ------------------------------------------------------------
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN ticket_details t ON c.customer_id = t.customer_id;

-- ------------------------------------------------------------
-- Task 6: Customer name by brand, Emirates
-- ------------------------------------------------------------
SELECT c.customer_id, c.first_name, c.last_name, t.brand
FROM customer c
JOIN ticket_details t ON c.customer_id = t.customer_id
WHERE t.brand = 'Emirates';

-- ------------------------------------------------------------
-- Task 7: Economy Plus passengers using GROUP BY and HAVING
-- ------------------------------------------------------------
SELECT customer_id, class_id, COUNT(*) AS NUM_FLIGHTS
FROM passengers_on_flights
GROUP BY customer_id, class_id
HAVING class_id = 'Economy Plus';

-- ------------------------------------------------------------
-- Task 8: Whether revenue has crossed 10000
-- ------------------------------------------------------------
SELECT SUM(no_of_tickets * price_per_ticket) AS TOTAL_REVENUE,
       IF(SUM(no_of_tickets * price_per_ticket) > 10000, 'YES', 'NO') AS CROSSED_10000
FROM ticket_details;

-- ------------------------------------------------------------
-- Task 9: Create and grant access to a new user
-- ------------------------------------------------------------
CREATE USER 'aircargo_analyst'@'localhost' IDENTIFIED BY 'StrongPassword123!';
GRANT SELECT, INSERT, UPDATE ON airlines.* TO 'aircargo_analyst'@'localhost';
FLUSH PRIVILEGES;

SHOW GRANTS FOR 'aircargo_analyst'@'localhost';

-- ------------------------------------------------------------
-- Task 10: Max ticket price per class using a window function
-- ------------------------------------------------------------
SELECT DISTINCT class_id,
       MAX(price_per_ticket) OVER (PARTITION BY class_id) AS MAX_PRICE
FROM ticket_details;

-- ------------------------------------------------------------
-- Task 11: Passengers on route 4, with an index added for speed
-- ------------------------------------------------------------
CREATE INDEX idx_route_id ON passengers_on_flights(route_id);

SELECT * FROM passengers_on_flights
WHERE route_id = 4;

-- ------------------------------------------------------------
-- Task 12: Execution plan for route 4, before and after the index
-- ------------------------------------------------------------
EXPLAIN SELECT * FROM passengers_on_flights
WHERE route_id = 4;

-- ------------------------------------------------------------
-- Task 13: Total price per customer and aircraft using ROLLUP
-- ------------------------------------------------------------
SELECT customer_id, aircraft_id,
       SUM(no_of_tickets * price_per_ticket) AS TOTAL_PRICE
FROM ticket_details
GROUP BY customer_id, aircraft_id WITH ROLLUP;

-- ------------------------------------------------------------
-- Task 14: A view of business class customers and their brand
-- ------------------------------------------------------------
CREATE VIEW business_class_customers AS
SELECT c.customer_id, c.first_name, c.last_name, t.brand
FROM customer c
JOIN ticket_details t ON c.customer_id = t.customer_id
WHERE t.class_id = 'Bussiness';

SELECT * FROM business_class_customers;

-- ------------------------------------------------------------
-- Task 15: Stored procedure, passengers within a route range
-- ------------------------------------------------------------
DELIMITER $$

CREATE PROCEDURE GetPassengersByRouteRange(IN start_route INT, IN end_route INT)
BEGIN
    DECLARE table_exists INT DEFAULT 0;

    SELECT COUNT(*) INTO table_exists
    FROM information_schema.tables
    WHERE table_schema = DATABASE() AND table_name = 'passengers_on_flights';

    IF table_exists = 0 THEN
        SELECT 'Error: passengers_on_flights table does not exist' AS MESSAGE;
    ELSE
        SELECT * FROM passengers_on_flights
        WHERE route_id BETWEEN start_route AND end_route;
    END IF;
END $$

DELIMITER ;

CALL GetPassengersByRouteRange(1, 10);

-- ------------------------------------------------------------
-- Task 16: Stored procedure, routes over 2000 miles
-- ------------------------------------------------------------
DELIMITER $$

CREATE PROCEDURE GetLongRoutes()
BEGIN
    SELECT * FROM routes WHERE distance_miles > 2000;
END $$

DELIMITER ;

CALL GetLongRoutes();

-- ------------------------------------------------------------
-- Task 17: Stored procedure, distance category SDT IDT LDT
-- ------------------------------------------------------------
DELIMITER $$

CREATE PROCEDURE CategoriseRouteDistance()
BEGIN
    SELECT route_id, flight_num, distance_miles,
        CASE
            WHEN distance_miles >= 0 AND distance_miles <= 2000 THEN 'SDT'
            WHEN distance_miles > 2000 AND distance_miles <= 6500 THEN 'IDT'
            WHEN distance_miles > 6500 THEN 'LDT'
        END AS DISTANCE_CATEGORY
    FROM routes;
END $$

DELIMITER ;

CALL CategoriseRouteDistance();

-- ------------------------------------------------------------
-- Task 18: Stored function inside a stored procedure, complimentary services
-- ------------------------------------------------------------
DELIMITER $$

CREATE FUNCTION CheckComplimentary(class_name VARCHAR(20))
RETURNS VARCHAR(3)
DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(3);
    IF class_name = 'Bussiness' OR class_name = 'Economy Plus' THEN
        SET result = 'Yes';
    ELSE
        SET result = 'No';
    END IF;
    RETURN result;
END $$

CREATE PROCEDURE GetComplimentaryServices()
BEGIN
    SELECT p_date, customer_id, class_id,
           CheckComplimentary(class_id) AS COMPLIMENTARY_SERVICE
    FROM ticket_details;
END $$

DELIMITER ;

CALL GetComplimentaryServices();

-- ------------------------------------------------------------
-- Task 19: Cursor, first customer whose last name ends with Scott
-- ------------------------------------------------------------
DELIMITER $$

CREATE PROCEDURE GetFirstScottCustomer()
BEGIN
    DECLARE v_customer_id INT;
    DECLARE v_first_name VARCHAR(50);
    DECLARE v_last_name VARCHAR(50);
    DECLARE done INT DEFAULT FALSE;

    DECLARE scott_cursor CURSOR FOR
        SELECT customer_id, first_name, last_name
        FROM customer
        WHERE last_name LIKE '%Scott';

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN scott_cursor;
    FETCH scott_cursor INTO v_customer_id, v_first_name, v_last_name;
    CLOSE scott_cursor;

    SELECT v_customer_id AS CUSTOMER_ID, v_first_name AS FIRST_NAME, v_last_name AS LAST_NAME;
END $$

DELIMITER ;

CALL GetFirstScottCustomer();
