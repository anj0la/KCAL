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

-- USERS
INSERT INTO USER VALUES 

-- Active Users
-- id  fname       lnmae         DOB		   gender			username			email					password					h	 w    t_w	join_date	last_log_date
(1, 'Jonathan',   'Magnus', 	'1997-09-24', 'Male', 			'Jmagnus', 			'Jmagnus@yahoo.com',	  '1$CoolPassword$1',		178, 145, 190, '2022-01-01', '2024-04-09'),
(2, 'Maris',      'Woo', 		'2000-02-07', 'Female', 		'Marris',       	'Maris.woo@gmail.com', 	  'password$2452', 			153, 110, 120, '2020-02-11', '2024-04-09'),
(3, 'Sandra',     'Parker', 	'1989-05-12', 'Female', 		'sandragymgirl', 	'sparker@hotmail.com', 	  '',						178, 145, 190, '2020-02-11', '2024-04-09'),
(4, 'Wendy',      'Woo', 		'2000-02-07', 'Female', 		'wendytheleader', 	'wendy.woo@gmail.com', 	  '', 						178, 145, 190, '2020-02-11', '2024-04-09'),
(5, 'Joshua',     'Phillips',   '1995-08-27', 'Rather not say', 'D_GymRat', 		'JPhillips@hotmail.com',  'NevaGiveUp_K**pPu$h1ng',	180, 300, 200, '2024-01-01', '2024-01-28'),
(6, 'Thomas',     'Shelby', 	'1976-05-25', 'Male', 			'Tommy', 			'TShelby@yahoo.com', 	  'PeakyB1inder$', 			172, 180, 200, '2024-01-01', '2024-01-28'),
(7, 'Arthur',     'Shelby', 	'1978-02-12', 'Male', 			'Arthur_S', 		'AShelby@hotmail.com',    'password_1',				177, 220, 200, '2024-01-01', '2024-01-28'),
(8, 'Hardin',     'Styles', 	'1997-11-06', 'Male', 			'Hardin', 			'HStyles@gmail.com',      'password_2', 			188, 160, 180, '2024-01-01', '2024-01-28'),
(9, 'Polly',      'Gray',       '1968-08-17', 'Female', 		'PollyG', 			'PGray@yahoo.com',        'password_3', 			163, 135, 120, '2024-01-01', '2024-01-28'),
(10, 'Anthony',   'Bridgerton', '1988-04-25', 'Male', 			'Anthonee_B', 		'A.Bridgerton@yahoo.com', 'password_4', 			180, 200, 250, '2024-01-01', '2024-01-28');

-- DAY
INSERT INTO `DAY` VALUES 
-- last 10 days
('2024-03-31', 2),
('2024-04-01', 2),
('2024-04-02', 2),
('2024-04-03', 2),
('2024-04-04', 2),
('2024-04-05', 1),
('2024-04-06', 1),
('2024-04-07', 1),
('2024-04-08', 1),
('2024-04-09', 1);

-- WORKOUT
INSERT INTO WORKOUT VALUES 
-- id    name      date          uid            c_burned
(101,   "LEGS",  '2024-03-31',    2,               500),
(102,   "ARMS",  '2024-04-01',    2,               450),
(103,   "CORE",  '2024-04-02',    2,               300),
(104,   "LEGS",  '2024-04-02',    2,               500),
(105,   "ARMS",  '2024-04-03',    2,               450),

(106,   "LEGS",  '2024-04-05',    1,               500),
(107,   "ARMS",  '2024-04-06',    1,               450),
(108,   "CORE",  '2024-04-07',    1,               300),
(109,   "ARMS",  '2024-04-08',    1,               450),
(110,   "CORE",  '2024-04-09',    1,               300);


-- EXERCISE
INSERT INTO EXERCISE VALUES
-- id              name                        equipment_type                 category              pri_muscle_grp             sec_muscle_grp
(201,    "Bulgarian Split Squat",              "Dumbbell",                    "Strength",           "Quadriceps",              "Gluteus Maximus"),
(202,    "Sumo Squat",                         "Barbell",                     "Strength",           "Quadriceps",              "Gluteus Maximus"),
(203,    "Hip Thrust",                         "Machine",                     "Strength",           "Gluteus Maximus",         "Quadriceps"),
(204,    "Push Up",                            "None",                        "Strength",           "Chest",                   "Triceps"),
(205,    "Tricep Pull Down",                   "Machine",                     "Strength",           "Triceps",                 "Deltoids"),
(206,    "Shoulder Shrug",                     "Barbell",                     "Strength",           "Deltoids",                "Forearms"),
(207,    "Calf Raise",                         "Dumbbell",                    "Strength",           "Gastrocnemius",           "Soleus"),
(208,    "Dead Lift",                          "Barbell",                     "Strength",           "Gluteus Maximus",          "Quadriceps"),
(209,    "Running",                            "Machine",                     "Cardio",             "Hamstrings",              "Soleus"),
(210,    "Jumping Jack",                        "None",                       "Cardio",              "Abdominals",             "Hamstrings");

-- WORKOUT_MADE_OF_EXERCISE
-- For each workout, associate some exercises
INSERT INTO WORKOUT_MADE_OF_EXERCISE VALUES
-- (workout_id, exercise_id)  
(208, 101), -- LEGS workout includes Dead Lift
(207, 101), -- LEGS workout includes Calf Raise
(204, 102), -- ARMS workout includes Push Up
(205, 102), -- ARMS workout includes Tricep Pull Down
(206, 103), -- CORE workout includes Shoulder Shrug
(204, 103), -- CORE workout includes Push Up
(208, 104), -- LEGS workout includes Dead Lift
(206, 105), -- ARMS workout includes Shoulder Shrug
(204, 105); -- ARMS workout includes Push Up

-- MEAL 
INSERT INTO MEAL VALUES
-- (meal_id, meal_timestamp, meal_date, meal_category) 
(1, '2024-04-09 08:00:00', '2024-04-09', 'Breakfast'),
(2, '2024-04-09 12:30:00', '2024-04-09', 'Lunch'),
(3, '2024-04-09 16:00:00', '2024-04-09', 'Snack'),
(4, '2024-04-09 19:00:00', '2024-04-06', 'Dinner'),
(5, '2024-04-09 07:30:00', '2024-04-09', 'Breakfast'),
(6, '2024-04-09 13:00:00', '2024-04-09', 'Lunch'),
(7, '2024-04-09 17:30:00', '2024-04-06', 'Snack'),
(8, '2024-04-09 19:30:00', '2024-04-09', 'Dinner'),
(9, '2024-04-09 08:30:00', '2024-04-09', 'Breakfast'),
(10, '2024-04-09 11:30:00', '2024-04-09', 'Brunch');

-- FOOD
INSERT INTO FOOD VALUES
-- (food_id, food_name, food_category, serving_size, serving_unit, is_metric, calories, total_fats, saturated_fats, 
-- cholesterol, sodium, total_carbs, fibre, sugar, protein, calcium, iron, potassium, vitamin_D, magnesium, zinc, vitamin_A, vitamin_C) 
(1, 'Apple', 'Fruit', 1, 'medium', 0, 95, 0.3, 0.1, 0, 1, 25, 4.4, 19, 0.5, 11, 0.1, 195, 0, 6, 0, 1, 14),
(2, 'Banana', 'Fruit', 1, 'medium', 0, 105, 0.4, 0.1, 0, 1, 27, 3.1, 14, 1.3, 6, 0.3, 422, 0.1, 32, 0.4, 1, 10),
(3, 'Chicken Breast', 'Meat', 100, 'grams', 1, 165, 3.6, 1, 83, 74, 0, 0, 31, 0.2, 2, 0.1, 256, 0, 4.2, 0, 0, 0),
(4, 'Brown Rice', 'Grains', 45, 'grams', 1, 160, 1.5, 0.3, 0, 0, 34, 1.6, 0, 3, 0.1, 10, 0.4, 28, 0, 3.7, 0, 0),
(5, 'Broccoli', 'Vegetable', 100, 'grams', 1, 34, 0.4, 0.1, 0, 33, 7, 2.6, 1.5, 2.8, 0.1, 47, 0.6, 316, 0, 0.7, 0.2, 89),
(6, 'Salmon', 'Fish', 100, 'grams', 1, 206, 10, 1.8, 55, 57, 0, 0, 22, 0.2, 13, 0.5, 429, 0, 3.5, 0, 0, 0),
(7, 'Avocado', 'Fruit', 100, 'grams', 1, 160, 14.7, 2.1, 0, 7, 8.5, 6.7, 0.7, 2, 0.1, 10, 0.6, 485, 0, 2, 0, 7),
(8, 'Egg', 'Dairy', 50, 'grams', 1, 78, 5.3, 1.6, 186, 62, 0.6, 0, 0, 0.6, 6.3, 2, 0, 24, 0.2, 0, 0, 0),
(9, 'Spinach', 'Vegetable', 100, 'grams', 1, 23, 0.4, 0, 0, 79, 3.6, 2.2, 0.4, 2.9, 0.2, 99, 2.7, 558, 0, 1.6, 0.9, 47),
(10, 'Oatmeal', 'Grains', 40, 'grams', 1, 150, 2.5, 0.5, 0, 0, 27, 4, 1, 5, 0.3, 22, 1.4, 164, 0, 3.7, 0, 0);


-- MEAL_CONTAINS_FOOD
-- For each meal, associate some food items
INSERT INTO MEAL_CONTAINS_FOOD (meal_id, food_id) 
VALUES 
(1, 8), -- Eggs
(2, 3), -- Chicken Breast
(3, 1), -- Apple
(4, 6); -- Salmon

INSERT INTO MEAL_CONTAINS_FOOD (meal_id, food_id) 
VALUES 
(1, 7); -- Avocado

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
	DELETE FROM MEAL AS m
    WHERE m.meal_date = specified_date;
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
CALL DeleteFoodFromMeal(1, 4);
SELECT * 
FROM FOOD;
