-- SELECT  occupation, AVG(salary)
-- FROM Parks_and_Recreation.employee_salary
-- WHERE occupation LIKE ('%Manager%')
-- GROUP BY occupation
-- HAVING AVG(salary) > 75000
-- ORDER BY AVG(salary) DESC
-- ;

-- SELECT *
-- FROM Parks_and_Recreation.employee_demographics
-- ORDER BY age DESC
-- LIMIT 3
-- ;



SELECT ped.employee_id, ped.first_name, occupation, salary, age, gender, birth_date
FROM Parks_and_Recreation.employee_demographics AS ped
RIGHT JOIN Parks_and_Recreation.employee_salary AS pes
	ON  ped.employee_id = pes.employee_id
;


SELECT ed.first_name, ed.last_name, salary, gender
FROM Parks_and_Recreation.employee_demographics AS ed
RIGHT JOIN Parks_and_Recreation.employee_salary AS es
ON ed.employee_id = es.employee_id
WHERE salary >= 30000
ORDER BY salary DESC
;

SELECT *
FROM Parks_and_Recreation.employee_demographics AS demographics
LEFT JOIN Parks_and_Recreation.employee_salary AS salary
	ON demographics.employee_id = salary.employee_id
LEFT JOIN Parks_and_Recreation.parks_departments AS departments
	ON salary.dept_id = departments.department_id
ORDER BY salary.employee_id
;


SELECT first_name, last_name, 'MALE' AS Label
FROM Parks_and_Recreation.employee_demographics
WHERE age >= 40 AND gender = 'Male'
UNION ALL
SELECT first_name, last_name, 'FEMALE' AS Label
FROM Parks_and_recreation.employee_demographics
WHERE age >= 40 AND gender = 'Female'
UNION ALL
SELECT first_name, last_name, 'paid more than 70k' AS Label
FROM Parks_and_recreation.employee_salary
WHERE salary >= 65000
ORDER BY first_name, last_name
;

SELECT first_name,
SUBSTRING(birth_date, 6, 2) AS BIRTH_MONTH
FROM Parks_and_Recreation.employee_demographics
WHERE SUBSTRING(birth_date, 6, 2) = 11
ORDER BY SUBSTRING(birth_date, 6, 2)
;


SELECT first_name,
last_name,
age,
CASE
	WHEN age BETWEEN 30 AND 50 THEN 'MID AGE CHRISES'
    WHEN age BETWEEN 50 AND 70 THEN 'ALMOST RETIRED'
    WHEN age > 70 THEN 'OLD' 
END as 'coments on age'
FROM Parks_and_Recreation.employee_demographics
WHERE age > 30
;

SELECT first_name,
last_name,
salary,
occupation,
CASE
	WHEN salary BETWEEN 20000 AND 50000 THEN salary * 1.05
    WHEN salary BETWEEN 50001 AND 70000 THEN salary * 1.02
END AS 'new salary based on age',
CASE
	WHEN dept_id = 6 THEN salary * 2
    WHEN dept_id = 3 THEN salary * 5
END AS 'new salary based on department'
FROM Parks_and_Recreation.employee_salary
;


SELECT first_name, last_name, salary,
(SELECT AVG(salary)
FROM Parks_and_Recreation.employee_salary)
FROM Parks_and_Recreation.employee_salary
;

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age) 
FROM Parks_and_Recreation.employee_demographics
GROUP BY gender
;

SELECT gender, AVG(salary) AS avg_salary
FROM Parks_and_Recreation.employee_salary AS salary
JOIN Parks_and_Recreation.employee_demographics AS gender
ON salary.employee_id = gender.employee_id
GROUP BY gender
;

SELECT demo.first_name, demo.last_name, gender, salary,
SUM(salary) OVER(PARTITION BY gender ORDER BY demo.employee_id) AS rolling_total
FROM Parks_and_Recreation.employee_demographics AS demo
JOIN Parks_and_Recreation.employee_salary AS salary
ON demo.employee_id = salary.employee_id
;

SELECT demo.employee_id, demo.first_name, demo.last_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC),
RANK() OVER(PARTITION BY gender ORDER BY salary DESC)
FROM Parks_and_Recreation.employee_demographics AS demo
JOIN Parks_and_Recreation.employee_salary AS salary
ON demo.employee_id = salary.employee_id
;

WITH CTE_Example AS 
(
 SELECT gender, AVG(salary) AS avg_sal, MAX(salary) AS max_sal, MIN(salary) AS min_sal, COUNT(salary) AS count_sal
 FROM Parks_and_Recreation.employee_demographics AS dem
 JOIN Parks_and_Recreation.employee_salary AS sal
 ON dem.employee_id = sal.employee_id
 GROUP BY gender
)
SELECT avg_sal
FROM CTE_Example
;



WITH CTE_Example AS 
(
 SELECT employee_id, gender, birth_date
 FROM Parks_and_Recreation.employee_demographics
 WHERE birth_date > '1985-01-01'
),
CTE_Example2 AS
(
 SELECT employee_id, salary
 FROM Parks_and_Recreation.employee_salary
 WHERE salary > 50000
)
SELECT *
FROM CTE_Example
JOIN CTE_Example2
	ON CTE_Example.employee_id = CTE_Example2.employee_id
; 

CREATE TEMPORARY TABLE temp_table
(
first_name varchar(50),
last_name varchar(50),
fav_movie varchar(100)
);

SELECT *
FROM temp_table
;


DELIMITER $$
CREATE PROCEDURE large_salaries2(employeeId INT)
BEGIN
	SELECT *
    FROM Parks_and_Recreation.employee_salary
    WHERE employee_id = employeeId
    ;
END $$
DELIMITER ;






