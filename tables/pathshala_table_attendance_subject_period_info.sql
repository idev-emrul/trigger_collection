
-- --------------------------------------------------------

--
-- Table structure for table `attendance_subject_period_info`
--

CREATE TABLE `attendance_subject_period_info` (
  `subject_period_id` int(11) NOT NULL,
  `period_code` int(5) NOT NULL,
  `subject_group_code` int(5) NOT NULL,
  `attendance_datetime` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `update_count` int(3) DEFAULT NULL,
  `created_by` int(5) DEFAULT NULL,
  `updated_by` int(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `attendance_subject_period_info`
--

INSERT INTO `attendance_subject_period_info` (`subject_period_id`, `period_code`, `subject_group_code`, `attendance_datetime`, `created_at`, `updated_at`, `update_count`, `created_by`, `updated_by`) VALUES
(8, 1, 73, '2023-12-06 12:47:00', '2023-12-06 14:41:23', NULL, NULL, 30, NULL),
(9, 1, 74, '2023-12-12 12:07:12', '2023-12-12 12:07:12', NULL, NULL, 1, NULL),
(10, 2, 74, '2023-12-12 12:07:12', '2023-02-28 11:04:54', '0000-00-00 00:00:00', NULL, 1, NULL);
