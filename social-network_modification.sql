-- Solutions to the SQL Movie-Rating Query Modification Exercises. The schema and database 
-- used for this problems can be found in the social.sql file


-- Q1
-- It's time for the seniors to graduate. Remove all 12th graders from Highschooler. 
DELETE FROM Highschooler
WHERE grade=12

-- Q2
-- If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple. 
DELETE FROM Likes
WHERE ID1 IN (
SELECT id1 FROM (SELECT DISTINCT S1.ID as id1, S2.ID
FROM Highschooler S1, Highschooler S2, Likes
WHERE S1.ID=ID1 AND S2.ID=ID2 AND S2.ID NOT IN (SELECT ID1 FROM Likes WHERE S1.ID=ID2)
INTERSECT 
SELECT * 
FROM Friend))

-- Q3
-- For all cases where A is friends with B, and B is friends with C, add a new friendship 
-- for the pair A and C. Do not add duplicate friendships, friendships that already exist, 
-- or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.) 
INSERT INTO Friend
SELECT DISTINCT S1.ID, S3.ID
FROM Highschooler S1, Highschooler S2, Highschooler S3, Friend F1, Friend F2
WHERE S1.ID=F1.ID1 AND S2.ID=F1.ID2 AND S2.ID=F2.ID1 AND S3.ID=F2.ID2 AND S1.ID<>S3.ID
EXCEPT 
SELECT *
FROM Friend
