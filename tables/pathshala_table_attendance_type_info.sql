
-- --------------------------------------------------------

--
-- Table structure for table `attendance_type_info`
--

CREATE TABLE IF NOT EXISTS `attendance_type_info` (
  `attendance_type_code` int(3) NOT NULL AUTO_INCREMENT,
  `attendance_type_name` varchar(50) NOT NULL,
  `attendance_type_name_short` varchar(10) NOT NULL,
  `attendance_type_name_bn` varchar(100) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `update_count` int(3) DEFAULT NULL,
  `created_by` int(5) DEFAULT NULL,
  `updated_by` int(5) DEFAULT NULL,
  `status` tinyint(1) NOT NULL COMMENT '1 = active, 2 = inactive',
  PRIMARY KEY (`attendance_type_code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `attendance_type_info`
--

INSERT INTO `attendance_type_info` (`attendance_type_code`, `attendance_type_name`, `attendance_type_name_short`, `attendance_type_name_bn`, `created_at`, `updated_at`, `update_count`, `created_by`, `updated_by`, `status`) VALUES
(1, 'Present', 'P', 'উপস্থিত', '2023-12-07 00:00:00', NULL, NULL, 30, NULL, 1),
(2, 'Absent', 'A', 'অনুপস্থিত', '2023-12-07 00:00:00', NULL, NULL, 30, NULL, 1),
(3, 'Leave', 'L', 'L ছুটি', '2023-12-07 00:00:00', NULL, NULL, 30, NULL, 1),
(4, 'Holiday', 'H', 'ছুটি', '2023-12-07 00:00:00', NULL, NULL, 30, NULL, 1),
(5, 'Fugitive', 'F', 'পলাতক', '2023-12-07 00:00:00', NULL, NULL, 30, NULL, 1);
