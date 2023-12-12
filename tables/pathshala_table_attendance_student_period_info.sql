
-- --------------------------------------------------------

--
-- Table structure for table `attendance_student_period_info`
--

CREATE TABLE `attendance_student_period_info` (
  `student_period_id` int(11) NOT NULL,
  `subject_period_id` int(11) NOT NULL,
  `student_current_id` int(11) DEFAULT NULL,
  `attendance_type` tinyint(1) DEFAULT NULL,
  `student_check_in` datetime DEFAULT NULL,
  `student_period_creator` int(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `attendance_student_period_info`
--

INSERT INTO `attendance_student_period_info` (`student_period_id`, `subject_period_id`, `student_current_id`, `attendance_type`, `student_check_in`, `student_period_creator`) VALUES
(20, 8, 1, 1, '2023-11-06 14:41:23', 30),
(21, 8, 2, 3, '2023-12-06 14:41:23', 30),
(22, 8, 3, 5, '2023-12-06 14:41:23', 30),
(23, 8, 2, 3, '2023-12-11 10:58:56', NULL),
(24, 8, 2, 1, '2023-12-11 00:00:00', NULL),
(25, 8, 2, 2, '2023-12-11 10:58:27', NULL),
(26, 8, 2, 1, '2023-12-11 10:58:27', NULL),
(27, 8, 2, 5, '2023-12-11 11:23:58', NULL),
(28, 8, 2, 1, '2023-12-11 10:58:27', NULL),
(29, 8, 2, 1, '2023-12-11 11:23:58', NULL),
(30, 8, 2, 2, '2023-12-11 12:06:12', NULL),
(31, 8, 2, 2, '2023-12-11 12:17:28', NULL),
(32, 8, 2, 2, '2023-12-11 12:19:27', NULL),
(33, 8, 3, 4, '2023-12-11 13:01:10', NULL),
(42, 8, 3, 1, '2023-12-11 10:58:27', 1),
(44, 10, 3, 5, '2023-12-11 10:58:27', NULL),
(49, 10, 3, 1, '2023-12-11 10:58:27', 1);

--
-- Triggers `attendance_student_period_info`
--
DELIMITER $$
CREATE TRIGGER `subject_wise_attendence_summary_on_delete` AFTER DELETE ON `attendance_student_period_info` FOR EACH ROW BEGIN
    DECLARE t_student_current_id INT;
    DECLARE t_subject_period_id INT;
    DECLARE t_subject_group_code INT;
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
        asupi.subject_group_code,
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
        t_subject_group_code,
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
         AND asupi.subject_group_code = (
                                        SELECT subject_group_code 
                                        FROM attendance_student_period_info C,
                                                attendance_subject_period_info D
                                        WHERE D.subject_period_id = OLD.subject_period_id 
                                        LIMIT 1
                                    )
        AND YEAR(`student_check_in`) = YEAR(OLD.`student_check_in`)
        AND MONTH(`student_check_in`) = MONTH(OLD.`student_check_in`);

    UPDATE trigger_attendance_student_subject_summary
    SET
        total_present = total_present,
        total_absent = total_absent,
        total_leave = total_leave,
        total_holiday = total_holiday,
        total_fugitive = total_fugitive
    WHERE
        student_current_id = t_student_current_id
        AND subject_group_code = t_subject_group_code
        AND `year` = t_year
        AND `month` = t_month;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `subject_wise_attendence_summary_on_insert` AFTER INSERT ON `attendance_student_period_info` FOR EACH ROW BEGIN
    DECLARE t_student_current_id INT;
    DECLARE t_subject_period_id INT;
    DECLARE t_subject_group_code INT;
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
        asupi.subject_group_code,
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
        t_subject_group_code,
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
        total_present = total_present,
        total_absent = total_absent,
        total_leave = total_leave,
        total_holiday = total_holiday,
        total_fugitive = total_fugitive
    WHERE
        student_current_id = t_student_current_id
        AND subject_group_code = t_subject_group_code
        AND `year` = t_year
        AND `month` = t_month;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `subject_wise_attendence_summary_on_update` AFTER UPDATE ON `attendance_student_period_info` FOR EACH ROW BEGIN
    DECLARE t_student_current_id INT;
    DECLARE t_subject_period_id INT;
    DECLARE t_subject_group_code INT;
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
        asupi.subject_group_code,
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
        t_subject_group_code,
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
        total_present = total_present,
        total_absent = total_absent,
        total_leave = total_leave,
        total_holiday = total_holiday,
        total_fugitive = total_fugitive
    WHERE
        student_current_id = t_student_current_id
        AND subject_group_code = t_subject_group_code
        AND `year` = t_year
        AND `month` = t_month;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_attendance_summary_on_delete` AFTER DELETE ON `attendance_student_period_info` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_attendance_summary_on_insert` AFTER INSERT ON `attendance_student_period_info` FOR EACH ROW BEGIN
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
        NEW.student_current_id,
        NEW.subject_period_id,
        asupi.period_code,
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
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_attendance_summary_on_update` AFTER UPDATE ON `attendance_student_period_info` FOR EACH ROW BEGIN
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
        NEW.student_current_id,
        NEW.subject_period_id,
        asupi.period_code,
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
END
$$
DELIMITER ;
