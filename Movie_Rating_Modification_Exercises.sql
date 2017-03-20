-- Movie-Rating Modification Exercises
-- https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_movie_mod/

-- Question 1:
-- Add the reviewer Roger Ebert to your database, with an rID of 209.
INSERT INTO reviewer
(
  rID, name
)
VALUES
(
  209, 'Roger Ebert'
);

-- Question 2:
-- Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL.
INSERT INTO rating
(
    rid, stars, mid
)
SELECT
	(
        SELECT rev.rid
        FROM reviewer AS rev
        WHERE rev.name = 'James Cameron'
    ),
    5,
    mov.mid
FROM movie AS mov
ORDER BY mov.mid ASC;

-- Question 3:
-- For all movies that have an average rating of 4 stars or higher, add 25 to the release year.
-- (Update the existing tuples; don't insert new tuples.)
UPDATE movie
SET year = year + 25
WHERE movie.mid IN
(
    SELECT avg_table.mid
    FROM
    (
        SELECT mov.mid, AVG(rat.stars)
        FROM movie AS mov, rating AS rat
        WHERE mov.mid = rat.mid
        GROUP BY mov.mid
        HAVING AVG(rat.stars) >= 4
    ) AS avg_table
);

-- Question 4:
-- Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars.
DELETE FROM rating
WHERE rating.mid IN
(
    SELECT mov.mid
    FROM movie AS mov
    WHERE mov.year < 1970
    OR mov.year > 2000
)
AND rating.stars < 4;
