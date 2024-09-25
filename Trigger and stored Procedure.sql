create database chatgpt4;
use chatgpt4;
CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_marks INT DEFAULT 0,
    age INT,
    photo_url VARCHAR(255) DEFAULT NULL
);
CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);
CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100),
    enrollment_count INT DEFAULT 0,
    is_important BOOLEAN DEFAULT FALSE
);
CREATE TABLE grades (
    student_id INT,
    course_id INT,
    marks INT,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);
CREATE TABLE logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    action VARCHAR(50),
    student_id INT,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id)
);
CREATE TABLE email_changes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    old_email VARCHAR(100),
    new_email VARCHAR(100),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id)
);
INSERT INTO students (name, email, total_marks, age, photo_url)
VALUES 
('John Doe', 'john.doe@example.com', 450, 21, '/static/uploads/john_doe.jpg'),
('Jane Smith', 'jane.smith@example.com', 480, 22, '/static/uploads/jane_smith.jpg'),
('Michael Johnson', 'michael.johnson@example.com', 430, 23, '/static/uploads/michael_johnson.jpg'),
('Emily Davis', 'emily.davis@example.com', 470, 20, '/static/uploads/emily_davis.jpg'),
('William Brown', 'william.brown@example.com', 460, 22, '/static/uploads/william_brown.jpg');
INSERT INTO courses (course_name, enrollment_count, is_important)
VALUES 
('Mathematics', 100, TRUE),
('Physics', 120, TRUE),
('Computer Science', 90, TRUE),
('History', 80, FALSE),
('Biology', 110, FALSE);

INSERT INTO enrollments (student_id, course_id, enrollment_date)
VALUES 
(1, 1, '2024-01-15'),
(1, 2, '2024-01-16'),
(2, 1, '2024-01-15'),
(2, 3, '2024-01-17'),
(3, 2, '2024-01-18'),
(3, 4, '2024-01-19'),
(4, 3, '2024-01-20'),
(5, 5, '2024-01-21');

INSERT INTO grades (student_id, course_id, marks)
VALUES 
(1, 1, 95),
(1, 2, 85),
(2, 1, 90),
(2, 3, 88),
(3, 2, 78),
(3, 4, 92),
(4, 3, 89),
(5, 5, 87);

INSERT INTO logs (action, student_id, action_time)
VALUES 
('Login', 1, '2024-09-22 08:00:00'),
('Profile Update', 2, '2024-09-22 08:30:00'),
('Enrollment', 3, '2024-09-22 09:00:00'),
('Course Completed', 1, '2024-09-22 09:15:00'),
('Login', 4, '2024-09-22 10:00:00');

INSERT INTO email_changes (student_id, old_email, new_email, change_date)
VALUES 
(1, 'john.doe@example.com', 'john.doe_new@example.com', '2024-09-20 10:00:00'),
(2, 'jane.smith@example.com', 'jane.smith_new@example.com', '2024-09-20 10:30:00'),
(3, 'michael.johnson@example.com', 'michael.j_new@example.com', '2024-09-20 11:00:00');
select * from enrollments;
select * from courses;
select * from email_changes;

select * from grades;
select * from logs;
select * from students;

################################################################################################
#                              Stored procedure
################################################################################################
# 1. Simple Procedure to Get All Students
delimiter //
create procedure all_stud()
begin
	select * from students;
end
// delimiter 

call all_stud();

# 2. Procedure to Insert a New Student
delimiter //
create procedure add_student(in name varchar(100), in email varchar(100))
begin
	insert into students(name, email) values (name, email);
end
// delimiter 
	
call add_student("Prajakta", "prajakta.H@example.com")    

# 3. Procedure to Update Student Information
delimiter //
create procedure update_stud(in s_name varchar(100), in s_email varchar(100), in  marks int)
begin 
	update students 
    set total_marks=marks 
    where name = s_name AND email = s_email;
END
//
DELIMITER ;

call update_stud("Prajakta", "prajakta.H@example.com", 460)

# 4. Procedure to Delete a Student
delimiter //
create procedure delete_stud(in name varchar(100))
begin
	delete from students
    where name= "Prajakta" and email is null;
END
//
DELIMITER ;

CALL delete_stud("Prajakta")

# 5. Procedure to Get Students by Course
delimiter //
create procedure stu_by_course(in c_id int)
begin
	 select e.student_id , e.course_id from enrollments e 
     join courses c on c.id=e.course_id
     where e.course_id=c_id;
END
//
DELIMITER ;

call stu_by_course(1)
     
# 6. Procedure to Calculate Total Marks of a Student
delimiter //
create procedure total(in stud_id int)
begin
	 select sum(marks) as total 
     from grades 
     where stud_id=student_id;
END
//
DELIMITER ;

call total(1)

# 7. Procedure to Assign a Course to a Student
DELIMITER $$
CREATE PROCEDURE AssignCourse(IN student_id INT, IN course_id INT)
BEGIN
    INSERT INTO enrollments (student_id, course_id) VALUES (student_id, course_id);
END $$
DELIMITER ;

call AssignCourse(1, 3)

# 8. Procedure to Get Count of Students in a Course
DELIMITER //
CREATE PROCEDURE xx(IN course_id INT)
BEGIN
	select count(*) as student_count
    from enrollments
    where course_id=course_id;
END
//
DELIMITER ;

call xx(1)

#9. Procedure to Update Student Marks
delimiter //
create procedure u_s1(in stud_id int, in c_id int, in mark int)
begin
	update grades 
    set marks=mark
    where stud_id=student_id and c_id=course_id;
end
//
DELIMITER ;

call u_s1(1,1,100)

##########################################################################################################
#                                    Trigger
##########################################################################################################
# 1. Trigger to Log Insertions into Student Table
delimiter //
create trigger after_stud_insert2
after insert on students
for each row
begin
	insert into logs (action, student_id, action_time) values ("insert", now());
end // 
delimiter ;

#2. Trigger to Prevent Negative Marks
delimiter //
create trigger beforeinsertongrade
before insert on grades
for each row
begin
	 if NEW.marks < 0 then 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Marks cannot be negative';
	end if;
end 
// delimiter ;

# 3. Trigger to Automatically Set Registration Date
delimiter //
create trigger set_reg
before insert on students
for each row
begin
	 set NEW.registration_date=now();
end 
// delimiter ;

# 4. Trigger to Log Deletion from Students Table
delimiter //
create trigger log_del 
after delete on students
for each row
begin
	insert into logs(action, student_id,action_time)
    values("Delete", OLD.id, now());
end
// delimiter ;

# 5. Trigger to Update Total Marks After Insertion into Grades
delimiter //
create trigger update_total_marks
after insert on grade
for each row
begin
	update students 
    set total_marks= (select sum(marks) from grades where student_id= NEW.student_id)
    where id=NEW.student_id;
end
// delimiter ;
	 
# 6. Trigger to Prevent Deletion of Important Courses
delimiter //
create trigger prevent_deletion_course
before delete on courses
for each row
begin
	IF OLD.is_important THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete important courses';
    END IF;
end 
// delimiter ;

# 7. Trigger to Maintain Course Enrollment Count
delimiter //
create trigger course_enroll_count
after update on enrollments
for each row
begin
	update enrollments
    set enrollment_count=enrollment_count+1
    where id=NEW.course_id;
end
// delimiter ;

# 8. Trigger to Check Age Before Insertion
select * from students;
delimiter //
create trigger age_check
before insert on students
for each row
begin
	if NEW.age < 18 then
		signal SQLSTATE '45000' SET MESSAGE_TEXT = 'Age must be 18 or above';
	end if;
end 
// delimiter ;

	
 
 