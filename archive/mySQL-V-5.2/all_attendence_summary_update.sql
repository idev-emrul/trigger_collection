DELIMITER //

CREATE TRIGGER all_attendence_summary_update
AFTER UPDATE ON attendance_student_period_info 
FOR EACH ROW
BEGIN
    DECLARE s_t_student_current_id INT;
    DECLARE s_t_subject_period_id INT;
    DECLARE s_t_subject_group_code INT;
    DECLARE s_t_year INT;
    DECLARE s_t_month INT;
    DECLARE s_total_present INT;
    DECLARE s_total_absent INT;
    DECLARE s_total_leave INT;
    DECLARE s_total_holiday INT;
    DECLARE s_total_fugitive INT;

    DECLARE p_t_student_current_id INT;
    DECLARE p_t_subject_period_id INT;
    DECLARE p_t_period_code INT;
    DECLARE p_t_year INT;
    DECLARE p_t_month INT;
    DECLARE p_total_present INT;
    DECLARE p_total_absent INT;
    DECLARE p_total_leave INT;
    DECLARE p_total_holiday INT;
    DECLARE p_total_fugitive INT;

    SELECT
        NEW.student_current_id,
        NEW.subject_period_id,
        asupi.subject_group_code,
        YEAR(NEW.student_check_in),
        MONTH(NEW.student_check_in),
        SUM(CASE WHEN attendance_type = 1 THEN 1 ELSE 0 END) AS s_total_present,
        SUM(CASE WHEN attendance_type = 2 THEN 1 ELSE 0 END) AS s_total_absent,
        SUM(CASE WHEN attendance_type = 3 THEN 1 ELSE 0 END) AS s_total_leave,
        SUM(CASE WHEN attendance_type = 4 THEN 1 ELSE 0 END) AS s_total_holiday,
        SUM(CASE WHEN attendance_type = 5 THEN 1 ELSE 0 END) AS s_total_fugitive
    INTO
        s_t_student_current_id,
        s_t_subject_period_id,
        s_t_subject_group_code,
        s_t_year,
        s_t_month,
        s_total_present,
        s_total_absent,
        s_total_leave,
        s_total_holiday,
        s_total_fugitive
    FROM    
        attendance_student_period_info aspi,
        attendance_subject_period_info asupi
    WHERE
        aspi.subject_period_id = asupi.subject_period_id
        AND student_current_id = NEW.student_current_id
        AND asupi.subject_group_code = (
                                        SELECT subject_group_code 
                                        FROM attendance_student_period_info C,
                                                attendance_subject_period_info D
                                        WHERE D.subject_period_id = NEW.subject_period_id 
                                        LIMIT 1
                                    )
        AND YEAR(`student_check_in`) = YEAR(NEW.`student_check_in`)
        AND MONTH(`student_check_in`) = MONTH(NEW.`student_check_in`);

    UPDATE trigger_attendance_student_subject_summary
    SET
        total_present = s_total_present,
        total_absent = s_total_absent,
        total_leave = s_total_leave,
        total_holiday = s_total_holiday,
        total_fugitive = s_total_fugitive
    WHERE
        student_current_id = s_t_student_current_id
        AND subject_group_code = s_t_subject_group_code
        AND `year` = s_t_year
        AND `month` = s_t_month;


-- ===== UPDATE PRIOD WISE ATTENDENCE =============
    

    SELECT
        NEW.student_current_id,
        NEW.subject_period_id,
        asupi.period_code,
        YEAR(NEW.student_check_in),
        MONTH(NEW.student_check_in),
        SUM(CASE WHEN attendance_type = 1 THEN 1 ELSE 0 END) AS p_total_present,
        SUM(CASE WHEN attendance_type = 2 THEN 1 ELSE 0 END) AS p_total_absent,
        SUM(CASE WHEN attendance_type = 3 THEN 1 ELSE 0 END) AS p_total_leave,
        SUM(CASE WHEN attendance_type = 4 THEN 1 ELSE 0 END) AS p_total_holiday,
        SUM(CASE WHEN attendance_type = 5 THEN 1 ELSE 0 END) AS p_total_fugitive
    INTO
        p_t_student_current_id,
        p_t_subject_period_id,
        p_t_period_code,
        p_t_year,
        p_t_month,
        p_total_present,
        p_total_absent,
        p_total_leave,
        p_total_holiday,
        p_total_fugitive
    FROM    
        attendance_student_period_info aspi,
        attendance_subject_period_info asupi
    WHERE
        aspi.subject_period_id = asupi.subject_period_id
        AND student_current_id = NEW.student_current_id
        AND asupi.period_code = (SELECT period_code 
                                        FROM attendance_student_period_info C,
                                                attendance_subject_period_info D
                                        WHERE D.subject_period_id = NEW.subject_period_id 
                                        LIMIT 1)
        AND YEAR(`student_check_in`) = YEAR(NEW.`student_check_in`)
        AND MONTH(`student_check_in`) = MONTH(NEW.`student_check_in`);

    UPDATE trigger_attendance_student_period_summary
    SET
        total_present = p_total_present,
        total_absent = p_total_absent,
        total_leave = p_total_leave,
        total_holiday = p_total_holiday,
        total_fugitive = p_total_fugitive
    WHERE
        student_current_id = p_t_student_current_id
        AND period_code = p_t_period_code
        AND `year` = p_t_year
        AND `month` = p_t_month;
END;
//
DELIMITER ;



