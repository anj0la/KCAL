/*
Author(s): Anjola Aina, Aarushi Gupta, Priscilla Adebanji, James Rota, Son Nghiem

Changes made:

	- We have reverted Meal back to one table. 
	This is because DAY_date and DAY_USER_user_id are foregin keys, 
	and adding them as a primary key in the table makes it susceptible to update anomolies. 
	Therefore, we made the primary key of MEAL Meal_id and Meal_timestamp unique, 
	making it a candidate key. The meal_id would determine every single value in the MEAL table.
    - We have changed email and password to user_email and user_password, as password is a keyword.
    - We have changed all day attributes in MEAL, WORKOUT and DAY to be [table_name]_day as day is a keyword.

*/

CREATE DATABASE IF NOT EXISTS KCAL;
USE KCAL;

CREATE TABLE `USER` 
(
	 user_id INT,
	 first_name VARCHAR(15),
	 last_name VARCHAR(15),
	 date_of_birth DATE, 
	 gender VARCHAR(15), 
	 username VARCHAR(15), -- NOT UNIQUE, so users can have the same username
	 email VARCHAR(25), 
	 `password` VARCHAR(25), 
	 height INT, 
	 weight INT, 
	 target_weight INT, 
	 profile_img LONGBLOB, 
	 join_date DATE, 
	 last_log_date DATE	
);

CREATE TABLE `DAY` 
(
	`date` DATE,
	 user_id INT -- foreign key (many side of relationship between DAY and USER
); 

CREATE TABLE WORKOUT 
(
	workout_id INT,
	workout_name VARCHAR(20), 
	workout_date DATE, 
	user_id INT, -- foreign key, many side of WORKOUT and USER
	calories_burned INT
);

CREATE TABLE EXERCISE 
(
	exercise_id INT, 
	exercise_name VARCHAR(25), 
	equipment_type VARCHAR(25), 
	exercise_category VARCHAR(25), 
	primary_muscle_grp VARCHAR(25), 
	secondary_muscle_grp VARCHAR(25)
);

-- RELATIONSHIP TABLE (MANY TO MANY)
CREATE TABLE WORKOUT_MADE_OF_EXERCISE 
(
	exercise_id INT, -- foreign key
    workout_id INT -- foreign key
);

CREATE TABLE FOOD 
(
	food_id INT, 
	food_name VARCHAR(25), 
	food_category VARCHAR(20), 
	serving_size INT, 
	serving_unit VARCHAR(15), 
	is_metric BOOLEAN, 
	calories INT, 
	total_fats INT, 
	saturated_fats INT, 
	cholesterol INT, 
	sodium INT, 
	total_carbs INT, 
	fibre INT, 
	sugar INT, 
	protein INT, 
	calcium INT, 
	iron INT, 
	potassium INT, 
	vitamin_D INT, 
	magnesium INT, 
	zinc INT, 
	vitamin_A INT, 
	vitamin_C INT
);

CREATE TABLE MEAL 
(
	meal_id INT, 
	meal_timestamp TIMESTAMP,
	meal_date DATE, -- foreign key, PK is in DAY
	user_id INT, 
	meal_category VARCHAR(20)
);
-- PRIMARY KEY AND UNIQUENESS CONSTRAINTS GO HERE
-- EXAMPLE: ALTER TABLE MEAL
-- 			ADD CONSTRAINT PK_Meal PRIMARY KEY (meal_id);

-- RELATIONSHIP TABLE (MANY TO MANY)
CREATE TABLE MEAL_CONTAINS_FOOD 
(
	meal_id INT, -- foreign key
	food_id INT -- foreign key
);
-- DELETE QUERIES

DELIMITER //

-- Deleting a user from the database given a user_id (as a stored procedure)
CREATE PROCEDURE DeleteUser(IN user_id INT)
BEGIN
	-- Delete the user from the USERS table with the specified user id
	DELETE FROM `USER`
    WHERE `USER`.user_id = user_id;
END//
DELIMITER ;

-- Deleting all meals from a specified day (as a stored procedure)
DELIMITER //
CREATE PROCEDURE DeleteAllMealsFromSpecifiedDay(IN specified_date DATE)
BEGIN
	DELETE FROM MEAL
    WHERE (MEAL.meal_date = `DAY`.`date`) AND (`DAY`.`date` = specified_date);
END//
DELIMITER ;

-- Deleting all foods from a specified meal (as a stored procedure)
-- The difference between this procedure and its former is that it does not delete the 
-- day from the table, just the foods and the meal itself

DELIMITER //
CREATE PROCEDURE DeleteAllFoodsFromSpecifiedMeal(IN specified_date DATE)
BEGIN
	DELETE FROM FOOD
    WHERE (MEAL.day_id = DAY.day_id) AND (DAY.date = specified_date);
END//
DELIMITER ;