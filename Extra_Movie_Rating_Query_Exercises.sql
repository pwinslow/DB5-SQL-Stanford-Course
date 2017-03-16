-- Extra SQL Movie-Rating Query Exercises
-- https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_movie_query_extra/

-- Question 1:
-- Find the names of all reviewers who rated Gone with the Wind.
SELECT rev.name
FROM reviewer AS rev,
(
    SELECT DISTINCT r.rid
    FROM rating AS r,
    (
        SELECT mid
        FROM movie
        WHERE title = 'Gone with the Wind'
    ) AS m
    WHERE r.mid = m.mid
) AS rid_table
WHERE rev.rid = rid_table.rid;

-- Question 2:
-- For any rating where the reviewer is the same as the director of the movie, return the reviewer name,
-- movie title, and number of stars.
SELECT rev.name, mov.title, rat.stars
FROM reviewer AS rev, movie AS mov, rating as rat
WHERE rev.rid = rat.rid AND rat.mid = mov.mid
AND rev.name = mov.director;

-- Question 3:
-- Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first
-- name of the reviewer and first word in the title is fine; no need for special processing on last names
-- or removing "The".)
SELECT name FROM reviewer
UNION
SELECT title FROM movie
ORDER BY name ASC;

-- Question 4:
-- Find the titles of all movies not reviewed by Chris Jackson.
SELECT mov.title
FROM movie AS mov
WHERE mov.title NOT IN
(
    SELECT DISTINCT mov.title
    FROM movie AS mov, rating AS rat, reviewer AS rev
    WHERE mov.mid = rat.mid AND rat.rid = rev.rid
    AND rev.name = 'Chris Jackson'
);

-- Question 5:
-- For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of
-- both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only
-- once. For each pair, return the names in the pair in alphabetical order.
SELECT DISTINCT rev1.name AS reviewer_name1, rev2.name AS reviewer_name2
FROM rating AS rat1, rating AS rat2, reviewer AS rev1, reviewer AS rev2
WHERE rat1.rid = rev1.rid
AND rat2.rid = rev2.rid
AND rat1.mid = rat2.mid
AND rev1.name != rev2.name
AND rev1.name < rev2.name;

-- Question 6:
-- For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie
-- title, and number of stars.
SELECT rev.name, mov.title, rat.stars
FROM reviewer AS rev, movie AS mov, rating AS rat
WHERE rat.stars = (SELECT MIN(stars) FROM rating)
AND rev.rid = rat.rid
AND rat.mid = mov.mid;

-- Question 7:
-- List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same
-- average rating, list them in alphabetical order.
SELECT mov.title, AVG(rat.stars) AS avg_rating
FROM movie AS mov, rating AS rat
WHERE mov.mid = rat.mid
GROUP BY mov.title
ORDER BY avg_rating DESC, mov.title;

-- Question 8:
-- Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing
-- the query without HAVING or without COUNT.)
SELECT rev.name
FROM reviewer AS rev, rating AS rat
WHERE rev.rid = rat.rid
GROUP BY rev.name
HAVING COUNT(rat.rid) >= 3;

-- Question 9:
-- Some directors directed more than one movie. For all such directors, return the titles of all movies directed by
-- them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing
-- the query both with and without COUNT.)
SELECT title, director FROM movie
WHERE director IN
(
    SELECT mov.director
    FROM movie AS mov
    GROUP BY mov.director
    HAVING COUNT(mov.director) > 1
)
ORDER BY director, title;

-- Question 10:
-- Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query
-- is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating
-- and then choosing the movie(s) with that average rating.)
SELECT mov.title, AVG(rat.stars)
FROM movie AS mov, rating AS rat
WHERE mov.mid = rat.mid
GROUP BY mov.title
HAVING AVG(rat.stars) =
(
    SELECT MAX(avg_table.avg)
    FROM
    (
        SELECT mid, AVG(stars) AS avg
        FROM rating
        GROUP BY mid
    ) AS avg_table
)
ORDER BY mov.title DESC;

-- Question 11:
-- Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may
-- be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating
-- and then choosing the movie(s) with that average rating.)
SELECT mov.title, AVG(rat.stars)
FROM movie AS mov, rating AS rat
WHERE mov.mid = rat.mid
GROUP BY mov.title
HAVING AVG(rat.stars) =
(
    SELECT MIN(avg_table.avg)
    FROM
    (
        SELECT mid, AVG(stars) AS avg
        FROM rating
        GROUP BY mid
    ) AS avg_table
)
ORDER BY mov.title DESC;

-- Question 12:
-- For each director, return the director's name together with the title(s) of the movie(s) they directed that received
-- the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL.
SELECT DISTINCT mov1.director, mov1.title, rat1.stars
FROM movie AS mov1, rating AS rat1
WHERE mov1.mid = rat1.mid
AND mov1.director IS NOT NULL
AND rat1.stars IN
(
    SELECT MAX(rat2.stars)
    FROM movie AS mov2, rating AS rat2
    WHERE mov2.mid = rat2.mid
    AND mov2.director IS NOT NULL
    AND mov2.director = mov1.director
);
