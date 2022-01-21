create table if not exists n_table
(
	n float
);

insert into n_table values(1),(2),(3),(4),(5);

insert into n_table values(1),(2),(3),(-4),(5.3);

insert into n_table values(0);

delete from n_table;

select exp(ln(120))

SELECT exp(SUM(ln(n))) product
from n_table

--Запрос
WITH T AS(SELECT * FROM n_table),
P AS (
SELECT SUM(CASE WHEN n<0 THEN 1 ELSE 0 END) neg,
SUM(CASE WHEN n>0 THEN 1 ELSE 0 END) pos,
COUNT(*) total
FROM T)
SELECT CASE WHEN total <> pos+neg THEN 0 ELSE 
(CASE WHEN neg%2=1 THEN -1 ELSE +1 END) *exp(SUM(ln(abs(n))))
END product  
FROM T,P 
WHERE n <> 0 
GROUP BY neg, pos, total;










--Без нулей (не работает)
WITH T AS(SELECT * FROM n_table),
P AS (
SELECT SUM(CASE WHEN n<0 THEN 1 ELSE 0 END) neg
FROM T)
SELECT (CASE WHEN neg%2=1 THEN -1 ELSE +1 end) *exp(SUM(ln(abs(n)))) as result
FROM T,P 
WHERE n <> 0 
GROUP BY neg;