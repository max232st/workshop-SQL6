-- 1. Создайте функцию, которая принимает кол-во сек и форматирует их в кол-во дней, часов.
-- Пример: 123456 ->'1 days 10 hours 17 minutes 36 seconds '

SET @@SESSION.SQL_LOG_BIN=0; -- отключаем бинарное логирование только для текущей сессии

DELIMITER //

-- Создаем  функцию sekonds_format, которая принимает один аргумент 
-- типа INT и возвращает значение типа VARCHAR(55).
CREATE FUNCTION seconds_format(seconds INT)  
RETURNS VARCHAR(55)

/* Атрибут ниже указывает на то, что функция всегда возвращает 
одинаковый результат для одинаковых входных параметров и не имеет побочных эффектов. 
Если функция не детерминирована, то ее результат может быть разным для одинаковых входных параметров, 
что может привести к непредсказуемому поведению запросов
*/
DETERMINISTIC 

-- Атрибут ниже указывает на то, что функция не изменяет данные в 
-- базе данных и не использует таблицы с возможностью изменения данных 
READS SQL DATA

-- Этот блок кода объявляет четыре локальные 
-- переменные внутри функции: days, hours, minutes и formated.
BEGIN
    DECLARE days INT;
    DECLARE hours INT;
    DECLARE minutes INT;
    DECLARE formatted VARCHAR(55);

-- Вычисление 
    SET days = FLOOR(seconds / (24 * 3600));
    SET seconds = seconds % (24 * 3600);
    SET hours = FLOOR(seconds / 3600);
    SET seconds = seconds % 3600;
    SET minutes = FLOOR(seconds / 60);
    SET seconds = seconds % 60;

-- Объединяем значения дней, часов, минут и секунд в одну строку, используя функцию CONCAT.
    SET formatted = CONCAT(days, " days ", hours, " hours ", minutes, " minutes ", seconds, " seconds");

-- Завершаем функцию и указывает, что функция должна 
-- вернуть значение переменной formated.
    RETURN formatted;
END //

DELIMITER ;

SELECT seconds_format(123456);

-- 2. Выведите только четные числа от 1 до 10 включительно. Пример: 2,4,6,8,10

DROP PROCEDURE IF EXISTS even_numbers;
DELIMITER //
CREATE PROCEDURE even_numbers()
BEGIN
    DECLARE x INT DEFAULT 1;
    DECLARE result VARCHAR(45) DEFAULT '';
    WHILE x <= 10 DO
        IF x % 2 = 0 THEN
            IF result = '' THEN
                SET result = x;
            ELSE
                SET result = CONCAT(result, ',', x);
            END IF;
        END IF;
        SET x = x + 1;
    END WHILE;
    SELECT result;
END //
DELIMITER ;

CALL even_numbers();