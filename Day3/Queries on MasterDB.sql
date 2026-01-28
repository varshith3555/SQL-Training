SELECT * FROM sysobjects

SELECT DISTINCT xtype from sysobjects

select * from sysobjects where xtype = 'U'

select xtype, count(xtype) as Count
from sysobjects
group by xtype
having xtype='U'

--Table will not be created physically
SELECT * FROM
(SELECT xtype, Count(xtype) as CountOfObjects
FROM sysobjects
GROUP BY xtype) g1 
WHERE g1.xtype = 'U'


--

--Create A1 (user tables count by xtype and name)
SELECT 
    xtype, name,
    COUNT(xtype) AS CountOfObjects
INTO A1
FROM sysobjects 
WHERE xtype = 'U'  -- Use WHERE, not HAVING for simple filter
GROUP BY xtype, name;

-- Create A2 (example: another table with xtype)
SELECT xtype, COUNT(*) AS CountOfA2 
INTO A2 
FROM sysobjects 
WHERE xtype = 'U'
GROUP BY xtype;

-- Join A1 and A2
SELECT A1.xtype, A1.CountOfObjects
FROM A1
INNER JOIN A2 ON A1.xtype = A2.xtype;

-- Cleanup
DROP TABLE A1,A2;




