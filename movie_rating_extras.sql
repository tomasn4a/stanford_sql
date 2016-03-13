-- Solutions to the SQL Movie-Rating Query Exercises Extras. The schema and database 
--used for this problems can be found in the rating.sql file


-- Q1
-- Find the names of all reviewers who rated Gone with the Wind.
SELECT DISTINCT name
FROM Reviewer RW, Movie M, Rating RA
WHERE RA.mID = M.mID AND RA.rID=RW.rID AND title = 'Gone with the Wind'

-- Q2
-- For any rating where the reviewer is the same as the director of the movie, 
-- return the reviewer name, movie title, and number of stars. 
SELECT name, title, stars
FROM Movie M, Rating RA, Reviewer RW
WHERE RA.mID = M.mID AND RA.rID=RW.rID AND name=director

-- Q3
-- Return all reviewer names and movie names together in a single list, alphabetized. 
-- (Sorting by the first name of the reviewer and first word in the title is fine; 
-- no need for special processing on last names or removing "The".) 
SELECT title FROM Movie 
UNION
SELECT name FROM Reviewer

-- Q4
-- Find the titles of all movies not reviewed by Chris Jackson.
SELECT DISTINCT title
FROM Movie M
WHERE M.mID NOT IN (
SELECT RA.mID
FROM Rating RA, Reviewer RE
WHERE RA.rID = RE.rID AND name = "Chris Jackson")

-- Q5
-- For all pairs of reviewers such that both reviewers gave a rating to the same movie, 
-- return the names of both reviewers. Eliminate duplicates, don't pair reviewers with 
-- themselves, and include each pair only once. For each pair, return the names in the 
-- pair in alphabetical order. 
SELECT DISTINCT RE1.name, RE2.name
FROM Reviewer RE1, Reviewer RE2, Rating R1, Rating R2
WHERE R1.mID = R2.mID AND RE1.rID = R1.rID AND RE2.rID = R2.rID
AND RE1.name < RE2.name

-- Q6
-- For each rating that is the lowest (fewest stars) currently in the database, return 
-- the reviewer name, movie title, and number of stars. 
SELECT name, title, RA.stars
FROM Rating RA, Movie M, Reviewer RE
WHERE M.mID=RA.mID AND RA.rID=RE.rID 
AND NOT EXISTS
(SELECT stars FROM Rating WHERE stars<RA.stars)

-- Q7
-- List movie titles and average ratings, from highest-rated to lowest-rated. If two or 
-- more movies have the same average rating, list them in alphabetical order. 
SELECT title, avstars
FROM Movie M, (SELECT mID, AVG(stars) AS avstars
FROM Rating
GROUP BY mID) RA
WHERE M.mID = RA.mID
ORDER BY avstars DESC, title

-- Q8
-- Find the names of all reviewers who have contributed three or more ratings. 
-- (As an extra challenge, try writing the query without HAVING or without COUNT.)
SELECT name
FROM Reviewer RE, (SELECT rID, count(mID) AS num
FROM Rating
GROUP BY rID) RA
WHERE RE.rID = RA.rID AND num>=3
-----------------------------
SELECT DISTINCT RE.name
FROM Reviewer RE, Rating R1, Rating R2, Rating R3
WHERE R1.rID=R2.rID AND R2.rID=R3.rID
AND COALESCE(R1.ratingDate,0)<R2.ratingDate AND R2.ratingDate<R3.ratingDate
AND RE.rID=R1.rID

-- Q9
-- Some directors directed more than one movie. For all such directors, return 
-- the titles of all movies directed by them, along with the director name. Sort 
-- by director name, then movie title. (As an extra challenge, try writing the query 
-- both with and without COUNT.) 
SELECT title, director
FROM Movie
WHERE director IN
(SELECT director
FROM Movie 
GROUP BY director
HAVING COUNT(director)>1)
ORDER BY director, title
------------------------------
SELECT m1.title, m1.director
FROM Movie m1, Movie m2
WHERE m1.director = m2.director AND m1.title <> m2.title
ORDER BY m1.director, m1.title

-- Q10
-- Find the movie(s) with the highest average rating. Return the movie title(s) and 
-- average rating. (Hint: This query is more difficult to write in SQLite than other 
-- systems; you might think of it as finding the highest average rating and then choosing 
-- the movie(s) with that average rating.) 
SELECT title, avgstars
FROM Movie M, (SELECT mID, AVG(stars) as avgstars FROM Rating GROUP BY mID) AV
WHERE M.mID=AV.mID
AND AV. avgstars IN
(SELECT MAX(avgstars) as maxstars FROM
(SELECT mID, AVG(stars) as avgstars FROM Rating GROUP BY mID))

-- Q11
-- Find the movie(s) with the lowest average rating. Return the movie title(s) and 
-- average rating. (Hint: This query may be more difficult to write in SQLite than other 
-- systems; you might think of it as finding the lowest average rating and then choosing
-- the movie(s) with that average rating.) 
SELECT title, avgstars
FROM Movie M, (SELECT mID, AVG(stars) as avgstars FROM Rating GROUP BY mID) AV
WHERE M.mID=AV.mID
AND AV. avgstars IN
(SELECT MIN(avgstars) as minstars FROM
(SELECT mID, AVG(stars) as avgstars FROM Rating GROUP BY mID))

-- Q12
-- For each director, return the director's name together with the title(s) of the movie(s) 
-- they directed that received the highest rating among all of their movies, and the value 
-- of that rating. Ignore movies whose director is NULL. 
SELECT director, title, MAX(stars)
FROM Movie M, Rating R
WHERE M.mID = R.mID AND director IS NOT NULL
GROUP BY director
