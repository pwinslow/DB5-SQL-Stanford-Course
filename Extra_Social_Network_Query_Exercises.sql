-- Extra SQL Social Network Query Exercises
-- https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_social_query_extra/

-- Question 1:
-- For every situation where student A likes student B, but student B likes a different student C, return the names
-- and grades of A, B, and C.
SELECT DISTINCT hs1.name, hs1.grade, hs2.name, hs2.grade, hs3.name, hs3.grade
FROM highschooler AS hs1, highschooler AS hs2, highschooler AS hs3, likes AS l
WHERE hs1.id = l.id1
AND hs2.id = l.id2
AND hs3.id IN
(
    SELECT likes.id2
    FROM likes
    WHERE likes.id1 = hs2.id
)
AND hs1.id NOT IN
(
    SELECT likes.id2
    FROM likes
    WHERE likes.id1 = hs2.id
);

-- Question 2:
-- Find those students for whom all of their friends are in different grades from themselves. Return the students' names
-- and grades.
SELECT DISTINCT hs.name, hs.grade
FROM highschooler AS hs, friend AS f
WHERE hs.grade NOT IN
(
    SELECT hsA.grade
    FROM highschooler AS hsA, friend
    WHERE hs.id = friend.id1
    AND hsA.id = friend.id2
);

-- Question 3:
-- What is the average number of friends per student? (Your result should be just one number.)
SELECT AVG(avg_table.count)
FROM
(
    SELECT hs.id, COUNT(f.id2) AS count
    FROM highschooler AS hs, friend AS f
    WHERE hs.id = f.id1
    GROUP BY hs.id
) AS avg_table;

-- Question 4:
-- Find the number of students who are either friends with Cassandra or are friends of friends
-- of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend.
SELECT COUNT(DISTINCT f2.id2)
FROM friend AS f2
WHERE f2.id1 =
(
    SELECT id
    FROM highschooler
    WHERE name = 'Cassandra'
)
OR f2.id1 IN
(
	SELECT f1.id2
    FROM friend AS f1
    WHERE f1.id1 =
    (
        SELECT id
        FROM highschooler
        WHERE name = 'Cassandra'
    )
)
AND f2.id2 !=
(
    SELECT id
    FROM highschooler
    WHERE name = 'Cassandra'
);

-- Question 5:
-- Find the name and grade of the student(s) with the greatest number of friends.
SELECT hs.name, hs.grade
FROM highschooler AS hs, friend AS f
WHERE hs.id = f.id1
GROUP BY hs.name, hs.grade
HAVING COUNT(f.id2) =
(
    SELECT MAX(ftable.friend_count)
    FROM
    (
        SELECT f.id1, COUNT(f.id2) AS friend_count
        FROM friend AS f
        GROUP BY f.id1
    ) AS ftable
);
