DROP TABLE student;
CREATE TABLE student (
    student_id INT AUTO_INCREMENT,
    name VARCHAR(20),
    major VARCHAR(20) DEFAULT 'undecided',
    PRIMARY KEY(student_id)
);
INSERT INTO student(name, major) VALUES('Jack', 'Biology');
INSERT INTO student(name, major) VALUES('Kate', 'Sociology');
INSERT INTO student VALUES(3, 'Claire', 'Chemisty');
INSERT INTO student VALUES(4, 'Jack', 'Biology');
INSERT INTO student VALUES(5, 'Mike', 'Computer Science');

SELECT * FROM student;

UPDATE student
SET major = 'English'
WHERE name = 'Claire';

DELETE FROM student
WHERE name = 'Tom' AND major = 'undecided';


SELECT *
FROM student;