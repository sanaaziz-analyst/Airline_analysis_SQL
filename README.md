# Air Cargo Analysis

**Industry:** Aviation and Airline Operations
**Tools:** MySQL, MySQL Workbench

> **A note on the data:** the dataset used in this project is an openly available practice dataset representing a fictional aviation company called Air Cargo. It is not real airline or passenger data, and was picked up specifically to practise and demonstrate SQL skills against a realistic customer, ticketing and route management scenario.

---

> Every query in this project was run against a real MySQL compatible database, loaded with the four CSV files in the Datasets folder, rather than only written and assumed to work. Every result file in the Results folder is genuine query output, not a manually typed example.

## Datasets Provided

* [customer.csv](Datasets/customer.csv), fifty customers with their name, date of birth and gender
* [routes.csv](Datasets/routes.csv), forty nine routes, each with an origin, destination, aircraft and distance
* [ticket_details.csv](Datasets/ticket_details.csv), fifty ticket purchases, including class, price and airline brand
* [passengers_on_flights.csv](Datasets/passengers_on_flights.csv), fifty individual passenger journeys, including seat, class and travel date

---

## Problem Scenario

Air Cargo is an aviation company providing air transportation for passengers and freight, operating through partnerships and alliances with other airlines. The company wants reports on regular passengers, busiest routes and ticket sales details, to improve the ease of travel and booking for its customers.

## Goal

As the database administrator on this project, the brief is to identify regular customers so the company can offer them targeted deals, analyse the busiest routes to help plan aircraft requirements, and prepare a full analysis of ticket sales, so Air Cargo can improve its operability and become a more customer centred, favourable choice for air travel.

---

## Tasks to be Performed

Every query below is written in the same single file, [arline_project.md](arline_project.md), clearly labelled by task number, with each task as its own section. The SQL Query column in the table links straight to that task's own section in the file, rather than a separate file per task.

| Task # | Task | SQL Query | Result CSV |
|--------|------|-----------|------------|
| 1 | Create the route_details table with constraints | [Query](arline_project.md#task-1-create-the-route_details-table-with-constraints) | [View Result](Results/task_1_create_route_details_table.csv) |
| 2 | Passengers who travelled on routes 1 to 25 | [Query](arline_project.md#task-2-passengers-who-travelled-on-routes-1-to-25) | [View Result](Results/task_2_passengers_routes_1_to_25.csv) |
| 3 | Business class passenger count and revenue | [Query](arline_project.md#task-3-business-class-passenger-count-and-revenue) | [View Result](Results/task_3_business_class_passengers_revenue.csv) |
| 4 | Customer full name | [Query](arline_project.md#task-4-customer-full-name) | [View Result](Results/task_4_customer_full_name.csv) |
| 5 | Customers who have registered and booked a ticket | [Query](arline_project.md#task-5-customers-who-have-registered-and-booked-a-ticket) | [View Result](Results/task_5_registered_and_booked_customers.csv) |
| 6 | Customer name by brand, Emirates | [Query](arline_project.md#task-6-customer-name-by-brand-emirates) | [View Result](Results/task_6_customer_name_by_brand.csv) |
| 7 | Economy Plus passengers using GROUP BY and HAVING | [Query](arline_project.md#task-7-economy-plus-passengers-using-group-by-and-having) | [View Result](Results/task_7_economy_plus_group_having.csv) |
| 8 | Whether revenue has crossed 10000 | [Query](arline_project.md#task-8-whether-revenue-has-crossed-10000) | [View Result](Results/task_8_revenue_crossed_10000.csv) |
| 9 | Create and grant access to a new user | [Query](arline_project.md#task-9-create-and-grant-access-to-a-new-user) | [View Result](Results/task_9_create_and_grant_user.csv) |
| 10 | Max ticket price per class using a window function | [Query](arline_project.md#task-10-max-ticket-price-per-class-using-a-window-function) | [View Result](Results/task_10_max_price_per_class.csv) |
| 11 | Passengers on route 4, with an index added for speed | [Query](arline_project.md#task-11-passengers-on-route-4-with-an-index-added-for-speed) | [View Result](Results/task_11_route_4_index.csv) |
| 12 | Execution plan for route 4, before and after the index | [Query](arline_project.md#task-12-execution-plan-for-route-4-before-and-after-the-index) | [View Result](Results/task_12_route_4_execution_plan.csv) |
| 13 | Total price per customer and aircraft using ROLLUP | [Query](arline_project.md#task-13-total-price-per-customer-and-aircraft-using-rollup) | [View Result](Results/task_13_total_price_rollup.csv) |
| 14 | A view of business class customers and their brand | [Query](arline_project.md#task-14-a-view-of-business-class-customers-and-their-brand) | [View Result](Results/task_14_business_class_view.csv) |
| 15 | Stored procedure, passengers within a route range | [Query](arline_project.md#task-15-stored-procedure-passengers-within-a-route-range) | [View Result](Results/task_15_stored_procedure_route_range.csv) |
| 16 | Stored procedure, routes over 2000 miles | [Query](arline_project.md#task-16-stored-procedure-routes-over-2000-miles) | [View Result](Results/task_16_stored_procedure_long_routes.csv) |
| 17 | Stored procedure, distance category, SDT, IDT, LDT | [Query](arline_project.md#task-17-stored-procedure-distance-category-sdt-idt-ldt) | [View Result](Results/task_17_stored_procedure_distance_category.csv) |
| 18 | Stored function inside a stored procedure, complimentary services | [Query](arline_project.md#task-18-stored-function-inside-a-stored-procedure-complimentary-services) | [View Result](Results/task_18_stored_function_complimentary_services.csv) |
| 19 | Cursor, first customer whose last name ends with Scott | [Query](arline_project.md#task-19-cursor-first-customer-whose-last-name-ends-with-scott) | [View Result](Results/task_19_cursor_first_scott_customer.csv) |

---

## What Each Task Actually Does

A short, plain English explanation of each task, beyond just the query itself.

**Task 1, Create the route_details table with constraints.** A fresh table built with a unique constraint on route_id and check constraints ensuring flight_num and distance_miles are always greater than zero. Rather than just writing the CREATE TABLE statement and assuming it works, the real forty nine rows from routes were loaded in successfully, then two deliberately invalid inserts were attempted, one with a negative distance and one with a duplicate route_id, and both genuinely failed against the real database exactly as the constraints are meant to prevent.

**Task 2, Passengers who travelled on routes 1 to 25.** A straightforward range filter on passengers_on_flights. Worth knowing, route 11 does not exist anywhere in the dataset, a genuine gap in the data rather than a query error, so the result naturally skips from route 10 to route 12.

**Task 3, Business class passenger count and revenue.** Sums up the number of tickets and total revenue for business class specifically. Worth flagging honestly, the class value in the real data is spelled Bussiness, not Business, a genuine typo carried through the original dataset, so the query filters on the value exactly as it appears rather than the correctly spelled word.

**Task 4, Customer full name.** Concatenates first and last name into one column for every customer, a small but genuinely tidier output than two separate columns.

**Task 5, Customers who have registered and booked a ticket.** An inner join between customer and ticket_details, returning only customers who appear in both, meaning they are registered in the system and have actually purchased at least one ticket.

**Task 6, Customer name by brand, Emirates.** Joins customer and ticket_details to pull out the name of every customer who has booked with Emirates specifically, useful for brand level marketing or loyalty analysis.

**Task 7, Economy Plus passengers using GROUP BY and HAVING.** Groups passengers_on_flights by customer and class, then uses HAVING to filter that grouped result down to Economy Plus only, the correct way to filter on a grouped result rather than filtering the raw rows beforehand.

**Task 8, Whether revenue has crossed 10000.** Uses IF directly inside a SELECT statement to turn a plain number into a clear yes or no answer, total revenue across all tickets comes to 15,369, comfortably past the 10,000 mark.

**Task 9, Create and grant access to a new user.** Creates a genuine new MySQL user account and grants it SELECT, INSERT and UPDATE access on the airlines database specifically, rather than full administrative rights, the kind of least privilege access a real DBA would set up for a new analyst joining the team.

**Task 10, Max ticket price per class using a window function.** A window function calculates the highest price paid within each class without collapsing the rest of the data down to one row per class, useful for understanding the top of the pricing range for every class side by side.

**Task 11, Passengers on route 4, with an index added for speed.** Adds an index on route_id to passengers_on_flights before running the filter, directly addressing the brief's request to improve speed and performance rather than just running the same query unchanged.

**Task 12, Execution plan for route 4, before and after the index.** EXPLAIN run against the real database confirms the improvement directly, before the index, MySQL scans all fifty rows in the table with type ALL, after the index from task 11, the same query drops to type ref scanning only three rows, a measurable performance improvement rather than a theoretical one.

**Task 13, Total price per customer and aircraft using ROLLUP.** Groups spending by customer and aircraft, then WITH ROLLUP adds an automatic subtotal row for each customer and a grand total row at the very end, which comes to 15,369 across all customers, matching task 8 exactly.

**Task 14, A view of business class customers and their brand.** Saves a join between customer and ticket_details as a permanent view, so anyone can query business class customers and their airline brand going forward with a simple SELECT, without needing to remember or rewrite the underlying join.

**Task 15, Stored procedure, passengers within a route range.** Takes a start and end route number as parameters at runtime, checks whether the passengers_on_flights table actually exists first using information_schema, and only then runs the range query, returning a clear error message instead of a raw SQL error if the table were ever missing.

**Task 16, Stored procedure, routes over 2000 miles.** Packages a simple distance filter as a reusable stored procedure against the routes table, returning twenty four routes that qualify as longer haul.

**Task 17, Stored procedure, distance category, SDT, IDT, LDT.** Categorises every route into short distance travel, intermediate distance travel or long distance travel using a CASE expression inside a stored procedure, based on the distance bands set out in the brief.

**Task 18, Stored function inside a stored procedure, complimentary services.** A stored function takes a class name and returns Yes or No depending on whether that class includes complimentary services, Business and Economy Plus do, Economy and First Class do not, based on the brief's own condition. That function is then called from inside a stored procedure that returns it alongside the ticket purchase date, customer ID and class for every single ticket.

**Task 19, Cursor, first customer whose last name ends with Scott.** A cursor steps through every customer whose last name ends with Scott and returns only the first one it reaches. There are genuinely two Scotts in the data, Samuel Scott and Alexis Scott, and the cursor correctly returns Samuel Scott, the one appearing first in customer ID order.



---

## Why I Built This Project

I love working with data, it is genuinely what I enjoy doing, and I picked up this dataset from an open source specifically to push my SQL skills further and give myself a proper reason to practise the parts of SQL that a simple SELECT statement never touches, constraints, window functions, stored procedures, a stored function called from within a procedure, and a cursor. Every task here maps to a real business question a database administrator would actually be asked to solve, identifying regular customers, analysing busiest routes, calculating revenue, and proving that constraints, indexes, procedures and cursors all genuinely work rather than just reading correctly on the page. Building it out properly, end to end, against a real database, is simply the kind of project I enjoy creating.

## Skills This Project Demonstrates

* Relational database design, including constraints such as UNIQUE and CHECK, proven against real invalid data rather than just written and assumed correct
* Core SQL, filtering, joins, grouping, aggregating and string functions
* Window functions, and ROLLUP for automatic subtotals and grand totals
* Views, stored procedures, a stored function called from within a stored procedure, and a cursor
* User management, creating a new database user with least privilege access
* Query performance analysis using EXPLAIN, and using an index to demonstrably improve it
* Translating a plain English business question into correct, working SQL, and validating the result against the real data rather than assuming it is correct



## What Could Be Added With More Time

* A short written summary pulling together the revenue, route and customer findings across all nineteen tasks into two or three overall business conclusions
* Screenshots of each query running inside MySQL Workbench, alongside the plain CSV results, for anyone who wants to see the tool itself in use
* A data cleaning pass correcting the Bussiness and Bristish Airways typos in a separate cleaned copy of the dataset, while keeping the original raw files untouched for transparency

## Acknowledgements

The dataset and business scenario for this project were sourced from an openly available SQL practice resource. All SQL queries, the entity relationship diagram and this write up are my own work.


---

## Contact

**Sana Aziz**

Data Analyst | SQL • Excel • Power BI • Tableau • Python

London, UK

[![Gmail](https://img.shields.io/badge/Gmail-sana.aziz.leo%40gmail.com-D14836?style=flat&logo=gmail&logoColor=white)](mailto:sana.aziz.leo@gmail.com)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-sana--aziz--analyst--uk-0077B5?style=flat&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/sana-aziz-analyst-uk/)
