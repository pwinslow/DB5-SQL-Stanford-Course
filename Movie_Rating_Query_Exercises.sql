-- SQL Movie-Rating Query Exercises
-- https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_movie_query_core/

-- Question 1:
-- Find the titles of all movies directed by Steven Spielberg.
SELECT title FROM MOVIE
WHERE director = 'Steven Spielberg';

-- Question 2:
-- Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
SELECT DISTINCT year
FROM Movie
INNER JOIN Rating
ON Movie.mid = Rating.mid
WHERE stars BETWEEN 4 AND 5
ORDER BY year ASC;

-- Question 3:
-- Find the titles of all movies that have no ratings.
SELECT title
FROM Movie
LEFT OUTER JOIN Rating
ON Movie.mid = Rating.mid
WHERE stars IS NULL;

-- Question 4:
-- Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings
-- with a NULL value for the date.
SELECT name
FROM reviewer
LEFT OUTER JOIN rating
ON reviewer.rid = rating.rid
WHERE ratingdate IS NULL;

-- Question 5:
-- Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and
-- ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.
SELECT reviewer.name, movie.title, rating.stars, rating.ratingdate
FROM movie, rating, reviewer
WHERE movie.mid = rating.mid AND rating.rid = reviewer.rid
ORDER BY reviewer.name, movie.title, rating.stars;

-- Question 6:
-- For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time,
-- return the reviewer's name and the title of the movie.
SELECT r.name, m.title
FROM movie m, reviewer r,
  (
    SELECT r1.rid, r1.mid
    FROM rating r1, rating r2
    WHERE r1.rid = r2.rid AND r1.mid = r2.mid
    AND r1.stars > r2.stars
    AND r1.ratingdate > r2.ratingdate
  ) AS a
WHERE m.mid = a.mid AND r.rid = a.rid;

-- Question 7:
-- For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie
-- title and number of stars. Sort by movie title.
SELECT m.title, r.max_stars
FROM movie AS m,
  (
    SELECT mid, MAX(stars) AS max_stars
    FROM rating
    GROUP BY mid
    HAVING MAX(stars) > 0
  ) AS r
WHERE m.mid = r.mid
ORDER BY m.title ASC;

-- Question 8:
-- For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings
-- given to that movie. Sort by rating spread from highest to lowest, then by movie title.
SELECT m.title, r.rating_spread
FROM movie AS m,
  (
    SELECT mid, MAX(stars)-MIN(stars) rating_spread
    FROM rating
    GROUP BY mid
  ) AS r
WHERE m.mid = r.mid
ORDER BY r.rating_spread DESC, m.title;

-- Question 9:
-- Find the difference between the average rating of movies released before 1980 and the average rating of movies released
-- after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies
-- before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)
SELECT AVG(early_avgs.avgs) - AVG(later_avgs.avgs)
FROM
  (
    SELECT AVG(r.stars) AS avgs
    FROM rating AS r,
      (
        SELECT m.mid
        FROM movie AS m
        WHERE m.year < 1980
      ) AS m1
    WHERE m1.mid = r.mid
    GROUP BY m1.mid
  ) AS early_avgs,
  (
    SELECT AVG(r.stars) AS avgs
  	FROM rating AS r,
      (
        SELECT m.mid
        FROM movie AS m
        WHERE m.year >= 1980
      ) AS m1
    WHERE m1.mid = r.mid
    GROUP BY m1.mid
  ) AS later_avgs;
