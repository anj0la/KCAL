/*
File: KCAL.sql
Author(s): Anjola Aina, Aarushi Gupta, Priscilla Adebanji, James Rota, Son Nghiem

Date: April 9th, 2024

Changes Made:

	- We have reverted Meal back to one table. This is because DAY_date and DAY_USER_user_id are foregin keys, and adding them as a primary key in the table makes it susceptible to update anomolies. 
	Therefore, we made the primary key of MEAL Meal_id and Meal_timestamp unique, making it a candidate key. The meal_id would determine every single value in the MEAL table.
    - We have removed profile_img from the USER table to make it easier to insert data.

*/

CREATE DATABASE IF NOT EXISTS KCAL;
USE KCAL;

CREATE TABLE USER 
(
	 user_id INT NOT NULL,
	 first_name VARCHAR(15) NOT NULL,
	 last_name VARCHAR(15) NOT NULL,
	 date_of_birth DATE NOT NULL, 
	 gender VARCHAR(15) NOT NULL, 
	 username VARCHAR(15) NOT NULL, -- NOT UNIQUE, so users can have the same username
	 email VARCHAR(25) NOT NULL, 
	 `password` VARCHAR(25) NOT NULL, 
	 height INT NOT NULL, 
	 weight INT NOT NULL, 
	 target_weight INT NOT NULL, 
	 join_date DATE NOT NULL, 
	 last_log_date DATE	 NOT NULL
);

CREATE TABLE DAY 
(
	`date` DATE NOT NULL,
	 user_id INT -- foreign key (many side of relationship between DAY and USER
); 

CREATE TABLE WORKOUT 
(
	workout_id INT NOT NULL,
	workout_name VARCHAR(20) NOT NULL, 
	workout_date DATE NOT NULL, 
	user_id INT, -- foreign key, many side of WORKOUT and USER
	calories_burned INT NOT NULL
);

CREATE TABLE EXERCISE 
(
	exercise_id INT NOT NULL, 
	exercise_name VARCHAR(25) NOT NULL, 
	equipment_type VARCHAR(25), 
	exercise_category VARCHAR(25) NOT NULL, 
	primary_muscle_grp VARCHAR(25) NOT NULL, 
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
	food_id INT NOT NULL, 
	food_name VARCHAR(25) NOT NULL, 
	food_category VARCHAR(20) NOT NULL, 
	serving_size INT NOT NULL, 
	serving_unit VARCHAR(15) NOT NULL, 
	is_metric BOOLEAN NOT NULL, 
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
	meal_id INT NOT NULL, 
	meal_timestamp TIMESTAMP, -- unique
	meal_date DATE, -- foreign key, PK is in DAY
	meal_category VARCHAR(20) NOT NULL
);

-- RELATIONSHIP TABLE (MANY TO MANY)
CREATE TABLE MEAL_CONTAINS_FOOD 
(
	meal_id INT, -- foreign key
	food_id INT -- foreign key
);

-- ========================================= ALTER TABLE STATEMENTS =========================================

-- Users
ALTER TABLE USER

-- Primary key constraint
ADD PRIMARY KEY (user_id);

-- Day
ALTER TABLE `DAY`

-- Foreign key constraint (many days correspond to a user)
ADD CONSTRAINT fk_user_id
FOREIGN KEY (user_id)
REFERENCES USER(user_id)
ON DELETE SET NULL
ON UPDATE CASCADE,

ADD PRIMARY KEY (`date`);

-- Workout
ALTER TABLE WORKOUT

-- Foreign key constraint (many workouts correspond to a user)
ADD CONSTRAINT fk_workout_user_id
FOREIGN KEY (user_id)
REFERENCES USER(user_id)
ON DELETE SET NULL
ON UPDATE CASCADE,

-- Primary key constraint
ADD PRIMARY KEY (workout_id);

-- Exercise
ALTER TABLE EXERCISE
ADD PRIMARY KEY (exercise_id);

-- Food
ALTER TABLE FOOD

-- Setting default value for metric = true (because this is a Canadian app)
ALTER is_metric SET DEFAULT TRUE, 
-- Primary key constraint
ADD PRIMARY KEY (food_id);

-- Meal
ALTER TABLE MEAL

-- Foreign key constraint (many meals correspond to a day)
ADD CONSTRAINT fk_meal_date
FOREIGN KEY (meal_date)
REFERENCES DAY(`date`)
ON DELETE SET NULL
ON UPDATE CASCADE,

-- Uniqueness constraint on meal timestamp
ADD CONSTRAINT meal_timestamp_uniqueness UNIQUE (meal_timestamp),
-- Primary key constraint
ADD PRIMARY KEY (meal_id);

-- Meal Contains Food
ALTER TABLE MEAL_CONTAINS_FOOD

-- Foreign key constraints (many meals correspond to many foods)
ADD CONSTRAINT fk_meal_id
FOREIGN KEY (meal_id)
REFERENCES MEAL(meal_id)
ON DELETE CASCADE
ON UPDATE CASCADE,

-- Foreign key constraints (many foods correspond to many meals)
ADD CONSTRAINT fk_food_id
FOREIGN KEY (food_id)
REFERENCES FOOD(food_id)
ON DELETE CASCADE
ON UPDATE CASCADE,

-- Primary key constraint
ADD PRIMARY KEY(meal_id, food_id);

-- Workout Made of Exercise
ALTER TABLE WORKOUT_MADE_OF_EXERCISE

-- Foreign key constraints (many exercises correspond to many workouts)
ADD CONSTRAINT fk_exercise_id
FOREIGN KEY (exercise_id)
REFERENCES EXERCISE(exercise_id)
ON DELETE CASCADE
ON UPDATE CASCADE,

-- Foreign key constraints (many workouts correspond to many exercises)
ADD CONSTRAINT fk_workout_id
FOREIGN KEY (workout_id)
REFERENCES WORKOUT(workout_id)
ON DELETE CASCADE
ON UPDATE CASCADE,

-- Primary key constraint
ADD PRIMARY KEY(exercise_id, workout_id);

-- ========================================= INSERT QUERIES =========================================

-- Inserting dummy data into USER table
INSERT INTO USER (user_id, first_name, last_name, date_of_birth, gender, username, email, password, height, weight, target_weight, join_date, last_log_date)
VALUES 
(1, 'John', 'Doe', '1990-01-01', 'Male', 'johndoe', 'johndoe@example.com', 'password123', 180, 75, 70, '2024-01-01', '2024-04-09'),
(2, 'Jane', 'Smith', '1985-05-15', 'Female', 'janesmith', 'janesmith@example.com', 'password456', 160, 55, 50, '2024-02-01', '2024-04-09');

-- Inserting dummy data into DAY table
INSERT INTO DAY (`date`, user_id)
VALUES 
('2024-04-09', 1),
('2024-04-08', 2);

-- Inserting dummy data into WORKOUT table
INSERT INTO WORKOUT (workout_id, workout_name, workout_date, user_id, calories_burned)
VALUES 
(1, 'Morning Run', '2024-04-09', 1, 300),
(2, 'Evening Gym Session', '2024-04-09', 2, 500);

-- Inserting dummy data into EXERCISE table
INSERT INTO EXERCISE (exercise_id, exercise_name, equipment_type, exercise_category, primary_muscle_grp, secondary_muscle_grp)
VALUES 
(1, 'Running', 'None', 'Cardio', 'Legs', NULL),
(2, 'Weight Lifting', 'Dumbbells', 'Strength', 'Arms', 'Shoulders');

-- Inserting dummy data into FOOD table
INSERT INTO FOOD (food_id, food_name, food_category, serving_size, serving_unit, is_metric, calories, total_fats, saturated_fats, cholesterol, sodium, total_carbs, fibre, sugar, protein, calcium, iron, potassium, vitamin_D, magnesium, zinc, vitamin_A, vitamin_C)
VALUES 
(1, 'Apple', 'Fruit', '150', 'grams', TRUE, 52, 0.2, 0, 0, 1, 14, 2.4, 10.4, 0.3, 5, 0.1, 107, 0, 5, 0, 3, NULL),
(2, 'Chicken Breast', 'Poultry', 100, 'grams', TRUE, 165, 3.6, 1, 85, 74, 0, 0, 0, 31, 1, 0.1, 256, 0, 12, 0, 0, NULL);

-- Inserting dummy data into MEAL table
INSERT INTO MEAL (meal_id, meal_timestamp, meal_date, meal_category)
VALUES 
(1, '2024-04-09 12:00:00', '2024-04-09', 'Lunch'),
(2, '2024-04-09 19:00:00', '2024-04-09', 'Dinner');

-- Inserting dummy data into MEAL_CONTAINS_FOOD table
INSERT INTO MEAL_CONTAINS_FOOD (meal_id, food_id)
VALUES 
(1, 1),
(2, 2);

-- Inserting dummy data into WORKOUT_MADE_OF_EXERCISE table
INSERT INTO WORKOUT_MADE_OF_EXERCISE (workout_id, exercise_id)
VALUES 
(1, 1),
(2, 2);

-- ========================================= UPDATE QUERIES =========================================

-- The team chose the following queries to be executed as procedures, as we assume that users 
-- will be executing the following queries the most. These are queries that you can expect a typical
-- fitness application would allow a user to do.

-- UPDATE PASSWORD (ie. change password) as a procedure --
DELIMITER //
CREATE PROCEDURE UpdateUserPassword(IN user_id INT, IN new_password VARCHAR(25))
BEGIN
	UPDATE USER AS u
	SET u.password = new_password
	WHERE u.user_id = user_id;
END//
DELIMITER ;

-- UPDATE TARGET WEIGHT (ie. change goal weight) as a procedure --
DELIMITER //
CREATE PROCEDURE UpdateUserTargetWeight(IN user_id INT, IN new_target_weight INT)
BEGIN
	UPDATE USER AS u
	SET u.target_weight = new_target_weight 
	WHERE u.user_id = user_id;
END//
DELIMITER ;

-- Example call: Update the weight of user with id 1 to be 130 lbs
CALL UpdateUserTargetWeight(1, 130);

-- UPDATE MEAL CATEGORY (BREAKFAST, LUNCH, DINNER) --

DELIMITER //

CREATE PROCEDURE UpdateMealCategory(IN meal_id_p INT, IN meal_category_p VARCHAR(20))
BEGIN
    UPDATE MEAL AS m
    SET m.meal_category = meal_category_p
    WHERE m.meal_id = meal_id_p;
END//
DELIMITER ;

-- UPDATE AN ENTIRE WORKOUT FOR A SPECIFIC workout_id
DELIMITER //
CREATE PROCEDURE UpdateWorkout(IN workout_id_p INT, IN workout_name_p VARCHAR(25), IN workout_date_p DATE, IN user_id_p INT, IN calories_burned_p INT)
BEGIN
	UPDATE WORKOUT AS w
	SET w.workout_name = workout_name_p,
		w.workout_date = workout_date_p,
		w.user_id = user_id_p,
		w.calories_burned = calories_burned_p
	WHERE w.workout_id = workout_id_p;
END//
DELIMITER ;

-- UPDATE CALORIES BURNED (Update the number of calories burned throughout a workout) -- 
DELIMITER //
CREATE PROCEDURE UpdateCaloriesBurnt(IN workout_id_p INT, IN new_calories_burnt INT)
BEGIN
	UPDATE WORKOUT AS w
	SET w.calories_burned = new_calories_burnt
	WHERE w.workout_id = workout_id_p;
END//
DELIMITER ;

-- UPDATE AN ENTIRE EXERCISE FOR A SPECIFIC exercise_id -- 

DELIMITER //
CREATE PROCEDURE UpdateExercise(IN exercise_id_p INT, IN exercise_name_p VARCHAR(25), IN equipment_type_p VARCHAR(25), IN exercise_category_p VARCHAR(25), IN primary_muscle_p VARCHAR(25), IN secondary_muscle_p VARCHAR(25))
BEGIN
	UPDATE EXERCISE AS e
	SET e.exercise_name = exercise_name_p,
		e.equipment_type = equipment_type_p,
		e.exercise_category = exercise_category_p,
		e.primary_muscle_grp = primary_muscle_p,
		e.secondary_muscle_grp = secondary_muscle_p
	WHERE e.exercise_id = exercise_id_p;
END//
DELIMITER ;

-- ========================================= DELETE QUERIES =========================================

-- All delete queries were stored using procedures, so that the statements can be executed given the parameters.
-- To execute the query, you would call the procedure along with parameter values. Some examples have been provided below.

DELIMITER //

-- Deleting a user from the database given a user_id (as a stored procedure)
CREATE PROCEDURE DeleteUser(IN user_id INT)
BEGIN
	-- Delete the user from the USERS table with the specified user id
	DELETE FROM USER AS u
    WHERE u.user_id = user_id;
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
DELIMITER //
CREATE PROCEDURE DeleteAllFoodsFromMeal(IN meal_id INT)
BEGIN
	DELETE FROM FOOD AS f
	WHERE f.food_id IN (
    SELECT mf.food_id
    FROM MEAL_CONTAINS_FOOD AS mf
    JOIN MEAL ON mf.meal_id = meal_id
    WHERE mf.food_id = f.food_id); 
END//
DELIMITER ;

-- Deleting a specific food from a specified meal (as a stored procedure)
-- The difference between this procedure and its former is that it does not delete the 
-- day from the table, just the foods and the meal itself

DELIMITER //
CREATE PROCEDURE DeleteFoodFromMeal(IN meal_id INT, IN food_id INT)
BEGIN
	DELETE FROM FOOD
	WHERE food_id IN (
    SELECT mf.food_id
    FROM MEAL_CONTAINS_FOOD AS mf
    JOIN MEAL ON mf.meal_id = meal_id
    WHERE mf.food_id = food_id); -- we use a select statement to link the meal_id
														-- to the food_id via the relationship table
END//
DELIMITER ;

-- ========================================= SPECIFIC EXAMPLES USING QUERIES =========================================

-- ======================= SPECIFIC UPDATE EXAMPLES =======================

-- Example call: Update the password of user with id 1 to be 123456
CALL UpdateUserPassword(1, '12345');

-- Example call: Update meal category of user 1 to be Breakfast
CALL UpdateMealCategory(1, 'Breakfast');

-- Example call: Update the workout with an id value of 1, associated with user 1 to be an Afternoon Run
CALL UpdateWorkout(1, 'Afternoon Run', CURRENT_DATE(), 1, 350);

-- Example call: Update exercise with an id of 1 with the following values
CALL UpdateExercise(1, 'Squat', 'Barbell', 'Strength', 'Quads', 'Glutes');

-- Example call: Update calories burnt on the workout with an id value of 1
CALL UpdateCaloriesBurnt(1, 400);

-- ======================= SPECIFIC DELETE EXAMPLES =======================

-- Example call: Delete user 4 from the table
SELECT * 
FROM USER;
CALL DeleteUser(4);
SELECT * 
FROM USER;

-- Example call: Delete all meals from April 6th, 2024
SELECT * 
FROM MEAL;
CALL DeleteAllMealsFromSpecifiedDay('2024-04-06');
SELECT * 
FROM MEAL;

-- Example call: Delete all foods from a meal with meal id 3
SELECT * 
FROM FOOD;
CALL DeleteAllFoodsFromMeal(3);
SELECT * 
FROM FOOD;

-- Example call: Delete food id 1 from a meal with meal id 4
SELECT * 
FROM FOOD;
CALL DeleteAllFoodsFromMeal(1, 4);
SELECT * 
FROM FOOD;
