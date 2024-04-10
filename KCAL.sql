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

-- USERS
INSERT INTO USER VALUES 

-- Active Users
(1, 'Jonathan', 'Magnus', 1997-09-24, 'Male', 
'Jmagnus', 'Jmagnus@yahoo.com', '1$CoolPassword$1',
178, 145, 190, 'duck_img.png', 2022-01-01, 2024-04-09),

(2, 'Wendy', 'Woo', 2000-02-07, 'Female', 
'wendytheleader', 'wendy.woo@gmail.com', 'password$2452',
178, 145, 190, 'cat_img.png', 2020-02-11, 2024-04-09),

(3, 'Sandra', 'Parker', 1989-05-12, 'Female', 
'sandragymgirl', 'sparker@hotmail.com', '',
178, 145, 190, 'cat_img.png', 2020-02-11, 2024-04-09),

(4, 'Wendy', 'Woo', 2000-02-07, 'Female', 
'wendytheleader', 'wendy.woo@gmail.com', '',
178, 145, 190, 'cat_img.png', 2020-02-11, 2024-04-09),

-- Inactive Users
(5, 'Joshua', 'Phillips', 1995-08-27, 'Rather not say', 
'D_GymRat', 'JPhillips@hotmail.com', 'NevaGiveUp_K**pPu$h1ng',
180,300,200,"cool_dog_img.png", 2024-01-01, 2024-01-28);

-- DAY
INSERT INTO `DAY` VALUES 
-- yesterday
(2024-04-08, 1),

-- today
(2024-04-09, 1);

-- WORKOUT
INSERT INTO WORKOUT VALUES 
(101, 2024-04-08, 1, "LEGS", 500);

-- EXERCISE
INSERT INTO EXCERCISE VALUES
(201, "Bulgarian Split Squats", "Dumbbell", "Strength Training", "Quadriceps", "Glutes"),
(202, "Squats", "Barbell", "Strength Training", "Quadriceps", "Glutes");

-- MEAL
INSERT INTO MEAL VALUES 
(98, 2024-04-08, 1, "Breakfast", '2024-04-08 18-59-13'), 
(97, 2024-04-08, 1, "Lunch", '2024-04-08 10-05-13');

-- FOOD
INSERT INTO FOOD VALUES 
(1, 'Turtle Chips', 'Chips', 28, 'Grams', 1, 160, 10, 4, 0, 190, 16, 0, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0);

-- ========================================= UPDATE QUERIES =========================================

-- UPDATE STATEMENTS: USER TABLE -- 

-- UPDATE PASSWORD (ie. change password) as a procedure --
DELIMITER //
CREATE PROCEDURE UpdateUserPassword(IN user_id INT, IN new_password INT)
BEGIN
	UPDATE USER
SET password = new_password
WHERE user_id = user_id;
END//
DELIMITER ;

-- UPDATE TARGET WEIGHT (ie. change goal weight) as a procedure --
DELIMITER //
CREATE PROCEDURE UpdateUserTargetWeight(IN user_id INT, IN new_target_weight INT)
BEGIN
	UPDATE USER
SET target_weight = new_target_weight 
WHERE user_id = user_id;
END//
DELIMITER ;

-- UPDATE LAST LOGGED IN (adjust the last time the user logged in) --
UPDATE USER
SET last_log_date = CURRENT_DATE();

-- ========================================= -- 

-- UPDATE STATEMENTS: DAY TABLE -- 

-- UPDATE DAY (Update DAY to the current day) for the current user --

DELIMITER //
CREATE PROCEDURE UpdateUserDay(IN user_id INT)
BEGIN
	UPDATE `DAY`
	JOIN USER ON DAY.user_id = USER.user_id
	SET DAY.date = CURRENT_DATE() 
	WHERE USER.user_id = user_id;
END//
DELIMITER ;

-- Example of the statement when user_id = 1
UPDATE `DAY`
JOIN USER ON DAY.user_id = USER.user_id
SET DAY.date = CURRENT_DATE()
WHERE user_id = 1;

-- ========================================= -- 

-- UPDATE STATEMENTS: MEAL TABLE -- 

-- UPDATE MEAL CATEGORY (BREAKFAST, LUNCH, DINNER) --

UPDATE MEAL
JOIN USER ON MEAL.user_id = USER.user_id
SET meal_category = 'Lunch'
WHERE meal_id = 1;

-- UPDATE MEAL TIME STAMP (DATE AND TIME) --
UPDATE MEAL
JOIN USER ON MEAL.user_id = USER.user_id
SET meal_timestamp = NOW() -- NOW() GETS CURRENT TIME AND DATE
WHERE meal_id = 1;

-- ========================================= -- 

-- UPDATE STATEMENTS: WORKOUT TABLE -- 

-- UPDATE AN ENTIRE WORKOUT FOR A SPECIFIC workout_id
DELIMITER //
CREATE PROCEDURE UpdateWorkout(IN workout_id_p INT, IN workout_name_p VARCHAR(25), IN workout_date_p DATE, IN user_id_p INT, IN calories_burned_p INT)
BEGIN
	UPDATE WORKOUT AS w
	SET w.workout_name = workout_name_p,
		w.workout_date = workout_date_p,
		w.user_id = user_id_p,
		w.calories_burned = calories_burned_p,
	WHERE w.workout_id = workout_id_p;
END//
DELIMITER ;

-- UPDATE CALORIES BURNED (Update the number of calories burned throughout a workout) -- 
CREATE PROCEDURE UpdateCaloriesBurnt(IN workout_id_p INT, IN new_calories_burnt INT)
BEGIN
	UPDATE WORKOUT AS w
	SET w.calories_burned = new_calories_burnt,
	WHERE w.workout_id = workout_id_p;
END//
DELIMITER ;

-- ========================================= -- 

-- UPDATE STATEMENTS: FOOD TABLE -- 

-- UPDATE THE SERVING SIZE BASED ON THE CURRENT SERVING SIZE -- 

UPDATE FOOD
SET serving_size = serving_size + 10 
WHERE food_id = 1;

-- ========================================= -- 

-- UPDATE STATEMENTS: EXERCISE TABLE -- 

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
	DELETE FROM USER
    WHERE USER.user_id = user_id;
END//
DELIMITER ;

-- Example: Delete user 4 from the table
SELECT * 
FROM USER;
DeleteUser(4)
SELECT * 
FROM USER;

-- Deleting all meals from a specified day (as a stored procedure)
DELIMITER //
CREATE PROCEDURE DeleteAllMealsFromSpecifiedDay(IN specified_date DATE)
BEGIN
	DELETE FROM MEAL
    WHERE (MEAL.meal_date = `DAY`.`date`) AND (`DAY`.`date` = specified_date);
END//
DELIMITER ;

-- Example: Delete all meals from April 6th, 2024.
SELECT * 
FROM MEAL;
DeleteAllMealsFromSpecifiedDay('2024-04-06')
SELECT * 
FROM MEAL;

-- Deleting all foods from a specified meal (as a stored procedure)
-- The difference between this procedure and its former is that it does not delete the 
-- day from the table, just the foods and the meal itself

DELIMITER //
CREATE PROCEDURE DeleteAllFoodsFromMeal(IN meal_id INT)
BEGIN
	DELETE FROM FOOD
	WHERE FOOD.food_id IN (
    SELECT MEAL_CONTAINS_FOOD.food_id
    FROM MEAL_CONTAINS_FOOD
    JOIN MEAL ON MEAL_CONTAINS_FOOD.meal_id = meal_id
    WHERE MEAL_CONTAINS_FOOD.food_id = FOOD.food_id); -- we use a select statement to link the meal_id
													  -- to the food_id via the relationship table
END//
DELIMITER ;

-- Example: Delete all foods from a meal with meal id 3
SELECT * 
FROM FOOD;
DeleteAllFoodsFromMeal(4)
SELECT * 
FROM FOOD;

-- Deleting a specific food from a specified meal (as a stored procedure)
-- The difference between this procedure and its former is that it does not delete the 
-- day from the table, just the foods and the meal itself

DELIMITER //
CREATE PROCEDURE DeleteFoodFromMeal(IN meal_id INT, IN food_id INT)
BEGIN
	DELETE FROM FOOD
	WHERE food_id IN (
    SELECT MEAL_CONTAINS_FOOD.food_id
    FROM MEAL_CONTAINS_FOOD
    JOIN MEAL ON MEAL_CONTAINS_FOOD.meal_id = meal_id
    WHERE MEAL_CONTAINS_FOOD.food_id = food_id); -- we use a select statement to link the meal_id
														-- to the food_id via the relationship table
END//
DELIMITER ;

-- Example: Delete food id 1 from a meal with meal id 4
SELECT * 
FROM FOOD;
DeleteAllFoodsFromMeal(1, 4)
SELECT * 
FROM FOOD;

-- ========================================= SELECT QUERIES =========================================

SELECT u.first_name, u.last_name, u.username, w.workout_date, w.calories_burned
FROM USER u
INNER JOIN WORKOUT w ON u.user_id = w.user_id
WHERE w.workout_name = 'Upper';

DELIMITER //
CREATE PROCEDURE SelectAllUsersByWorkoutName(IN workout_name)
BEGIN
	SELECT u.first_name, u.last_name, u.username, w.workout_date, w.calories_burned
FROM USER u
INNER JOIN WORKOUT w ON u.user_id = w.user_id
WHERE w.workout_name = workout_name;
END//
DELIMITER ;

