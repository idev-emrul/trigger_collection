DELIMITER //

CREATE TRIGGER update_attendance_summary_on_update
AFTER UPDATE ON attendance_student_period_info 
FOR EACH ROW
BEGIN
    DECLARE t_student_current_id INT;
    DECLARE t_subject_period_id INT;
    DECLARE t_year INT;
    DECLARE t_month INT;
    DECLARE total_present INT;
    DECLARE total_absent INT;
    DECLARE total_leave INT;
    DECLARE total_holiday INT;
    DECLARE total_fugitive INT;

    SELECT
        NEW.student_current_id,
        NEW.subject_period_id,
        YEAR(NEW.student_check_in),
        MONTH(NEW.student_check_in),
        SUM(CASE WHEN attendance_type = 1 THEN 1 ELSE 0 END) AS total_present,
        SUM(CASE WHEN attendance_type = 2 THEN 1 ELSE 0 END) AS total_absent,
        SUM(CASE WHEN attendance_type = 3 THEN 1 ELSE 0 END) AS total_leave,
        SUM(CASE WHEN attendance_type = 4 THEN 1 ELSE 0 END) AS total_holiday,
        SUM(CASE WHEN attendance_type = 5 THEN 1 ELSE 0 END) AS total_fugitive
    INTO
        t_student_current_id,
        t_subject_period_id,
        t_year,
        t_month,
        total_present,
        total_absent,
        total_leave,
        total_holiday,
        total_fugitive
    FROM    
        attendance_student_period_info
    WHERE
        student_current_id = NEW.student_current_id
        AND subject_period_id = NEW.subject_period_id
        AND YEAR(`student_check_in`) = YEAR(NEW.`student_check_in`)
        AND MONTH(`student_check_in`) = MONTH(NEW.`student_check_in`);

    UPDATE trigger_attendance_student_summary
    SET
        total_present = total_present,
        total_absent = total_absent,
        total_leave = total_leave,
        total_holiday = total_holiday,
        total_fugitive = total_fugitive
    WHERE
        student_current_id = t_student_current_id
        AND subject_period_id = t_subject_period_id
        AND `year` = t_year
        AND `month` = t_month;
END;
//

DELIMITER ;
