DELIMITER //

CREATE TRIGGER update_attendance_summary_on_delete
AFTER DELETE ON attendance_student_period_info 
FOR EACH ROW
BEGIN
    DECLARE t_student_current_id INT;
    DECLARE t_subject_period_id INT;
    DECLARE t_period_code INT;
    DECLARE t_year INT;
    DECLARE t_month INT;
    DECLARE total_present INT;
    DECLARE total_absent INT;
    DECLARE total_leave INT;
    DECLARE total_holiday INT;
    DECLARE total_fugitive INT;

    SELECT
        OLD.student_current_id,
        OLD.subject_period_id,
        asupi.period_code,
        YEAR(OLD.student_check_in),
        MONTH(OLD.student_check_in),
        SUM(CASE WHEN attendance_type = 1 THEN 1 ELSE 0 END) AS total_present,
        SUM(CASE WHEN attendance_type = 2 THEN 1 ELSE 0 END) AS total_absent,
        SUM(CASE WHEN attendance_type = 3 THEN 1 ELSE 0 END) AS total_leave,
        SUM(CASE WHEN attendance_type = 4 THEN 1 ELSE 0 END) AS total_holiday,
        SUM(CASE WHEN attendance_type = 5 THEN 1 ELSE 0 END) AS total_fugitive
    INTO
        t_student_current_id,
        t_subject_period_id,
        t_period_code,
        t_year,
        t_month,
        total_present,
        total_absent,
        total_leave,
        total_holiday,
        total_fugitive
    FROM    
        attendance_student_period_info aspi,
        attendance_subject_period_info asupi
    WHERE
        aspi.subject_period_id = asupi.subject_period_id
        AND student_current_id = OLD.student_current_id
        AND asupi.period_code = (SELECT period_code 
                                        FROM attendance_student_period_info C,
                                                attendance_subject_period_info D
                                        WHERE D.subject_period_id = OLD.subject_period_id 
                                        LIMIT 1)
        AND YEAR(`student_check_in`) = YEAR(OLD.`student_check_in`)
        AND MONTH(`student_check_in`) = MONTH(OLD.`student_check_in`);

    UPDATE trigger_attendance_student_period_summary
    SET
        total_present = total_present,
        total_absent = total_absent,
        total_leave = total_leave,
        total_holiday = total_holiday,
        total_fugitive = total_fugitive
    WHERE
        student_current_id = t_student_current_id
        AND period_code = t_period_code
        AND `year` = t_year
        AND `month` = t_month;
END;
//
DELIMITER ;
