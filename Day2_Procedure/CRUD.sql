USE [lpuDB]
GO

INSERT INTO tbl_dept
                         (Id, deptName)
VALUES        (3, 'Tech')

SELECT Id, deptName FROM tbl_dept

UPDATE       tbl_dept
SET                deptName = 'Agri'
WHERE        (Id = 5)

go
CRUDLpuDB 'INSERT',11, 'TECH'


go 
CRUDLpuDB 'SELECT'