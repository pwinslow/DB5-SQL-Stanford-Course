-- Find the name and grade of the student(s) that both like Cassandra and
-- have the greatest number of friends.
SELECT hs.name, hs.grade
FROM highschooler AS hs, friend AS f, likes AS l
WHERE hs.id = f.id1
AND hs.id = l.id1
AND
(
    SELECT hs.id
    FROM highschooler AS hs
    WHERE hs.name = 'Cassandra'
) = l.id2
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

-- Find the name(s) of the employee(s) with the 3rd highest salary that are also customers
SELECT emp.salary
FROM employee AS emp
WHERE emp.salary IN
(
  SELECT DISTINCT emp.salary
  FROM employee AS emp
  ORDER BY emp.salary DESC
  LIMIT 2
)
AND !=
(
  SELECT MAX(emp.salary)
  FROM employee AS emp
);
