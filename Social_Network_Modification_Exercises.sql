-- Social Network Modification Exercises
-- https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_social_mod/

-- Question 1:
-- It's time for the seniors to graduate. Remove all 12th graders from Highschooler.
DELETE FROM highschooler
WHERE grade = 12;

-- Question 2:
-- If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.
DELETE FROM likes
WHERE likes.id1 IN
(
    SELECT f.id2
    FROM friend AS f
    WHERE f.id1 = likes.id2
)
AND likes.id2 IN
(
    SELECT l.id2
    FROM likes AS l
    WHERE l.id1 = likes.id1
)
AND likes.id1 NOT IN
(
    SELECT l.id2
    FROM likes AS l
    WHERE l.id1 = likes.id2
);

-- Question 3:
-- For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C.
-- Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a
-- bit challenging; congratulations if you get it right.)
INSERT INTO friend (id1, id2)
SELECT DISTINCT f1.id1 AS id1, f3.id1 AS id2
FROM friend AS f1, friend AS f2, friend AS f3
WHERE f2.id1 IN
(
    SELECT friend.id2
    FROM friend
    WHERE friend.id1 = f1.id1
)
AND f2.id1 IN
(
    SELECT friend.id2
    FROM friend
    WHERE friend.id1 = f3.id1
)
AND f3.id1 NOT IN
(
    SELECT friend.id2
    FROM friend
    WHERE friend.id1 = f1.id1
)
AND f1.id1 != f3.id1;
