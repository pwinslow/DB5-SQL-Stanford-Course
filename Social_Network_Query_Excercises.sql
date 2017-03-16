-- SQL Social Network Query Exercises
-- https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_social_query_core/

-- Question 1:
-- Find the names of all students who are friends with someone named Gabriel.
SELECT hs1.name
FROM highschooler AS hs1, highschooler AS hs2, friend AS f
WHERE hs1.id = f.id1
AND hs2.id = f.id2
AND hs2.name = 'Gabriel';

-- Question 2:
-- For every student who likes someone 2 or more grades younger than themselves, return that student's
-- name and grade, and the name and grade of the student they like.
SELECT hs1.name, hs1.grade, hs2.name, hs2.grade
FROM highschooler AS hs1, highschooler AS hs2, likes AS l
WHERE
(
    hs1.id = l.id1
    AND l.id2 = hs2.id
    AND hs1.grade - hs2.grade >= 2
)
OR
(
    hs1.id = l.id2
    AND l.id1 = hs2.id
    AND hs1.grade - hs2.grade >= 2
)

-- Question 3:
-- For every pair of students who both like each other, return the name and grade of both students. Include
-- each pair only once, with the two names in alphabetical order.
SELECT DISTINCT hs1.name, hs1.grade, hs2.name, hs2.grade
FROM highschooler AS hs1, highschooler AS hs2, likes AS l1, likes AS l2
WHERE
(hs1.id = l1.id1
AND l1.id2 = hs2.id)
AND
(hs2.id = l2.id1
AND l2.id2 = hs1.id)
AND
hs1.name < hs2.name;

-- Question 4:
-- Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their
-- names and grades. Sort by grade, then by name within each grade.
SELECT DISTINCT hs.name, hs.grade
FROM highschooler AS hs, likes AS l
WHERE
hs.id NOT IN (SELECT l.id1 FROM likes AS l)
AND hs.id NOT IN (SELECT l.id2 FROM likes AS l)
ORDER BY hs.grade, hs.name ASC;

-- Question 5:
-- For every situation where student A likes student B, but we have no information about whom B likes (that is,
-- B does not appear as an ID1 in the Likes table), return A and B's names and grades.
SELECT DISTINCT hs1.name, hs1.grade, hs2.name, hs2.grade
FROM highschooler AS hs1, highschooler AS hs2, likes AS l
WHERE
(
    hs1.id = l.id1
    AND hs2.id = l.id2
    AND hs2.id NOT IN
    (SELECT id1 FROM likes)
);

-- Question 6:
-- Find names and grades of students who only have friends in the same grade. Return the result sorted by grade,
-- then by name within each grade.
SELECT DISTINCT hs1.name, hs1.grade
FROM highschooler AS hs1, highschooler AS hs2, friend AS f
WHERE hs1.id = f.id1
AND hs2.id = f.id2
AND hs1.id NOT IN
(
    SELECT hs1.id
    FROM highschooler AS hs1, highschooler AS hs2, friend AS f
    WHERE hs1.id = f.id1
    AND hs2.id = f.id2
    AND hs1.grade != hs2.grade
)
ORDER BY hs1.grade, hs1.name;

-- Question 7:
-- For each student A who likes a student B where the two are not friends, find if they have a friend C in common
-- (who can introduce them!). For all such trios, return the name and grade of A, B, and C.
SELECT DISTINCT hs1.name, hs1.grade, hs2.name, hs2.grade, hs3.name, hs3.grade
FROM highschooler AS hs1, highschooler AS hs2, highschooler AS hs3, friend AS f, likes AS l
WHERE hs1.id = l.id1
AND hs2.id = l.id2
AND hs1.id NOT IN
(
    SELECT friend.id2
    FROM friend
    WHERE friend.id1 = hs2.id
)
AND hs3.id IN
(
    SELECT friend.id2
    FROM friend
    WHERE friend.id1 = hs1.id
)
AND hs3.id IN
(
    SELECT friend.id2
    FROM friend
    WHERE friend.id1 = hs2.id
);

-- Question 8:
-- Find the difference between the number of students in the school and the number of different first names.
SELECT COUNT(*)
- (
    SELECT COUNT(DISTINCT hs.name)
    FROM highschooler AS hs
  ) AS difference
FROM highschooler;

-- Question 9:
-- Find the name and grade of all students who are liked by more than one other student.
SELECT DISTINCT hs.name, hs.grade
FROM highschooler AS hs, likes AS l
WHERE
(
    SELECT COUNT(likes.id1)
    FROM likes
    WHERE likes.id2 = hs.id
) > 1;
