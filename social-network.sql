-- Solutions to the SQL Social-Network Query Exercises. The schema and database used for
-- this problems can be found in the social.sql file


-- Q1
-- Find the names of all students who are friends with someone named Gabriel. 
SELECT name
FROM Highschooler h1
JOIN Friend 
ON h1.ID = ID1
WHERE ID2 IN (SELECT ID FROM Highschooler WHERE name = "Gabriel")

-- Q2
-- For every student who likes someone 2 or more grades younger than themselves, 
-- return that student's name and grade, and the name and grade of the student they like. 
SELECT h1.name, h1.grade, h2.name, h2.grade
FROM Highschooler h1
JOIN Likes
ON h1.ID = ID1
JOIN Highschooler h2
ON h2.ID = ID2
WHERE ABS(h1.grade-h2.grade)>=2

-- Q3
-- For every pair of students who both like each other, return the name and grade of 
-- both students. Include each pair only once, with the two names in alphabetical order.
SELECT h1.name, h1.grade, h2.name, h2.grade
FROM Highschooler h1, Highschooler h2,
(SELECT l1.ID1 AS id1, l1.ID2 as id2
FROM (Likes l1 JOIN Likes l2)
WHERE l1.ID1=l2.ID2 AND l1.ID2=l2.ID1)
WHERE h1.ID = id1 AND h2.ID = id2
AND h1.name < h2.name

-- Q4
-- Find all students who do not appear in the Likes table (as a student who likes or 
-- is liked) and return their names and grades. Sort by grade, then by name within each grade. 
SELECT name, grade
FROM Highschooler
WHERE ID NOT IN (
SELECT ID1 FROM Likes 
UNION SELECT ID2 FROM Likes)
ORDER BY grade, name

 -- Q5
 -- For every situation where student A likes student B, but we have no information about 
 -- whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and 
 -- B's names and grades. 
SELECT S1.name, S1.grade, S2.name, S2.grade
FROM Highschooler S1, Highschooler S2, Likes
WHERE S1.ID=ID1 AND S2.ID=ID2
AND ID2 NOT IN (SELECT ID1 FROM Likes)

-- Q6
-- Find names and grades of students who only have friends in the same grade. Return the 
-- result sorted by grade, then by name within each grade. 
SELECT S1.name, S1.grade
FROM Highschooler S1, Highschooler S2, Friend
WHERE S1.ID=ID1 AND S2.ID=ID2
GROUP BY S1.ID
HAVING MAX(S2.grade)=MIN(S2.grade) AND S1.grade=S2.grade
ORDER BY S1.grade, S1.name

-- Q7
-- For each student A who likes a student B where the two are not friends, find if they 
-- have a friend C in common (who can introduce them!). For all such trios, return the name 
-- and grade of A, B, and C. 
SELECT S1.name, S1.grade, S2.name, S2.grade, S3.name, S3.grade
FROM Highschooler S1, Highschooler S2, Highschooler S3, Likes
WHERE S1.ID=ID1 AND S2.ID=ID2
AND S2.ID NOT IN (SELECT ID2 FROM Friend WHERE ID1 = S1.ID)
AND S3.ID IN (SELECT ID2 FROM Friend WHERE ID1 = S1.ID)
AND S3.ID IN (SELECT ID2 FROM Friend WHERE ID1 = S2.ID)

-- Q8
-- Find the difference between the number of students in the school and the number of 
-- different first names. 
SELECT COUNT(DISTINCT ID)-COUNT(DISTINCT name)
FROM Highschooler

-- Q9
-- Find the name and grade of all students who are liked by more than one other student. 
SELECT name, grade
FROM Highschooler
WHERE ID IN (
SELECT ID2 FROM Likes 
GROUP BY ID2
HAVING COUNT(ID1)>1)



