
-- --------------------------------------------------------

--
-- Table structure for table `trigger_attendance_student_period_summary`
--

CREATE TABLE IF NOT EXISTS `trigger_attendance_student_period_summary` (
  `attendance_student_summary_id` int(11) NOT NULL AUTO_INCREMENT,
  `student_current_id` int(11) NOT NULL,
  `period_code` int(11) NOT NULL,
  `session_code` int(3) NOT NULL,
  `month` int(2) NOT NULL,
  `year` int(4) NOT NULL,
  `total_present` int(3) NOT NULL,
  `total_absent` int(3) NOT NULL,
  `total_leave` int(3) NOT NULL,
  `total_holiday` int(3) NOT NULL,
  `total_fugitive` int(3) NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`attendance_student_summary_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `trigger_attendance_student_period_summary`
--

INSERT INTO `trigger_attendance_student_period_summary` (`attendance_student_summary_id`, `student_current_id`, `period_code`, `session_code`, `month`, `year`, `total_present`, `total_absent`, `total_leave`, `total_holiday`, `total_fugitive`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 9, 12, 2023, 10, 20, 1, 0, 0, 30, 0, '2023-12-09 00:00:00', '0000-00-00 00:00:00'),
(2, 2, 8, 9, 12, 2023, 4, 4, 2, 0, 1, 30, 0, '2023-12-09 00:00:00', '0000-00-00 00:00:00'),
(3, 3, 1, 9, 12, 2023, 1, 0, 0, 1, 1, 30, 0, '2023-12-09 00:00:00', '0000-00-00 00:00:00'),
(4, 3, 2, 9, 12, 2023, 1, 0, 0, 0, 1, 1, 0, '2023-12-12 07:29:04', '2023-12-12 07:29:04');
