-- Solutions to the SQL Social-Network Query Exercises Extras. The schema and database 
-- used for this problems can be found in the social.sql file


-- Q1
-- For every situation where student A likes student B, but student B likes a different
-- student C, return the names and grades of A, B, and C. 
SELECT S1.name, S1.grade, S2.name, S2.grade, S3.name, S3.grade
FROM Highschooler S1, Highschooler S2, Highschooler S3, Likes L1, Likes L2
WHERE S1.ID=L1.ID1 AND S2.ID=L1.ID2 AND S2.ID=L2.ID1 AND S3.ID=L2.ID2
AND S1.ID<>S3.ID

-- Q2
-- Find those students for whom all of their friends are in different grades from 
-- themselves. Return the students' names and grades. 
SELECT DISTINCT S1.name, S1.grade
FROM Highschooler S1, Highschooler S2, Friend
WHERE S1.ID=ID1 AND S2.ID=ID2
AND NOT EXISTS (
SELECT S3.grade
FROM Highschooler S3, Friend
WHERE S1.ID=ID1 and S3.ID=ID2
AND S3.grade=S1.grade)

-- Q3
-- What is the average number of friends per student? (Your result should be just one number.) 
SELECT AVG(nf) FROM
(SELECT COUNT(DISTINCT ID2) as nf
FROM Friend
GROUP BY ID1)

-- Q4
-- Find the number of students who are either friends with Cassandra or are friends of 
-- friends of Cassandra. Do not count Cassandra, even though technically she is a friend 
-- of a friend.
SELECT COUNT(DISTINCT f1)+COUNT(DISTINCT f2) FROM (
SELECT S1.name, S2.name as f1, S3.name as f2
FROM Highschooler S1, Highschooler S2, Highschooler S3, Friend F1, Friend F2
WHERE S1.ID=F1.ID1 AND S2.ID=F1.ID2 AND S2.ID=F2.ID1 AND S3.ID=F2.ID2
AND S1.name="Cassandra" AND S3.name<>"Cassandra")

-- Q5
-- Find the name and grade of the student(s) with the greatest number of friends. 
SELECT NF.nm, NF.gr FROM (
SELECT S1.name AS nm, S1.grade AS gr, COUNT(DISTINCT F.ID2) AS nf
FROM Highschooler S1, Friend F
WHERE S1.ID=F.ID1
GROUP BY S1.ID) NF
WHERE NF.nf >= (
SELECT MAX(MF.nf) FROM (
SELECT S2.name AS nm, S2.grade AS gr, COUNT(DISTINCT F2.ID2) AS nf
FROM Highschooler S2, Friend F2
WHERE S2.ID=F2.ID1
GROUP BY S2.ID) MF)
