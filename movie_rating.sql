-- Solutions to the SQL Movie-Rating Query Exercises. The schema and database used for
-- this problems can be found in the rating.sql file


-- Q1
-- Find the titles of all movies directed by Steven Spielberg. 
SELECT title 
FROM Movie
WHERE director = "Steven Spielberg"

-- Q2
-- Find all years that have a movie that received a rating of 4 or 5, and sort them in 
-- increasing order. 
SELECT DISTINCT year
FROM Movie M, Rating R
WHERE M.mID = R.mID
AND stars>=4

-- Q3
-- Find the titles of all movies that have no ratings. 
SELECT title 
FROM Movie M
WHERE M.mID NOT IN (SELECT mID FROM Rating)

-- Q4
-- Some reviewers didn't provide a date with their rating. Find the names of all 
-- reviewers who have ratings with a NULL value for the date. 
SELECT name
FROM Rating RA, Reviewer RE
WHERE RA.rID=RE.rID and ratingDate IS NULL

-- Q5
-- Write a query to return the ratings data in a more readable format: reviewer name, 
-- movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, 
-- then by movie title, and lastly by number of stars. 
SELECT RE.name, M.title, RA.stars, RA.ratingDate
FROM Movie M, Reviewer RE, Rating RA
WHERE M.mID=RA.mID AND RA.rID=RE.rID
ORDER BY RE.name, M.title, RA.stars

-- Q6
-- For all cases where the same reviewer rated the same movie twice and gave it a 
-- higher rating the second time, return the reviewer's name and the title of the movie. 
SELECT RE.name, M.title
FROM Movie M, Reviewer RE, Rating R1, Rating R2
WHERE R1.rID=R2.rID AND R1.mID=R2.mID 
AND R1.stars>R2.stars AND R1.ratingDate>R2.ratingDate
AND RE.rID=R1.rID AND M.mID=R1.mID

-- Q7
-- For each movie that has at least one rating, find the highest number of stars that 
-- movie received. Return the movie title and number of stars. Sort by movie title.
SELECT title, R1.S
FROM Movie M, (SELECT mID, max(stars) as S FROM Rating GROUP BY mID) R1
WHERE R1.mID AND R1.mID=M.mID
ORDER BY title

-- Q8
-- For each movie, return the title and the 'rating spread', that is, the difference 
-- between highest and lowest ratings given to that movie. Sort by rating spread from 
-- highest to lowest, then by movie title.  
SELECT title, mx-mn AS spread
FROM Movie, 
(SELECT mID, max(stars) as mx FROM Rating GROUP BY mID) R1, 
(SELECT mID, min(stars) as mn FROM Rating GROUP BY mID) R2
WHERE Movie.mID = R1.mID and Movie.mID = R2.mID
ORDER BY SPREAD DESC, title

-- Q9
-- Find the difference between the average rating of movies released before 1980 and 
-- the average rating of movies released after 1980. (Make sure to calculate the average 
-- rating for each movie, then the average of those averages for movies before 1980 and 
-- movies after. Don't just calculate the overall average rating before and after 1980.) 
SELECT pr-ps
FROM
(SELECT AVG(avgstars) as pr
FROM (SELECT R2.mID, R2.avgstars, M.year
FROM Movie M JOIN (SELECT mID, AVG(stars) as avgstars FROM Rating GROUP BY mID) R2
ON M.mID=R2.mID WHERE M.year<1980)) as pre,
(SELECT AVG(avgstars) as ps
FROM (SELECT R2.mID, R2.avgstars, M.year
FROM Movie M JOIN (SELECT mID, AVG(stars) as avgstars FROM Rating GROUP BY mID) R2
ON M.mID=R2.mID WHERE M.year>1980)) as post