CREATE SCHEMA `sibgeo_test`;

-- Таблица для связи названий компании с их id
CREATE TABLE company (
	id INT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(255)
    );

-- Основаня таблица данных о ЛУ
CREATE TABLE area (
	id INT PRIMARY KEY AUTO_INCREMENT,
    area_name VARCHAR(255),
    company_id INT,
    series VARCHAR(3),
    num VARCHAR(5),
    kind VARCHAR(2),
    issue_date DATE,
    validity_period DATE,
    CONSTRAINT company_id
    FOREIGN KEY (company_id)
		REFERENCES company(id)
        ON DELETE CASCADE
    );

-- Таблица с изначальными данными
CREATE TABLE base_data (
    id INT PRIMARY  KEY AUTO_INCREMENT,
	company_name VARCHAR(255),
    area_lsit VARCHAR(300)
    );

-- Вспомогательная таблица для дальнейшего заполнения таблицы area
CREATE TABLE tmp (
	id INT PRIMARY  KEY AUTO_INCREMENT,
	company VARCHAR(255),
    area VARCHAR(255)
    )