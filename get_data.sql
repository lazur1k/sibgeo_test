-- Сккрипт для выгрузки данных из готвоых таблиц
SELECT 
company.company_name AS "Компания",
area_name AS "Название ЛУ",
series AS "Серия",
num AS "Номер",
kind AS "Вид",
issue_date AS "Дата выдачи",
validity_period AS "Срок действия"
FROM area
JOIN company
ON area.company_id = company.id