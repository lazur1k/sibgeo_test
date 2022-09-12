-- Код используемых функций
-- Функция возвращает подстроку назделенную заданным знаком, находящуюся на определенной позиции. Если на заданной позиции нет подстроки, то возвращается пустая строка
-- CREATE DEFINER=`root`@`localhost` FUNCTION `SPLIT_STR`(
--   str VARCHAR(300),
--   delim VARCHAR(1),
--   pos INT
-- ) RETURNS varchar(255)
-- RETURN REPLACE(REPLACE(SUBSTRING_INDEX(str, delim, pos), SUBSTRING_INDEX(str, delim, pos-1), ""), delim, "");

-- Функция заполняет временную таблицу названием компании и привязанной к ней лицензионными участками
-- CREATE DEFINER=`root`@`localhost` FUNCTION `INSERT_SPLIT_SUBSTRING`(
-- 	area_list VARCHAR(255),
--     curr_company VARCHAR(255)
-- ) RETURNS int
-- DECLARE Counter INT;
-- SET Counter = 1;
-- WHILE SPLIT_STR(area_list, ";", Counter) != "" 
-- 	DO
--     INSERT INTO tmp(area, company)
--     VALUES
--     (SPLIT_STR(area_list, ";", Counter), curr_company);
--     SET Counter = Counter + 1;
-- END WHILE;
-- RETURN 1;

-- Вызывается функция для заполнения временной таблицы
SELECT INSERT_SPLIT_SUBSTRING(bd.area_list, bd.company)
FROM base_data AS bd;

-- Заполняется таблица с названиями компаний
INSERT INTO company (company_name)
SELECT company FROM base_data;

-- Заполняется таблица с информацией о ЛУ
INSERT INTO area (
company_id,
area_name,
series,
num,
kind,
issue_date)
SELECT 
company.id AS company_id,
IF(split_table.area_name != split_table.num, split_table.area_name, "") AS area_name,
SUBSTRING(split_table.num, 1, 3) AS series,
SUBSTRING(split_table.num, 4, 5) AS area_num,
SUBSTRING(split_table.num, 9, 2) AS kind
FROM( SELECT 
	SUBSTRING_INDEX(area, "/", 1) AS area_name, 
	TRIM(REPLACE(area, CONCAT(SUBSTRING_INDEX(area, "/", 1), "/"), "")) AS num, 
	company    
	FROM tmp
)AS split_table
INNER JOIN company
ON company.company_name = split_table.company;

-- Генерируются случайные даты и сроки действия для ЛУ
UPDATE area 
SET issue_date = adddate('2000-01-01', INTERVAL FLOOR(RAND() * 4000) DAY),
	validity_period = IF(YEAR(issue_date) = 2010, NULL, adddate(issue_date, INTERVAL FLOOR(RAND() * 5 + 5) YEAR))
WHERE id > 0;

