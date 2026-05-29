/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80041 (8.0.41)
 Source Host           : localhost:3306
 Source Schema         : student-scores

 Target Server Type    : MySQL
 Target Server Version : 80041 (8.0.41)
 File Encoding         : 65001

 Date: 29/04/2026 11:42:59
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_group
-- ----------------------------
INSERT INTO `auth_group` VALUES (1, '用户');

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_group_permissions_group_id_permission_id_0cd325b0_uniq`(`group_id` ASC, `permission_id` ASC) USING BTREE,
  INDEX `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm`(`permission_id` ASC) USING BTREE,
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_group_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_permission_content_type_id_codename_01ab375a_uniq`(`content_type_id` ASC, `codename` ASC) USING BTREE,
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 109 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_permission
-- ----------------------------
INSERT INTO `auth_permission` VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO `auth_permission` VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO `auth_permission` VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO `auth_permission` VALUES (4, 'Can view log entry', 1, 'view_logentry');
INSERT INTO `auth_permission` VALUES (5, 'Can add permission', 2, 'add_permission');
INSERT INTO `auth_permission` VALUES (6, 'Can change permission', 2, 'change_permission');
INSERT INTO `auth_permission` VALUES (7, 'Can delete permission', 2, 'delete_permission');
INSERT INTO `auth_permission` VALUES (8, 'Can view permission', 2, 'view_permission');
INSERT INTO `auth_permission` VALUES (9, 'Can add group', 3, 'add_group');
INSERT INTO `auth_permission` VALUES (10, 'Can change group', 3, 'change_group');
INSERT INTO `auth_permission` VALUES (11, 'Can delete group', 3, 'delete_group');
INSERT INTO `auth_permission` VALUES (12, 'Can view group', 3, 'view_group');
INSERT INTO `auth_permission` VALUES (13, 'Can add content type', 4, 'add_contenttype');
INSERT INTO `auth_permission` VALUES (14, 'Can change content type', 4, 'change_contenttype');
INSERT INTO `auth_permission` VALUES (15, 'Can delete content type', 4, 'delete_contenttype');
INSERT INTO `auth_permission` VALUES (16, 'Can view content type', 4, 'view_contenttype');
INSERT INTO `auth_permission` VALUES (17, 'Can add session', 5, 'add_session');
INSERT INTO `auth_permission` VALUES (18, 'Can change session', 5, 'change_session');
INSERT INTO `auth_permission` VALUES (19, 'Can delete session', 5, 'delete_session');
INSERT INTO `auth_permission` VALUES (20, 'Can view session', 5, 'view_session');
INSERT INTO `auth_permission` VALUES (21, 'Can add crontab', 6, 'add_crontabschedule');
INSERT INTO `auth_permission` VALUES (22, 'Can change crontab', 6, 'change_crontabschedule');
INSERT INTO `auth_permission` VALUES (23, 'Can delete crontab', 6, 'delete_crontabschedule');
INSERT INTO `auth_permission` VALUES (24, 'Can view crontab', 6, 'view_crontabschedule');
INSERT INTO `auth_permission` VALUES (25, 'Can add interval', 7, 'add_intervalschedule');
INSERT INTO `auth_permission` VALUES (26, 'Can change interval', 7, 'change_intervalschedule');
INSERT INTO `auth_permission` VALUES (27, 'Can delete interval', 7, 'delete_intervalschedule');
INSERT INTO `auth_permission` VALUES (28, 'Can view interval', 7, 'view_intervalschedule');
INSERT INTO `auth_permission` VALUES (29, 'Can add periodic task', 8, 'add_periodictask');
INSERT INTO `auth_permission` VALUES (30, 'Can change periodic task', 8, 'change_periodictask');
INSERT INTO `auth_permission` VALUES (31, 'Can delete periodic task', 8, 'delete_periodictask');
INSERT INTO `auth_permission` VALUES (32, 'Can view periodic task', 8, 'view_periodictask');
INSERT INTO `auth_permission` VALUES (33, 'Can add periodic task track', 9, 'add_periodictasks');
INSERT INTO `auth_permission` VALUES (34, 'Can change periodic task track', 9, 'change_periodictasks');
INSERT INTO `auth_permission` VALUES (35, 'Can delete periodic task track', 9, 'delete_periodictasks');
INSERT INTO `auth_permission` VALUES (36, 'Can view periodic task track', 9, 'view_periodictasks');
INSERT INTO `auth_permission` VALUES (37, 'Can add solar event', 10, 'add_solarschedule');
INSERT INTO `auth_permission` VALUES (38, 'Can change solar event', 10, 'change_solarschedule');
INSERT INTO `auth_permission` VALUES (39, 'Can delete solar event', 10, 'delete_solarschedule');
INSERT INTO `auth_permission` VALUES (40, 'Can view solar event', 10, 'view_solarschedule');
INSERT INTO `auth_permission` VALUES (41, 'Can add clocked', 11, 'add_clockedschedule');
INSERT INTO `auth_permission` VALUES (42, 'Can change clocked', 11, 'change_clockedschedule');
INSERT INTO `auth_permission` VALUES (43, 'Can delete clocked', 11, 'delete_clockedschedule');
INSERT INTO `auth_permission` VALUES (44, 'Can view clocked', 11, 'view_clockedschedule');
INSERT INTO `auth_permission` VALUES (45, 'Can add task result', 12, 'add_taskresult');
INSERT INTO `auth_permission` VALUES (46, 'Can change task result', 12, 'change_taskresult');
INSERT INTO `auth_permission` VALUES (47, 'Can delete task result', 12, 'delete_taskresult');
INSERT INTO `auth_permission` VALUES (48, 'Can view task result', 12, 'view_taskresult');
INSERT INTO `auth_permission` VALUES (49, 'Can add chord counter', 13, 'add_chordcounter');
INSERT INTO `auth_permission` VALUES (50, 'Can change chord counter', 13, 'change_chordcounter');
INSERT INTO `auth_permission` VALUES (51, 'Can delete chord counter', 13, 'delete_chordcounter');
INSERT INTO `auth_permission` VALUES (52, 'Can view chord counter', 13, 'view_chordcounter');
INSERT INTO `auth_permission` VALUES (53, 'Can add group result', 14, 'add_groupresult');
INSERT INTO `auth_permission` VALUES (54, 'Can change group result', 14, 'change_groupresult');
INSERT INTO `auth_permission` VALUES (55, 'Can delete group result', 14, 'delete_groupresult');
INSERT INTO `auth_permission` VALUES (56, 'Can view group result', 14, 'view_groupresult');
INSERT INTO `auth_permission` VALUES (57, 'Can add 用户', 15, 'add_user');
INSERT INTO `auth_permission` VALUES (58, 'Can change 用户', 15, 'change_user');
INSERT INTO `auth_permission` VALUES (59, 'Can delete 用户', 15, 'delete_user');
INSERT INTO `auth_permission` VALUES (60, 'Can view 用户', 15, 'view_user');
INSERT INTO `auth_permission` VALUES (61, 'Can add 学生信息', 16, 'add_studentprofile');
INSERT INTO `auth_permission` VALUES (62, 'Can change 学生信息', 16, 'change_studentprofile');
INSERT INTO `auth_permission` VALUES (63, 'Can delete 学生信息', 16, 'delete_studentprofile');
INSERT INTO `auth_permission` VALUES (64, 'Can view 学生信息', 16, 'view_studentprofile');
INSERT INTO `auth_permission` VALUES (65, 'Can add 教师信息', 17, 'add_teacherprofile');
INSERT INTO `auth_permission` VALUES (66, 'Can change 教师信息', 17, 'change_teacherprofile');
INSERT INTO `auth_permission` VALUES (67, 'Can delete 教师信息', 17, 'delete_teacherprofile');
INSERT INTO `auth_permission` VALUES (68, 'Can view 教师信息', 17, 'view_teacherprofile');
INSERT INTO `auth_permission` VALUES (69, 'Can add 课程', 18, 'add_course');
INSERT INTO `auth_permission` VALUES (70, 'Can change 课程', 18, 'change_course');
INSERT INTO `auth_permission` VALUES (71, 'Can delete 课程', 18, 'delete_course');
INSERT INTO `auth_permission` VALUES (72, 'Can view 课程', 18, 'view_course');
INSERT INTO `auth_permission` VALUES (73, 'Can add 课程班级', 19, 'add_courseclass');
INSERT INTO `auth_permission` VALUES (74, 'Can change 课程班级', 19, 'change_courseclass');
INSERT INTO `auth_permission` VALUES (75, 'Can delete 课程班级', 19, 'delete_courseclass');
INSERT INTO `auth_permission` VALUES (76, 'Can view 课程班级', 19, 'view_courseclass');
INSERT INTO `auth_permission` VALUES (77, 'Can add 课程目标达成度', 20, 'add_courseobjectiveachievement');
INSERT INTO `auth_permission` VALUES (78, 'Can change 课程目标达成度', 20, 'change_courseobjectiveachievement');
INSERT INTO `auth_permission` VALUES (79, 'Can delete 课程目标达成度', 20, 'delete_courseobjectiveachievement');
INSERT INTO `auth_permission` VALUES (80, 'Can view 课程目标达成度', 20, 'view_courseobjectiveachievement');
INSERT INTO `auth_permission` VALUES (81, 'Can add 选课记录', 21, 'add_enrollment');
INSERT INTO `auth_permission` VALUES (82, 'Can change 选课记录', 21, 'change_enrollment');
INSERT INTO `auth_permission` VALUES (83, 'Can delete 选课记录', 21, 'delete_enrollment');
INSERT INTO `auth_permission` VALUES (84, 'Can view 选课记录', 21, 'view_enrollment');
INSERT INTO `auth_permission` VALUES (85, 'Can add 成绩评定政策', 22, 'add_gradingpolicy');
INSERT INTO `auth_permission` VALUES (86, 'Can change 成绩评定政策', 22, 'change_gradingpolicy');
INSERT INTO `auth_permission` VALUES (87, 'Can delete 成绩评定政策', 22, 'delete_gradingpolicy');
INSERT INTO `auth_permission` VALUES (88, 'Can view 成绩评定政策', 22, 'view_gradingpolicy');
INSERT INTO `auth_permission` VALUES (89, 'Can add 成绩调整记录', 23, 'add_scoreadjustment');
INSERT INTO `auth_permission` VALUES (90, 'Can change 成绩调整记录', 23, 'change_scoreadjustment');
INSERT INTO `auth_permission` VALUES (91, 'Can delete 成绩调整记录', 23, 'delete_scoreadjustment');
INSERT INTO `auth_permission` VALUES (92, 'Can view 成绩调整记录', 23, 'view_scoreadjustment');
INSERT INTO `auth_permission` VALUES (93, 'Can add 成绩导入日志', 24, 'add_scoreimportlog');
INSERT INTO `auth_permission` VALUES (94, 'Can change 成绩导入日志', 24, 'change_scoreimportlog');
INSERT INTO `auth_permission` VALUES (95, 'Can delete 成绩导入日志', 24, 'delete_scoreimportlog');
INSERT INTO `auth_permission` VALUES (96, 'Can view 成绩导入日志', 24, 'view_scoreimportlog');
INSERT INTO `auth_permission` VALUES (97, 'Can add 成绩记录', 25, 'add_score');
INSERT INTO `auth_permission` VALUES (98, 'Can change 成绩记录', 25, 'change_score');
INSERT INTO `auth_permission` VALUES (99, 'Can delete 成绩记录', 25, 'delete_score');
INSERT INTO `auth_permission` VALUES (100, 'Can view 成绩记录', 25, 'view_score');
INSERT INTO `auth_permission` VALUES (101, 'Can add 记分册', 26, 'add_gradebook');
INSERT INTO `auth_permission` VALUES (102, 'Can change 记分册', 26, 'change_gradebook');
INSERT INTO `auth_permission` VALUES (103, 'Can delete 记分册', 26, 'delete_gradebook');
INSERT INTO `auth_permission` VALUES (104, 'Can view 记分册', 26, 'view_gradebook');
INSERT INTO `auth_permission` VALUES (105, 'Can add 算法分析与设计成绩', 27, 'add_algorithmscore');
INSERT INTO `auth_permission` VALUES (106, 'Can change 算法分析与设计成绩', 27, 'change_algorithmscore');
INSERT INTO `auth_permission` VALUES (107, 'Can delete 算法分析与设计成绩', 27, 'delete_algorithmscore');
INSERT INTO `auth_permission` VALUES (108, 'Can view 算法分析与设计成绩', 27, 'view_algorithmscore');

-- ----------------------------
-- Table structure for courses_course
-- ----------------------------
DROP TABLE IF EXISTS `courses_course`;
CREATE TABLE `courses_course`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `course_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `course_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `english_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `credit` double NOT NULL,
  `hours` int NOT NULL,
  `department` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `semester` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `year` int NOT NULL,
  `is_required` tinyint(1) NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `syllabus_file` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `course_objectives` json NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `course_code`(`course_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of courses_course
-- ----------------------------
INSERT INTO `courses_course` VALUES (3, '1', '计算机图形学', 'Computer Graphics', 2.5, 40, '计算机学院', 'spring', 2025, 0, '《计算机图形学》是计算机绘图、图像处理以及图形可视化设计的理论基础，是数\n字媒体技术专业核心课。主要介绍计算机图形学的原理、算法及系统，计算机图形建模\n技术和造型技术，包括计算机图形学基本概念、图形系统的组成，人机交互处理、图形\n对象在计算机内的表示以及基本图形的生成算法，图形二维变换和三维变换观察，自由\n曲线曲面的生成，以及真实感图形绘制等算法分析与设计方法。通过训练学生逻辑思维\n和抽象思维，提高其计算机图形图像系统的开发能力，培养学生分析问题、解决问题的\n能力，以及实践动手能力，为今后从事可视化智能处理、动画制作、图像处理及模式识\n别等相关工程技术工作打下坚实的基础。', 'syllabus/1dbf72fe-7cf6-463f-8db6-cd9d2379ccc4.pdf', '[{\"max_score\": 31, \"final_weight\": 0.7, \"usual_weight\": 0.1, \"objective_name\": \"课程目标1\", \"experiment_weight\": 0}, {\"max_score\": 37, \"final_weight\": 0.7, \"usual_weight\": 0.06, \"objective_name\": \"课程目标2\", \"experiment_weight\": 0.25}, {\"max_score\": 32, \"final_weight\": 0.6, \"usual_weight\": 0.04, \"objective_name\": \"课程目标3\", \"experiment_weight\": 0.25}]', '2025-12-09 12:40:39.844443', '2026-01-13 07:45:48.867210');
INSERT INTO `courses_course` VALUES (4, '2', '算法分析与设计', 'Design and Analysis of Algorithm', 2.5, 40, '计算机学院', 'spring', 2025, 1, '本课程是计算机科学与技术专业必修课程。本课程介绍了计算复杂性的定义和算法分析的基本方法，介绍了计算机科学及应用领域中大部分经典的算法：分治法、动态规划、贪婪法、回朔法、分支限界法、随机算法、NP 完全问题、近似计算等。通过对算法分析与设计课程的学习，使学生理解和掌握算法设计的主要方法，培养学生对算法的计算复杂性进行正确分析的能力。不但为其他专业课程奠定了扎实的基础，也为日后从事计算机系统结构、系统软件和应用软件的研究与开发奠定了基础。', 'syllabus/c3dff5af-004e-42e5-b482-778ef1dac560.pdf', '[{\"max_score\": 31, \"final_weight\": 0.7, \"usual_weight\": 0.1, \"objective_name\": \"课程目标1\", \"experiment_weight\": 0}, {\"max_score\": 37, \"final_weight\": 0.7, \"usual_weight\": 0.06, \"objective_name\": \"课程目标2\", \"experiment_weight\": 0.25}, {\"max_score\": 32, \"final_weight\": 0.6, \"usual_weight\": 0.04, \"objective_name\": \"课程目标3\", \"experiment_weight\": 0.25}]', '2025-12-28 04:09:37.117664', '2025-12-28 04:10:49.449399');

-- ----------------------------
-- Table structure for courses_course_teachers
-- ----------------------------
DROP TABLE IF EXISTS `courses_course_teachers`;
CREATE TABLE `courses_course_teachers`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `course_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `courses_course_teachers_course_id_user_id_158fc95d_uniq`(`course_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `courses_course_teachers_user_id_30e1701b_fk_users_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `courses_course_teachers_course_id_62104cb5_fk_courses_course_id` FOREIGN KEY (`course_id`) REFERENCES `courses_course` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `courses_course_teachers_user_id_30e1701b_fk_users_user_id` FOREIGN KEY (`user_id`) REFERENCES `users_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of courses_course_teachers
-- ----------------------------
INSERT INTO `courses_course_teachers` VALUES (2, 3, 1);
INSERT INTO `courses_course_teachers` VALUES (3, 4, 1);

-- ----------------------------
-- Table structure for courses_courseclass
-- ----------------------------
DROP TABLE IF EXISTS `courses_courseclass`;
CREATE TABLE `courses_courseclass`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `class_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `max_students` int NOT NULL,
  `class_time` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `classroom` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `course_id` bigint NOT NULL,
  `main_teacher_id` bigint NULL DEFAULT NULL,
  `m_calculation_config` json NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `courses_courseclass_course_id_class_name_953880d9_uniq`(`course_id` ASC, `class_name` ASC) USING BTREE,
  INDEX `courses_courseclass_main_teacher_id_4193a3ee_fk_users_user_id`(`main_teacher_id` ASC) USING BTREE,
  CONSTRAINT `courses_courseclass_course_id_31079432_fk_courses_course_id` FOREIGN KEY (`course_id`) REFERENCES `courses_course` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `courses_courseclass_main_teacher_id_4193a3ee_fk_users_user_id` FOREIGN KEY (`main_teacher_id`) REFERENCES `users_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of courses_courseclass
-- ----------------------------
INSERT INTO `courses_courseclass` VALUES (1, '计科2203', 100, '', '', 3, 1, NULL);
INSERT INTO `courses_courseclass` VALUES (2, '计科2202', 100, '', '', 3, 1, NULL);
INSERT INTO `courses_courseclass` VALUES (3, '计科2201', 100, '', '', 3, 1, NULL);
INSERT INTO `courses_courseclass` VALUES (4, '计科2301', 100, '', '', 4, 1, NULL);
INSERT INTO `courses_courseclass` VALUES (5, '计科2302', 100, '', '', 4, 1, NULL);
INSERT INTO `courses_courseclass` VALUES (6, '计科2303', 100, '', '', 4, 1, NULL);
INSERT INTO `courses_courseclass` VALUES (7, '计科2304', 100, '', '', 4, 1, NULL);
INSERT INTO `courses_courseclass` VALUES (8, '计科2305', 100, '', '', 4, 1, NULL);
INSERT INTO `courses_courseclass` VALUES (9, '计科2204', 100, '', '', 3, 1, NULL);

-- ----------------------------
-- Table structure for courses_courseclass_assistant_teachers
-- ----------------------------
DROP TABLE IF EXISTS `courses_courseclass_assistant_teachers`;
CREATE TABLE `courses_courseclass_assistant_teachers`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `courseclass_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `courses_courseclass_assi_courseclass_id_user_id_d93a26d2_uniq`(`courseclass_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `courses_courseclass__user_id_d424ddc6_fk_users_use`(`user_id` ASC) USING BTREE,
  CONSTRAINT `courses_courseclass__courseclass_id_a6d1de06_fk_courses_c` FOREIGN KEY (`courseclass_id`) REFERENCES `courses_courseclass` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `courses_courseclass__user_id_d424ddc6_fk_users_use` FOREIGN KEY (`user_id`) REFERENCES `users_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of courses_courseclass_assistant_teachers
-- ----------------------------

-- ----------------------------
-- Table structure for courses_courseobjectiveachievement
-- ----------------------------
DROP TABLE IF EXISTS `courses_courseobjectiveachievement`;
CREATE TABLE `courses_courseobjectiveachievement`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `objective_number` int NOT NULL,
  `usual_score` double NOT NULL,
  `experiment_score` double NOT NULL,
  `final_score` double NOT NULL,
  `achievement_score` double NOT NULL,
  `achievement_degree` double NOT NULL,
  `max_score` double NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `score_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `courses_courseobjectivea_score_id_objective_numbe_414cf444_uniq`(`score_id` ASC, `objective_number` ASC) USING BTREE,
  CONSTRAINT `courses_courseobject_score_id_368e39e9_fk_scores_sc` FOREIGN KEY (`score_id`) REFERENCES `scores_score` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 505 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of courses_courseobjectiveachievement
-- ----------------------------
INSERT INTO `courses_courseobjectiveachievement` VALUES (1, 1, 9.03, 0, 18.87, 27.9, 0.9001, 31, '2025-12-26 13:31:30.227000', '2025-12-27 06:48:01.674084', 1);
INSERT INTO `courses_courseobjectiveachievement` VALUES (2, 2, 5.42, 9.25, 18.87, 33.54, 0.9065, 37, '2025-12-26 13:31:30.229108', '2025-12-27 06:48:01.678237', 1);
INSERT INTO `courses_courseobjectiveachievement` VALUES (3, 3, 3.61, 9.25, 16.18, 29.04, 0.9075, 32, '2025-12-26 13:31:30.233474', '2025-12-27 06:48:01.683736', 1);
INSERT INTO `courses_courseobjectiveachievement` VALUES (4, 1, 8.26, 0, 15.33, 23.59, 0.7608, 31, '2025-12-26 13:31:36.706972', '2025-12-27 06:47:54.700821', 2);
INSERT INTO `courses_courseobjectiveachievement` VALUES (5, 2, 4.95, 8.05, 15.33, 28.33, 0.7658, 37, '2025-12-26 13:31:36.710202', '2025-12-27 06:47:54.705182', 2);
INSERT INTO `courses_courseobjectiveachievement` VALUES (6, 3, 3.3, 8.05, 13.14, 24.49, 0.7654, 32, '2025-12-26 13:31:36.711220', '2025-12-27 06:47:54.709228', 2);
INSERT INTO `courses_courseobjectiveachievement` VALUES (7, 1, 9, 0, 16.38, 25.38, 0.8185, 31, '2025-12-26 13:31:43.936211', '2025-12-26 13:54:56.097808', 3);
INSERT INTO `courses_courseobjectiveachievement` VALUES (8, 2, 5.4, 8.25, 16.38, 30.03, 0.8115, 37, '2025-12-26 13:31:43.938250', '2025-12-26 13:54:56.101874', 3);
INSERT INTO `courses_courseobjectiveachievement` VALUES (9, 3, 3.6, 8.25, 14.04, 25.89, 0.809, 32, '2025-12-26 13:31:43.940307', '2025-12-26 13:54:56.105961', 3);
INSERT INTO `courses_courseobjectiveachievement` VALUES (10, 1, 9.14, 0, 17.43, 26.56, 0.8569, 31, '2025-12-26 13:31:50.488845', '2025-12-26 13:55:02.811157', 4);
INSERT INTO `courses_courseobjectiveachievement` VALUES (11, 2, 5.48, 8.6, 17.43, 31.51, 0.8516, 37, '2025-12-26 13:31:50.490897', '2025-12-26 13:55:02.815278', 4);
INSERT INTO `courses_courseobjectiveachievement` VALUES (12, 3, 3.65, 8.6, 14.94, 27.19, 0.8498, 32, '2025-12-26 13:31:50.492993', '2025-12-26 13:55:02.820535', 4);
INSERT INTO `courses_courseobjectiveachievement` VALUES (13, 1, 9.15, 0, 16.3, 25.45, 0.821, 31, '2025-12-26 13:31:57.175119', '2025-12-26 13:55:09.370888', 5);
INSERT INTO `courses_courseobjectiveachievement` VALUES (14, 2, 5.49, 8.1, 16.3, 29.89, 0.8079, 37, '2025-12-26 13:31:57.177210', '2025-12-26 13:55:09.374153', 5);
INSERT INTO `courses_courseobjectiveachievement` VALUES (15, 3, 3.66, 8.1, 13.97, 25.73, 0.8041, 32, '2025-12-26 13:31:57.180403', '2025-12-26 13:55:09.378312', 5);
INSERT INTO `courses_courseobjectiveachievement` VALUES (16, 1, 8.67, 0, 17.01, 25.68, 0.8284, 31, '2025-12-26 13:32:03.961849', '2025-12-26 13:55:16.513601', 6);
INSERT INTO `courses_courseobjectiveachievement` VALUES (17, 2, 5.2, 8.25, 17.01, 30.46, 0.8233, 37, '2025-12-26 13:32:03.965240', '2025-12-26 13:55:16.518828', 6);
INSERT INTO `courses_courseobjectiveachievement` VALUES (18, 3, 3.47, 8.25, 14.58, 26.3, 0.8218, 32, '2025-12-26 13:32:03.967291', '2025-12-26 13:55:16.522929', 6);
INSERT INTO `courses_courseobjectiveachievement` VALUES (19, 1, 8.82, 0, 16.25, 25.06, 0.8085, 31, '2025-12-26 13:32:10.636490', '2025-12-26 13:55:23.085941', 7);
INSERT INTO `courses_courseobjectiveachievement` VALUES (20, 2, 5.29, 7.7, 16.25, 29.24, 0.7902, 37, '2025-12-26 13:32:10.638497', '2025-12-26 13:55:23.090096', 7);
INSERT INTO `courses_courseobjectiveachievement` VALUES (21, 3, 3.53, 7.7, 13.93, 25.15, 0.786, 32, '2025-12-26 13:32:10.641591', '2025-12-26 13:55:23.095433', 7);
INSERT INTO `courses_courseobjectiveachievement` VALUES (22, 1, 9.13, 0, 14.59, 23.72, 0.7653, 31, '2025-12-26 13:32:17.813827', '2025-12-26 13:55:30.238305', 8);
INSERT INTO `courses_courseobjectiveachievement` VALUES (23, 2, 5.48, 7.55, 14.59, 27.62, 0.7466, 37, '2025-12-26 13:32:17.817196', '2025-12-26 13:55:30.242461', 8);
INSERT INTO `courses_courseobjectiveachievement` VALUES (24, 3, 3.65, 7.55, 12.51, 23.71, 0.741, 32, '2025-12-26 13:32:17.821470', '2025-12-26 13:55:30.246511', 8);
INSERT INTO `courses_courseobjectiveachievement` VALUES (25, 1, 9.29, 0, 16.93, 26.22, 0.8458, 31, '2025-12-26 13:32:26.052313', '2025-12-26 13:55:36.724429', 9);
INSERT INTO `courses_courseobjectiveachievement` VALUES (26, 2, 5.57, 8.55, 16.93, 31.06, 0.8393, 37, '2025-12-26 13:32:26.055571', '2025-12-26 13:55:36.728482', 9);
INSERT INTO `courses_courseobjectiveachievement` VALUES (27, 3, 3.72, 8.55, 14.51, 26.78, 0.8368, 32, '2025-12-26 13:32:26.058638', '2025-12-26 13:55:36.733575', 9);
INSERT INTO `courses_courseobjectiveachievement` VALUES (28, 1, 9.1, 0, 17.22, 26.32, 0.849, 31, '2025-12-26 13:32:33.777356', '2025-12-26 13:55:44.198668', 10);
INSERT INTO `courses_courseobjectiveachievement` VALUES (29, 2, 5.46, 8.5, 17.22, 31.18, 0.8427, 37, '2025-12-26 13:32:33.781561', '2025-12-26 13:55:44.202674', 10);
INSERT INTO `courses_courseobjectiveachievement` VALUES (30, 3, 3.64, 8.5, 14.76, 26.9, 0.8406, 32, '2025-12-26 13:32:33.784609', '2025-12-26 13:55:44.206839', 10);
INSERT INTO `courses_courseobjectiveachievement` VALUES (31, 1, 9.18, 0, 16.48, 25.66, 0.8279, 31, '2025-12-26 13:32:44.481626', '2025-12-26 13:55:51.049937', 11);
INSERT INTO `courses_courseobjectiveachievement` VALUES (32, 2, 5.51, 8.45, 16.48, 30.44, 0.8228, 37, '2025-12-26 13:32:44.483888', '2025-12-26 13:55:51.055424', 11);
INSERT INTO `courses_courseobjectiveachievement` VALUES (33, 3, 3.67, 8.45, 14.13, 26.25, 0.8204, 32, '2025-12-26 13:32:44.487032', '2025-12-26 13:55:51.059585', 11);
INSERT INTO `courses_courseobjectiveachievement` VALUES (34, 1, 9.19, 0, 17.04, 26.22, 0.8458, 31, '2025-12-26 13:32:59.412253', '2025-12-26 13:55:58.964815', 12);
INSERT INTO `courses_courseobjectiveachievement` VALUES (35, 2, 5.51, 8.45, 17.04, 31, 0.8378, 37, '2025-12-26 13:32:59.416429', '2025-12-26 13:55:58.974247', 12);
INSERT INTO `courses_courseobjectiveachievement` VALUES (36, 3, 3.67, 8.45, 14.6, 26.73, 0.8352, 32, '2025-12-26 13:32:59.419559', '2025-12-26 13:55:58.980550', 12);
INSERT INTO `courses_courseobjectiveachievement` VALUES (37, 1, 9.52, 0, 18.03, 27.55, 0.8887, 31, '2025-12-26 13:33:14.185442', '2025-12-27 06:49:47.341005', 13);
INSERT INTO `courses_courseobjectiveachievement` VALUES (38, 2, 5.71, 8.55, 18.03, 32.29, 0.8728, 37, '2025-12-26 13:33:14.188477', '2025-12-27 06:49:47.349386', 13);
INSERT INTO `courses_courseobjectiveachievement` VALUES (39, 3, 3.81, 8.55, 15.46, 27.81, 0.8692, 32, '2025-12-26 13:33:14.190512', '2025-12-27 06:49:47.357097', 13);
INSERT INTO `courses_courseobjectiveachievement` VALUES (40, 1, 9.2, 0, 14.54, 23.74, 0.7659, 31, '2025-12-26 13:33:29.565129', '2025-12-27 06:49:38.360399', 14);
INSERT INTO `courses_courseobjectiveachievement` VALUES (41, 2, 5.52, 7.75, 14.54, 27.81, 0.7517, 37, '2025-12-26 13:33:29.568158', '2025-12-27 06:49:38.368916', 14);
INSERT INTO `courses_courseobjectiveachievement` VALUES (42, 3, 3.68, 7.75, 12.46, 23.89, 0.7467, 32, '2025-12-26 13:33:29.572495', '2025-12-27 06:49:38.379333', 14);
INSERT INTO `courses_courseobjectiveachievement` VALUES (43, 1, 9.19, 0, 18.19, 27.38, 0.8833, 31, '2025-12-26 13:33:44.760961', '2025-12-27 06:49:34.400803', 15);
INSERT INTO `courses_courseobjectiveachievement` VALUES (44, 2, 5.51, 8.55, 18.19, 32.26, 0.8718, 37, '2025-12-26 13:33:44.766088', '2025-12-27 06:49:34.409235', 15);
INSERT INTO `courses_courseobjectiveachievement` VALUES (45, 3, 3.68, 8.55, 15.59, 27.82, 0.8693, 32, '2025-12-26 13:33:44.768098', '2025-12-27 06:49:34.420731', 15);
INSERT INTO `courses_courseobjectiveachievement` VALUES (46, 1, 9.19, 0, 16.01, 25.2, 0.813, 31, '2025-12-26 13:33:59.444518', '2025-12-27 06:49:23.567762', 16);
INSERT INTO `courses_courseobjectiveachievement` VALUES (47, 2, 5.51, 7.85, 16.01, 29.38, 0.794, 37, '2025-12-26 13:33:59.449700', '2025-12-27 06:49:23.578153', 16);
INSERT INTO `courses_courseobjectiveachievement` VALUES (48, 3, 3.68, 7.85, 13.72, 25.25, 0.7891, 32, '2025-12-26 13:33:59.451734', '2025-12-27 06:49:23.591537', 16);
INSERT INTO `courses_courseobjectiveachievement` VALUES (49, 1, 9.25, 0, 17.01, 26.26, 0.8471, 31, '2025-12-26 13:34:14.302632', '2025-12-27 06:49:19.623225', 17);
INSERT INTO `courses_courseobjectiveachievement` VALUES (50, 2, 5.55, 8.25, 17.01, 30.81, 0.8327, 37, '2025-12-26 13:34:14.305664', '2025-12-27 06:49:19.633484', 17);
INSERT INTO `courses_courseobjectiveachievement` VALUES (51, 3, 3.7, 8.25, 14.58, 26.53, 0.8291, 32, '2025-12-26 13:34:14.308696', '2025-12-27 06:49:19.642654', 17);
INSERT INTO `courses_courseobjectiveachievement` VALUES (52, 1, 8.98, 0, 16.09, 25.08, 0.8089, 31, '2025-12-26 13:34:28.979344', '2025-12-27 06:49:08.502111', 18);
INSERT INTO `courses_courseobjectiveachievement` VALUES (53, 2, 5.39, 8.15, 16.09, 29.63, 0.8009, 37, '2025-12-26 13:34:28.983687', '2025-12-27 06:49:08.513665', 18);
INSERT INTO `courses_courseobjectiveachievement` VALUES (54, 3, 3.59, 8.15, 13.79, 25.54, 0.798, 32, '2025-12-26 13:34:28.988809', '2025-12-27 06:49:08.527536', 18);
INSERT INTO `courses_courseobjectiveachievement` VALUES (55, 1, 9.52, 0, 17.85, 27.36, 0.8827, 31, '2025-12-26 13:34:43.599905', '2025-12-27 06:49:03.900250', 19);
INSERT INTO `courses_courseobjectiveachievement` VALUES (56, 2, 5.71, 8.65, 17.85, 32.21, 0.8705, 37, '2025-12-26 13:34:43.603243', '2025-12-27 06:49:03.910771', 19);
INSERT INTO `courses_courseobjectiveachievement` VALUES (57, 3, 3.81, 8.65, 15.3, 27.76, 0.8674, 32, '2025-12-26 13:34:43.606266', '2025-12-27 06:49:03.921050', 19);
INSERT INTO `courses_courseobjectiveachievement` VALUES (58, 1, 9.12, 0, 16.59, 25.71, 0.8295, 31, '2025-12-26 13:34:58.311637', '2025-12-27 06:48:53.215156', 20);
INSERT INTO `courses_courseobjectiveachievement` VALUES (59, 2, 5.47, 7.75, 16.59, 29.81, 0.8058, 37, '2025-12-26 13:34:58.316264', '2025-12-27 06:48:53.235402', 20);
INSERT INTO `courses_courseobjectiveachievement` VALUES (60, 3, 3.65, 7.75, 14.22, 25.62, 0.8006, 32, '2025-12-26 13:34:58.321727', '2025-12-27 06:48:53.251863', 20);
INSERT INTO `courses_courseobjectiveachievement` VALUES (61, 1, 9.47, 0, 17.53, 27, 0.8711, 31, '2025-12-26 13:35:12.966939', '2025-12-27 06:48:49.217507', 21);
INSERT INTO `courses_courseobjectiveachievement` VALUES (62, 2, 5.68, 8.65, 17.53, 31.87, 0.8613, 37, '2025-12-26 13:35:12.970284', '2025-12-27 06:48:49.226214', 21);
INSERT INTO `courses_courseobjectiveachievement` VALUES (63, 3, 3.79, 8.65, 15.03, 27.47, 0.8584, 32, '2025-12-26 13:35:12.972305', '2025-12-27 06:48:49.237137', 21);
INSERT INTO `courses_courseobjectiveachievement` VALUES (64, 1, 6.9, 0, 17.77, 24.67, 0.7958, 31, '2025-12-26 13:35:27.898048', '2025-12-27 06:48:42.516273', 22);
INSERT INTO `courses_courseobjectiveachievement` VALUES (65, 2, 4.14, 8.65, 17.77, 30.56, 0.826, 37, '2025-12-26 13:35:27.900602', '2025-12-27 06:48:42.521561', 22);
INSERT INTO `courses_courseobjectiveachievement` VALUES (66, 3, 2.76, 8.65, 15.23, 26.64, 0.8326, 32, '2025-12-26 13:35:27.903673', '2025-12-27 06:48:42.525607', 22);
INSERT INTO `courses_courseobjectiveachievement` VALUES (67, 1, 9.13, 0, 17.56, 26.69, 0.861, 31, '2025-12-26 13:35:42.803076', '2025-12-27 06:48:40.342514', 23);
INSERT INTO `courses_courseobjectiveachievement` VALUES (68, 2, 5.48, 8.4, 17.56, 31.44, 0.8497, 37, '2025-12-26 13:35:42.807394', '2025-12-27 06:48:40.348433', 23);
INSERT INTO `courses_courseobjectiveachievement` VALUES (69, 3, 3.65, 8.4, 15.05, 27.1, 0.847, 32, '2025-12-26 13:35:42.810547', '2025-12-27 06:48:40.353824', 23);
INSERT INTO `courses_courseobjectiveachievement` VALUES (70, 1, 8.75, 0, 17.38, 26.13, 0.8428, 31, '2025-12-26 13:35:57.880137', '2025-12-27 06:48:34.678973', 24);
INSERT INTO `courses_courseobjectiveachievement` VALUES (71, 2, 5.25, 8.35, 17.38, 30.98, 0.8372, 37, '2025-12-26 13:35:57.882221', '2025-12-27 06:48:34.686368', 24);
INSERT INTO `courses_courseobjectiveachievement` VALUES (72, 3, 3.5, 8.35, 14.89, 26.74, 0.8358, 32, '2025-12-26 13:35:57.887448', '2025-12-27 06:48:34.691764', 24);
INSERT INTO `courses_courseobjectiveachievement` VALUES (73, 1, 9.07, 0, 18.22, 27.29, 0.8802, 31, '2025-12-26 13:36:13.133104', '2025-12-27 06:48:32.535404', 25);
INSERT INTO `courses_courseobjectiveachievement` VALUES (74, 2, 5.44, 8.75, 18.22, 32.41, 0.8759, 37, '2025-12-26 13:36:13.136225', '2025-12-27 06:48:32.540107', 25);
INSERT INTO `courses_courseobjectiveachievement` VALUES (75, 3, 3.63, 8.75, 15.61, 27.99, 0.8748, 32, '2025-12-26 13:36:13.138348', '2025-12-27 06:48:32.545492', 25);
INSERT INTO `courses_courseobjectiveachievement` VALUES (76, 1, 9.45, 0, 16.51, 25.96, 0.8375, 31, '2025-12-26 13:36:28.135733', '2025-12-27 06:48:26.621166', 26);
INSERT INTO `courses_courseobjectiveachievement` VALUES (77, 2, 5.67, 8.5, 16.51, 30.68, 0.8292, 37, '2025-12-26 13:36:28.140979', '2025-12-27 06:48:26.625166', 26);
INSERT INTO `courses_courseobjectiveachievement` VALUES (78, 3, 3.78, 8.5, 14.15, 26.43, 0.826, 32, '2025-12-26 13:36:28.144028', '2025-12-27 06:48:26.630549', 26);
INSERT INTO `courses_courseobjectiveachievement` VALUES (79, 1, 9.58, 0, 16.46, 26.04, 0.84, 31, '2025-12-26 13:36:43.165613', '2025-12-27 06:48:24.395636', 27);
INSERT INTO `courses_courseobjectiveachievement` VALUES (80, 2, 5.75, 8.4, 16.46, 30.61, 0.8272, 37, '2025-12-26 13:36:43.167786', '2025-12-27 06:48:24.399681', 27);
INSERT INTO `courses_courseobjectiveachievement` VALUES (81, 3, 3.83, 8.4, 14.11, 26.34, 0.8231, 32, '2025-12-26 13:36:43.170907', '2025-12-27 06:48:24.404856', 27);
INSERT INTO `courses_courseobjectiveachievement` VALUES (82, 1, 9.04, 0, 17.04, 26.08, 0.8412, 31, '2025-12-26 13:36:58.064784', '2025-12-27 06:48:18.526786', 28);
INSERT INTO `courses_courseobjectiveachievement` VALUES (83, 2, 5.42, 8.3, 17.04, 30.76, 0.8314, 37, '2025-12-26 13:36:58.069948', '2025-12-27 06:48:18.531005', 28);
INSERT INTO `courses_courseobjectiveachievement` VALUES (84, 3, 3.62, 8.3, 14.6, 26.52, 0.8287, 32, '2025-12-26 13:36:58.073084', '2025-12-27 06:48:18.535070', 28);
INSERT INTO `courses_courseobjectiveachievement` VALUES (85, 1, 9.23, 0, 16.33, 25.56, 0.8246, 31, '2025-12-26 13:37:12.944048', '2025-12-27 06:48:16.329224', 29);
INSERT INTO `courses_courseobjectiveachievement` VALUES (86, 2, 5.54, 8.15, 16.33, 30.02, 0.8113, 37, '2025-12-26 13:37:12.946308', '2025-12-27 06:48:16.335571', 29);
INSERT INTO `courses_courseobjectiveachievement` VALUES (87, 3, 3.69, 8.15, 13.99, 25.84, 0.8075, 32, '2025-12-26 13:37:12.949488', '2025-12-27 06:48:16.339639', 29);
INSERT INTO `courses_courseobjectiveachievement` VALUES (88, 1, 9.27, 0, 19.27, 28.54, 0.9206, 31, '2025-12-26 13:37:27.971326', '2025-12-27 06:48:08.787611', 30);
INSERT INTO `courses_courseobjectiveachievement` VALUES (89, 2, 5.56, 9.25, 19.27, 34.08, 0.9211, 37, '2025-12-26 13:37:27.977592', '2025-12-27 06:48:08.790739', 30);
INSERT INTO `courses_courseobjectiveachievement` VALUES (90, 3, 3.71, 9.25, 16.51, 29.47, 0.921, 32, '2025-12-26 13:37:27.980668', '2025-12-27 06:48:08.794899', 30);
INSERT INTO `courses_courseobjectiveachievement` VALUES (91, 1, 8.9, 0, 14.12, 23.03, 0.7428, 31, '2025-12-28 03:08:02.947113', '2025-12-28 03:36:08.442249', 57);
INSERT INTO `courses_courseobjectiveachievement` VALUES (92, 2, 5.34, 7.25, 14.12, 26.72, 0.722, 37, '2025-12-28 03:08:02.952186', '2025-12-28 03:36:08.447424', 57);
INSERT INTO `courses_courseobjectiveachievement` VALUES (93, 3, 3.56, 7.25, 12.1, 22.92, 0.7162, 32, '2025-12-28 03:08:02.957275', '2025-12-28 03:36:08.452623', 57);
INSERT INTO `courses_courseobjectiveachievement` VALUES (94, 1, 8.48, 0, 15.38, 23.87, 0.7699, 31, '2025-12-28 03:08:09.696813', '2025-12-28 03:36:15.176321', 58);
INSERT INTO `courses_courseobjectiveachievement` VALUES (95, 2, 5.09, 7.7, 15.38, 28.17, 0.7614, 37, '2025-12-28 03:08:09.701443', '2025-12-28 03:36:15.180421', 58);
INSERT INTO `courses_courseobjectiveachievement` VALUES (96, 3, 3.39, 7.7, 13.18, 24.28, 0.7587, 32, '2025-12-28 03:08:09.705863', '2025-12-28 03:36:15.183804', 58);
INSERT INTO `courses_courseobjectiveachievement` VALUES (97, 1, 8.79, 0, 18.79, 27.58, 0.8898, 31, '2025-12-28 03:08:16.365364', '2025-12-28 03:36:21.834157', 59);
INSERT INTO `courses_courseobjectiveachievement` VALUES (98, 2, 5.27, 9.1, 18.79, 33.17, 0.8965, 37, '2025-12-28 03:08:16.370711', '2025-12-28 03:36:21.838274', 59);
INSERT INTO `courses_courseobjectiveachievement` VALUES (99, 3, 3.52, 9.1, 16.11, 28.73, 0.8977, 32, '2025-12-28 03:08:16.374774', '2025-12-28 03:36:21.843329', 59);
INSERT INTO `courses_courseobjectiveachievement` VALUES (103, 1, 8.54, 0, 17.54, 26.08, 0.8413, 31, '2025-12-28 03:08:30.068879', '2025-12-28 03:36:35.176295', 34);
INSERT INTO `courses_courseobjectiveachievement` VALUES (104, 2, 5.13, 8.2, 17.54, 30.86, 0.8341, 37, '2025-12-28 03:08:30.074033', '2025-12-28 03:36:35.180357', 34);
INSERT INTO `courses_courseobjectiveachievement` VALUES (105, 3, 3.42, 8.2, 15.03, 26.65, 0.8328, 32, '2025-12-28 03:08:30.078351', '2025-12-28 03:36:35.185425', 34);
INSERT INTO `courses_courseobjectiveachievement` VALUES (106, 1, 8.41, 0, 19.14, 27.55, 0.8887, 31, '2025-12-28 03:08:36.794591', '2025-12-28 03:36:42.041592', 35);
INSERT INTO `courses_courseobjectiveachievement` VALUES (107, 2, 5.05, 8.7, 19.14, 32.89, 0.8888, 37, '2025-12-28 03:08:36.799692', '2025-12-28 03:36:42.047286', 35);
INSERT INTO `courses_courseobjectiveachievement` VALUES (108, 3, 3.37, 8.7, 16.4, 28.47, 0.8896, 32, '2025-12-28 03:08:36.805108', '2025-12-28 03:36:42.053286', 35);
INSERT INTO `courses_courseobjectiveachievement` VALUES (109, 1, 8.05, 0, 17.56, 25.61, 0.8262, 31, '2025-12-28 03:08:39.454434', '2025-12-28 03:36:48.746507', 36);
INSERT INTO `courses_courseobjectiveachievement` VALUES (110, 2, 4.83, 8.85, 17.56, 31.24, 0.8444, 37, '2025-12-28 03:08:39.458851', '2025-12-28 03:36:48.750603', 36);
INSERT INTO `courses_courseobjectiveachievement` VALUES (111, 3, 3.22, 8.85, 15.05, 27.12, 0.8476, 32, '2025-12-28 03:08:39.465265', '2025-12-28 03:36:48.754819', 36);
INSERT INTO `courses_courseobjectiveachievement` VALUES (112, 1, 7.01, 0, 15.12, 22.13, 0.7139, 31, '2025-12-28 03:08:44.028765', '2025-12-28 03:36:55.969120', 37);
INSERT INTO `courses_courseobjectiveachievement` VALUES (113, 2, 4.21, 7.35, 15.12, 26.68, 0.721, 37, '2025-12-28 03:08:44.034013', '2025-12-28 03:36:55.975455', 37);
INSERT INTO `courses_courseobjectiveachievement` VALUES (114, 3, 2.8, 7.35, 12.96, 23.11, 0.7223, 32, '2025-12-28 03:08:44.038156', '2025-12-28 03:36:55.979589', 37);
INSERT INTO `courses_courseobjectiveachievement` VALUES (115, 1, 8.08, 0, 15.93, 24.01, 0.7746, 31, '2025-12-28 03:08:47.158322', '2025-12-28 03:37:02.749287', 38);
INSERT INTO `courses_courseobjectiveachievement` VALUES (116, 2, 4.85, 7.7, 15.93, 28.48, 0.7698, 37, '2025-12-28 03:08:47.163483', '2025-12-28 03:37:02.753132', 38);
INSERT INTO `courses_courseobjectiveachievement` VALUES (117, 3, 3.23, 7.7, 13.66, 24.59, 0.7684, 32, '2025-12-28 03:08:47.169909', '2025-12-28 03:37:02.757258', 38);
INSERT INTO `courses_courseobjectiveachievement` VALUES (118, 1, 8.45, 0, 17.09, 25.54, 0.8238, 31, '2025-12-28 03:08:51.496283', '2025-12-28 03:37:09.413148', 39);
INSERT INTO `courses_courseobjectiveachievement` VALUES (119, 2, 5.07, 8.1, 17.09, 30.26, 0.8178, 37, '2025-12-28 03:08:51.501383', '2025-12-28 03:37:09.417410', 39);
INSERT INTO `courses_courseobjectiveachievement` VALUES (120, 3, 3.38, 8.1, 14.65, 26.13, 0.8165, 32, '2025-12-28 03:08:51.506716', '2025-12-28 03:37:09.420456', 39);
INSERT INTO `courses_courseobjectiveachievement` VALUES (121, 1, 8.19, 0, 17.38, 25.57, 0.8248, 31, '2025-12-28 03:08:54.663485', '2025-12-28 03:37:15.726267', 40);
INSERT INTO `courses_courseobjectiveachievement` VALUES (122, 2, 4.91, 8.35, 17.38, 30.64, 0.8281, 37, '2025-12-28 03:08:54.668664', '2025-12-28 03:37:15.731491', 40);
INSERT INTO `courses_courseobjectiveachievement` VALUES (123, 3, 3.28, 8.35, 14.89, 26.52, 0.8288, 32, '2025-12-28 03:08:54.673897', '2025-12-28 03:37:15.735713', 40);
INSERT INTO `courses_courseobjectiveachievement` VALUES (124, 1, 8.82, 0, 18.87, 27.69, 0.8933, 31, '2025-12-28 03:08:59.086241', '2025-12-28 03:37:22.676175', 41);
INSERT INTO `courses_courseobjectiveachievement` VALUES (125, 2, 5.29, 9.1, 18.87, 33.27, 0.8991, 37, '2025-12-28 03:08:59.090275', '2025-12-28 03:37:22.684336', 41);
INSERT INTO `courses_courseobjectiveachievement` VALUES (126, 3, 3.53, 9.1, 16.18, 28.81, 0.9002, 32, '2025-12-28 03:08:59.096746', '2025-12-28 03:37:22.693659', 41);
INSERT INTO `courses_courseobjectiveachievement` VALUES (127, 1, 9.43, 0, 18.43, 27.86, 0.8986, 31, '2025-12-28 03:09:02.287191', '2025-12-28 03:37:34.813406', 42);
INSERT INTO `courses_courseobjectiveachievement` VALUES (128, 2, 5.66, 9.15, 18.43, 33.24, 0.8983, 37, '2025-12-28 03:09:02.292583', '2025-12-28 03:37:34.821804', 42);
INSERT INTO `courses_courseobjectiveachievement` VALUES (129, 3, 3.77, 9.15, 15.79, 28.72, 0.8974, 32, '2025-12-28 03:09:02.298911', '2025-12-28 03:37:34.829114', 42);
INSERT INTO `courses_courseobjectiveachievement` VALUES (130, 1, 8.57, 0, 15.04, 23.62, 0.7618, 31, '2025-12-28 03:09:06.982035', '2025-12-28 03:37:46.891480', 43);
INSERT INTO `courses_courseobjectiveachievement` VALUES (131, 2, 5.14, 7.5, 15.04, 27.69, 0.7483, 37, '2025-12-28 03:09:06.991688', '2025-12-28 03:37:46.899013', 43);
INSERT INTO `courses_courseobjectiveachievement` VALUES (132, 3, 3.43, 7.5, 12.89, 23.82, 0.7445, 32, '2025-12-28 03:09:07.000382', '2025-12-28 03:37:46.906741', 43);
INSERT INTO `courses_courseobjectiveachievement` VALUES (133, 1, 8.64, 0, 15.09, 23.74, 0.7658, 31, '2025-12-28 03:09:13.125195', '2025-12-28 03:38:00.116663', 44);
INSERT INTO `courses_courseobjectiveachievement` VALUES (134, 2, 5.19, 7.3, 15.09, 27.58, 0.7454, 37, '2025-12-28 03:09:13.135568', '2025-12-28 03:38:00.125661', 44);
INSERT INTO `courses_courseobjectiveachievement` VALUES (135, 3, 3.46, 7.3, 12.94, 23.7, 0.7405, 32, '2025-12-28 03:09:13.151283', '2025-12-28 03:38:00.133966', 44);
INSERT INTO `courses_courseobjectiveachievement` VALUES (136, 1, 9.25, 0, 17.19, 26.45, 0.8532, 31, '2025-12-28 03:09:21.563996', '2025-12-28 03:38:12.281333', 45);
INSERT INTO `courses_courseobjectiveachievement` VALUES (137, 2, 5.55, 8.45, 17.19, 31.2, 0.8432, 37, '2025-12-28 03:09:21.576243', '2025-12-28 03:38:12.290925', 45);
INSERT INTO `courses_courseobjectiveachievement` VALUES (138, 3, 3.7, 8.45, 14.74, 26.89, 0.8403, 32, '2025-12-28 03:09:21.586757', '2025-12-28 03:38:12.299827', 45);
INSERT INTO `courses_courseobjectiveachievement` VALUES (139, 1, 9.3, 0, 17.38, 26.68, 0.8606, 31, '2025-12-28 03:09:28.342712', '2025-12-28 03:38:24.377318', 46);
INSERT INTO `courses_courseobjectiveachievement` VALUES (140, 2, 5.58, 8.5, 17.38, 31.46, 0.8502, 37, '2025-12-28 03:09:28.350042', '2025-12-28 03:38:24.384428', 46);
INSERT INTO `courses_courseobjectiveachievement` VALUES (141, 3, 3.72, 8.5, 14.89, 27.12, 0.8473, 32, '2025-12-28 03:09:28.361397', '2025-12-28 03:38:24.391830', 46);
INSERT INTO `courses_courseobjectiveachievement` VALUES (142, 1, 8.86, 0, 15.54, 24.4, 0.7871, 31, '2025-12-28 03:09:36.837129', '2025-12-28 03:38:36.363287', 47);
INSERT INTO `courses_courseobjectiveachievement` VALUES (143, 2, 5.32, 7.85, 15.54, 28.71, 0.7758, 37, '2025-12-28 03:09:36.844622', '2025-12-28 03:38:36.371617', 47);
INSERT INTO `courses_courseobjectiveachievement` VALUES (144, 3, 3.54, 7.85, 13.32, 24.71, 0.7723, 32, '2025-12-28 03:09:36.853065', '2025-12-28 03:38:36.379824', 47);
INSERT INTO `courses_courseobjectiveachievement` VALUES (145, 1, 9.19, 0, 16.51, 25.7, 0.8289, 31, '2025-12-28 03:09:43.013562', '2025-12-28 03:38:48.347394', 48);
INSERT INTO `courses_courseobjectiveachievement` VALUES (146, 2, 5.51, 8.2, 16.51, 30.22, 0.8168, 37, '2025-12-28 03:09:43.021856', '2025-12-28 03:38:48.354674', 48);
INSERT INTO `courses_courseobjectiveachievement` VALUES (147, 3, 3.67, 8.2, 14.15, 26.03, 0.8133, 32, '2025-12-28 03:09:43.031572', '2025-12-28 03:38:48.363155', 48);
INSERT INTO `courses_courseobjectiveachievement` VALUES (148, 1, 9.21, 0, 17.4, 26.61, 0.8585, 31, '2025-12-28 03:09:51.684161', '2025-12-28 03:39:00.436867', 49);
INSERT INTO `courses_courseobjectiveachievement` VALUES (149, 2, 5.53, 8.55, 17.4, 31.48, 0.8508, 37, '2025-12-28 03:09:51.693822', '2025-12-28 03:39:00.445823', 49);
INSERT INTO `courses_courseobjectiveachievement` VALUES (150, 3, 3.68, 8.55, 14.92, 27.15, 0.8485, 32, '2025-12-28 03:09:51.706606', '2025-12-28 03:39:00.454853', 49);
INSERT INTO `courses_courseobjectiveachievement` VALUES (151, 1, 9.53, 0, 17.59, 27.12, 0.8748, 31, '2025-12-28 03:09:58.041827', '2025-12-28 03:39:12.469672', 50);
INSERT INTO `courses_courseobjectiveachievement` VALUES (152, 2, 5.72, 8.75, 17.59, 32.06, 0.8664, 37, '2025-12-28 03:09:58.053333', '2025-12-28 03:39:12.477326', 50);
INSERT INTO `courses_courseobjectiveachievement` VALUES (153, 3, 3.81, 8.75, 15.07, 27.64, 0.8637, 32, '2025-12-28 03:09:58.064354', '2025-12-28 03:39:12.484726', 50);
INSERT INTO `courses_courseobjectiveachievement` VALUES (154, 1, 7.86, 0, 16.09, 23.96, 0.7728, 31, '2025-12-28 03:10:06.863270', '2025-12-28 03:39:24.560124', 51);
INSERT INTO `courses_courseobjectiveachievement` VALUES (155, 2, 4.72, 7.7, 16.09, 28.51, 0.7705, 37, '2025-12-28 03:10:06.876598', '2025-12-28 03:39:24.566528', 51);
INSERT INTO `courses_courseobjectiveachievement` VALUES (156, 3, 3.15, 7.7, 13.79, 24.64, 0.77, 32, '2025-12-28 03:10:06.884875', '2025-12-28 03:39:24.575590', 51);
INSERT INTO `courses_courseobjectiveachievement` VALUES (157, 1, 9.37, 0, 18.93, 28.29, 0.9126, 31, '2025-12-28 03:10:13.229325', '2025-12-28 03:39:36.654611', 52);
INSERT INTO `courses_courseobjectiveachievement` VALUES (158, 2, 5.62, 9.35, 18.93, 33.9, 0.9161, 37, '2025-12-28 03:10:13.238910', '2025-12-28 03:39:36.661783', 52);
INSERT INTO `courses_courseobjectiveachievement` VALUES (159, 3, 3.75, 9.35, 16.22, 29.32, 0.9162, 32, '2025-12-28 03:10:13.250197', '2025-12-28 03:39:36.670687', 52);
INSERT INTO `courses_courseobjectiveachievement` VALUES (160, 1, 9.21, 0, 18.56, 27.77, 0.8958, 31, '2025-12-28 03:10:21.991246', '2025-12-28 03:39:48.625456', 53);
INSERT INTO `courses_courseobjectiveachievement` VALUES (161, 2, 5.53, 9.4, 18.56, 33.48, 0.905, 37, '2025-12-28 03:10:22.001298', '2025-12-28 03:39:48.633623', 53);
INSERT INTO `courses_courseobjectiveachievement` VALUES (162, 3, 3.68, 9.4, 15.91, 28.99, 0.906, 32, '2025-12-28 03:10:22.012161', '2025-12-28 03:39:48.640905', 53);
INSERT INTO `courses_courseobjectiveachievement` VALUES (163, 1, 9.26, 0, 19.74, 29, 0.9355, 31, '2025-12-28 03:10:28.222913', '2025-12-28 03:40:00.506305', 54);
INSERT INTO `courses_courseobjectiveachievement` VALUES (164, 2, 5.56, 9.4, 19.74, 34.7, 0.9377, 37, '2025-12-28 03:10:28.234101', '2025-12-28 03:40:00.513753', 54);
INSERT INTO `courses_courseobjectiveachievement` VALUES (165, 3, 3.7, 9.4, 16.92, 30.02, 0.9383, 32, '2025-12-28 03:10:28.247587', '2025-12-28 03:40:00.523444', 54);
INSERT INTO `courses_courseobjectiveachievement` VALUES (166, 1, 8.5, 0, 17.77, 26.27, 0.8473, 31, '2025-12-28 03:10:36.725563', '2025-12-28 03:40:12.671567', 55);
INSERT INTO `courses_courseobjectiveachievement` VALUES (167, 2, 5.1, 8.5, 17.77, 31.37, 0.8478, 37, '2025-12-28 03:10:36.734741', '2025-12-28 03:40:12.680950', 55);
INSERT INTO `courses_courseobjectiveachievement` VALUES (168, 3, 3.4, 8.5, 15.23, 27.13, 0.8478, 32, '2025-12-28 03:10:36.743098', '2025-12-28 03:40:12.689249', 55);
INSERT INTO `courses_courseobjectiveachievement` VALUES (169, 1, 8.3, 0, 15.8, 24.1, 0.7775, 31, '2025-12-28 03:10:43.043451', '2025-12-28 03:40:24.775574', 56);
INSERT INTO `courses_courseobjectiveachievement` VALUES (170, 2, 4.98, 7.9, 15.8, 28.68, 0.7752, 37, '2025-12-28 03:10:43.053941', '2025-12-28 03:40:24.783309', 56);
INSERT INTO `courses_courseobjectiveachievement` VALUES (171, 3, 3.32, 7.9, 13.54, 24.77, 0.7739, 32, '2025-12-28 03:10:43.063816', '2025-12-28 03:40:24.790164', 56);
INSERT INTO `courses_courseobjectiveachievement` VALUES (172, 1, 8.2, 0, 17.3, 25.49, 0.8224, 31, '2025-12-28 03:10:51.453953', '2025-12-28 03:40:37.095441', 31);
INSERT INTO `courses_courseobjectiveachievement` VALUES (173, 2, 4.92, 8.5, 17.3, 30.72, 0.8302, 37, '2025-12-28 03:10:51.463749', '2025-12-28 03:40:37.102774', 31);
INSERT INTO `courses_courseobjectiveachievement` VALUES (174, 3, 3.28, 8.5, 14.83, 26.61, 0.8314, 32, '2025-12-28 03:10:51.475786', '2025-12-28 03:40:37.111048', 31);
INSERT INTO `courses_courseobjectiveachievement` VALUES (175, 1, 9.24, 0, 17.3, 26.54, 0.8561, 31, '2025-12-28 03:10:57.868495', '2025-12-28 03:40:49.444550', 32);
INSERT INTO `courses_courseobjectiveachievement` VALUES (176, 2, 5.54, 8.5, 17.3, 31.34, 0.8471, 37, '2025-12-28 03:10:57.881582', '2025-12-28 03:40:49.451844', 32);
INSERT INTO `courses_courseobjectiveachievement` VALUES (177, 3, 3.7, 8.5, 14.83, 27.02, 0.8445, 32, '2025-12-28 03:10:57.891356', '2025-12-28 03:40:49.459966', 32);
INSERT INTO `courses_courseobjectiveachievement` VALUES (178, 1, 9.19, 0, 18.98, 28.16, 0.9085, 31, '2025-12-28 03:11:06.466488', '2025-12-28 03:41:02.652004', 33);
INSERT INTO `courses_courseobjectiveachievement` VALUES (179, 2, 5.51, 9, 18.98, 33.49, 0.9051, 37, '2025-12-28 03:11:06.474864', '2025-12-28 03:41:02.661667', 33);
INSERT INTO `courses_courseobjectiveachievement` VALUES (180, 3, 3.67, 9, 16.27, 28.94, 0.9044, 32, '2025-12-28 03:11:06.487094', '2025-12-28 03:41:02.672087', 33);
INSERT INTO `courses_courseobjectiveachievement` VALUES (184, 1, 8.8, 0, 19.37, 28.17, 0.9088, 31, '2025-12-28 03:50:49.908960', '2025-12-28 03:50:54.499165', 83);
INSERT INTO `courses_courseobjectiveachievement` VALUES (185, 2, 5.28, 9.45, 19.37, 34.1, 0.9217, 37, '2025-12-28 03:50:49.913326', '2025-12-28 03:50:54.501254', 83);
INSERT INTO `courses_courseobjectiveachievement` VALUES (186, 3, 3.52, 9.45, 16.61, 29.58, 0.9242, 32, '2025-12-28 03:50:49.915383', '2025-12-28 03:50:54.504555', 83);
INSERT INTO `courses_courseobjectiveachievement` VALUES (187, 1, 9.02, 0, 18.35, 27.37, 0.8829, 31, '2025-12-28 03:50:54.514036', '2025-12-28 03:50:58.921723', 84);
INSERT INTO `courses_courseobjectiveachievement` VALUES (188, 2, 5.41, 9, 18.35, 32.76, 0.8854, 37, '2025-12-28 03:50:54.516069', '2025-12-28 03:50:58.924207', 84);
INSERT INTO `courses_courseobjectiveachievement` VALUES (189, 3, 3.61, 9, 15.73, 28.34, 0.8855, 32, '2025-12-28 03:50:54.519498', '2025-12-28 03:50:58.928276', 84);
INSERT INTO `courses_courseobjectiveachievement` VALUES (190, 1, 8.61, 0, 17.01, 25.62, 0.8265, 31, '2025-12-28 03:50:58.939957', '2025-12-28 03:51:03.277462', 85);
INSERT INTO `courses_courseobjectiveachievement` VALUES (191, 2, 5.17, 8.25, 17.01, 30.43, 0.8223, 37, '2025-12-28 03:50:58.942020', '2025-12-28 03:51:03.280582', 85);
INSERT INTO `courses_courseobjectiveachievement` VALUES (192, 3, 3.44, 8.25, 14.58, 26.27, 0.8211, 32, '2025-12-28 03:50:58.946264', '2025-12-28 03:51:03.283686', 85);
INSERT INTO `courses_courseobjectiveachievement` VALUES (193, 1, 8.09, 0, 15.38, 23.47, 0.7572, 31, '2025-12-28 03:51:03.293172', '2025-12-28 03:51:07.670815', 86);
INSERT INTO `courses_courseobjectiveachievement` VALUES (194, 2, 4.85, 7.55, 15.38, 27.79, 0.751, 37, '2025-12-28 03:51:03.296300', '2025-12-28 03:51:07.672816', 86);
INSERT INTO `courses_courseobjectiveachievement` VALUES (195, 3, 3.24, 7.55, 13.18, 23.97, 0.7491, 32, '2025-12-28 03:51:03.298396', '2025-12-28 03:51:07.676414', 86);
INSERT INTO `courses_courseobjectiveachievement` VALUES (196, 1, 9.6, 0, 17.8, 27.4, 0.8838, 31, '2025-12-28 03:51:07.686053', '2025-12-28 03:51:12.028954', 87);
INSERT INTO `courses_courseobjectiveachievement` VALUES (197, 2, 5.76, 8.7, 17.8, 32.26, 0.8718, 37, '2025-12-28 03:51:07.688140', '2025-12-28 03:51:12.032055', 87);
INSERT INTO `courses_courseobjectiveachievement` VALUES (198, 3, 3.84, 8.7, 15.26, 27.8, 0.8686, 32, '2025-12-28 03:51:07.690242', '2025-12-28 03:51:12.035120', 87);
INSERT INTO `courses_courseobjectiveachievement` VALUES (199, 1, 8.43, 0, 15.88, 24.31, 0.7842, 31, '2025-12-28 03:51:12.045609', '2025-12-28 03:51:16.500608', 88);
INSERT INTO `courses_courseobjectiveachievement` VALUES (200, 2, 5.06, 7.75, 15.88, 28.69, 0.7754, 37, '2025-12-28 03:51:12.047691', '2025-12-28 03:51:16.502705', 88);
INSERT INTO `courses_courseobjectiveachievement` VALUES (201, 3, 3.37, 7.75, 13.61, 24.73, 0.773, 32, '2025-12-28 03:51:12.049740', '2025-12-28 03:51:16.505947', 88);
INSERT INTO `courses_courseobjectiveachievement` VALUES (202, 1, 8.71, 0, 15.64, 24.35, 0.7856, 31, '2025-12-28 03:51:16.516369', '2025-12-28 03:51:20.901578', 89);
INSERT INTO `courses_courseobjectiveachievement` VALUES (203, 2, 5.23, 7.6, 15.64, 28.47, 0.7695, 37, '2025-12-28 03:51:16.519467', '2025-12-28 03:51:20.904305', 89);
INSERT INTO `courses_courseobjectiveachievement` VALUES (204, 3, 3.48, 7.6, 13.41, 24.49, 0.7654, 32, '2025-12-28 03:51:16.522673', '2025-12-28 03:51:20.907453', 89);
INSERT INTO `courses_courseobjectiveachievement` VALUES (205, 1, 8.91, 0, 16.9, 25.81, 0.8327, 31, '2025-12-28 03:51:20.919047', '2025-12-28 03:51:25.314776', 90);
INSERT INTO `courses_courseobjectiveachievement` VALUES (206, 2, 5.35, 8.05, 16.9, 30.3, 0.8189, 37, '2025-12-28 03:51:20.922586', '2025-12-28 03:51:25.317877', 90);
INSERT INTO `courses_courseobjectiveachievement` VALUES (207, 3, 3.56, 8.05, 14.49, 26.1, 0.8157, 32, '2025-12-28 03:51:20.924638', '2025-12-28 03:51:25.321231', 90);
INSERT INTO `courses_courseobjectiveachievement` VALUES (208, 1, 9.06, 0, 17.85, 26.91, 0.8681, 31, '2025-12-28 03:51:25.330506', '2025-12-28 03:51:29.650039', 91);
INSERT INTO `courses_courseobjectiveachievement` VALUES (209, 2, 5.44, 8.8, 17.85, 32.09, 0.8672, 37, '2025-12-28 03:51:25.332718', '2025-12-28 03:51:29.652470', 91);
INSERT INTO `courses_courseobjectiveachievement` VALUES (210, 3, 3.62, 8.8, 15.3, 27.72, 0.8664, 32, '2025-12-28 03:51:25.333780', '2025-12-28 03:51:29.654927', 91);
INSERT INTO `courses_courseobjectiveachievement` VALUES (211, 1, 8.87, 0, 15.91, 24.78, 0.7993, 31, '2025-12-28 03:51:29.664038', '2025-12-28 03:51:34.005765', 62);
INSERT INTO `courses_courseobjectiveachievement` VALUES (212, 2, 5.32, 7.8, 15.91, 29.03, 0.7846, 37, '2025-12-28 03:51:29.667115', '2025-12-28 03:51:34.008948', 62);
INSERT INTO `courses_courseobjectiveachievement` VALUES (213, 3, 3.55, 7.8, 13.63, 24.98, 0.7807, 32, '2025-12-28 03:51:29.669216', '2025-12-28 03:51:34.013379', 62);
INSERT INTO `courses_courseobjectiveachievement` VALUES (214, 1, 9.14, 0, 15.64, 24.79, 0.7997, 31, '2025-12-28 03:51:34.024662', '2025-12-28 03:51:38.379763', 63);
INSERT INTO `courses_courseobjectiveachievement` VALUES (215, 2, 5.49, 7.75, 15.64, 28.88, 0.7806, 37, '2025-12-28 03:51:34.027753', '2025-12-28 03:51:38.382874', 63);
INSERT INTO `courses_courseobjectiveachievement` VALUES (216, 3, 3.66, 7.75, 13.41, 24.82, 0.7756, 32, '2025-12-28 03:51:34.030818', '2025-12-28 03:51:38.385990', 63);
INSERT INTO `courses_courseobjectiveachievement` VALUES (217, 1, 8.97, 0, 18.01, 26.98, 0.8702, 31, '2025-12-28 03:51:38.396719', '2025-12-28 03:51:43.208715', 64);
INSERT INTO `courses_courseobjectiveachievement` VALUES (218, 2, 5.38, 9.1, 18.01, 32.49, 0.8781, 37, '2025-12-28 03:51:38.398797', '2025-12-28 03:51:43.212837', 64);
INSERT INTO `courses_courseobjectiveachievement` VALUES (219, 3, 3.59, 9.1, 15.43, 28.12, 0.8788, 32, '2025-12-28 03:51:38.401983', '2025-12-28 03:51:43.216303', 64);
INSERT INTO `courses_courseobjectiveachievement` VALUES (220, 1, 9.35, 0, 17.61, 26.96, 0.8698, 31, '2025-12-28 03:51:43.226088', '2025-12-28 03:51:47.630998', 65);
INSERT INTO `courses_courseobjectiveachievement` VALUES (221, 2, 5.61, 8.8, 17.61, 32.02, 0.8655, 37, '2025-12-28 03:51:43.229373', '2025-12-28 03:51:47.633109', 65);
INSERT INTO `courses_courseobjectiveachievement` VALUES (222, 3, 3.74, 8.8, 15.1, 27.64, 0.8637, 32, '2025-12-28 03:51:43.232627', '2025-12-28 03:51:47.635220', 65);
INSERT INTO `courses_courseobjectiveachievement` VALUES (223, 1, 9.33, 0, 17.51, 26.84, 0.8658, 31, '2025-12-28 03:51:47.645892', '2025-12-28 03:51:52.083045', 66);
INSERT INTO `courses_courseobjectiveachievement` VALUES (224, 2, 5.6, 8.9, 17.51, 32.01, 0.865, 37, '2025-12-28 03:51:47.649065', '2025-12-28 03:51:52.086205', 66);
INSERT INTO `courses_courseobjectiveachievement` VALUES (225, 3, 3.73, 8.9, 15.01, 27.64, 0.8637, 32, '2025-12-28 03:51:47.651148', '2025-12-28 03:51:52.089473', 66);
INSERT INTO `courses_courseobjectiveachievement` VALUES (226, 1, 8.92, 0, 16.77, 25.69, 0.8288, 31, '2025-12-28 03:51:52.097718', '2025-12-28 03:51:56.429349', 67);
INSERT INTO `courses_courseobjectiveachievement` VALUES (227, 2, 5.35, 8.25, 16.77, 30.38, 0.821, 37, '2025-12-28 03:51:52.100113', '2025-12-28 03:51:56.432463', 67);
INSERT INTO `courses_courseobjectiveachievement` VALUES (228, 3, 3.57, 8.25, 14.38, 26.2, 0.8186, 32, '2025-12-28 03:51:52.102180', '2025-12-28 03:51:56.436091', 67);
INSERT INTO `courses_courseobjectiveachievement` VALUES (229, 1, 9.38, 0, 19.5, 28.88, 0.9317, 31, '2025-12-28 03:51:56.446686', '2025-12-28 03:52:00.829568', 68);
INSERT INTO `courses_courseobjectiveachievement` VALUES (230, 2, 5.63, 9.1, 19.5, 34.23, 0.9252, 37, '2025-12-28 03:51:56.450919', '2025-12-28 03:52:00.834568', 68);
INSERT INTO `courses_courseobjectiveachievement` VALUES (231, 3, 3.75, 9.1, 16.72, 29.57, 0.924, 32, '2025-12-28 03:51:56.454989', '2025-12-28 03:52:00.836714', 68);
INSERT INTO `courses_courseobjectiveachievement` VALUES (232, 1, 8.45, 0, 14.52, 22.97, 0.7408, 31, '2025-12-28 03:52:00.845913', '2025-12-28 03:52:05.175542', 69);
INSERT INTO `courses_courseobjectiveachievement` VALUES (233, 2, 5.07, 7.4, 14.52, 26.99, 0.7294, 37, '2025-12-28 03:52:00.848111', '2025-12-28 03:52:05.178734', 69);
INSERT INTO `courses_courseobjectiveachievement` VALUES (234, 3, 3.38, 7.4, 12.44, 23.22, 0.7257, 32, '2025-12-28 03:52:00.850294', '2025-12-28 03:52:05.181836', 69);
INSERT INTO `courses_courseobjectiveachievement` VALUES (235, 1, 8.56, 0, 17.46, 26.02, 0.8394, 31, '2025-12-28 03:52:05.190281', '2025-12-28 03:52:09.601108', 70);
INSERT INTO `courses_courseobjectiveachievement` VALUES (236, 2, 5.14, 8.5, 17.46, 31.1, 0.8404, 37, '2025-12-28 03:52:05.192770', '2025-12-28 03:52:09.605289', 70);
INSERT INTO `courses_courseobjectiveachievement` VALUES (237, 3, 3.43, 8.5, 14.96, 26.89, 0.8403, 32, '2025-12-28 03:52:05.195915', '2025-12-28 03:52:09.610511', 70);
INSERT INTO `courses_courseobjectiveachievement` VALUES (238, 1, 8.67, 0, 8.27, 16.94, 0.5464, 31, '2025-12-28 03:52:09.619948', '2025-12-28 03:52:14.050153', 71);
INSERT INTO `courses_courseobjectiveachievement` VALUES (239, 2, 5.2, 6.75, 8.27, 20.22, 0.5465, 37, '2025-12-28 03:52:09.622063', '2025-12-28 03:52:14.053255', 71);
INSERT INTO `courses_courseobjectiveachievement` VALUES (240, 3, 3.47, 6.75, 7.09, 17.31, 0.5408, 32, '2025-12-28 03:52:09.626576', '2025-12-28 03:52:14.055320', 71);
INSERT INTO `courses_courseobjectiveachievement` VALUES (241, 1, 9.48, 0, 17.48, 26.96, 0.8698, 31, '2025-12-28 03:52:14.066046', '2025-12-28 03:52:18.416977', 72);
INSERT INTO `courses_courseobjectiveachievement` VALUES (242, 2, 5.69, 8.55, 17.48, 31.72, 0.8573, 37, '2025-12-28 03:52:14.068143', '2025-12-28 03:52:18.419004', 72);
INSERT INTO `courses_courseobjectiveachievement` VALUES (243, 3, 3.79, 8.55, 14.98, 27.33, 0.854, 32, '2025-12-28 03:52:14.070213', '2025-12-28 03:52:18.422696', 72);
INSERT INTO `courses_courseobjectiveachievement` VALUES (244, 1, 9.09, 0, 13.2, 22.29, 0.7192, 31, '2025-12-28 03:52:18.431803', '2025-12-28 03:52:22.812563', 73);
INSERT INTO `courses_courseobjectiveachievement` VALUES (245, 2, 5.45, 7, 13.2, 25.66, 0.6935, 37, '2025-12-28 03:52:18.434934', '2025-12-28 03:52:22.815658', 73);
INSERT INTO `courses_courseobjectiveachievement` VALUES (246, 3, 3.64, 7, 11.32, 21.95, 0.686, 32, '2025-12-28 03:52:18.436998', '2025-12-28 03:52:22.818751', 73);
INSERT INTO `courses_courseobjectiveachievement` VALUES (247, 1, 8.82, 0, 15.38, 24.2, 0.7807, 31, '2025-12-28 03:52:22.901756', '2025-12-28 03:52:27.236848', 74);
INSERT INTO `courses_courseobjectiveachievement` VALUES (248, 2, 5.29, 7.55, 15.38, 28.22, 0.7628, 37, '2025-12-28 03:52:22.903838', '2025-12-28 03:52:27.239964', 74);
INSERT INTO `courses_courseobjectiveachievement` VALUES (249, 3, 3.53, 7.55, 13.18, 24.26, 0.7582, 32, '2025-12-28 03:52:22.905892', '2025-12-28 03:52:27.244332', 74);
INSERT INTO `courses_courseobjectiveachievement` VALUES (250, 1, 8.8, 0, 16.64, 25.45, 0.8209, 31, '2025-12-28 03:52:27.253777', '2025-12-28 03:52:31.598856', 75);
INSERT INTO `courses_courseobjectiveachievement` VALUES (251, 2, 5.28, 7.85, 16.64, 29.78, 0.8047, 37, '2025-12-28 03:52:27.255860', '2025-12-28 03:52:31.600928', 75);
INSERT INTO `courses_courseobjectiveachievement` VALUES (252, 3, 3.52, 7.85, 14.26, 25.64, 0.8012, 32, '2025-12-28 03:52:27.257940', '2025-12-28 03:52:31.604269', 75);
INSERT INTO `courses_courseobjectiveachievement` VALUES (253, 1, 9.45, 0, 18.66, 28.11, 0.9069, 31, '2025-12-28 03:52:31.614707', '2025-12-28 03:52:36.041175', 76);
INSERT INTO `courses_courseobjectiveachievement` VALUES (254, 2, 5.67, 9.3, 18.66, 33.63, 0.909, 37, '2025-12-28 03:52:31.615736', '2025-12-28 03:52:36.045297', 76);
INSERT INTO `courses_courseobjectiveachievement` VALUES (255, 3, 3.78, 9.3, 16, 29.08, 0.9087, 32, '2025-12-28 03:52:31.618803', '2025-12-28 03:52:36.047360', 76);
INSERT INTO `courses_courseobjectiveachievement` VALUES (256, 1, 8.95, 0, 15.43, 24.38, 0.7865, 31, '2025-12-28 03:52:36.057092', '2025-12-28 03:52:40.448762', 77);
INSERT INTO `courses_courseobjectiveachievement` VALUES (257, 2, 5.37, 7.65, 15.43, 28.45, 0.769, 37, '2025-12-28 03:52:36.060842', '2025-12-28 03:52:40.451838', 77);
INSERT INTO `courses_courseobjectiveachievement` VALUES (258, 3, 3.58, 7.65, 13.23, 24.46, 0.7643, 32, '2025-12-28 03:52:36.064161', '2025-12-28 03:52:40.454272', 77);
INSERT INTO `courses_courseobjectiveachievement` VALUES (259, 1, 8.52, 0, 11.94, 20.46, 0.6601, 31, '2025-12-28 03:52:40.467645', '2025-12-28 03:52:46.505901', 78);
INSERT INTO `courses_courseobjectiveachievement` VALUES (260, 2, 5.11, 3.25, 11.94, 20.31, 0.5488, 37, '2025-12-28 03:52:40.470691', '2025-12-28 03:52:46.509932', 78);
INSERT INTO `courses_courseobjectiveachievement` VALUES (261, 3, 3.41, 3.25, 10.24, 16.9, 0.528, 32, '2025-12-28 03:52:40.473774', '2025-12-28 03:52:46.511979', 78);
INSERT INTO `courses_courseobjectiveachievement` VALUES (262, 1, 8.66, 0, 14.23, 22.89, 0.7383, 31, '2025-12-28 03:52:46.520068', '2025-12-28 03:52:50.889511', 79);
INSERT INTO `courses_courseobjectiveachievement` VALUES (263, 2, 5.2, 7.15, 14.23, 26.57, 0.7182, 37, '2025-12-28 03:52:46.524402', '2025-12-28 03:52:50.892653', 79);
INSERT INTO `courses_courseobjectiveachievement` VALUES (264, 3, 3.46, 7.15, 12.19, 22.81, 0.7128, 32, '2025-12-28 03:52:46.526563', '2025-12-28 03:52:50.895820', 79);
INSERT INTO `courses_courseobjectiveachievement` VALUES (265, 1, 8.63, 0, 16.96, 25.59, 0.8254, 31, '2025-12-28 03:52:50.905151', '2025-12-28 03:52:55.272522', 80);
INSERT INTO `courses_courseobjectiveachievement` VALUES (266, 2, 5.18, 8, 16.96, 30.14, 0.8145, 37, '2025-12-28 03:52:50.910201', '2025-12-28 03:52:55.276641', 80);
INSERT INTO `courses_courseobjectiveachievement` VALUES (267, 3, 3.45, 8, 14.53, 25.99, 0.8121, 32, '2025-12-28 03:52:50.912337', '2025-12-28 03:52:55.278693', 80);
INSERT INTO `courses_courseobjectiveachievement` VALUES (268, 1, 8.92, 0, 17.04, 25.96, 0.8373, 31, '2025-12-28 03:52:55.288101', '2025-12-28 03:53:00.978612', 81);
INSERT INTO `courses_courseobjectiveachievement` VALUES (269, 2, 5.35, 8.45, 17.04, 30.84, 0.8335, 37, '2025-12-28 03:52:55.289135', '2025-12-28 03:53:00.981829', 81);
INSERT INTO `courses_courseobjectiveachievement` VALUES (270, 3, 3.57, 8.45, 14.6, 26.62, 0.8319, 32, '2025-12-28 03:52:55.293217', '2025-12-28 03:53:00.985047', 81);
INSERT INTO `courses_courseobjectiveachievement` VALUES (271, 1, 8.95, 0, 15.72, 24.67, 0.7959, 31, '2025-12-28 03:53:00.994633', '2025-12-28 03:53:05.348125', 82);
INSERT INTO `courses_courseobjectiveachievement` VALUES (272, 2, 5.37, 7.75, 15.72, 28.84, 0.7796, 37, '2025-12-28 03:53:00.997895', '2025-12-28 03:53:05.350243', 82);
INSERT INTO `courses_courseobjectiveachievement` VALUES (273, 3, 3.58, 7.75, 13.48, 24.81, 0.7752, 32, '2025-12-28 03:53:01.001311', '2025-12-28 03:53:05.353655', 82);
INSERT INTO `courses_courseobjectiveachievement` VALUES (415, 1, 8.95, 0, 15.72, 24.67, 0.7959, 31, '2026-01-15 02:27:09.378410', '2026-01-15 02:44:32.550926', 112);
INSERT INTO `courses_courseobjectiveachievement` VALUES (416, 2, 5.37, 7.75, 15.72, 28.84, 0.7796, 37, '2026-01-15 02:27:09.381965', '2026-01-15 02:44:32.555589', 112);
INSERT INTO `courses_courseobjectiveachievement` VALUES (417, 3, 3.58, 7.75, 13.48, 24.81, 0.7752, 32, '2026-01-15 02:27:09.384069', '2026-01-15 02:44:32.561067', 112);
INSERT INTO `courses_courseobjectiveachievement` VALUES (418, 1, 8.8, 0, 19.37, 28.17, 0.9088, 31, '2026-01-15 02:27:09.390482', '2026-01-15 02:44:32.566746', 113);
INSERT INTO `courses_courseobjectiveachievement` VALUES (419, 2, 5.28, 9.45, 19.37, 34.1, 0.9217, 37, '2026-01-15 02:27:09.392002', '2026-01-15 02:44:32.570915', 113);
INSERT INTO `courses_courseobjectiveachievement` VALUES (420, 3, 3.52, 9.45, 16.61, 29.58, 0.9242, 32, '2026-01-15 02:27:09.394086', '2026-01-15 02:44:32.576776', 113);
INSERT INTO `courses_courseobjectiveachievement` VALUES (421, 1, 9.02, 0, 18.35, 27.37, 0.8829, 31, '2026-01-15 02:27:09.398263', '2026-01-15 02:44:32.583492', 114);
INSERT INTO `courses_courseobjectiveachievement` VALUES (422, 2, 5.41, 9, 18.35, 32.76, 0.8854, 37, '2026-01-15 02:27:09.402084', '2026-01-15 02:44:32.588711', 114);
INSERT INTO `courses_courseobjectiveachievement` VALUES (423, 3, 3.61, 9, 15.73, 28.34, 0.8855, 32, '2026-01-15 02:27:09.404366', '2026-01-15 02:44:32.594744', 114);
INSERT INTO `courses_courseobjectiveachievement` VALUES (424, 1, 8.61, 0, 17.01, 25.62, 0.8265, 31, '2026-01-15 02:27:09.409016', '2026-01-15 02:44:32.600987', 115);
INSERT INTO `courses_courseobjectiveachievement` VALUES (425, 2, 5.17, 8.25, 17.01, 30.43, 0.8223, 37, '2026-01-15 02:27:09.412069', '2026-01-15 02:44:32.605045', 115);
INSERT INTO `courses_courseobjectiveachievement` VALUES (426, 3, 3.44, 8.25, 14.58, 26.27, 0.8211, 32, '2026-01-15 02:27:09.414645', '2026-01-15 02:44:32.610787', 115);
INSERT INTO `courses_courseobjectiveachievement` VALUES (427, 1, 8.09, 0, 15.38, 23.47, 0.7572, 31, '2026-01-15 02:27:09.421002', '2026-01-15 02:44:32.616929', 116);
INSERT INTO `courses_courseobjectiveachievement` VALUES (428, 2, 4.85, 7.55, 15.38, 27.79, 0.751, 37, '2026-01-15 02:27:09.423512', '2026-01-15 02:44:32.621946', 116);
INSERT INTO `courses_courseobjectiveachievement` VALUES (429, 3, 3.24, 7.55, 13.18, 23.97, 0.7491, 32, '2026-01-15 02:27:09.426909', '2026-01-15 02:44:32.627569', 116);
INSERT INTO `courses_courseobjectiveachievement` VALUES (430, 1, 9.6, 0, 17.8, 27.4, 0.8838, 31, '2026-01-15 02:27:09.432278', '2026-01-15 02:44:32.633489', 117);
INSERT INTO `courses_courseobjectiveachievement` VALUES (431, 2, 5.76, 8.7, 17.8, 32.26, 0.8718, 37, '2026-01-15 02:27:09.435675', '2026-01-15 02:44:32.637075', 117);
INSERT INTO `courses_courseobjectiveachievement` VALUES (432, 3, 3.84, 8.7, 15.26, 27.8, 0.8686, 32, '2026-01-15 02:27:09.437764', '2026-01-15 02:44:32.642281', 117);
INSERT INTO `courses_courseobjectiveachievement` VALUES (433, 1, 8.43, 0, 15.88, 24.31, 0.7842, 31, '2026-01-15 02:27:09.444447', '2026-01-15 02:44:32.647862', 118);
INSERT INTO `courses_courseobjectiveachievement` VALUES (434, 2, 5.06, 7.75, 15.88, 28.69, 0.7754, 37, '2026-01-15 02:27:09.446494', '2026-01-15 02:44:32.651879', 118);
INSERT INTO `courses_courseobjectiveachievement` VALUES (435, 3, 3.37, 7.75, 13.61, 24.73, 0.773, 32, '2026-01-15 02:27:09.449811', '2026-01-15 02:44:32.657432', 118);
INSERT INTO `courses_courseobjectiveachievement` VALUES (436, 1, 8.71, 0, 15.64, 24.35, 0.7856, 31, '2026-01-15 02:27:09.454431', '2026-01-15 02:44:32.665435', 119);
INSERT INTO `courses_courseobjectiveachievement` VALUES (437, 2, 5.23, 7.6, 15.64, 28.47, 0.7695, 37, '2026-01-15 02:27:09.457516', '2026-01-15 02:44:32.669759', 119);
INSERT INTO `courses_courseobjectiveachievement` VALUES (438, 3, 3.48, 7.6, 13.41, 24.49, 0.7654, 32, '2026-01-15 02:27:09.459691', '2026-01-15 02:44:32.673274', 119);
INSERT INTO `courses_courseobjectiveachievement` VALUES (439, 1, 8.91, 0, 16.9, 25.81, 0.8327, 31, '2026-01-15 02:27:09.464671', '2026-01-15 02:44:32.680747', 120);
INSERT INTO `courses_courseobjectiveachievement` VALUES (440, 2, 5.35, 8.05, 16.9, 30.3, 0.8189, 37, '2026-01-15 02:27:09.466744', '2026-01-15 02:44:32.684289', 120);
INSERT INTO `courses_courseobjectiveachievement` VALUES (441, 3, 3.56, 8.05, 14.49, 26.1, 0.8157, 32, '2026-01-15 02:27:09.468810', '2026-01-15 02:44:32.689883', 120);
INSERT INTO `courses_courseobjectiveachievement` VALUES (442, 1, 9.06, 0, 17.85, 26.91, 0.8681, 31, '2026-01-15 02:27:09.472424', '2026-01-15 02:44:32.697037', 121);
INSERT INTO `courses_courseobjectiveachievement` VALUES (443, 2, 5.44, 8.8, 17.85, 32.09, 0.8672, 37, '2026-01-15 02:27:09.475571', '2026-01-15 02:44:32.701965', 121);
INSERT INTO `courses_courseobjectiveachievement` VALUES (444, 3, 3.62, 8.8, 15.3, 27.72, 0.8664, 32, '2026-01-15 02:27:09.479007', '2026-01-15 02:44:32.706422', 121);
INSERT INTO `courses_courseobjectiveachievement` VALUES (445, 1, 8.87, 0, 15.91, 24.78, 0.7993, 31, '2026-01-15 02:27:09.484644', '2026-01-15 02:44:32.714693', 92);
INSERT INTO `courses_courseobjectiveachievement` VALUES (446, 2, 5.32, 7.8, 15.91, 29.03, 0.7846, 37, '2026-01-15 02:27:09.486712', '2026-01-15 02:44:32.719532', 92);
INSERT INTO `courses_courseobjectiveachievement` VALUES (447, 3, 3.55, 7.8, 13.63, 24.98, 0.7807, 32, '2026-01-15 02:27:09.488847', '2026-01-15 02:44:32.725374', 92);
INSERT INTO `courses_courseobjectiveachievement` VALUES (448, 1, 9.14, 0, 15.64, 24.79, 0.7997, 31, '2026-01-15 02:27:09.494634', '2026-01-15 02:44:32.733260', 93);
INSERT INTO `courses_courseobjectiveachievement` VALUES (449, 2, 5.49, 7.75, 15.64, 28.88, 0.7806, 37, '2026-01-15 02:27:09.496674', '2026-01-15 02:44:32.737474', 93);
INSERT INTO `courses_courseobjectiveachievement` VALUES (450, 3, 3.66, 7.75, 13.41, 24.82, 0.7756, 32, '2026-01-15 02:27:09.500863', '2026-01-15 02:44:32.742526', 93);
INSERT INTO `courses_courseobjectiveachievement` VALUES (451, 1, 8.97, 0, 18.01, 26.98, 0.8702, 31, '2026-01-15 02:27:09.504448', '2026-01-15 02:44:32.750140', 94);
INSERT INTO `courses_courseobjectiveachievement` VALUES (452, 2, 5.38, 9.1, 18.01, 32.49, 0.8781, 37, '2026-01-15 02:27:09.505498', '2026-01-15 02:44:32.753500', 94);
INSERT INTO `courses_courseobjectiveachievement` VALUES (453, 3, 3.59, 9.1, 15.43, 28.12, 0.8788, 32, '2026-01-15 02:27:09.510320', '2026-01-15 02:44:32.759597', 94);
INSERT INTO `courses_courseobjectiveachievement` VALUES (454, 1, 9.35, 0, 17.61, 26.96, 0.8698, 31, '2026-01-15 02:27:09.513889', '2026-01-15 02:44:32.769696', 95);
INSERT INTO `courses_courseobjectiveachievement` VALUES (455, 2, 5.61, 8.8, 17.61, 32.02, 0.8655, 37, '2026-01-15 02:27:09.515980', '2026-01-15 02:44:32.774288', 95);
INSERT INTO `courses_courseobjectiveachievement` VALUES (456, 3, 3.74, 8.8, 15.1, 27.64, 0.8637, 32, '2026-01-15 02:27:09.517034', '2026-01-15 02:44:32.778786', 95);
INSERT INTO `courses_courseobjectiveachievement` VALUES (457, 1, 9.33, 0, 17.51, 26.84, 0.8658, 31, '2026-01-15 02:27:09.521236', '2026-01-15 02:44:32.785413', 96);
INSERT INTO `courses_courseobjectiveachievement` VALUES (458, 2, 5.6, 8.9, 17.51, 32.01, 0.865, 37, '2026-01-15 02:27:09.523734', '2026-01-15 02:44:32.789504', 96);
INSERT INTO `courses_courseobjectiveachievement` VALUES (459, 3, 3.73, 8.9, 15.01, 27.64, 0.8637, 32, '2026-01-15 02:27:09.526821', '2026-01-15 02:44:32.796070', 96);
INSERT INTO `courses_courseobjectiveachievement` VALUES (460, 1, 8.92, 0, 16.77, 25.69, 0.8288, 31, '2026-01-15 02:27:09.532048', '2026-01-15 02:44:32.802068', 97);
INSERT INTO `courses_courseobjectiveachievement` VALUES (461, 2, 5.35, 8.25, 16.77, 30.38, 0.821, 37, '2026-01-15 02:27:09.535054', '2026-01-15 02:44:32.807494', 97);
INSERT INTO `courses_courseobjectiveachievement` VALUES (462, 3, 3.57, 8.25, 14.38, 26.2, 0.8186, 32, '2026-01-15 02:27:09.537133', '2026-01-15 02:44:32.812656', 97);
INSERT INTO `courses_courseobjectiveachievement` VALUES (463, 1, 9.38, 0, 19.5, 28.88, 0.9317, 31, '2026-01-15 02:27:09.541879', '2026-01-15 02:44:32.818255', 98);
INSERT INTO `courses_courseobjectiveachievement` VALUES (464, 2, 5.63, 9.1, 19.5, 34.23, 0.9252, 37, '2026-01-15 02:27:09.545013', '2026-01-15 02:44:32.822323', 98);
INSERT INTO `courses_courseobjectiveachievement` VALUES (465, 3, 3.75, 9.1, 16.72, 29.57, 0.924, 32, '2026-01-15 02:27:09.547072', '2026-01-15 02:44:32.828770', 98);
INSERT INTO `courses_courseobjectiveachievement` VALUES (466, 1, 8.45, 0, 14.52, 22.97, 0.7408, 31, '2026-01-15 02:27:09.550453', '2026-01-15 02:44:32.834436', 99);
INSERT INTO `courses_courseobjectiveachievement` VALUES (467, 2, 5.07, 7.4, 14.52, 26.99, 0.7294, 37, '2026-01-15 02:27:09.553030', '2026-01-15 02:44:32.839711', 99);
INSERT INTO `courses_courseobjectiveachievement` VALUES (468, 3, 3.38, 7.4, 12.44, 23.22, 0.7257, 32, '2026-01-15 02:27:09.555405', '2026-01-15 02:44:32.845414', 99);
INSERT INTO `courses_courseobjectiveachievement` VALUES (469, 1, 8.56, 0, 17.46, 26.02, 0.8394, 31, '2026-01-15 02:27:09.559527', '2026-01-15 02:44:32.852031', 100);
INSERT INTO `courses_courseobjectiveachievement` VALUES (470, 2, 5.14, 8.5, 17.46, 31.1, 0.8404, 37, '2026-01-15 02:27:09.560739', '2026-01-15 02:44:32.856950', 100);
INSERT INTO `courses_courseobjectiveachievement` VALUES (471, 3, 3.43, 8.5, 14.96, 26.89, 0.8403, 32, '2026-01-15 02:27:09.562261', '2026-01-15 02:44:32.862274', 100);
INSERT INTO `courses_courseobjectiveachievement` VALUES (472, 1, 8.67, 0, 8.27, 16.94, 0.5464, 31, '2026-01-15 02:27:09.565441', '2026-01-15 02:44:32.869000', 101);
INSERT INTO `courses_courseobjectiveachievement` VALUES (473, 2, 5.2, 6.75, 8.27, 20.22, 0.5465, 37, '2026-01-15 02:27:09.567512', '2026-01-15 02:44:32.873555', 101);
INSERT INTO `courses_courseobjectiveachievement` VALUES (474, 3, 3.47, 6.75, 7.09, 17.31, 0.5408, 32, '2026-01-15 02:27:09.571327', '2026-01-15 02:44:32.877836', 101);
INSERT INTO `courses_courseobjectiveachievement` VALUES (475, 1, 9.48, 0, 17.48, 26.96, 0.8698, 31, '2026-01-15 02:27:09.575450', '2026-01-15 02:44:32.884953', 102);
INSERT INTO `courses_courseobjectiveachievement` VALUES (476, 2, 5.69, 8.55, 17.48, 31.72, 0.8573, 37, '2026-01-15 02:27:09.576485', '2026-01-15 02:44:32.890165', 102);
INSERT INTO `courses_courseobjectiveachievement` VALUES (477, 3, 3.79, 8.55, 14.98, 27.33, 0.854, 32, '2026-01-15 02:27:09.578574', '2026-01-15 02:44:32.894476', 102);
INSERT INTO `courses_courseobjectiveachievement` VALUES (478, 1, 9.09, 0, 13.2, 22.29, 0.7192, 31, '2026-01-15 02:27:09.583235', '2026-01-15 02:44:32.901690', 103);
INSERT INTO `courses_courseobjectiveachievement` VALUES (479, 2, 5.45, 7, 13.2, 25.66, 0.6935, 37, '2026-01-15 02:27:09.586647', '2026-01-15 02:44:32.905783', 103);
INSERT INTO `courses_courseobjectiveachievement` VALUES (480, 3, 3.64, 7, 11.32, 21.95, 0.686, 32, '2026-01-15 02:27:09.587685', '2026-01-15 02:44:32.910989', 103);
INSERT INTO `courses_courseobjectiveachievement` VALUES (481, 1, 8.82, 0, 15.38, 24.2, 0.7807, 31, '2026-01-15 02:27:09.592286', '2026-01-15 02:44:32.917825', 104);
INSERT INTO `courses_courseobjectiveachievement` VALUES (482, 2, 5.29, 7.55, 15.38, 28.22, 0.7628, 37, '2026-01-15 02:27:09.594428', '2026-01-15 02:44:32.921931', 104);
INSERT INTO `courses_courseobjectiveachievement` VALUES (483, 3, 3.53, 7.55, 13.18, 24.26, 0.7582, 32, '2026-01-15 02:27:09.596476', '2026-01-15 02:44:32.927584', 104);
INSERT INTO `courses_courseobjectiveachievement` VALUES (484, 1, 8.8, 0, 16.64, 25.45, 0.8209, 31, '2026-01-15 02:27:09.600333', '2026-01-15 02:44:32.934190', 105);
INSERT INTO `courses_courseobjectiveachievement` VALUES (485, 2, 5.28, 7.85, 16.64, 29.78, 0.8047, 37, '2026-01-15 02:27:09.602858', '2026-01-15 02:44:32.938247', 105);
INSERT INTO `courses_courseobjectiveachievement` VALUES (486, 3, 3.52, 7.85, 14.26, 25.64, 0.8012, 32, '2026-01-15 02:27:09.603882', '2026-01-15 02:44:32.943296', 105);
INSERT INTO `courses_courseobjectiveachievement` VALUES (487, 1, 9.45, 0, 18.66, 28.11, 0.9069, 31, '2026-01-15 02:27:09.608461', '2026-01-15 02:44:32.949517', 106);
INSERT INTO `courses_courseobjectiveachievement` VALUES (488, 2, 5.67, 9.3, 18.66, 33.63, 0.909, 37, '2026-01-15 02:27:09.610503', '2026-01-15 02:44:32.954274', 106);
INSERT INTO `courses_courseobjectiveachievement` VALUES (489, 3, 3.78, 9.3, 16, 29.08, 0.9087, 32, '2026-01-15 02:27:09.612023', '2026-01-15 02:44:32.959621', 106);
INSERT INTO `courses_courseobjectiveachievement` VALUES (490, 1, 8.95, 0, 15.43, 24.38, 0.7865, 31, '2026-01-15 02:27:09.616462', '2026-01-15 02:44:32.968499', 107);
INSERT INTO `courses_courseobjectiveachievement` VALUES (491, 2, 5.37, 7.65, 15.43, 28.45, 0.769, 37, '2026-01-15 02:27:09.618505', '2026-01-15 02:44:32.975901', 107);
INSERT INTO `courses_courseobjectiveachievement` VALUES (492, 3, 3.58, 7.65, 13.23, 24.46, 0.7643, 32, '2026-01-15 02:27:09.619558', '2026-01-15 02:44:32.981649', 107);
INSERT INTO `courses_courseobjectiveachievement` VALUES (493, 1, 8.52, 0, 11.94, 20.46, 0.6601, 31, '2026-01-15 02:27:09.624482', '2026-01-15 02:44:32.990425', 108);
INSERT INTO `courses_courseobjectiveachievement` VALUES (494, 2, 5.11, 3.25, 11.94, 20.31, 0.5488, 37, '2026-01-15 02:27:09.626594', '2026-01-15 02:44:32.995754', 108);
INSERT INTO `courses_courseobjectiveachievement` VALUES (495, 3, 3.41, 3.25, 10.24, 16.9, 0.528, 32, '2026-01-15 02:27:09.628667', '2026-01-15 02:44:33.001188', 108);
INSERT INTO `courses_courseobjectiveachievement` VALUES (496, 1, 8.66, 0, 14.23, 22.89, 0.7383, 31, '2026-01-15 02:27:09.633385', '2026-01-15 02:44:33.007900', 109);
INSERT INTO `courses_courseobjectiveachievement` VALUES (497, 2, 5.2, 7.15, 14.23, 26.57, 0.7182, 37, '2026-01-15 02:27:09.635422', '2026-01-15 02:44:33.013539', 109);
INSERT INTO `courses_courseobjectiveachievement` VALUES (498, 3, 3.46, 7.15, 12.19, 22.81, 0.7128, 32, '2026-01-15 02:27:09.636511', '2026-01-15 02:44:33.017986', 109);
INSERT INTO `courses_courseobjectiveachievement` VALUES (499, 1, 8.63, 0, 16.96, 25.59, 0.8254, 31, '2026-01-15 02:27:09.640665', '2026-01-15 02:44:33.025916', 110);
INSERT INTO `courses_courseobjectiveachievement` VALUES (500, 2, 5.18, 8, 16.96, 30.14, 0.8145, 37, '2026-01-15 02:27:09.643203', '2026-01-15 02:44:33.030697', 110);
INSERT INTO `courses_courseobjectiveachievement` VALUES (501, 3, 3.45, 8, 14.53, 25.99, 0.8121, 32, '2026-01-15 02:27:09.645310', '2026-01-15 02:44:33.034653', 110);
INSERT INTO `courses_courseobjectiveachievement` VALUES (502, 1, 8.92, 0, 17.04, 25.96, 0.8373, 31, '2026-01-15 02:27:09.650650', '2026-01-15 02:44:33.043226', 111);
INSERT INTO `courses_courseobjectiveachievement` VALUES (503, 2, 5.35, 8.45, 17.04, 30.84, 0.8335, 37, '2026-01-15 02:27:09.653285', '2026-01-15 02:44:33.048393', 111);
INSERT INTO `courses_courseobjectiveachievement` VALUES (504, 3, 3.57, 8.45, 14.6, 26.62, 0.8319, 32, '2026-01-15 02:27:09.656428', '2026-01-15 02:44:33.053194', 111);

-- ----------------------------
-- Table structure for courses_enrollment
-- ----------------------------
DROP TABLE IF EXISTS `courses_enrollment`;
CREATE TABLE `courses_enrollment`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `enrolled_at` datetime(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `course_class_id` bigint NOT NULL,
  `student_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `courses_enrollment_student_id_course_class_id_18bdaf90_uniq`(`student_id` ASC, `course_class_id` ASC) USING BTREE,
  INDEX `courses_enrollment_course_class_id_687dfabc_fk_courses_c`(`course_class_id` ASC) USING BTREE,
  CONSTRAINT `courses_enrollment_course_class_id_687dfabc_fk_courses_c` FOREIGN KEY (`course_class_id`) REFERENCES `courses_courseclass` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `courses_enrollment_student_id_aebf8536_fk_users_user_id` FOREIGN KEY (`student_id`) REFERENCES `users_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 265 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of courses_enrollment
-- ----------------------------
INSERT INTO `courses_enrollment` VALUES (1, '2025-12-26 12:46:51.513741', 1, 1, 3);
INSERT INTO `courses_enrollment` VALUES (2, '2025-12-26 12:46:51.528217', 1, 1, 4);
INSERT INTO `courses_enrollment` VALUES (3, '2025-12-26 12:46:51.541459', 1, 1, 5);
INSERT INTO `courses_enrollment` VALUES (4, '2025-12-26 12:46:51.552272', 1, 1, 6);
INSERT INTO `courses_enrollment` VALUES (5, '2025-12-26 12:46:51.564624', 1, 1, 7);
INSERT INTO `courses_enrollment` VALUES (6, '2025-12-26 12:46:51.577018', 1, 1, 8);
INSERT INTO `courses_enrollment` VALUES (7, '2025-12-26 12:46:51.588119', 1, 1, 9);
INSERT INTO `courses_enrollment` VALUES (8, '2025-12-26 12:46:51.599502', 1, 1, 10);
INSERT INTO `courses_enrollment` VALUES (9, '2025-12-26 12:46:51.611099', 1, 1, 11);
INSERT INTO `courses_enrollment` VALUES (10, '2025-12-26 12:46:51.622349', 1, 1, 12);
INSERT INTO `courses_enrollment` VALUES (11, '2025-12-26 12:46:51.633504', 1, 1, 13);
INSERT INTO `courses_enrollment` VALUES (12, '2025-12-26 12:46:51.645075', 1, 1, 14);
INSERT INTO `courses_enrollment` VALUES (13, '2025-12-26 12:46:51.655336', 1, 1, 15);
INSERT INTO `courses_enrollment` VALUES (14, '2025-12-26 12:46:51.665596', 1, 1, 16);
INSERT INTO `courses_enrollment` VALUES (15, '2025-12-26 12:46:51.676046', 1, 1, 17);
INSERT INTO `courses_enrollment` VALUES (16, '2025-12-26 12:46:51.686263', 1, 1, 18);
INSERT INTO `courses_enrollment` VALUES (17, '2025-12-26 12:46:51.696499', 1, 1, 19);
INSERT INTO `courses_enrollment` VALUES (18, '2025-12-26 12:46:51.707693', 1, 1, 20);
INSERT INTO `courses_enrollment` VALUES (19, '2025-12-26 12:46:51.717996', 1, 1, 21);
INSERT INTO `courses_enrollment` VALUES (20, '2025-12-26 12:46:51.728141', 1, 1, 22);
INSERT INTO `courses_enrollment` VALUES (21, '2025-12-26 12:46:51.738431', 1, 1, 23);
INSERT INTO `courses_enrollment` VALUES (22, '2025-12-26 12:46:51.750956', 1, 1, 24);
INSERT INTO `courses_enrollment` VALUES (23, '2025-12-26 12:46:51.761261', 1, 1, 25);
INSERT INTO `courses_enrollment` VALUES (24, '2025-12-26 12:46:51.771389', 1, 1, 26);
INSERT INTO `courses_enrollment` VALUES (25, '2025-12-26 12:46:51.782709', 1, 1, 27);
INSERT INTO `courses_enrollment` VALUES (26, '2025-12-26 12:46:51.794307', 1, 1, 28);
INSERT INTO `courses_enrollment` VALUES (27, '2025-12-26 12:46:51.804557', 1, 1, 29);
INSERT INTO `courses_enrollment` VALUES (28, '2025-12-26 12:46:51.815947', 1, 1, 30);
INSERT INTO `courses_enrollment` VALUES (29, '2025-12-26 12:46:51.828242', 1, 1, 31);
INSERT INTO `courses_enrollment` VALUES (30, '2025-12-26 12:46:51.839983', 1, 1, 32);
INSERT INTO `courses_enrollment` VALUES (31, '2025-12-28 03:06:58.316186', 1, 2, 33);
INSERT INTO `courses_enrollment` VALUES (32, '2025-12-28 03:06:58.329425', 1, 2, 34);
INSERT INTO `courses_enrollment` VALUES (33, '2025-12-28 03:06:58.342084', 1, 2, 35);
INSERT INTO `courses_enrollment` VALUES (34, '2025-12-28 03:06:58.354702', 1, 2, 36);
INSERT INTO `courses_enrollment` VALUES (35, '2025-12-28 03:06:58.368606', 1, 2, 37);
INSERT INTO `courses_enrollment` VALUES (36, '2025-12-28 03:06:58.380082', 1, 2, 38);
INSERT INTO `courses_enrollment` VALUES (37, '2025-12-28 03:06:58.391609', 1, 2, 39);
INSERT INTO `courses_enrollment` VALUES (38, '2025-12-28 03:06:58.406128', 1, 2, 40);
INSERT INTO `courses_enrollment` VALUES (39, '2025-12-28 03:06:58.419233', 1, 2, 41);
INSERT INTO `courses_enrollment` VALUES (40, '2025-12-28 03:06:58.431236', 1, 2, 42);
INSERT INTO `courses_enrollment` VALUES (41, '2025-12-28 03:06:58.443784', 1, 2, 43);
INSERT INTO `courses_enrollment` VALUES (42, '2025-12-28 03:06:58.455191', 1, 2, 44);
INSERT INTO `courses_enrollment` VALUES (43, '2025-12-28 03:06:58.473247', 1, 2, 45);
INSERT INTO `courses_enrollment` VALUES (44, '2025-12-28 03:06:58.484951', 1, 2, 46);
INSERT INTO `courses_enrollment` VALUES (45, '2025-12-28 03:06:58.498835', 1, 2, 47);
INSERT INTO `courses_enrollment` VALUES (46, '2025-12-28 03:06:58.509956', 1, 2, 48);
INSERT INTO `courses_enrollment` VALUES (47, '2025-12-28 03:06:58.521702', 1, 2, 49);
INSERT INTO `courses_enrollment` VALUES (48, '2025-12-28 03:06:58.534044', 1, 2, 50);
INSERT INTO `courses_enrollment` VALUES (49, '2025-12-28 03:06:58.545084', 1, 2, 51);
INSERT INTO `courses_enrollment` VALUES (50, '2025-12-28 03:06:58.557232', 1, 2, 52);
INSERT INTO `courses_enrollment` VALUES (51, '2025-12-28 03:06:58.568872', 1, 2, 53);
INSERT INTO `courses_enrollment` VALUES (52, '2025-12-28 03:06:58.578384', 1, 2, 54);
INSERT INTO `courses_enrollment` VALUES (53, '2025-12-28 03:06:58.589443', 1, 2, 55);
INSERT INTO `courses_enrollment` VALUES (54, '2025-12-28 03:06:58.600892', 1, 2, 56);
INSERT INTO `courses_enrollment` VALUES (55, '2025-12-28 03:06:58.613076', 1, 2, 57);
INSERT INTO `courses_enrollment` VALUES (56, '2025-12-28 03:06:58.623846', 1, 2, 58);
INSERT INTO `courses_enrollment` VALUES (57, '2025-12-28 03:06:58.635543', 1, 2, 59);
INSERT INTO `courses_enrollment` VALUES (58, '2025-12-28 03:06:58.645817', 1, 2, 60);
INSERT INTO `courses_enrollment` VALUES (59, '2025-12-28 03:06:58.657911', 1, 2, 61);
INSERT INTO `courses_enrollment` VALUES (62, '2025-12-28 03:50:08.743412', 1, 3, 63);
INSERT INTO `courses_enrollment` VALUES (63, '2025-12-28 03:50:08.758304', 1, 3, 64);
INSERT INTO `courses_enrollment` VALUES (64, '2025-12-28 03:50:08.774418', 1, 3, 65);
INSERT INTO `courses_enrollment` VALUES (65, '2025-12-28 03:50:08.790565', 1, 3, 66);
INSERT INTO `courses_enrollment` VALUES (66, '2025-12-28 03:50:08.806867', 1, 3, 67);
INSERT INTO `courses_enrollment` VALUES (67, '2025-12-28 03:50:08.823022', 1, 3, 68);
INSERT INTO `courses_enrollment` VALUES (68, '2025-12-28 03:50:08.839044', 1, 3, 69);
INSERT INTO `courses_enrollment` VALUES (69, '2025-12-28 03:50:08.854703', 1, 3, 70);
INSERT INTO `courses_enrollment` VALUES (70, '2025-12-28 03:50:08.867431', 1, 3, 71);
INSERT INTO `courses_enrollment` VALUES (71, '2025-12-28 03:50:08.881058', 1, 3, 72);
INSERT INTO `courses_enrollment` VALUES (72, '2025-12-28 03:50:08.893496', 1, 3, 73);
INSERT INTO `courses_enrollment` VALUES (73, '2025-12-28 03:50:08.905661', 1, 3, 74);
INSERT INTO `courses_enrollment` VALUES (74, '2025-12-28 03:50:08.917344', 1, 3, 75);
INSERT INTO `courses_enrollment` VALUES (75, '2025-12-28 03:50:08.928345', 1, 3, 76);
INSERT INTO `courses_enrollment` VALUES (76, '2025-12-28 03:50:08.939750', 1, 3, 77);
INSERT INTO `courses_enrollment` VALUES (77, '2025-12-28 03:50:08.952383', 1, 3, 78);
INSERT INTO `courses_enrollment` VALUES (78, '2025-12-28 03:50:08.964822', 1, 3, 79);
INSERT INTO `courses_enrollment` VALUES (79, '2025-12-28 03:50:08.976060', 1, 3, 80);
INSERT INTO `courses_enrollment` VALUES (80, '2025-12-28 03:50:08.987675', 1, 3, 81);
INSERT INTO `courses_enrollment` VALUES (81, '2025-12-28 03:50:08.999678', 1, 3, 82);
INSERT INTO `courses_enrollment` VALUES (82, '2025-12-28 03:50:09.010222', 1, 3, 83);
INSERT INTO `courses_enrollment` VALUES (83, '2025-12-28 03:50:09.020460', 1, 3, 84);
INSERT INTO `courses_enrollment` VALUES (84, '2025-12-28 03:50:09.032528', 1, 3, 85);
INSERT INTO `courses_enrollment` VALUES (85, '2025-12-28 03:50:09.044063', 1, 3, 86);
INSERT INTO `courses_enrollment` VALUES (86, '2025-12-28 03:50:09.057155', 1, 3, 87);
INSERT INTO `courses_enrollment` VALUES (87, '2025-12-28 03:50:09.068595', 1, 3, 88);
INSERT INTO `courses_enrollment` VALUES (88, '2025-12-28 03:50:09.081274', 1, 3, 89);
INSERT INTO `courses_enrollment` VALUES (89, '2025-12-28 03:50:09.093806', 1, 3, 90);
INSERT INTO `courses_enrollment` VALUES (90, '2025-12-28 03:50:09.106393', 1, 3, 91);
INSERT INTO `courses_enrollment` VALUES (91, '2025-12-28 03:50:09.118218', 1, 3, 92);
INSERT INTO `courses_enrollment` VALUES (92, '2026-01-08 09:44:41.443624', 1, 4, 93);
INSERT INTO `courses_enrollment` VALUES (93, '2026-01-08 09:44:41.465638', 1, 4, 94);
INSERT INTO `courses_enrollment` VALUES (94, '2026-01-08 09:44:41.486263', 1, 4, 95);
INSERT INTO `courses_enrollment` VALUES (95, '2026-01-08 09:44:41.500857', 1, 4, 96);
INSERT INTO `courses_enrollment` VALUES (96, '2026-01-08 09:44:41.517025', 1, 4, 97);
INSERT INTO `courses_enrollment` VALUES (97, '2026-01-08 09:44:41.531737', 1, 4, 98);
INSERT INTO `courses_enrollment` VALUES (98, '2026-01-08 09:44:41.548436', 1, 4, 99);
INSERT INTO `courses_enrollment` VALUES (99, '2026-01-08 09:44:41.562661', 1, 4, 100);
INSERT INTO `courses_enrollment` VALUES (100, '2026-01-08 09:44:41.576508', 1, 4, 101);
INSERT INTO `courses_enrollment` VALUES (101, '2026-01-08 09:44:41.590468', 1, 4, 102);
INSERT INTO `courses_enrollment` VALUES (102, '2026-01-08 09:44:41.604733', 1, 4, 103);
INSERT INTO `courses_enrollment` VALUES (103, '2026-01-08 09:44:41.619321', 1, 4, 104);
INSERT INTO `courses_enrollment` VALUES (104, '2026-01-08 09:44:41.634771', 1, 4, 105);
INSERT INTO `courses_enrollment` VALUES (105, '2026-01-08 09:44:41.649631', 1, 4, 106);
INSERT INTO `courses_enrollment` VALUES (106, '2026-01-08 09:44:41.663100', 1, 4, 107);
INSERT INTO `courses_enrollment` VALUES (107, '2026-01-08 09:44:41.677937', 1, 4, 108);
INSERT INTO `courses_enrollment` VALUES (108, '2026-01-08 09:44:41.691576', 1, 4, 109);
INSERT INTO `courses_enrollment` VALUES (109, '2026-01-08 09:44:41.706510', 1, 4, 110);
INSERT INTO `courses_enrollment` VALUES (110, '2026-01-08 09:44:41.722286', 1, 4, 111);
INSERT INTO `courses_enrollment` VALUES (111, '2026-01-08 09:44:41.736008', 1, 4, 112);
INSERT INTO `courses_enrollment` VALUES (112, '2026-01-08 09:44:41.751029', 1, 4, 113);
INSERT INTO `courses_enrollment` VALUES (113, '2026-01-08 09:44:41.766391', 1, 4, 114);
INSERT INTO `courses_enrollment` VALUES (114, '2026-01-08 09:44:41.784426', 1, 4, 115);
INSERT INTO `courses_enrollment` VALUES (115, '2026-01-08 09:44:41.798089', 1, 4, 116);
INSERT INTO `courses_enrollment` VALUES (116, '2026-01-08 09:44:41.813781', 1, 4, 117);
INSERT INTO `courses_enrollment` VALUES (117, '2026-01-08 09:44:41.827398', 1, 4, 118);
INSERT INTO `courses_enrollment` VALUES (118, '2026-01-08 09:44:41.841190', 1, 4, 119);
INSERT INTO `courses_enrollment` VALUES (119, '2026-01-08 09:47:04.291437', 1, 5, 120);
INSERT INTO `courses_enrollment` VALUES (120, '2026-01-08 09:47:04.304192', 1, 5, 121);
INSERT INTO `courses_enrollment` VALUES (121, '2026-01-08 09:47:04.317473', 1, 5, 122);
INSERT INTO `courses_enrollment` VALUES (122, '2026-01-08 09:47:04.328716', 1, 5, 123);
INSERT INTO `courses_enrollment` VALUES (123, '2026-01-08 09:47:04.341912', 1, 5, 124);
INSERT INTO `courses_enrollment` VALUES (124, '2026-01-08 09:47:04.353893', 1, 5, 125);
INSERT INTO `courses_enrollment` VALUES (125, '2026-01-08 09:47:04.364848', 1, 5, 126);
INSERT INTO `courses_enrollment` VALUES (126, '2026-01-08 09:47:04.377092', 1, 5, 127);
INSERT INTO `courses_enrollment` VALUES (127, '2026-01-08 09:47:04.388708', 1, 5, 128);
INSERT INTO `courses_enrollment` VALUES (128, '2026-01-08 09:47:04.402253', 1, 5, 129);
INSERT INTO `courses_enrollment` VALUES (129, '2026-01-08 09:47:04.414527', 1, 5, 130);
INSERT INTO `courses_enrollment` VALUES (130, '2026-01-08 09:47:04.427850', 1, 5, 131);
INSERT INTO `courses_enrollment` VALUES (131, '2026-01-08 09:47:04.439090', 1, 5, 132);
INSERT INTO `courses_enrollment` VALUES (132, '2026-01-08 09:47:04.453262', 1, 5, 133);
INSERT INTO `courses_enrollment` VALUES (133, '2026-01-08 09:47:04.468624', 1, 5, 134);
INSERT INTO `courses_enrollment` VALUES (134, '2026-01-08 09:47:04.481778', 1, 5, 135);
INSERT INTO `courses_enrollment` VALUES (135, '2026-01-08 09:47:04.494058', 1, 5, 136);
INSERT INTO `courses_enrollment` VALUES (136, '2026-01-08 09:47:04.505642', 1, 5, 137);
INSERT INTO `courses_enrollment` VALUES (137, '2026-01-08 09:47:04.517253', 1, 5, 138);
INSERT INTO `courses_enrollment` VALUES (138, '2026-01-08 09:47:04.531184', 1, 5, 139);
INSERT INTO `courses_enrollment` VALUES (139, '2026-01-08 09:47:04.543568', 1, 5, 140);
INSERT INTO `courses_enrollment` VALUES (140, '2026-01-08 09:47:04.553905', 1, 5, 141);
INSERT INTO `courses_enrollment` VALUES (141, '2026-01-08 09:47:04.565526', 1, 5, 142);
INSERT INTO `courses_enrollment` VALUES (142, '2026-01-08 09:47:04.575678', 1, 5, 143);
INSERT INTO `courses_enrollment` VALUES (143, '2026-01-08 09:47:04.588137', 1, 5, 144);
INSERT INTO `courses_enrollment` VALUES (144, '2026-01-08 09:47:04.598999', 1, 5, 145);
INSERT INTO `courses_enrollment` VALUES (145, '2026-01-08 09:47:04.611926', 1, 5, 146);
INSERT INTO `courses_enrollment` VALUES (146, '2026-01-08 09:47:04.623785', 1, 5, 147);
INSERT INTO `courses_enrollment` VALUES (147, '2026-01-08 09:47:04.635421', 1, 5, 148);
INSERT INTO `courses_enrollment` VALUES (148, '2026-01-08 09:47:04.647450', 1, 5, 149);
INSERT INTO `courses_enrollment` VALUES (149, '2026-01-08 09:47:44.635073', 1, 6, 150);
INSERT INTO `courses_enrollment` VALUES (150, '2026-01-08 09:47:44.648271', 1, 6, 151);
INSERT INTO `courses_enrollment` VALUES (151, '2026-01-08 09:47:44.658854', 1, 6, 152);
INSERT INTO `courses_enrollment` VALUES (152, '2026-01-08 09:47:44.669513', 1, 6, 153);
INSERT INTO `courses_enrollment` VALUES (153, '2026-01-08 09:47:44.680974', 1, 6, 154);
INSERT INTO `courses_enrollment` VALUES (154, '2026-01-08 09:47:44.693692', 1, 6, 155);
INSERT INTO `courses_enrollment` VALUES (155, '2026-01-08 09:47:44.703331', 1, 6, 156);
INSERT INTO `courses_enrollment` VALUES (156, '2026-01-08 09:47:44.715300', 1, 6, 157);
INSERT INTO `courses_enrollment` VALUES (157, '2026-01-08 09:47:44.725675', 1, 6, 158);
INSERT INTO `courses_enrollment` VALUES (158, '2026-01-08 09:47:44.736257', 1, 6, 159);
INSERT INTO `courses_enrollment` VALUES (159, '2026-01-08 09:47:44.750147', 1, 6, 160);
INSERT INTO `courses_enrollment` VALUES (160, '2026-01-08 09:47:44.765115', 1, 6, 161);
INSERT INTO `courses_enrollment` VALUES (161, '2026-01-08 09:47:44.778386', 1, 6, 162);
INSERT INTO `courses_enrollment` VALUES (162, '2026-01-08 09:47:44.789902', 1, 6, 163);
INSERT INTO `courses_enrollment` VALUES (163, '2026-01-08 09:47:44.802074', 1, 6, 164);
INSERT INTO `courses_enrollment` VALUES (164, '2026-01-08 09:47:44.814739', 1, 6, 165);
INSERT INTO `courses_enrollment` VALUES (165, '2026-01-08 09:47:44.828088', 1, 6, 166);
INSERT INTO `courses_enrollment` VALUES (166, '2026-01-08 09:47:44.842273', 1, 6, 167);
INSERT INTO `courses_enrollment` VALUES (167, '2026-01-08 09:47:44.852543', 1, 6, 168);
INSERT INTO `courses_enrollment` VALUES (168, '2026-01-08 09:47:44.864236', 1, 6, 169);
INSERT INTO `courses_enrollment` VALUES (169, '2026-01-08 09:47:44.876959', 1, 6, 170);
INSERT INTO `courses_enrollment` VALUES (170, '2026-01-08 09:47:44.889753', 1, 6, 171);
INSERT INTO `courses_enrollment` VALUES (171, '2026-01-08 09:47:44.901395', 1, 6, 172);
INSERT INTO `courses_enrollment` VALUES (172, '2026-01-08 09:47:44.918286', 1, 6, 173);
INSERT INTO `courses_enrollment` VALUES (173, '2026-01-08 09:47:44.928658', 1, 6, 174);
INSERT INTO `courses_enrollment` VALUES (174, '2026-01-08 09:47:44.943364', 1, 6, 175);
INSERT INTO `courses_enrollment` VALUES (175, '2026-01-08 09:47:44.957007', 1, 6, 176);
INSERT INTO `courses_enrollment` VALUES (176, '2026-01-08 09:47:44.969521', 1, 6, 177);
INSERT INTO `courses_enrollment` VALUES (177, '2026-01-08 09:47:44.984373', 1, 6, 178);
INSERT INTO `courses_enrollment` VALUES (178, '2026-01-08 09:48:29.970888', 1, 7, 179);
INSERT INTO `courses_enrollment` VALUES (179, '2026-01-08 09:48:29.983906', 1, 7, 180);
INSERT INTO `courses_enrollment` VALUES (180, '2026-01-08 09:48:29.996775', 1, 7, 181);
INSERT INTO `courses_enrollment` VALUES (181, '2026-01-08 09:48:30.009311', 1, 7, 182);
INSERT INTO `courses_enrollment` VALUES (182, '2026-01-08 09:48:30.021214', 1, 7, 183);
INSERT INTO `courses_enrollment` VALUES (183, '2026-01-08 09:48:30.034682', 1, 7, 184);
INSERT INTO `courses_enrollment` VALUES (184, '2026-01-08 09:48:30.047974', 1, 7, 185);
INSERT INTO `courses_enrollment` VALUES (185, '2026-01-08 09:48:30.063485', 1, 7, 186);
INSERT INTO `courses_enrollment` VALUES (186, '2026-01-08 09:48:30.076633', 1, 7, 187);
INSERT INTO `courses_enrollment` VALUES (187, '2026-01-08 09:48:30.090546', 1, 7, 188);
INSERT INTO `courses_enrollment` VALUES (188, '2026-01-08 09:48:30.104052', 1, 7, 189);
INSERT INTO `courses_enrollment` VALUES (189, '2026-01-08 09:48:30.117205', 1, 7, 190);
INSERT INTO `courses_enrollment` VALUES (190, '2026-01-08 09:48:30.131069', 1, 7, 191);
INSERT INTO `courses_enrollment` VALUES (191, '2026-01-08 09:48:30.143624', 1, 7, 192);
INSERT INTO `courses_enrollment` VALUES (192, '2026-01-08 09:48:30.155342', 1, 7, 193);
INSERT INTO `courses_enrollment` VALUES (193, '2026-01-08 09:48:30.168078', 1, 7, 194);
INSERT INTO `courses_enrollment` VALUES (194, '2026-01-08 09:48:30.180638', 1, 7, 195);
INSERT INTO `courses_enrollment` VALUES (195, '2026-01-08 09:48:30.193911', 1, 7, 196);
INSERT INTO `courses_enrollment` VALUES (196, '2026-01-08 09:48:30.205272', 1, 7, 197);
INSERT INTO `courses_enrollment` VALUES (197, '2026-01-08 09:48:30.218084', 1, 7, 198);
INSERT INTO `courses_enrollment` VALUES (198, '2026-01-08 09:48:30.230961', 1, 7, 199);
INSERT INTO `courses_enrollment` VALUES (199, '2026-01-08 09:48:30.242748', 1, 7, 200);
INSERT INTO `courses_enrollment` VALUES (200, '2026-01-08 09:48:30.256281', 1, 7, 201);
INSERT INTO `courses_enrollment` VALUES (201, '2026-01-08 09:48:30.266423', 1, 7, 202);
INSERT INTO `courses_enrollment` VALUES (202, '2026-01-08 09:48:30.278020', 1, 7, 203);
INSERT INTO `courses_enrollment` VALUES (203, '2026-01-08 09:48:30.291079', 1, 7, 204);
INSERT INTO `courses_enrollment` VALUES (204, '2026-01-08 09:48:30.301643', 1, 7, 205);
INSERT INTO `courses_enrollment` VALUES (205, '2026-01-08 09:48:30.313902', 1, 7, 206);
INSERT INTO `courses_enrollment` VALUES (206, '2026-01-08 09:56:11.587834', 1, 8, 207);
INSERT INTO `courses_enrollment` VALUES (207, '2026-01-08 09:56:11.600307', 1, 8, 208);
INSERT INTO `courses_enrollment` VALUES (208, '2026-01-08 09:56:11.613208', 1, 8, 209);
INSERT INTO `courses_enrollment` VALUES (209, '2026-01-08 09:56:11.624940', 1, 8, 210);
INSERT INTO `courses_enrollment` VALUES (210, '2026-01-08 09:56:11.635283', 1, 8, 211);
INSERT INTO `courses_enrollment` VALUES (211, '2026-01-08 09:56:11.647902', 1, 8, 212);
INSERT INTO `courses_enrollment` VALUES (212, '2026-01-08 09:56:11.673668', 1, 8, 213);
INSERT INTO `courses_enrollment` VALUES (213, '2026-01-08 09:56:11.685087', 1, 8, 214);
INSERT INTO `courses_enrollment` VALUES (214, '2026-01-08 09:56:11.696643', 1, 8, 215);
INSERT INTO `courses_enrollment` VALUES (215, '2026-01-08 09:56:11.709346', 1, 8, 216);
INSERT INTO `courses_enrollment` VALUES (216, '2026-01-08 09:56:11.721424', 1, 8, 217);
INSERT INTO `courses_enrollment` VALUES (217, '2026-01-08 09:56:11.733985', 1, 8, 218);
INSERT INTO `courses_enrollment` VALUES (218, '2026-01-08 09:56:11.745387', 1, 8, 219);
INSERT INTO `courses_enrollment` VALUES (219, '2026-01-08 09:56:11.757054', 1, 8, 220);
INSERT INTO `courses_enrollment` VALUES (220, '2026-01-08 09:56:11.767691', 1, 8, 221);
INSERT INTO `courses_enrollment` VALUES (221, '2026-01-08 09:56:11.781000', 1, 8, 222);
INSERT INTO `courses_enrollment` VALUES (222, '2026-01-08 09:56:11.792512', 1, 8, 223);
INSERT INTO `courses_enrollment` VALUES (223, '2026-01-08 09:56:11.804032', 1, 8, 224);
INSERT INTO `courses_enrollment` VALUES (224, '2026-01-08 09:56:11.815877', 1, 8, 225);
INSERT INTO `courses_enrollment` VALUES (225, '2026-01-08 09:56:11.826880', 1, 8, 226);
INSERT INTO `courses_enrollment` VALUES (226, '2026-01-08 09:56:11.837633', 1, 8, 227);
INSERT INTO `courses_enrollment` VALUES (227, '2026-01-08 09:56:11.852864', 1, 8, 228);
INSERT INTO `courses_enrollment` VALUES (228, '2026-01-08 09:56:11.864424', 1, 8, 229);
INSERT INTO `courses_enrollment` VALUES (229, '2026-01-08 09:56:11.877067', 1, 8, 230);
INSERT INTO `courses_enrollment` VALUES (230, '2026-01-08 09:56:11.887480', 1, 8, 231);
INSERT INTO `courses_enrollment` VALUES (231, '2026-01-08 09:56:11.899258', 1, 8, 232);
INSERT INTO `courses_enrollment` VALUES (232, '2026-01-08 09:56:11.910003', 1, 8, 233);
INSERT INTO `courses_enrollment` VALUES (233, '2026-01-08 09:56:11.922993', 1, 8, 234);
INSERT INTO `courses_enrollment` VALUES (234, '2026-01-08 09:56:11.936011', 1, 8, 235);
INSERT INTO `courses_enrollment` VALUES (235, '2026-01-15 02:27:02.478767', 1, 9, 63);
INSERT INTO `courses_enrollment` VALUES (236, '2026-01-15 02:27:02.487032', 1, 9, 64);
INSERT INTO `courses_enrollment` VALUES (237, '2026-01-15 02:27:02.496735', 1, 9, 65);
INSERT INTO `courses_enrollment` VALUES (238, '2026-01-15 02:27:02.505401', 1, 9, 66);
INSERT INTO `courses_enrollment` VALUES (239, '2026-01-15 02:27:02.513469', 1, 9, 67);
INSERT INTO `courses_enrollment` VALUES (240, '2026-01-15 02:27:02.520594', 1, 9, 68);
INSERT INTO `courses_enrollment` VALUES (241, '2026-01-15 02:27:02.529493', 1, 9, 69);
INSERT INTO `courses_enrollment` VALUES (242, '2026-01-15 02:27:02.536361', 1, 9, 70);
INSERT INTO `courses_enrollment` VALUES (243, '2026-01-15 02:27:02.546084', 1, 9, 71);
INSERT INTO `courses_enrollment` VALUES (244, '2026-01-15 02:27:02.552152', 1, 9, 72);
INSERT INTO `courses_enrollment` VALUES (245, '2026-01-15 02:27:02.562818', 1, 9, 73);
INSERT INTO `courses_enrollment` VALUES (246, '2026-01-15 02:27:02.570903', 1, 9, 74);
INSERT INTO `courses_enrollment` VALUES (247, '2026-01-15 02:27:02.579488', 1, 9, 75);
INSERT INTO `courses_enrollment` VALUES (248, '2026-01-15 02:27:02.586067', 1, 9, 76);
INSERT INTO `courses_enrollment` VALUES (249, '2026-01-15 02:27:02.594251', 1, 9, 77);
INSERT INTO `courses_enrollment` VALUES (250, '2026-01-15 02:27:02.602401', 1, 9, 78);
INSERT INTO `courses_enrollment` VALUES (251, '2026-01-15 02:27:02.610541', 1, 9, 79);
INSERT INTO `courses_enrollment` VALUES (252, '2026-01-15 02:27:02.618284', 1, 9, 80);
INSERT INTO `courses_enrollment` VALUES (253, '2026-01-15 02:27:02.627238', 1, 9, 81);
INSERT INTO `courses_enrollment` VALUES (254, '2026-01-15 02:27:02.633851', 1, 9, 82);
INSERT INTO `courses_enrollment` VALUES (255, '2026-01-15 02:27:02.642180', 1, 9, 83);
INSERT INTO `courses_enrollment` VALUES (256, '2026-01-15 02:27:02.649569', 1, 9, 84);
INSERT INTO `courses_enrollment` VALUES (257, '2026-01-15 02:27:02.656420', 1, 9, 85);
INSERT INTO `courses_enrollment` VALUES (258, '2026-01-15 02:27:02.666093', 1, 9, 86);
INSERT INTO `courses_enrollment` VALUES (259, '2026-01-15 02:27:02.675317', 1, 9, 87);
INSERT INTO `courses_enrollment` VALUES (260, '2026-01-15 02:27:02.683891', 1, 9, 88);
INSERT INTO `courses_enrollment` VALUES (261, '2026-01-15 02:27:02.691008', 1, 9, 89);
INSERT INTO `courses_enrollment` VALUES (262, '2026-01-15 02:27:02.696345', 1, 9, 90);
INSERT INTO `courses_enrollment` VALUES (263, '2026-01-15 02:27:02.703672', 1, 9, 91);
INSERT INTO `courses_enrollment` VALUES (264, '2026-01-15 02:27:02.710079', 1, 9, 92);

-- ----------------------------
-- Table structure for courses_gradingpolicy
-- ----------------------------
DROP TABLE IF EXISTS `courses_gradingpolicy`;
CREATE TABLE `courses_gradingpolicy`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `usual_weight` double NOT NULL,
  `final_weight` double NOT NULL,
  `attendance_weight` double NOT NULL,
  `homework_weight` double NOT NULL,
  `experiment_weight` double NOT NULL,
  `review_note_weight` double NOT NULL,
  `grading_scale` json NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `course_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `course_id`(`course_id` ASC) USING BTREE,
  CONSTRAINT `courses_gradingpolicy_course_id_9eac59ee_fk_courses_course_id` FOREIGN KEY (`course_id`) REFERENCES `courses_course` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of courses_gradingpolicy
-- ----------------------------
INSERT INTO `courses_gradingpolicy` VALUES (1, 0.4, 0.6, 0.2, 0.3, 0.3, 0.2, '{}', '2025-12-09 13:05:09.649668', 3);
INSERT INTO `courses_gradingpolicy` VALUES (2, 0.4, 0.6, 0.2, 0.3, 0.3, 0.2, '{}', '2025-12-28 04:10:49.460436', 4);

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `object_repr` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `action_flag` smallint UNSIGNED NOT NULL,
  `change_message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content_type_id` int NULL DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `django_admin_log_content_type_id_c4bce8eb_fk_django_co`(`content_type_id` ASC) USING BTREE,
  INDEX `django_admin_log_user_id_c564eba6_fk_users_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_users_user_id` FOREIGN KEY (`user_id`) REFERENCES `users_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_chk_1` CHECK (`action_flag` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_admin_log
-- ----------------------------
INSERT INTO `django_admin_log` VALUES (1, '2025-12-09 10:13:19.387696', '1', '用户', 1, '[{\"added\": {}}]', 3, 1);
INSERT INTO `django_admin_log` VALUES (2, '2025-12-09 10:13:23.108554', '1', '用户', 2, '[]', 3, 1);

-- ----------------------------
-- Table structure for django_celery_beat_clockedschedule
-- ----------------------------
DROP TABLE IF EXISTS `django_celery_beat_clockedschedule`;
CREATE TABLE `django_celery_beat_clockedschedule`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `clocked_time` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_celery_beat_clockedschedule
-- ----------------------------

-- ----------------------------
-- Table structure for django_celery_beat_crontabschedule
-- ----------------------------
DROP TABLE IF EXISTS `django_celery_beat_crontabschedule`;
CREATE TABLE `django_celery_beat_crontabschedule`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `minute` varchar(240) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `hour` varchar(96) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `day_of_week` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `day_of_month` varchar(124) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `month_of_year` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `timezone` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_celery_beat_crontabschedule
-- ----------------------------

-- ----------------------------
-- Table structure for django_celery_beat_intervalschedule
-- ----------------------------
DROP TABLE IF EXISTS `django_celery_beat_intervalschedule`;
CREATE TABLE `django_celery_beat_intervalschedule`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `every` int NOT NULL,
  `period` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_celery_beat_intervalschedule
-- ----------------------------

-- ----------------------------
-- Table structure for django_celery_beat_periodictask
-- ----------------------------
DROP TABLE IF EXISTS `django_celery_beat_periodictask`;
CREATE TABLE `django_celery_beat_periodictask`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `task` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `args` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `kwargs` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `queue` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `exchange` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `routing_key` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `expires` datetime(6) NULL DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL,
  `last_run_at` datetime(6) NULL DEFAULT NULL,
  `total_run_count` int UNSIGNED NOT NULL,
  `date_changed` datetime(6) NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `crontab_id` int NULL DEFAULT NULL,
  `interval_id` int NULL DEFAULT NULL,
  `solar_id` int NULL DEFAULT NULL,
  `one_off` tinyint(1) NOT NULL,
  `start_time` datetime(6) NULL DEFAULT NULL,
  `priority` int UNSIGNED NULL DEFAULT NULL,
  `headers` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `clocked_id` int NULL DEFAULT NULL,
  `expire_seconds` int UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE,
  INDEX `django_celery_beat_p_crontab_id_d3cba168_fk_django_ce`(`crontab_id` ASC) USING BTREE,
  INDEX `django_celery_beat_p_interval_id_a8ca27da_fk_django_ce`(`interval_id` ASC) USING BTREE,
  INDEX `django_celery_beat_p_solar_id_a87ce72c_fk_django_ce`(`solar_id` ASC) USING BTREE,
  INDEX `django_celery_beat_p_clocked_id_47a69f82_fk_django_ce`(`clocked_id` ASC) USING BTREE,
  CONSTRAINT `django_celery_beat_p_clocked_id_47a69f82_fk_django_ce` FOREIGN KEY (`clocked_id`) REFERENCES `django_celery_beat_clockedschedule` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_celery_beat_p_crontab_id_d3cba168_fk_django_ce` FOREIGN KEY (`crontab_id`) REFERENCES `django_celery_beat_crontabschedule` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_celery_beat_p_interval_id_a8ca27da_fk_django_ce` FOREIGN KEY (`interval_id`) REFERENCES `django_celery_beat_intervalschedule` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_celery_beat_p_solar_id_a87ce72c_fk_django_ce` FOREIGN KEY (`solar_id`) REFERENCES `django_celery_beat_solarschedule` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_celery_beat_periodictask_chk_1` CHECK (`total_run_count` >= 0),
  CONSTRAINT `django_celery_beat_periodictask_chk_2` CHECK (`priority` >= 0),
  CONSTRAINT `django_celery_beat_periodictask_chk_3` CHECK (`expire_seconds` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_celery_beat_periodictask
-- ----------------------------

-- ----------------------------
-- Table structure for django_celery_beat_periodictasks
-- ----------------------------
DROP TABLE IF EXISTS `django_celery_beat_periodictasks`;
CREATE TABLE `django_celery_beat_periodictasks`  (
  `ident` smallint NOT NULL,
  `last_update` datetime(6) NOT NULL,
  PRIMARY KEY (`ident`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_celery_beat_periodictasks
-- ----------------------------

-- ----------------------------
-- Table structure for django_celery_beat_solarschedule
-- ----------------------------
DROP TABLE IF EXISTS `django_celery_beat_solarschedule`;
CREATE TABLE `django_celery_beat_solarschedule`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `event` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `latitude` decimal(9, 6) NOT NULL,
  `longitude` decimal(9, 6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `django_celery_beat_solar_event_latitude_longitude_ba64999a_uniq`(`event` ASC, `latitude` ASC, `longitude` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_celery_beat_solarschedule
-- ----------------------------

-- ----------------------------
-- Table structure for django_celery_results_chordcounter
-- ----------------------------
DROP TABLE IF EXISTS `django_celery_results_chordcounter`;
CREATE TABLE `django_celery_results_chordcounter`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sub_tasks` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `count` int UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `group_id`(`group_id` ASC) USING BTREE,
  CONSTRAINT `django_celery_results_chordcounter_chk_1` CHECK (`count` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_celery_results_chordcounter
-- ----------------------------

-- ----------------------------
-- Table structure for django_celery_results_groupresult
-- ----------------------------
DROP TABLE IF EXISTS `django_celery_results_groupresult`;
CREATE TABLE `django_celery_results_groupresult`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `date_created` datetime(6) NOT NULL,
  `date_done` datetime(6) NOT NULL,
  `content_type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content_encoding` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `result` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `group_id`(`group_id` ASC) USING BTREE,
  INDEX `django_cele_date_cr_bd6c1d_idx`(`date_created` ASC) USING BTREE,
  INDEX `django_cele_date_do_caae0e_idx`(`date_done` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_celery_results_groupresult
-- ----------------------------

-- ----------------------------
-- Table structure for django_celery_results_taskresult
-- ----------------------------
DROP TABLE IF EXISTS `django_celery_results_taskresult`;
CREATE TABLE `django_celery_results_taskresult`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `task_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content_type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content_encoding` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `result` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `date_done` datetime(6) NOT NULL,
  `traceback` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `task_args` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `task_kwargs` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `task_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `worker` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `date_created` datetime(6) NOT NULL,
  `periodic_task_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `date_started` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `task_id`(`task_id` ASC) USING BTREE,
  INDEX `django_cele_task_na_08aec9_idx`(`task_name` ASC) USING BTREE,
  INDEX `django_cele_status_9b6201_idx`(`status` ASC) USING BTREE,
  INDEX `django_cele_worker_d54dd8_idx`(`worker` ASC) USING BTREE,
  INDEX `django_cele_date_cr_f04a50_idx`(`date_created` ASC) USING BTREE,
  INDEX `django_cele_date_do_f59aad_idx`(`date_done` ASC) USING BTREE,
  INDEX `django_cele_periodi_1993cf_idx`(`periodic_task_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_celery_results_taskresult
-- ----------------------------

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `django_content_type_app_label_model_76bd3d3b_uniq`(`app_label` ASC, `model` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
INSERT INTO `django_content_type` VALUES (1, 'admin', 'logentry');
INSERT INTO `django_content_type` VALUES (3, 'auth', 'group');
INSERT INTO `django_content_type` VALUES (2, 'auth', 'permission');
INSERT INTO `django_content_type` VALUES (4, 'contenttypes', 'contenttype');
INSERT INTO `django_content_type` VALUES (18, 'courses', 'course');
INSERT INTO `django_content_type` VALUES (19, 'courses', 'courseclass');
INSERT INTO `django_content_type` VALUES (20, 'courses', 'courseobjectiveachievement');
INSERT INTO `django_content_type` VALUES (21, 'courses', 'enrollment');
INSERT INTO `django_content_type` VALUES (22, 'courses', 'gradingpolicy');
INSERT INTO `django_content_type` VALUES (11, 'django_celery_beat', 'clockedschedule');
INSERT INTO `django_content_type` VALUES (6, 'django_celery_beat', 'crontabschedule');
INSERT INTO `django_content_type` VALUES (7, 'django_celery_beat', 'intervalschedule');
INSERT INTO `django_content_type` VALUES (8, 'django_celery_beat', 'periodictask');
INSERT INTO `django_content_type` VALUES (9, 'django_celery_beat', 'periodictasks');
INSERT INTO `django_content_type` VALUES (10, 'django_celery_beat', 'solarschedule');
INSERT INTO `django_content_type` VALUES (13, 'django_celery_results', 'chordcounter');
INSERT INTO `django_content_type` VALUES (14, 'django_celery_results', 'groupresult');
INSERT INTO `django_content_type` VALUES (12, 'django_celery_results', 'taskresult');
INSERT INTO `django_content_type` VALUES (27, 'scores', 'algorithmscore');
INSERT INTO `django_content_type` VALUES (26, 'scores', 'gradebook');
INSERT INTO `django_content_type` VALUES (25, 'scores', 'score');
INSERT INTO `django_content_type` VALUES (23, 'scores', 'scoreadjustment');
INSERT INTO `django_content_type` VALUES (24, 'scores', 'scoreimportlog');
INSERT INTO `django_content_type` VALUES (5, 'sessions', 'session');
INSERT INTO `django_content_type` VALUES (16, 'users', 'studentprofile');
INSERT INTO `django_content_type` VALUES (17, 'users', 'teacherprofile');
INSERT INTO `django_content_type` VALUES (15, 'users', 'user');

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 63 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_migrations
-- ----------------------------
INSERT INTO `django_migrations` VALUES (1, 'contenttypes', '0001_initial', '2025-12-09 08:45:33.868737');
INSERT INTO `django_migrations` VALUES (2, 'contenttypes', '0002_remove_content_type_name', '2025-12-09 08:47:35.598280');
INSERT INTO `django_migrations` VALUES (3, 'auth', '0001_initial', '2025-12-09 08:47:35.837961');
INSERT INTO `django_migrations` VALUES (4, 'auth', '0002_alter_permission_name_max_length', '2025-12-09 08:47:35.889494');
INSERT INTO `django_migrations` VALUES (5, 'auth', '0003_alter_user_email_max_length', '2025-12-09 08:47:35.895914');
INSERT INTO `django_migrations` VALUES (6, 'auth', '0004_alter_user_username_opts', '2025-12-09 08:47:35.903904');
INSERT INTO `django_migrations` VALUES (7, 'auth', '0005_alter_user_last_login_null', '2025-12-09 08:47:35.963208');
INSERT INTO `django_migrations` VALUES (8, 'auth', '0006_require_contenttypes_0002', '2025-12-09 08:47:35.966485');
INSERT INTO `django_migrations` VALUES (9, 'auth', '0007_alter_validators_add_error_messages', '2025-12-09 08:47:35.972846');
INSERT INTO `django_migrations` VALUES (10, 'auth', '0008_alter_user_username_max_length', '2025-12-09 08:47:35.978885');
INSERT INTO `django_migrations` VALUES (11, 'auth', '0009_alter_user_last_name_max_length', '2025-12-09 08:47:35.984639');
INSERT INTO `django_migrations` VALUES (12, 'auth', '0010_alter_group_name_max_length', '2025-12-09 08:47:36.001315');
INSERT INTO `django_migrations` VALUES (13, 'auth', '0011_update_proxy_permissions', '2025-12-09 08:47:36.007602');
INSERT INTO `django_migrations` VALUES (14, 'auth', '0012_alter_user_first_name_max_length', '2025-12-09 08:47:36.014829');
INSERT INTO `django_migrations` VALUES (15, 'users', '0001_initial', '2025-12-09 08:47:36.441750');
INSERT INTO `django_migrations` VALUES (16, 'admin', '0001_initial', '2025-12-09 08:48:46.020544');
INSERT INTO `django_migrations` VALUES (17, 'admin', '0002_logentry_remove_auto_add', '2025-12-09 08:48:46.084151');
INSERT INTO `django_migrations` VALUES (18, 'admin', '0003_logentry_add_action_flag_choices', '2025-12-09 08:48:46.094603');
INSERT INTO `django_migrations` VALUES (19, 'courses', '0001_initial', '2025-12-09 08:48:46.194857');
INSERT INTO `django_migrations` VALUES (20, 'scores', '0001_initial', '2025-12-09 08:48:46.309062');
INSERT INTO `django_migrations` VALUES (21, 'courses', '0002_initial', '2025-12-09 08:48:47.038848');
INSERT INTO `django_migrations` VALUES (22, 'django_celery_beat', '0001_initial', '2025-12-09 08:48:47.221924');
INSERT INTO `django_migrations` VALUES (23, 'django_celery_beat', '0002_auto_20161118_0346', '2025-12-09 08:48:47.302697');
INSERT INTO `django_migrations` VALUES (24, 'django_celery_beat', '0003_auto_20161209_0049', '2025-12-09 08:48:47.326895');
INSERT INTO `django_migrations` VALUES (25, 'django_celery_beat', '0004_auto_20170221_0000', '2025-12-09 08:48:47.331894');
INSERT INTO `django_migrations` VALUES (26, 'django_celery_beat', '0005_add_solarschedule_events_choices', '2025-12-09 08:48:47.338961');
INSERT INTO `django_migrations` VALUES (27, 'django_celery_beat', '0006_auto_20180322_0932', '2025-12-09 08:48:47.452687');
INSERT INTO `django_migrations` VALUES (28, 'django_celery_beat', '0007_auto_20180521_0826', '2025-12-09 08:48:47.566182');
INSERT INTO `django_migrations` VALUES (29, 'django_celery_beat', '0008_auto_20180914_1922', '2025-12-09 08:48:47.604117');
INSERT INTO `django_migrations` VALUES (30, 'django_celery_beat', '0006_auto_20180210_1226', '2025-12-09 08:48:47.628354');
INSERT INTO `django_migrations` VALUES (31, 'django_celery_beat', '0006_periodictask_priority', '2025-12-09 08:48:47.704051');
INSERT INTO `django_migrations` VALUES (32, 'django_celery_beat', '0009_periodictask_headers', '2025-12-09 08:48:47.777571');
INSERT INTO `django_migrations` VALUES (33, 'django_celery_beat', '0010_auto_20190429_0326', '2025-12-09 08:48:47.995481');
INSERT INTO `django_migrations` VALUES (34, 'django_celery_beat', '0011_auto_20190508_0153', '2025-12-09 08:48:48.083830');
INSERT INTO `django_migrations` VALUES (35, 'django_celery_beat', '0012_periodictask_expire_seconds', '2025-12-09 08:48:48.156739');
INSERT INTO `django_migrations` VALUES (36, 'django_celery_beat', '0013_auto_20200609_0727', '2025-12-09 08:48:48.170046');
INSERT INTO `django_migrations` VALUES (37, 'django_celery_beat', '0014_remove_clockedschedule_enabled', '2025-12-09 08:48:48.214989');
INSERT INTO `django_migrations` VALUES (38, 'django_celery_beat', '0015_edit_solarschedule_events_choices', '2025-12-09 08:48:48.220043');
INSERT INTO `django_migrations` VALUES (39, 'django_celery_beat', '0016_alter_crontabschedule_timezone', '2025-12-09 08:48:48.234455');
INSERT INTO `django_migrations` VALUES (40, 'django_celery_beat', '0017_alter_crontabschedule_month_of_year', '2025-12-09 08:48:48.245874');
INSERT INTO `django_migrations` VALUES (41, 'django_celery_beat', '0018_improve_crontab_helptext', '2025-12-09 08:48:48.256615');
INSERT INTO `django_migrations` VALUES (42, 'django_celery_beat', '0019_alter_periodictasks_options', '2025-12-09 08:48:48.261551');
INSERT INTO `django_migrations` VALUES (43, 'django_celery_results', '0001_initial', '2025-12-09 08:48:48.303063');
INSERT INTO `django_migrations` VALUES (44, 'django_celery_results', '0002_add_task_name_args_kwargs', '2025-12-09 08:48:48.425547');
INSERT INTO `django_migrations` VALUES (45, 'django_celery_results', '0003_auto_20181106_1101', '2025-12-09 08:48:48.430780');
INSERT INTO `django_migrations` VALUES (46, 'django_celery_results', '0004_auto_20190516_0412', '2025-12-09 08:48:48.505150');
INSERT INTO `django_migrations` VALUES (47, 'django_celery_results', '0005_taskresult_worker', '2025-12-09 08:48:48.568934');
INSERT INTO `django_migrations` VALUES (48, 'django_celery_results', '0006_taskresult_date_created', '2025-12-09 08:48:48.668890');
INSERT INTO `django_migrations` VALUES (49, 'django_celery_results', '0007_remove_taskresult_hidden', '2025-12-09 08:48:48.715511');
INSERT INTO `django_migrations` VALUES (50, 'django_celery_results', '0008_chordcounter', '2025-12-09 08:48:48.738888');
INSERT INTO `django_migrations` VALUES (51, 'django_celery_results', '0009_groupresult', '2025-12-09 08:48:49.028054');
INSERT INTO `django_migrations` VALUES (52, 'django_celery_results', '0010_remove_duplicate_indices', '2025-12-09 08:48:49.040371');
INSERT INTO `django_migrations` VALUES (53, 'django_celery_results', '0011_taskresult_periodic_task_name', '2025-12-09 08:48:49.089851');
INSERT INTO `django_migrations` VALUES (54, 'django_celery_results', '0012_taskresult_date_started', '2025-12-09 08:48:49.148614');
INSERT INTO `django_migrations` VALUES (55, 'django_celery_results', '0013_taskresult_django_cele_periodi_1993cf_idx', '2025-12-09 08:48:49.172716');
INSERT INTO `django_migrations` VALUES (56, 'django_celery_results', '0014_alter_taskresult_status', '2025-12-09 08:48:49.177867');
INSERT INTO `django_migrations` VALUES (57, 'scores', '0002_initial', '2025-12-09 08:48:49.823796');
INSERT INTO `django_migrations` VALUES (58, 'sessions', '0001_initial', '2025-12-09 08:48:49.864072');
INSERT INTO `django_migrations` VALUES (59, 'scores', '0003_gradebook', '2026-01-08 10:31:00.660255');
INSERT INTO `django_migrations` VALUES (60, 'scores', '0004_algorithmscore', '2026-01-09 03:24:38.493783');
INSERT INTO `django_migrations` VALUES (61, 'scores', '0005_algorithmscore_raw_paper_scores', '2026-01-09 08:43:40.610539');
INSERT INTO `django_migrations` VALUES (62, 'courses', '0003_add_m_calculation_config', '2026-01-10 04:18:41.313707');

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session`  (
  `session_key` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `session_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`) USING BTREE,
  INDEX `django_session_expire_date_a5c62663`(`expire_date` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_session
-- ----------------------------
INSERT INTO `django_session` VALUES ('9bxo7y77ctuign73eg6ypot4w3w3kjo5', '.eJxVjDsKwzAQRO-iOgj98Mop0-cMYlcrRU6CBJZdmdw9NrhIqoF5b2YTAdelhLWnOUwsrkKLy29HGF-pHoCfWB9NxlaXeSJ5KPKkXd4bp_ftdP8OCvayrwGJdDJAPHhPezoLbKw3SMoxaNTZRWdAj0xeeTVYyDnBaFzGCIrE5wvijzfL:1vSudf:tTDuq1_JNjk0pVMO5p9sTQi0wc55cRvm5ZFnTNhRAfw', '2025-12-23 10:08:11.892289');

-- ----------------------------
-- Table structure for scores_algorithmscore
-- ----------------------------
DROP TABLE IF EXISTS `scores_algorithmscore`;
CREATE TABLE `scores_algorithmscore`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `class_performance` double NULL DEFAULT NULL,
  `note_score` double NULL DEFAULT NULL,
  `homework_avg` double NULL DEFAULT NULL,
  `experiment_avg` double NULL DEFAULT NULL,
  `usual_score` double NULL DEFAULT NULL,
  `M1` double NULL DEFAULT NULL,
  `M2` double NULL DEFAULT NULL,
  `M3` double NULL DEFAULT NULL,
  `M4` double NULL DEFAULT NULL,
  `final_paper_score` double NULL DEFAULT NULL,
  `obj1_classroom` double NULL DEFAULT NULL,
  `obj1_note` double NULL DEFAULT NULL,
  `obj1_homework` double NULL DEFAULT NULL,
  `obj1_experiment` double NULL DEFAULT NULL,
  `obj1_final` double NULL DEFAULT NULL,
  `obj1_achievement` double NULL DEFAULT NULL,
  `obj1_degree` double NULL DEFAULT NULL,
  `obj2_classroom` double NULL DEFAULT NULL,
  `obj2_note` double NULL DEFAULT NULL,
  `obj2_homework` double NULL DEFAULT NULL,
  `obj2_experiment` double NULL DEFAULT NULL,
  `obj2_final` double NULL DEFAULT NULL,
  `obj2_achievement` double NULL DEFAULT NULL,
  `obj2_degree` double NULL DEFAULT NULL,
  `obj3_classroom` double NULL DEFAULT NULL,
  `obj3_note` double NULL DEFAULT NULL,
  `obj3_homework` double NULL DEFAULT NULL,
  `obj3_experiment` double NULL DEFAULT NULL,
  `obj3_final` double NULL DEFAULT NULL,
  `obj3_achievement` double NULL DEFAULT NULL,
  `obj3_degree` double NULL DEFAULT NULL,
  `obj4_classroom` double NULL DEFAULT NULL,
  `obj4_note` double NULL DEFAULT NULL,
  `obj4_homework` double NULL DEFAULT NULL,
  `obj4_experiment` double NULL DEFAULT NULL,
  `obj4_final` double NULL DEFAULT NULL,
  `obj4_achievement` double NULL DEFAULT NULL,
  `obj4_degree` double NULL DEFAULT NULL,
  `total_score` double NULL DEFAULT NULL,
  `usual_entry` double NULL DEFAULT NULL,
  `final_entry` double NULL DEFAULT NULL,
  `final_grade` double NULL DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `course_class_id` bigint NOT NULL,
  `created_by_id` bigint NULL DEFAULT NULL,
  `gradebook_id` bigint NOT NULL,
  `student_id` bigint NOT NULL,
  `updated_by_id` bigint NULL DEFAULT NULL,
  `raw_paper_scores` json NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `gradebook_id`(`gradebook_id` ASC) USING BTREE,
  UNIQUE INDEX `scores_algorithmscore_student_id_course_class_id_4696757f_uniq`(`student_id` ASC, `course_class_id` ASC) USING BTREE,
  INDEX `scores_algorithmscor_course_class_id_3882163b_fk_courses_c`(`course_class_id` ASC) USING BTREE,
  INDEX `scores_algorithmscore_created_by_id_64fc81f3_fk_users_user_id`(`created_by_id` ASC) USING BTREE,
  INDEX `scores_algorithmscore_updated_by_id_5e25a0b6_fk_users_user_id`(`updated_by_id` ASC) USING BTREE,
  CONSTRAINT `scores_algorithmscor_course_class_id_3882163b_fk_courses_c` FOREIGN KEY (`course_class_id`) REFERENCES `courses_courseclass` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `scores_algorithmscor_gradebook_id_f418f87e_fk_scores_gr` FOREIGN KEY (`gradebook_id`) REFERENCES `scores_gradebook` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `scores_algorithmscore_created_by_id_64fc81f3_fk_users_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `users_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `scores_algorithmscore_student_id_ed97e516_fk_users_user_id` FOREIGN KEY (`student_id`) REFERENCES `users_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `scores_algorithmscore_updated_by_id_5e25a0b6_fk_users_user_id` FOREIGN KEY (`updated_by_id`) REFERENCES `users_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 144 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of scores_algorithmscore
-- ----------------------------
INSERT INTO `scores_algorithmscore` VALUES (1, 100, 85, 86, 86.5, 88, 21, 1, 19, 0, 41, 2, 1.7, 3.44, 0, 12.6, 19.74, 0.68, 1.5, 1.27, 2.58, 6.92, 0.6, 12.87, 0.49, 1.5, 1.27, 2.58, 3.46, 10.1, 18.91, 0.61, 0, 0, 0, 6.92, 0, 6.92, 0.49, 60, 88, 41, 60, '2026-01-09 03:25:48.405259', '2026-01-10 05:51:21.465673', 4, 1, 1, 93, 1, '{\"一\": {\"total\": 10.0}, \"三\": {\"1\": 11.0, \"2.0\": 9.0, \"3.0\": 10.0}, \"二\": {\"1\": 0.0, \"2.0\": 1.0, \"3.0\": 0.0}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 41.0}}');
INSERT INTO `scores_algorithmscore` VALUES (2, 96, 70, 78, 80, 80, 31, 10, 25, 0, 66, 1.92, 1.4, 3.12, 0, 18.6, 25.04, 0.86, 1.44, 1.05, 2.34, 6.4, 6, 17.23, 0.66, 1.44, 1.05, 2.34, 3.2, 13.29, 21.32, 0.69, 0, 0, 0, 6.4, 0, 6.4, 0.46, 72, 80, 66, 72, '2026-01-09 03:25:48.419093', '2026-01-10 05:51:21.472721', 4, 1, 2, 94, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2.0\": 15.0, \"3.0\": 10.0}, \"二\": {\"1\": 0.0, \"2.0\": 0.0, \"3.0\": 10.0}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 66.0}}');
INSERT INTO `scores_algorithmscore` VALUES (3, 100, 85, 90, 75, 83, 31, 5, 31, 10, 77, 2, 1.7, 3.6, 0, 18.6, 25.9, 0.89, 1.5, 1.27, 2.7, 6, 3, 14.47, 0.56, 1.5, 1.27, 2.7, 3, 16.47, 24.94, 0.8, 0, 0, 0, 6, 6, 12, 0.86, 79, 83, 77, 79, '2026-01-09 03:25:48.430406', '2026-01-10 05:51:21.481437', 4, 1, 3, 95, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2.0\": 15.0, \"3.0\": 11.0}, \"二\": {\"1\": 5.0, \"2.0\": 0.0, \"3.0\": 5.0}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 77.0}}');
INSERT INTO `scores_algorithmscore` VALUES (4, 100, 75, 85, 80, 83, 25, 10, 24, 3, 62, 2, 1.5, 3.4, 0, 15, 21.9, 0.76, 1.5, 1.12, 2.55, 6.4, 6, 17.57, 0.68, 1.5, 1.12, 2.55, 3.2, 12.75, 21.12, 0.68, 0, 0, 0, 6.4, 1.8, 8.2, 0.59, 70, 83, 62, 70, '2026-01-09 03:25:48.440538', '2026-01-10 05:51:21.490906', 4, 1, 4, 96, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 11.0, \"2.0\": 9.0, \"3.0\": 10.0}, \"二\": {\"1\": 5.0, \"2.0\": 0.0, \"3.0\": 10.0}, \"四\": {\"total\": 3.0}, \"卷面\": {\"total\": 62.0}}');
INSERT INTO `scores_algorithmscore` VALUES (5, 100, 95, 94, 90, 93, 27, 20, 25, 8, 80, 2, 1.9, 3.76, 0, 16.2, 23.86, 0.82, 1.5, 1.43, 2.82, 7.2, 12, 24.95, 0.96, 1.5, 1.43, 2.82, 3.6, 13.29, 22.64, 0.73, 0, 0, 0, 7.2, 4.8, 12, 0.86, 85, 93, 80, 85, '2026-01-09 03:25:48.450184', '2026-01-10 05:51:21.498068', 4, 1, 5, 97, 1, '{\"一\": {\"total\": 12.0}, \"三\": {\"1\": 15.0, \"2.0\": 15.0, \"3.0\": 10.0}, \"二\": {\"1\": 0.0, \"2.0\": 10.0, \"3.0\": 10.0}, \"四\": {\"total\": 8.0}, \"卷面\": {\"total\": 80.0}}');
INSERT INTO `scores_algorithmscore` VALUES (6, 100, 95, 88, 82.5, 88, 27, 12, 19, 5, 63, 2, 1.9, 3.52, 0, 16.2, 23.62, 0.81, 1.5, 1.43, 2.64, 6.6, 7.2, 19.37, 0.74, 1.5, 1.43, 2.64, 3.3, 10.1, 18.97, 0.61, 0, 0, 0, 6.6, 3, 9.6, 0.69, 73, 88, 63, 73, '2026-01-09 03:25:48.461956', '2026-01-10 05:51:21.504359', 4, 1, 6, 98, 1, '{\"一\": {\"total\": 12.0}, \"三\": {\"1\": 15.0, \"2.0\": 15.0, \"3.0\": 4.0}, \"二\": {\"1\": 0.0, \"2.0\": 2.0, \"3.0\": 10.0}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 63.0}}');
INSERT INTO `scores_algorithmscore` VALUES (7, 96, 80, 90, 77.5, 83, 33, 10, 25, 0, 68, 1.92, 1.6, 3.6, 0, 19.8, 26.92, 0.93, 1.44, 1.2, 2.7, 6.2, 6, 17.54, 0.67, 1.44, 1.2, 2.7, 3.1, 13.29, 21.73, 0.7, 0, 0, 0, 6.2, 0, 6.2, 0.44, 74, 83, 68, 74, '2026-01-09 03:25:48.472387', '2026-01-10 05:51:21.513119', 4, 1, 7, 99, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 15.0, \"2.0\": 15.0, \"3.0\": 10.0}, \"二\": {\"1\": 0.0, \"2.0\": 0.0, \"3.0\": 10.0}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 68.0}}');
INSERT INTO `scores_algorithmscore` VALUES (8, 100, 90, 88, 72.5, 82, 35, 14, 30, 5, 84, 2, 1.8, 3.52, 0, 21, 28.32, 0.98, 1.5, 1.35, 2.64, 5.8, 8.4, 19.69, 0.76, 1.5, 1.35, 2.64, 2.9, 15.94, 24.33, 0.78, 0, 0, 0, 5.8, 3, 8.8, 0.63, 83, 82, 84, 83, '2026-01-09 03:25:48.483060', '2026-01-10 05:51:21.521637', 4, 1, 8, 100, 1, '{\"一\": {\"total\": 20.0}, \"三\": {\"1\": 15.0, \"2.0\": 15.0, \"3.0\": 10.0}, \"二\": {\"1\": 5.0, \"2.0\": 4.0, \"3.0\": 10.0}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 84.0}}');
INSERT INTO `scores_algorithmscore` VALUES (9, 96, 85, 86, 75, 82, 8, 12, 20, 0, 40, 1.92, 1.7, 3.44, 0, 4.8, 11.86, 0.41, 1.44, 1.27, 2.58, 6, 7.2, 18.49, 0.71, 1.44, 1.27, 2.58, 3, 10.63, 18.92, 0.61, 0, 0, 0, 6, 0, 6, 0.43, 57, 82, 40, 57, '2026-01-09 03:25:48.494976', '2026-01-10 05:51:21.530003', 4, 1, 9, 101, 1, '{\"一\": {\"total\": 8.0}, \"三\": {\"1\": 0.0, \"2.0\": 15.0, \"3.0\": 0.0}, \"二\": {\"1\": 5.0, \"2.0\": 2.0, \"3.0\": 10.0}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 40.0}}');
INSERT INTO `scores_algorithmscore` VALUES (10, 96, 90, 90, 90, 91, 27, 20, 30, 0, 77, 1.92, 1.8, 3.6, 0, 16.2, 23.52, 0.81, 1.44, 1.35, 2.7, 7.2, 12, 24.69, 0.95, 1.44, 1.35, 2.7, 3.6, 15.94, 25.03, 0.81, 0, 0, 0, 7.2, 0, 7.2, 0.51, 83, 91, 77, 83, '2026-01-09 03:25:48.504599', '2026-01-10 05:51:21.538377', 4, 1, 10, 102, 1, '{\"一\": {\"total\": 12.0}, \"三\": {\"1\": 15.0, \"2.0\": 15.0, \"3.0\": 10.0}, \"二\": {\"1\": 5.0, \"2.0\": 10.0, \"3.0\": 10.0}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 77.0}}');
INSERT INTO `scores_algorithmscore` VALUES (11, 100, 75, 88, 80, 84, 31, 6, 25, 10, 72, 2, 1.5, 3.52, 0, 18.6, 25.62, 0.88, 1.5, 1.12, 2.64, 6.4, 3.6, 15.26, 0.59, 1.5, 1.12, 2.64, 3.2, 13.29, 21.75, 0.7, 0, 0, 0, 6.4, 6, 12.4, 0.89, 77, 84, 72, 77, '2026-01-09 03:25:48.515615', '2026-01-10 05:51:21.547137', 4, 1, 11, 103, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2.0\": 15.0, \"3.0\": 10.0}, \"二\": {\"1\": 0.0, \"2.0\": 2.0, \"3.0\": 4.0}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 72.0}}');
INSERT INTO `scores_algorithmscore` VALUES (12, 96, 88, 92, 80, 86, 31, 14, 35, 10, 90, 1.92, 1.76, 3.68, 0, 18.6, 25.96, 0.9, 1.44, 1.32, 2.76, 6.4, 8.4, 20.32, 0.78, 1.44, 1.32, 2.76, 3.2, 18.6, 27.32, 0.88, 0, 0, 0, 6.4, 6, 12.4, 0.89, 88, 86, 90, 88, '2026-01-09 03:25:48.526695', '2026-01-10 05:51:21.553979', 4, 1, 12, 104, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2.0\": 15.0, \"3.0\": 15.0}, \"二\": {\"1\": 5.0, \"2.0\": 4.0, \"3.0\": 10.0}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 90.0}}');
INSERT INTO `scores_algorithmscore` VALUES (13, 100, 85, 96, 87.5, 91, 29, 4, 31, 2, 66, 2, 1.7, 3.84, 0, 17.4, 24.94, 0.86, 1.5, 1.27, 2.88, 7, 2.4, 15.05, 0.58, 1.5, 1.27, 2.88, 3.5, 16.47, 25.62, 0.83, 0, 0, 0, 7, 1.2, 8.2, 0.59, 76, 91, 66, 76, '2026-01-09 03:25:48.538125', '2026-01-10 05:51:21.560879', 4, 1, 13, 105, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 15.0, \"2.0\": 15.0, \"3.0\": 11.0}, \"二\": {\"1\": 5.0, \"2.0\": 4.0, \"3.0\": 0.0}, \"四\": {\"total\": 2.0}, \"卷面\": {\"total\": 66.0}}');
INSERT INTO `scores_algorithmscore` VALUES (14, 100, 90, 91, 92.5, 93, 33, 12, 34, 5, 84, 2, 1.8, 3.64, 0, 19.8, 27.24, 0.94, 1.5, 1.35, 2.73, 7.4, 7.2, 20.18, 0.78, 1.5, 1.35, 2.73, 3.7, 18.07, 27.35, 0.88, 0, 0, 0, 7.4, 3, 10.4, 0.74, 88, 93, 84, 88, '2026-01-09 03:25:48.549607', '2026-01-10 05:51:21.569173', 4, 1, 14, 106, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 15.0, \"2.0\": 15.0, \"3.0\": 14.0}, \"二\": {\"1\": 5.0, \"2.0\": 4.0, \"3.0\": 8.0}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 84.0}}');
INSERT INTO `scores_algorithmscore` VALUES (15, 100, 65, 76, 72.5, 76, 25, 15, 21, 2, 63, 2, 1.3, 3.04, 0, 15, 21.34, 0.74, 1.5, 0.97, 2.28, 5.8, 9, 19.55, 0.75, 1.5, 0.97, 2.28, 2.9, 11.16, 18.81, 0.61, 0, 0, 0, 5.8, 1.2, 7, 0.5, 68, 76, 63, 68, '2026-01-09 03:25:48.560842', '2026-01-10 05:51:21.577529', 4, 1, 15, 107, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 11.0, \"2.0\": 9.0, \"3.0\": 12.0}, \"二\": {\"1\": 0.0, \"2.0\": 10.0, \"3.0\": 5.0}, \"四\": {\"total\": 2.0}, \"卷面\": {\"total\": 63.0}}');
INSERT INTO `scores_algorithmscore` VALUES (16, 100, 95, 93, 100, 98, 35, 17, 26, 10, 88, 2, 1.9, 3.72, 0, 21, 28.62, 0.99, 1.5, 1.43, 2.79, 8, 10.2, 23.92, 0.92, 1.5, 1.43, 2.79, 4, 13.82, 23.54, 0.76, 0, 0, 0, 8, 6, 14, 1, 92, 98, 88, 92, '2026-01-09 03:25:48.570277', '2026-01-10 05:51:21.585184', 4, 1, 16, 108, 1, '{\"一\": {\"total\": 20.0}, \"三\": {\"1\": 15.0, \"2.0\": 6.0, \"3.0\": 15.0}, \"二\": {\"1\": 5.0, \"2.0\": 7.0, \"3.0\": 10.0}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 88.0}}');
INSERT INTO `scores_algorithmscore` VALUES (17, 100, 90, 91, 100, 96, 33, 7, 30, 6, 76, 2, 1.8, 3.64, 0, 19.8, 27.24, 0.94, 1.5, 1.35, 2.73, 8, 4.2, 17.78, 0.68, 1.5, 1.35, 2.73, 4, 15.94, 25.52, 0.82, 0, 0, 0, 8, 3.6, 11.6, 0.83, 84, 96, 76, 84, '2026-01-09 03:25:48.581930', '2026-01-10 05:51:21.594047', 4, 1, 17, 109, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 15.0, \"2.0\": 15.0, \"3.0\": 10.0}, \"二\": {\"1\": 5.0, \"2.0\": 4.0, \"3.0\": 3.0}, \"四\": {\"total\": 6.0}, \"卷面\": {\"total\": 76.0}}');
INSERT INTO `scores_algorithmscore` VALUES (18, 100, 80, 85, 82.5, 85, 25, 20, 24, 5, 74, 2, 1.6, 3.4, 0, 15, 22, 0.76, 1.5, 1.2, 2.55, 6.6, 12, 23.85, 0.92, 1.5, 1.2, 2.55, 3.3, 12.75, 21.3, 0.69, 0, 0, 0, 6.6, 3, 9.6, 0.69, 78, 85, 74, 78, '2026-01-09 03:25:48.593665', '2026-01-10 05:51:21.601938', 4, 1, 18, 110, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 11.0, \"2.0\": 9.0, \"3.0\": 10.0}, \"二\": {\"1\": 5.0, \"2.0\": 10.0, \"3.0\": 10.0}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 74.0}}');
INSERT INTO `scores_algorithmscore` VALUES (19, 100, 90, 93, 92.5, 93, 23, 4, 21, 2, 50, 2, 1.8, 3.72, 0, 13.8, 21.32, 0.74, 1.5, 1.35, 2.79, 7.4, 2.4, 15.44, 0.59, 1.5, 1.35, 2.79, 3.7, 11.16, 20.5, 0.66, 0, 0, 0, 7.4, 1.2, 8.6, 0.61, 67, 93, 50, 67, '2026-01-09 03:25:48.604842', '2026-01-10 05:51:21.609288', 4, 1, 19, 111, 1, '{\"一\": {\"total\": 12.0}, \"三\": {\"1\": 11.0, \"2.0\": 15.0, \"3.0\": 1.0}, \"二\": {\"1\": 5.0, \"2.0\": 4.0, \"3.0\": 0.0}, \"四\": {\"total\": 2.0}, \"卷面\": {\"total\": 50.0}}');
INSERT INTO `scores_algorithmscore` VALUES (20, 100, 70, 85, 82.5, 84, 25, 14, 21, 0, 60, 2, 1.4, 3.4, 0, 15, 21.8, 0.75, 1.5, 1.05, 2.55, 6.6, 8.4, 20.1, 0.77, 1.5, 1.05, 2.55, 3.3, 11.16, 19.56, 0.63, 0, 0, 0, 6.6, 0, 6.6, 0.47, 70, 84, 60, 70, '2026-01-09 03:25:48.615388', '2026-01-10 05:51:21.616633', 4, 1, 20, 112, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 11.0, \"2.0\": 6.0, \"3.0\": 10.0}, \"二\": {\"1\": 5.0, \"2.0\": 4.0, \"3.0\": 10.0}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 60.0}}');
INSERT INTO `scores_algorithmscore` VALUES (21, 100, 75, 78, 75, 79, 20, 14, 27, 5, 66, 2, 1.5, 3.12, 0, 12, 18.62, 0.64, 1.5, 1.12, 2.34, 6, 8.4, 19.36, 0.74, 1.5, 1.12, 2.34, 3, 14.35, 22.31, 0.72, 0, 0, 0, 6, 3, 9, 0.64, 71, 79, 66, 71, '2026-01-09 03:25:48.625950', '2026-01-10 05:51:21.624663', 4, 1, 21, 113, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 6.0, \"2.0\": 15.0, \"3.0\": 12.0}, \"二\": {\"1\": 0.0, \"2.0\": 4.0, \"3.0\": 10.0}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 66.0}}');
INSERT INTO `scores_algorithmscore` VALUES (22, 100, 85, 92, 77.5, 85, 31, 12, 19, 9, 71, 2, 1.7, 3.68, 0, 18.6, 25.98, 0.9, 1.5, 1.27, 2.76, 6.2, 7.2, 18.93, 0.73, 1.5, 1.27, 2.76, 3.1, 10.1, 18.73, 0.6, 0, 0, 0, 6.2, 5.4, 11.6, 0.83, 77, 85, 71, 77, '2026-01-09 03:25:48.636748', '2026-01-10 05:51:21.632671', 4, 1, 22, 114, 1, '{\"一\": {\"total\": 20.0}, \"三\": {\"1\": 11.0, \"2.0\": 15.0, \"3.0\": 4.0}, \"二\": {\"1\": 0.0, \"2.0\": 2.0, \"3.0\": 10.0}, \"四\": {\"total\": 9.0}, \"卷面\": {\"total\": 71.0}}');
INSERT INTO `scores_algorithmscore` VALUES (23, 100, 95, 100, 100, 99, 35, 15, 33, 10, 93, 2, 1.9, 4, 0, 21, 28.9, 1, 1.5, 1.43, 3, 8, 9, 22.93, 0.88, 1.5, 1.43, 3, 4, 17.54, 27.47, 0.89, 0, 0, 0, 8, 6, 14, 1, 95, 99, 93, 95, '2026-01-09 03:25:48.648850', '2026-01-10 05:51:21.640960', 4, 1, 23, 115, 1, '{\"一\": {\"total\": 20.0}, \"三\": {\"1\": 15.0, \"2.0\": 14.0, \"3.0\": 14.0}, \"二\": {\"1\": 5.0, \"2.0\": 5.0, \"3.0\": 10.0}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 93.0}}');
INSERT INTO `scores_algorithmscore` VALUES (24, 100, 90, 94, 90, 92, 16, 4, 25, 4, 49, 2, 1.8, 3.76, 0, 9.6, 17.16, 0.59, 1.5, 1.35, 2.82, 7.2, 2.4, 15.27, 0.59, 1.5, 1.35, 2.82, 3.6, 13.29, 22.56, 0.73, 0, 0, 0, 7.2, 2.4, 9.6, 0.69, 66, 92, 49, 66, '2026-01-09 03:25:48.658792', '2026-01-10 05:51:21.649432', 4, 1, 24, 116, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 0.0, \"2.0\": 15.0, \"3.0\": 10.0}, \"二\": {\"1\": 0.0, \"2.0\": 4.0, \"3.0\": 0.0}, \"四\": {\"total\": 4.0}, \"卷面\": {\"total\": 49.0}}');
INSERT INTO `scores_algorithmscore` VALUES (25, 100, 90, 81, 80, 84, 12, 14, 20, 5, 51, 2, 1.8, 3.24, 0, 7.2, 14.24, 0.49, 1.5, 1.35, 2.43, 6.4, 8.4, 20.08, 0.77, 1.5, 1.35, 2.43, 3.2, 10.63, 19.11, 0.62, 0, 0, 0, 6.4, 3, 9.4, 0.67, 64, 84, 51, 64, '2026-01-09 03:25:48.668735', '2026-01-10 05:51:21.656625', 4, 1, 25, 117, 1, '{\"一\": {\"total\": 12.0}, \"三\": {\"1\": 0.0, \"2.0\": 15.0, \"3.0\": 0.0}, \"二\": {\"1\": 5.0, \"2.0\": 4.0, \"3.0\": 10.0}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 51.0}}');
INSERT INTO `scores_algorithmscore` VALUES (26, 100, 78, 90, 82.5, 86, 25, 14, 31, 0, 70, 2, 1.56, 3.6, 0, 15, 22.16, 0.76, 1.5, 1.17, 2.7, 6.6, 8.4, 20.37, 0.78, 1.5, 1.17, 2.7, 3.3, 16.47, 25.14, 0.81, 0, 0, 0, 6.6, 0, 6.6, 0.47, 76, 86, 70, 76, '2026-01-09 03:25:48.678456', '2026-01-10 05:51:21.666340', 4, 1, 26, 118, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 11.0, \"2.0\": 15.0, \"3.0\": 11.0}, \"二\": {\"1\": 5.0, \"2.0\": 4.0, \"3.0\": 10.0}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 70.0}}');
INSERT INTO `scores_algorithmscore` VALUES (27, 100, 95, 95, 92.5, 94, 33, 16, 34, 10, 93, 2, 1.9, 3.8, 0, 19.8, 27.5, 0.95, 1.5, 1.43, 2.85, 7.4, 9.6, 22.78, 0.88, 1.5, 1.43, 2.85, 3.7, 18.07, 27.55, 0.89, 0, 0, 0, 7.4, 6, 13.4, 0.96, 93, 94, 93, 93, '2026-01-09 03:25:48.688788', '2026-01-10 05:51:21.674967', 4, 1, 27, 119, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 15.0, \"2.0\": 15.0, \"3.0\": 14.0}, \"二\": {\"1\": 5.0, \"2.0\": 6.0, \"3.0\": 10.0}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 93.0}}');
INSERT INTO `scores_algorithmscore` VALUES (28, 100, 98, 93, 100, 98, 31, 20, 35, 8, 94, 2, 1.96, 3.72, 0, 18.6, 26.28, 0.91, 1.5, 1.47, 2.79, 8, 12, 25.76, 0.99, 1.5, 1.47, 2.79, 4, 18.6, 28.36, 0.91, 0, 0, 0, 8, 4.8, 12.8, 0.91, 96, 98, 94, 96, '2026-01-09 10:42:26.292663', '2026-01-10 05:27:16.813605', 5, NULL, 28, 120, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 15.0}, \"二\": {\"1\": 5.0, \"2\": 10.0, \"3\": 10.0}, \"四\": {\"total\": 8.0}, \"卷面\": {\"total\": 94.0}}');
INSERT INTO `scores_algorithmscore` VALUES (29, 100, 85, 84, 85, 87, 33, 18, 35, 10, 96, 2, 1.7, 3.36, 0, 19.8, 26.86, 0.93, 1.5, 1.27, 2.52, 6.8, 10.8, 22.89, 0.88, 1.5, 1.27, 2.52, 3.4, 18.6, 27.29, 0.88, 0, 0, 0, 6.8, 6, 12.8, 0.91, 92, 87, 96, 92, '2026-01-09 10:42:26.314394', '2026-01-10 05:27:16.824431', 5, NULL, 29, 121, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 15.0}, \"二\": {\"1\": 5.0, \"2\": 8.0, \"3\": 10.0}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 96.0}}');
INSERT INTO `scores_algorithmscore` VALUES (30, 100, 75, 99, 100, 97, 33, 12, 33, 4, 82, 2, 1.5, 3.96, 0, 19.8, 27.26, 0.94, 1.5, 1.12, 2.97, 8, 7.2, 20.79, 0.8, 1.5, 1.12, 2.97, 4, 17.54, 27.13, 0.88, 0, 0, 0, 8, 2.4, 10.4, 0.74, 88, 97, 82, 88, '2026-01-09 10:42:26.332083', '2026-01-10 05:27:16.827545', 5, NULL, 30, 122, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 13.0}, \"二\": {\"1\": 5.0, \"2\": 2.0, \"3\": 10.0}, \"四\": {\"total\": 4.0}, \"卷面\": {\"total\": 82.0}}');
INSERT INTO `scores_algorithmscore` VALUES (31, 100, 80, 96, 92.5, 93, 31, 9, 29, 9, 78, 2, 1.6, 3.84, 0, 18.6, 26.04, 0.9, 1.5, 1.2, 2.88, 7.4, 5.4, 18.38, 0.71, 1.5, 1.2, 2.88, 3.7, 15.41, 24.69, 0.8, 0, 0, 0, 7.4, 5.4, 12.8, 0.91, 84, 93, 78, 84, '2026-01-09 10:42:26.348025', '2026-01-10 05:27:16.832200', 5, NULL, 31, 123, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2\": 13.0, \"3\": 14.0}, \"二\": {\"1\": 2.0, \"2\": 4.0, \"3\": 5.0}, \"四\": {\"total\": 9.0}, \"卷面\": {\"total\": 78.0}}');
INSERT INTO `scores_algorithmscore` VALUES (32, 100, 80, 98, 87.5, 91, 33, 16, 29, 10, 88, 2, 1.6, 3.92, 0, 19.8, 27.32, 0.94, 1.5, 1.2, 2.94, 7, 9.6, 22.24, 0.86, 1.5, 1.2, 2.94, 3.5, 15.41, 24.55, 0.79, 0, 0, 0, 7, 6, 13, 0.93, 89, 91, 88, 89, '2026-01-09 10:42:26.363894', '2026-01-10 05:27:16.835413', 5, NULL, 32, 124, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 12.0}, \"二\": {\"1\": 2.0, \"2\": 6.0, \"3\": 10.0}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 88.0}}');
INSERT INTO `scores_algorithmscore` VALUES (33, 100, 80, 94, 90, 91, 33, 20, 35, 10, 98, 2, 1.6, 3.76, 0, 19.8, 27.16, 0.94, 1.5, 1.2, 2.82, 7.2, 12, 24.72, 0.95, 1.5, 1.2, 2.82, 3.6, 18.6, 27.72, 0.89, 0, 0, 0, 7.2, 6, 13.2, 0.94, 95, 91, 98, 95, '2026-01-09 10:42:26.379669', '2026-01-10 05:27:16.838741', 5, NULL, 33, 125, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 15.0}, \"二\": {\"1\": 5.0, \"2\": 10.0, \"3\": 10.0}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 98.0}}');
INSERT INTO `scores_algorithmscore` VALUES (34, 100, 95, 99, 85, 92, 33, 14, 25, 3, 75, 2, 1.9, 3.96, 0, 19.8, 27.66, 0.95, 1.5, 1.43, 2.97, 6.8, 8.4, 21.1, 0.81, 1.5, 1.43, 2.97, 3.4, 13.29, 22.59, 0.73, 0, 0, 0, 6.8, 1.8, 8.6, 0.61, 82, 92, 75, 82, '2026-01-09 10:42:26.394646', '2026-01-10 05:27:16.841755', 5, NULL, 34, 126, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 10.0}, \"二\": {\"1\": 0.0, \"2\": 4.0, \"3\": 10.0}, \"四\": {\"total\": 3.0}, \"卷面\": {\"total\": 75.0}}');
INSERT INTO `scores_algorithmscore` VALUES (35, 100, 80, 93, 95, 93, 35, 20, 29, 2, 86, 2, 1.6, 3.72, 0, 21, 28.32, 0.98, 1.5, 1.2, 2.79, 7.6, 12, 25.09, 0.96, 1.5, 1.2, 2.79, 3.8, 15.41, 24.7, 0.8, 0, 0, 0, 7.6, 1.2, 8.8, 0.63, 89, 93, 86, 89, '2026-01-09 10:42:26.411686', '2026-01-10 05:27:16.845713', 5, NULL, 35, 127, 1, '{\"一\": {\"total\": 20.0}, \"三\": {\"1\": 15.0, \"2\": 14.0, \"3\": 10.0}, \"二\": {\"1\": 5.0, \"2\": 10.0, \"3\": 10.0}, \"四\": {\"total\": 2.0}, \"卷面\": {\"total\": 86.0}}');
INSERT INTO `scores_algorithmscore` VALUES (36, 100, 95, 97, 92.5, 95, 31, 20, 20, 10, 81, 2, 1.9, 3.88, 0, 18.6, 26.38, 0.91, 1.5, 1.43, 2.91, 7.4, 12, 25.24, 0.97, 1.5, 1.43, 2.91, 3.7, 10.63, 20.17, 0.65, 0, 0, 0, 7.4, 6, 13.4, 0.96, 87, 95, 81, 87, '2026-01-09 10:42:26.432918', '2026-01-10 05:27:16.848988', 5, NULL, 36, 128, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2\": 6.0, \"3\": 14.0}, \"二\": {\"1\": 0.0, \"2\": 10.0, \"3\": 10.0}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 81.0}}');
INSERT INTO `scores_algorithmscore` VALUES (37, 100, 90, 81, 95, 92, 31, 15, 25, 10, 81, 2, 1.8, 3.24, 0, 18.6, 25.64, 0.88, 1.5, 1.35, 2.43, 7.6, 9, 21.88, 0.84, 1.5, 1.35, 2.43, 3.8, 13.29, 22.37, 0.72, 0, 0, 0, 7.6, 6, 13.6, 0.97, 85, 92, 81, 85, '2026-01-09 10:42:26.449568', '2026-01-10 05:27:16.852357', 5, NULL, 37, 129, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 10.0}, \"二\": {\"1\": 0.0, \"2\": 5.0, \"3\": 10.0}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 81.0}}');
INSERT INTO `scores_algorithmscore` VALUES (38, 100, 98, 100, 100, 100, 35, 18, 35, 10, 98, 2, 1.96, 4, 0, 21, 28.96, 1, 1.5, 1.47, 3, 8, 10.8, 24.77, 0.95, 1.5, 1.47, 3, 4, 18.6, 28.57, 0.92, 0, 0, 0, 8, 6, 14, 1, 99, 100, 98, 99, '2026-01-09 10:42:26.467793', '2026-01-10 05:27:16.856504', 5, NULL, 38, 130, 1, '{\"一\": {\"total\": 20.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 15.0}, \"二\": {\"1\": 5.0, \"2\": 8.0, \"3\": 10.0}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 98.0}}');
INSERT INTO `scores_algorithmscore` VALUES (39, 96, 80, 84, 82.5, 84, 25, 16, 28, 10, 79, 1.92, 1.6, 3.36, 0, 15, 21.88, 0.75, 1.44, 1.2, 2.52, 6.6, 9.6, 21.36, 0.82, 1.44, 1.2, 2.52, 3.3, 14.88, 23.34, 0.75, 0, 0, 0, 6.6, 6, 12.6, 0.9, 81, 84, 79, 81, '2026-01-09 10:42:26.484371', '2026-01-10 05:27:16.859570', 5, NULL, 39, 131, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 11.0, \"2\": 13.0, \"3\": 15.0}, \"二\": {\"1\": 0.0, \"2\": 6.0, \"3\": 10.0}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 79.0}}');
INSERT INTO `scores_algorithmscore` VALUES (40, 100, 65, 87, 75, 80, 31, 16, 27, 10, 84, 2, 1.3, 3.48, 0, 18.6, 25.38, 0.88, 1.5, 0.97, 2.61, 6, 9.6, 20.68, 0.8, 1.5, 0.97, 2.61, 3, 14.35, 22.43, 0.72, 0, 0, 0, 6, 6, 12, 0.86, 82, 80, 84, 82, '2026-01-09 10:42:26.505233', '2026-01-10 05:27:16.863330', 5, NULL, 40, 132, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2\": 13.0, \"3\": 14.0}, \"二\": {\"1\": 0.0, \"2\": 6.0, \"3\": 10.0}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 84.0}}');
INSERT INTO `scores_algorithmscore` VALUES (41, 100, 95, 90, 95, 94, 31, 10, 33, 10, 84, 2, 1.9, 3.6, 0, 18.6, 26.1, 0.9, 1.5, 1.43, 2.7, 7.6, 6, 19.23, 0.74, 1.5, 1.43, 2.7, 3.8, 17.54, 26.97, 0.87, 0, 0, 0, 7.6, 6, 13.6, 0.97, 88, 94, 84, 88, '2026-01-09 10:42:26.524641', '2026-01-10 05:27:16.866600', 5, NULL, 41, 133, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2\": 13.0, \"3\": 15.0}, \"二\": {\"1\": 5.0, \"2\": 10.0, \"3\": 0.0}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 84.0}}');
INSERT INTO `scores_algorithmscore` VALUES (42, 100, 75, 79, 85, 84, 29, 20, 24, 10, 83, 2, 1.5, 3.16, 0, 17.4, 24.06, 0.83, 1.5, 1.12, 2.37, 6.8, 12, 23.79, 0.91, 1.5, 1.12, 2.37, 3.4, 12.75, 21.14, 0.68, 0, 0, 0, 6.8, 6, 12.8, 0.91, 83, 84, 83, 83, '2026-01-09 10:42:26.545179', '2026-01-10 05:27:16.870224', 5, NULL, 42, 134, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 15.0, \"2\": 13.0, \"3\": 11.0}, \"二\": {\"1\": 0.0, \"2\": 10.0, \"3\": 10.0}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 83.0}}');
INSERT INTO `scores_algorithmscore` VALUES (43, 92, 80, 79, 90, 86, 31, 20, 28, 10, 89, 1.84, 1.6, 3.16, 0, 18.6, 25.2, 0.87, 1.38, 1.2, 2.37, 7.2, 12, 24.15, 0.93, 1.38, 1.2, 2.37, 3.6, 14.88, 23.43, 0.76, 0, 0, 0, 7.2, 6, 13.2, 0.94, 88, 86, 89, 88, '2026-01-09 10:42:26.564967', '2026-01-10 05:27:16.873795', 5, NULL, 43, 135, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2\": 13.0, \"3\": 15.0}, \"二\": {\"1\": 0.0, \"2\": 10.0, \"3\": 10.0}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 89.0}}');
INSERT INTO `scores_algorithmscore` VALUES (44, 100, 90, 99, 97.5, 97, 33, 14, 18, 2, 67, 2, 1.8, 3.96, 0, 19.8, 27.56, 0.95, 1.5, 1.35, 2.97, 7.8, 8.4, 22.02, 0.85, 1.5, 1.35, 2.97, 3.9, 9.57, 19.29, 0.62, 0, 0, 0, 7.8, 1.2, 9, 0.64, 79, 97, 67, 79, '2026-01-09 10:42:26.583948', '2026-01-10 05:27:16.877150', 5, NULL, 44, 136, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 15.0, \"2\": 4.0, \"3\": 14.0}, \"二\": {\"1\": 0.0, \"2\": 4.0, \"3\": 10.0}, \"四\": {\"total\": 2.0}, \"卷面\": {\"total\": 67.0}}');
INSERT INTO `scores_algorithmscore` VALUES (45, 96, 65, 84, 87.5, 85, 35, 20, 15, 10, 80, 1.92, 1.3, 3.36, 0, 21, 27.58, 0.95, 1.44, 0.97, 2.52, 7, 12, 23.93, 0.92, 1.44, 0.97, 2.52, 3.5, 7.97, 16.4, 0.53, 0, 0, 0, 7, 6, 13, 0.93, 82, 85, 80, 82, '2026-01-09 10:42:26.602166', '2026-01-10 05:27:16.880733', 5, NULL, 45, 137, 1, '{\"一\": {\"total\": 20.0}, \"三\": {\"1\": 15.0, \"2\": 4.0, \"3\": 11.0}, \"二\": {\"1\": 0.0, \"2\": 10.0, \"3\": 10.0}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 80.0}}');
INSERT INTO `scores_algorithmscore` VALUES (46, 100, 85, 99, 100, 98, 33, 20, 32, 10, 95, 2, 1.7, 3.96, 0, 19.8, 27.46, 0.95, 1.5, 1.27, 2.97, 8, 12, 25.74, 0.99, 1.5, 1.27, 2.97, 4, 17.01, 26.75, 0.86, 0, 0, 0, 8, 6, 14, 1, 96, 98, 95, 96, '2026-01-09 10:42:26.621862', '2026-01-10 05:27:16.884328', 5, NULL, 46, 138, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 15.0, \"2\": 13.0, \"3\": 14.0}, \"二\": {\"1\": 5.0, \"2\": 10.0, \"3\": 10.0}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 95.0}}');
INSERT INTO `scores_algorithmscore` VALUES (47, 100, 88, 94, 92.5, 93, 35, 20, 23, 5, 83, 2, 1.76, 3.76, 0, 21, 28.52, 0.98, 1.5, 1.32, 2.82, 7.4, 12, 25.04, 0.96, 1.5, 1.32, 2.82, 3.7, 12.22, 21.56, 0.7, 0, 0, 0, 7.4, 3, 10.4, 0.74, 87, 93, 83, 87, '2026-01-09 10:42:26.641493', '2026-01-10 05:27:16.887242', 5, NULL, 47, 139, 1, '{\"一\": {\"total\": 20.0}, \"三\": {\"1\": 15.0, \"2\": 13.0, \"3\": 10.0}, \"二\": {\"1\": 0.0, \"2\": 10.0, \"3\": 10.0}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 83.0}}');
INSERT INTO `scores_algorithmscore` VALUES (48, 96, 90, 90, 80, 86, 27, 7, 28, 7, 69, 1.92, 1.8, 3.6, 0, 16.2, 23.52, 0.81, 1.44, 1.35, 2.7, 6.4, 4.2, 16.09, 0.62, 1.44, 1.35, 2.7, 3.2, 14.88, 23.57, 0.76, 0, 0, 0, 6.4, 4.2, 10.6, 0.76, 76, 86, 69, 76, '2026-01-09 10:42:26.659597', '2026-01-10 05:27:16.890755', 5, NULL, 48, 140, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 13.0, \"2\": 13.0, \"3\": 10.0}, \"二\": {\"1\": 5.0, \"2\": 2.0, \"3\": 5.0}, \"四\": {\"total\": 7.0}, \"卷面\": {\"total\": 69.0}}');
INSERT INTO `scores_algorithmscore` VALUES (49, 100, 95, 96, 100, 98, 35, 20, 29, 0, 84, 2, 1.9, 3.84, 0, 21, 28.74, 0.99, 1.5, 1.43, 2.88, 8, 12, 25.81, 0.99, 1.5, 1.43, 2.88, 4, 15.41, 25.22, 0.81, 0, 0, 0, 8, 0, 8, 0.57, 90, 98, 84, 90, '2026-01-09 10:42:26.677482', '2026-01-10 05:27:16.895115', 5, NULL, 49, 141, 1, '{\"一\": {\"total\": 20.0}, \"三\": {\"1\": 15.0, \"2\": 13.0, \"3\": 11.0}, \"二\": {\"1\": 5.0, \"2\": 10.0, \"3\": 10.0}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 84.0}}');
INSERT INTO `scores_algorithmscore` VALUES (50, 96, 65, 77, 75, 77, 31, 12, 30, 5, 78, 1.92, 1.3, 3.08, 0, 18.6, 24.9, 0.86, 1.44, 0.97, 2.31, 6, 7.2, 17.92, 0.69, 1.44, 0.97, 2.31, 3, 15.94, 23.66, 0.76, 0, 0, 0, 6, 3, 9, 0.64, 78, 77, 78, 78, '2026-01-09 10:42:26.697435', '2026-01-10 05:27:16.898645', 5, NULL, 50, 142, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 10.0}, \"二\": {\"1\": 5.0, \"2\": 7.0, \"3\": 5.0}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 78.0}}');
INSERT INTO `scores_algorithmscore` VALUES (51, 92, 98, 100, 92.5, 95, 31, 14, 30, 10, 85, 1.84, 1.96, 4, 0, 18.6, 26.4, 0.91, 1.38, 1.47, 3, 7.4, 8.4, 21.65, 0.83, 1.38, 1.47, 3, 3.7, 15.94, 25.49, 0.82, 0, 0, 0, 7.4, 6, 13.4, 0.96, 89, 95, 85, 89, '2026-01-09 10:42:26.714683', '2026-01-10 05:27:16.901303', 5, NULL, 51, 143, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 13.0, \"2\": 13.0, \"3\": 12.0}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 10.0}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 85.0}}');
INSERT INTO `scores_algorithmscore` VALUES (52, 100, 75, 94, 82.5, 87, 35, 14, 32, 9, 90, 2, 1.5, 3.76, 0, 21, 28.26, 0.97, 1.5, 1.12, 2.82, 6.6, 8.4, 20.44, 0.79, 1.5, 1.12, 2.82, 3.3, 17.01, 25.75, 0.83, 0, 0, 0, 6.6, 5.4, 12, 0.86, 89, 87, 90, 89, '2026-01-09 10:42:26.730797', '2026-01-10 05:27:16.904852', 5, NULL, 52, 144, 1, '{\"一\": {\"total\": 20.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 12.0}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 10.0}, \"四\": {\"total\": 9.0}, \"卷面\": {\"total\": 90.0}}');
INSERT INTO `scores_algorithmscore` VALUES (53, 96, 90, 93, 95, 94, 31, 17, 33, 10, 91, 1.92, 1.8, 3.72, 0, 18.6, 26.04, 0.9, 1.44, 1.35, 2.79, 7.6, 10.2, 23.38, 0.9, 1.44, 1.35, 2.79, 3.8, 17.54, 26.92, 0.87, 0, 0, 0, 7.6, 6, 13.6, 0.97, 92, 94, 91, 92, '2026-01-09 10:42:26.751234', '2026-01-10 05:27:16.908993', 5, NULL, 53, 145, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2\": 13.0, \"3\": 15.0}, \"二\": {\"1\": 5.0, \"2\": 7.0, \"3\": 10.0}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 91.0}}');
INSERT INTO `scores_algorithmscore` VALUES (54, 100, 95, 96, 85, 91, 35, 20, 26, 7, 88, 2, 1.9, 3.84, 0, 21, 28.74, 0.99, 1.5, 1.43, 2.88, 6.8, 12, 24.61, 0.95, 1.5, 1.43, 2.88, 3.4, 13.82, 23.03, 0.74, 0, 0, 0, 6.8, 4.2, 11, 0.79, 89, 91, 88, 89, '2026-01-09 10:42:26.768032', '2026-01-10 05:27:16.911314', 5, NULL, 54, 146, 1, '{\"一\": {\"total\": 20.0}, \"三\": {\"1\": 15.0, \"2\": 9.0, \"3\": 12.0}, \"二\": {\"1\": 5.0, \"2\": 10.0, \"3\": 10.0}, \"四\": {\"total\": 7.0}, \"卷面\": {\"total\": 88.0}}');
INSERT INTO `scores_algorithmscore` VALUES (55, 100, 80, 81, 87.5, 86, 29, 14, 25, 0, 68, 2, 1.6, 3.24, 0, 17.4, 24.24, 0.84, 1.5, 1.2, 2.43, 7, 8.4, 20.53, 0.79, 1.5, 1.2, 2.43, 3.5, 13.29, 21.92, 0.71, 0, 0, 0, 7, 0, 7, 0.5, 75, 86, 68, 75, '2026-01-09 10:42:26.787755', '2026-01-10 05:27:16.915383', 5, NULL, 55, 147, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 15.0, \"2\": 13.0, \"3\": 12.0}, \"二\": {\"1\": 0.0, \"2\": 4.0, \"3\": 10.0}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 68.0}}');
INSERT INTO `scores_algorithmscore` VALUES (56, 100, 100, 94, 90, 93, 29, 10, 28, 10, 77, 2, 2, 3.76, 0, 17.4, 25.16, 0.87, 1.5, 1.5, 2.82, 7.2, 6, 19.02, 0.73, 1.5, 1.5, 2.82, 3.6, 14.88, 24.3, 0.78, 0, 0, 0, 7.2, 6, 13.2, 0.94, 83, 93, 77, 83, '2026-01-09 10:42:26.804001', '2026-01-10 05:27:16.917984', 5, NULL, 56, 148, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 15.0, \"2\": 13.0, \"3\": 10.0}, \"二\": {\"1\": 5.0, \"2\": 0.0, \"3\": 10.0}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 77.0}}');
INSERT INTO `scores_algorithmscore` VALUES (57, 100, 95, 96, 100, 98, 25, 12, 28, 0, 65, 2, 1.9, 3.84, 0, 15, 22.74, 0.78, 1.5, 1.43, 2.88, 8, 7.2, 21.01, 0.81, 1.5, 1.43, 2.88, 4, 14.88, 24.69, 0.8, 0, 0, 0, 8, 0, 8, 0.57, 78, 98, 65, 78, '2026-01-09 10:42:26.823157', '2026-01-10 05:27:16.921441', 5, NULL, 57, 149, 1, '{\"一\": {\"total\": 10.0}, \"三\": {\"1\": 15.0, \"2\": 13.0, \"3\": 13.0}, \"二\": {\"1\": 2.0, \"2\": 2.0, \"3\": 10.0}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 65.0}}');
INSERT INTO `scores_algorithmscore` VALUES (58, 100, 80, 96, 95, 94, 29, 20, 23, 5, 77, 2, 1.6, 3.84, 0, 17.4, 24.84, 0.86, 1.5, 1.2, 2.88, 7.6, 12, 25.18, 0.97, 1.5, 1.2, 2.88, 3.8, 12.22, 21.6, 0.7, 0, 0, 0, 7.6, 3, 10.6, 0.76, 84, 94, 77, 84, '2026-01-11 08:00:01.592856', '2026-01-11 08:00:33.117892', 6, NULL, 58, 150, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 15.0, \"2\": 13.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 10.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 77.0}}');
INSERT INTO `scores_algorithmscore` VALUES (59, 100, 75, 89, 75, 82, 14, 2, 24, 0, 40, 2, 1.5, 3.56, 0, 8.4, 15.46, 0.53, 1.5, 1.12, 2.67, 6, 1.2, 12.49, 0.48, 1.5, 1.12, 2.67, 3, 12.75, 21.04, 0.68, 0, 0, 0, 6, 0, 6, 0.43, 57, 82, 40, 57, '2026-01-11 08:00:01.640480', '2026-01-11 08:00:33.141553', 6, NULL, 59, 151, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 0.0, \"2\": 13.0, \"3\": 11.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 2.0, \"3\": 0.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 40.0}}');
INSERT INTO `scores_algorithmscore` VALUES (60, 96, 90, 88, 80, 85, 29, 20, 33, 0, 82, 1.92, 1.8, 3.52, 0, 17.4, 24.64, 0.85, 1.44, 1.35, 2.64, 6.4, 12, 23.83, 0.92, 1.44, 1.35, 2.64, 3.2, 17.54, 26.17, 0.84, 0, 0, 0, 6.4, 0, 6.4, 0.46, 83, 85, 82, 83, '2026-01-11 08:00:01.687053', '2026-01-11 08:00:33.166327', 6, NULL, 60, 152, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 15.0, \"2\": 13.0, \"3\": 15.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 10.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 82.0}}');
INSERT INTO `scores_algorithmscore` VALUES (61, 100, 85, 68, 75, 78, 31, 19, 32, 5, 87, 2, 1.7, 2.72, 0, 18.6, 25.02, 0.86, 1.5, 1.27, 2.04, 6, 11.4, 22.21, 0.85, 1.5, 1.27, 2.04, 3, 17.01, 24.82, 0.8, 0, 0, 0, 6, 3, 9, 0.64, 83, 78, 87, 83, '2026-01-11 08:00:01.730222', '2026-01-11 08:00:33.190925', 6, NULL, 61, 153, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2\": 13.0, \"3\": 14.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 9.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 87.0}}');
INSERT INTO `scores_algorithmscore` VALUES (62, 96, 85, 93, 72.5, 82, 27, 14, 20, 2, 63, 1.92, 1.7, 3.72, 0, 16.2, 23.54, 0.81, 1.44, 1.27, 2.79, 5.8, 8.4, 19.7, 0.76, 1.44, 1.27, 2.79, 2.9, 10.63, 19.03, 0.61, 0, 0, 0, 5.8, 1.2, 7, 0.5, 71, 82, 63, 71, '2026-01-11 08:00:01.778042', '2026-01-11 08:00:33.214706', 6, NULL, 62, 154, 1, '{\"一\": {\"total\": 12.0}, \"三\": {\"1\": 15.0, \"2\": 4.0, \"3\": 11.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 2.0}, \"卷面\": {\"total\": 63.0}}');
INSERT INTO `scores_algorithmscore` VALUES (63, 100, 90, 92, 87.5, 90, 16, 14, 25, 5, 60, 2, 1.8, 3.68, 0, 9.6, 17.08, 0.59, 1.5, 1.35, 2.76, 7, 8.4, 21.01, 0.81, 1.5, 1.35, 2.76, 3.5, 13.29, 22.4, 0.72, 0, 0, 0, 7, 3, 10, 0.71, 72, 90, 60, 72, '2026-01-11 08:00:01.824924', '2026-01-11 08:00:33.237551', 6, NULL, 63, 155, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 0.0, \"2\": 13.0, \"3\": 12.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 60.0}}');
INSERT INTO `scores_algorithmscore` VALUES (64, 96, 85, 93, 95, 93, 35, 20, 23, 5, 83, 1.92, 1.7, 3.72, 0, 21, 28.34, 0.98, 1.44, 1.27, 2.79, 7.6, 12, 25.1, 0.97, 1.44, 1.27, 2.79, 3.8, 12.22, 21.52, 0.69, 0, 0, 0, 7.6, 3, 10.6, 0.76, 87, 93, 83, 87, '2026-01-11 08:00:01.871632', '2026-01-11 08:00:33.259804', 6, NULL, 64, 156, 1, '{\"一\": {\"total\": 20.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 3.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 10.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 83.0}}');
INSERT INTO `scores_algorithmscore` VALUES (65, 100, 90, 98, 95, 96, 35, 20, 35, 5, 95, 2, 1.8, 3.92, 0, 21, 28.72, 0.99, 1.5, 1.35, 2.94, 7.6, 12, 25.39, 0.98, 1.5, 1.35, 2.94, 3.8, 18.6, 28.19, 0.91, 0, 0, 0, 7.6, 3, 10.6, 0.76, 95, 96, 95, 95, '2026-01-11 08:00:01.914894', '2026-01-11 08:00:33.283420', 6, NULL, 65, 157, 1, '{\"一\": {\"total\": 20.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 15.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 10.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 95.0}}');
INSERT INTO `scores_algorithmscore` VALUES (66, 88, 90, 96, 95, 94, 29, 14, 30, 5, 78, 1.76, 1.8, 3.84, 0, 17.4, 24.8, 0.86, 1.32, 1.35, 2.88, 7.6, 8.4, 21.55, 0.83, 1.32, 1.35, 2.88, 3.8, 15.94, 25.29, 0.82, 0, 0, 0, 7.6, 3, 10.6, 0.76, 84, 94, 78, 84, '2026-01-11 08:00:01.965366', '2026-01-11 08:00:33.305786', 6, NULL, 66, 158, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 11.0, \"2\": 13.0, \"3\": 12.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 78.0}}');
INSERT INTO `scores_algorithmscore` VALUES (67, 96, 85, 90, 82.5, 86, 26, 4, 35, 5, 70, 1.92, 1.7, 3.6, 0, 15.6, 22.82, 0.79, 1.44, 1.27, 2.7, 6.6, 2.4, 14.41, 0.55, 1.44, 1.27, 2.7, 3.3, 18.6, 27.31, 0.88, 0, 0, 0, 6.6, 3, 9.6, 0.69, 76, 86, 70, 76, '2026-01-11 08:00:02.013089', '2026-01-11 08:00:33.330121', 6, NULL, 67, 159, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 8.0, \"2\": 15.0, \"3\": 15.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 0.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 70.0}}');
INSERT INTO `scores_algorithmscore` VALUES (68, 100, 80, 82, 82.5, 84, 27, 10, 16, 5, 58, 2, 1.6, 3.28, 0, 16.2, 23.08, 0.8, 1.5, 1.2, 2.46, 6.6, 6, 17.76, 0.68, 1.5, 1.2, 2.46, 3.3, 8.5, 16.96, 0.55, 0, 0, 0, 6.6, 3, 9.6, 0.69, 68, 84, 58, 68, '2026-01-11 08:00:02.055686', '2026-01-11 08:00:33.355062', 6, NULL, 68, 160, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 11.0, \"2\": 4.0, \"3\": 12.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 0.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 58.0}}');
INSERT INTO `scores_algorithmscore` VALUES (69, 100, 90, 94, 92.5, 93, 33, 14, 29, 5, 81, 2, 1.8, 3.76, 0, 19.8, 27.36, 0.94, 1.5, 1.35, 2.82, 7.4, 8.4, 21.47, 0.83, 1.5, 1.35, 2.82, 3.7, 15.41, 24.78, 0.8, 0, 0, 0, 7.4, 3, 10.4, 0.74, 86, 93, 81, 86, '2026-01-11 08:00:02.100266', '2026-01-11 08:00:33.380948', 6, NULL, 69, 161, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 15.0, \"2\": 13.0, \"3\": 11.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 81.0}}');
INSERT INTO `scores_algorithmscore` VALUES (70, 96, 95, 98, 97.5, 97, 29, 14, 23, 5, 71, 1.92, 1.9, 3.92, 0, 17.4, 25.14, 0.87, 1.44, 1.43, 2.94, 7.8, 8.4, 22.01, 0.85, 1.44, 1.43, 2.94, 3.9, 12.22, 21.93, 0.71, 0, 0, 0, 7.8, 3, 10.8, 0.77, 81, 97, 71, 81, '2026-01-11 08:00:02.144244', '2026-01-11 08:00:33.406947', 6, NULL, 70, 162, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 15.0, \"2\": 6.0, \"3\": 12.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 71.0}}');
INSERT INTO `scores_algorithmscore` VALUES (71, 96, 90, 86, 75, 82, 17, 11, 13, 10, 51, 1.92, 1.8, 3.44, 0, 10.2, 17.36, 0.6, 1.44, 1.35, 2.58, 6, 6.6, 17.97, 0.69, 1.44, 1.35, 2.58, 3, 6.91, 15.28, 0.49, 0, 0, 0, 6, 6, 12, 0.86, 63, 82, 51, 63, '2026-01-11 08:00:02.189189', '2026-01-11 08:00:33.431344', 6, NULL, 71, 163, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 1.0, \"2\": 3.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 1.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 51.0}}');
INSERT INTO `scores_algorithmscore` VALUES (72, 96, 75, 78, 85, 83, 24, 12, 30, 10, 76, 1.92, 1.5, 3.12, 0, 14.4, 20.94, 0.72, 1.44, 1.12, 2.34, 6.8, 7.2, 18.9, 0.73, 1.44, 1.12, 2.34, 3.4, 15.94, 24.24, 0.78, 0, 0, 0, 6.8, 6, 12.8, 0.91, 79, 83, 76, 79, '2026-01-11 08:00:02.231633', '2026-01-11 08:00:33.455973', 6, NULL, 72, 164, 1, '{\"一\": {\"total\": 20.0}, \"三\": {\"1\": 4.0, \"2\": 15.0, \"3\": 15.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 2.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 76.0}}');
INSERT INTO `scores_algorithmscore` VALUES (73, 100, 90, 94, 97.5, 96, 25, 14, 23, 10, 72, 2, 1.8, 3.76, 0, 15, 22.56, 0.78, 1.5, 1.35, 2.82, 7.8, 8.4, 21.87, 0.84, 1.5, 1.35, 2.82, 3.9, 12.22, 21.79, 0.7, 0, 0, 0, 7.8, 6, 13.8, 0.99, 82, 96, 72, 82, '2026-01-11 08:00:02.279448', '2026-01-11 08:00:33.480178', 6, NULL, 73, 165, 1, '{\"一\": {\"total\": 10.0}, \"三\": {\"1\": 15.0, \"2\": 6.0, \"3\": 12.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 72.0}}');
INSERT INTO `scores_algorithmscore` VALUES (74, 100, 95, 96, 95, 96, 24, 7, 30, 0, 61, 2, 1.9, 3.84, 0, 14.4, 22.14, 0.76, 1.5, 1.43, 2.88, 7.6, 4.2, 17.61, 0.68, 1.5, 1.43, 2.88, 3.8, 15.94, 25.55, 0.82, 0, 0, 0, 7.6, 0, 7.6, 0.54, 75, 96, 61, 75, '2026-01-11 08:00:02.330021', '2026-01-11 08:00:33.502597', 6, NULL, 74, 166, 1, '{\"一\": {\"total\": 20.0}, \"三\": {\"1\": 4.0, \"2\": 15.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 2.0, \"3\": 5.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 61.0}}');
INSERT INTO `scores_algorithmscore` VALUES (75, 100, 90, 97, 90, 93, 31, 10, 23, 8, 72, 2, 1.8, 3.88, 0, 18.6, 26.28, 0.91, 1.5, 1.35, 2.91, 7.2, 6, 18.96, 0.73, 1.5, 1.35, 2.91, 3.6, 12.22, 21.58, 0.7, 0, 0, 0, 7.2, 4.8, 12, 0.86, 80, 93, 72, 80, '2026-01-11 08:00:02.378717', '2026-01-11 08:00:33.524866', 6, NULL, 75, 167, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2\": 11.0, \"3\": 12.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 0.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 8.0}, \"卷面\": {\"total\": 72.0}}');
INSERT INTO `scores_algorithmscore` VALUES (76, 96, 95, 100, 95, 96, 35, 10, 32, 2, 79, 1.92, 1.9, 4, 0, 21, 28.82, 0.99, 1.44, 1.43, 3, 7.6, 6, 19.47, 0.75, 1.44, 1.43, 3, 3.8, 17.01, 26.68, 0.86, 0, 0, 0, 7.6, 1.2, 8.8, 0.63, 86, 96, 79, 86, '2026-01-11 08:00:02.425086', '2026-01-11 08:00:33.546271', 6, NULL, 76, 168, 1, '{\"一\": {\"total\": 20.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 12.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 0.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 2.0}, \"卷面\": {\"total\": 79.0}}');
INSERT INTO `scores_algorithmscore` VALUES (77, 100, 95, 96, 100, 98, 31, 20, 27, 2, 80, 2, 1.9, 3.84, 0, 18.6, 26.34, 0.91, 1.5, 1.43, 2.88, 8, 12, 25.81, 0.99, 1.5, 1.43, 2.88, 4, 14.35, 24.16, 0.78, 0, 0, 0, 8, 1.2, 9.2, 0.66, 87, 98, 80, 87, '2026-01-11 08:00:02.468181', '2026-01-11 08:00:33.572090', 6, NULL, 77, 169, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 12.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 10.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 2.0}, \"卷面\": {\"total\": 80.0}}');
INSERT INTO `scores_algorithmscore` VALUES (78, 100, 65, 86, 75, 80, 33, 10, 30, 10, 83, 2, 1.3, 3.44, 0, 19.8, 26.54, 0.92, 1.5, 0.97, 2.58, 6, 6, 17.05, 0.66, 1.5, 0.97, 2.58, 3, 15.94, 23.99, 0.77, 0, 0, 0, 6, 6, 12, 0.86, 82, 80, 83, 82, '2026-01-11 08:00:02.517104', '2026-01-11 08:00:33.596231', 6, NULL, 78, 170, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 0.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 83.0}}');
INSERT INTO `scores_algorithmscore` VALUES (79, 100, 65, 93, 77.5, 83, 29, 10, 26, 0, 65, 2, 1.3, 3.72, 0, 17.4, 24.42, 0.84, 1.5, 0.97, 2.79, 6.2, 6, 17.46, 0.67, 1.5, 0.97, 2.79, 3.1, 13.82, 22.18, 0.72, 0, 0, 0, 6.2, 0, 6.2, 0.44, 72, 83, 65, 72, '2026-01-11 08:00:02.564917', '2026-01-11 08:00:33.619277', 6, NULL, 79, 171, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 15.0, \"2\": 11.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 0.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 65.0}}');
INSERT INTO `scores_algorithmscore` VALUES (80, 96, 98, 95, 92.5, 94, 33, 16, 31, 5, 85, 1.92, 1.96, 3.8, 0, 19.8, 27.48, 0.95, 1.44, 1.47, 2.85, 7.4, 9.6, 22.76, 0.88, 1.44, 1.47, 2.85, 3.7, 16.47, 25.93, 0.84, 0, 0, 0, 7.4, 3, 10.4, 0.74, 89, 94, 85, 89, '2026-01-11 08:00:02.607315', '2026-01-11 08:00:33.641551', 6, NULL, 80, 172, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 11.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 6.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 85.0}}');
INSERT INTO `scores_algorithmscore` VALUES (81, 100, 80, 83.6, 85, 86, 27, 2, 15, 0, 44, 2, 1.6, 3.34, 0, 16.2, 23.14, 0.8, 1.5, 1.2, 2.51, 6.8, 1.2, 13.21, 0.51, 1.5, 1.2, 2.51, 3.4, 7.97, 16.58, 0.53, 0, 0, 0, 6.8, 0, 6.8, 0.49, 61, 86, 44, 61, '2026-01-11 08:00:02.650522', '2026-01-11 08:00:33.662698', 6, NULL, 81, 173, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 11.0, \"2\": 15.0, \"3\": 0.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 0.0, \"3\": 2.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 44.0}}');
INSERT INTO `scores_algorithmscore` VALUES (82, 96, 95, 99, 87.5, 92, 31, 0, 32, 0, 63, 1.92, 1.9, 3.96, 0, 18.6, 26.38, 0.91, 1.44, 1.43, 2.97, 7, 0, 12.84, 0.49, 1.44, 1.43, 2.97, 3.5, 17.01, 26.35, 0.85, 0, 0, 0, 7, 0, 7, 0.5, 75, 92, 63, 75, '2026-01-11 08:00:02.694251', '2026-01-11 08:00:33.684488', 6, NULL, 82, 174, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 12.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 0.0, \"3\": 0.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 63.0}}');
INSERT INTO `scores_algorithmscore` VALUES (83, 96, 80, 97, 80, 86, 27, 4, 30, 3, 64, 1.92, 1.6, 3.88, 0, 16.2, 23.6, 0.81, 1.44, 1.2, 2.91, 6.4, 2.4, 14.35, 0.55, 1.44, 1.2, 2.91, 3.2, 15.94, 24.69, 0.8, 0, 0, 0, 6.4, 1.8, 8.2, 0.59, 73, 86, 64, 73, '2026-01-11 08:00:02.737557', '2026-01-11 08:00:33.705001', 6, NULL, 83, 175, 1, '{\"一\": {\"total\": 12.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 0.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 3.0}, \"卷面\": {\"total\": 64.0}}');
INSERT INTO `scores_algorithmscore` VALUES (84, 100, 85, 85, 87.5, 88, 35, 14, 30, 0, 79, 2, 1.7, 3.4, 0, 21, 28.1, 0.97, 1.5, 1.27, 2.55, 7, 8.4, 20.72, 0.8, 1.5, 1.27, 2.55, 3.5, 15.94, 24.76, 0.8, 0, 0, 0, 7, 0, 7, 0.5, 83, 88, 79, 83, '2026-01-11 08:00:02.784468', '2026-01-11 08:00:33.727702', 6, NULL, 84, 176, 1, '{\"一\": {\"total\": 20.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 15.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 79.0}}');
INSERT INTO `scores_algorithmscore` VALUES (85, 100, 95, 94, 92.5, 94, 33, 17, 26, 2, 78, 2, 1.9, 3.76, 0, 19.8, 27.46, 0.95, 1.5, 1.43, 2.82, 7.4, 10.2, 23.35, 0.9, 1.5, 1.43, 2.82, 3.7, 13.82, 23.27, 0.75, 0, 0, 0, 7.4, 1.2, 8.6, 0.61, 84, 94, 78, 84, '2026-01-11 08:00:02.830372', '2026-01-11 08:00:33.752591', 6, NULL, 85, 177, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 11.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 7.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 2.0}, \"卷面\": {\"total\": 78.0}}');
INSERT INTO `scores_algorithmscore` VALUES (86, 96, 98, 95, 85, 90, 29, 12, 25, 5, 71, 1.92, 1.96, 3.8, 0, 17.4, 25.08, 0.86, 1.44, 1.47, 2.85, 6.8, 7.2, 19.76, 0.76, 1.44, 1.47, 2.85, 3.4, 13.29, 22.45, 0.72, 0, 0, 0, 6.8, 3, 9.8, 0.7, 79, 90, 71, 79, '2026-01-11 08:00:02.878940', '2026-01-11 08:00:33.776231', 6, NULL, 86, 178, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 2.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 71.0}}');
INSERT INTO `scores_algorithmscore` VALUES (87, 100, 90, 96, 92.5, 94, 33, 20, 33, 0, 86, 2, 1.8, 3.84, 0, 19.8, 27.44, 0.95, 1.5, 1.35, 2.88, 7.4, 12, 25.13, 0.97, 1.5, 1.35, 2.88, 3.7, 17.54, 26.97, 0.87, 0, 0, 0, 7.4, 0, 7.4, 0.53, 89, 94, 86, 89, '2026-01-15 03:06:08.186020', '2026-01-15 03:18:28.356750', 7, NULL, 87, 179, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 13.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 10.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 86.0}}');
INSERT INTO `scores_algorithmscore` VALUES (88, 92, 80, 92, 87.5, 88, 29, 14, 30, 8, 81, 1.84, 1.6, 3.68, 0, 17.4, 24.52, 0.85, 1.38, 1.2, 2.76, 7, 8.4, 20.74, 0.8, 1.38, 1.2, 2.76, 3.5, 15.94, 24.78, 0.8, 0, 0, 0, 7, 4.8, 11.8, 0.84, 84, 88, 81, 84, '2026-01-15 03:06:08.211000', '2026-01-15 03:18:28.369829', 7, NULL, 88, 180, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 8.0}, \"卷面\": {\"total\": 81.0}}');
INSERT INTO `scores_algorithmscore` VALUES (89, 100, 95, 97, 95, 96, 24, 4, 31, 5, 64, 2, 1.9, 3.88, 0, 14.4, 22.18, 0.76, 1.5, 1.43, 2.91, 7.6, 2.4, 15.84, 0.61, 1.5, 1.43, 2.91, 3.8, 16.47, 26.11, 0.84, 0, 0, 0, 7.6, 3, 10.6, 0.76, 77, 96, 64, 77, '2026-01-15 03:06:08.228825', '2026-01-15 03:18:28.382263', 7, NULL, 89, 181, 1, '{\"一\": {\"total\": 20.0}, \"三\": {\"1\": 4.0, \"2\": 15.0, \"3\": 11.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 0.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 64.0}}');
INSERT INTO `scores_algorithmscore` VALUES (90, 96, 90, 95, 95, 94, 29, 10, 28, 10, 77, 1.92, 1.8, 3.8, 0, 17.4, 24.92, 0.86, 1.44, 1.35, 2.85, 7.6, 6, 19.24, 0.74, 1.44, 1.35, 2.85, 3.8, 14.88, 24.32, 0.78, 0, 0, 0, 7.6, 6, 13.6, 0.97, 84, 94, 77, 84, '2026-01-15 03:06:08.249549', '2026-01-15 03:18:28.395640', 7, NULL, 90, 182, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 12.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 1.0, \"2\": 0.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 77.0}}');
INSERT INTO `scores_algorithmscore` VALUES (91, 100, 98, 96, 97.5, 98, 27, 4, 25, 10, 66, 2, 1.96, 3.84, 0, 16.2, 24, 0.83, 1.5, 1.47, 2.88, 7.8, 2.4, 16.05, 0.62, 1.5, 1.47, 2.88, 3.9, 13.29, 23.04, 0.74, 0, 0, 0, 7.8, 6, 13.8, 0.99, 79, 98, 66, 79, '2026-01-15 03:06:08.269437', '2026-01-15 03:18:28.406361', 7, NULL, 91, 183, 1, '{\"一\": {\"total\": 12.0}, \"三\": {\"1\": 15.0, \"2\": 10.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 0.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 66.0}}');
INSERT INTO `scores_algorithmscore` VALUES (92, 100, 95, 96, 95, 96, 31, 17, 25, 5, 78, 2, 1.9, 3.84, 0, 18.6, 26.34, 0.91, 1.5, 1.43, 2.88, 7.6, 10.2, 23.61, 0.91, 1.5, 1.43, 2.88, 3.8, 13.29, 22.9, 0.74, 0, 0, 0, 7.6, 3, 10.6, 0.76, 85, 96, 78, 85, '2026-01-15 03:06:08.287843', '2026-01-15 03:18:28.418221', 7, NULL, 92, 184, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2\": 9.0, \"3\": 11.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 7.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 78.0}}');
INSERT INTO `scores_algorithmscore` VALUES (93, 100, 85, 97, 92.5, 94, 33, 14, 30, 8, 85, 2, 1.7, 3.88, 0, 19.8, 27.38, 0.94, 1.5, 1.27, 2.91, 7.4, 8.4, 21.48, 0.83, 1.5, 1.27, 2.91, 3.7, 15.94, 25.32, 0.82, 0, 0, 0, 7.4, 4.8, 12.2, 0.87, 89, 94, 85, 89, '2026-01-15 03:06:08.307526', '2026-01-15 03:18:28.430022', 7, NULL, 93, 185, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 8.0}, \"卷面\": {\"total\": 85.0}}');
INSERT INTO `scores_algorithmscore` VALUES (94, 96, 95, 95, 97.5, 96, 27, 20, 35, 0, 82, 1.92, 1.9, 3.8, 0, 16.2, 23.82, 0.82, 1.44, 1.43, 2.85, 7.8, 12, 25.52, 0.98, 1.44, 1.43, 2.85, 3.9, 18.6, 28.22, 0.91, 0, 0, 0, 7.8, 0, 7.8, 0.56, 88, 96, 82, 88, '2026-01-15 03:06:08.326678', '2026-01-15 03:18:28.442428', 7, NULL, 94, 186, 1, '{\"一\": {\"total\": 12.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 15.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 10.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 82.0}}');
INSERT INTO `scores_algorithmscore` VALUES (95, 100, 80, 84, 85, 86, 31, 20, 29, 10, 90, 2, 1.6, 3.36, 0, 18.6, 25.56, 0.88, 1.5, 1.2, 2.52, 6.8, 12, 24.02, 0.92, 1.5, 1.2, 2.52, 3.4, 15.41, 24.03, 0.78, 0, 0, 0, 6.8, 6, 12.8, 0.91, 88, 86, 90, 88, '2026-01-15 03:06:08.347118', '2026-01-15 03:18:28.453385', 7, NULL, 95, 187, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 14.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 10.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 90.0}}');
INSERT INTO `scores_algorithmscore` VALUES (96, 96, 85, 90, 90, 90, 20, 0, 25, 5, 50, 1.92, 1.7, 3.6, 0, 12, 19.22, 0.66, 1.44, 1.27, 2.7, 7.2, 0, 12.61, 0.48, 1.44, 1.27, 2.7, 3.6, 13.29, 22.3, 0.72, 0, 0, 0, 7.2, 3, 10.2, 0.73, 66, 90, 50, 66, '2026-01-15 03:06:08.364153', '2026-01-15 03:18:28.465768', 7, NULL, 96, 188, 1, '{\"一\": {\"total\": 12.0}, \"三\": {\"1\": 8.0, \"2\": 9.0, \"3\": 11.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 0.0, \"3\": 0.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 50.0}}');
INSERT INTO `scores_algorithmscore` VALUES (97, 100, 98, 97, 92.5, 95, 27, 6, 33, 8, 74, 2, 1.96, 3.88, 0, 16.2, 24.04, 0.83, 1.5, 1.47, 2.91, 7.4, 3.6, 16.88, 0.65, 1.5, 1.47, 2.91, 3.7, 17.54, 27.12, 0.87, 0, 0, 0, 7.4, 4.8, 12.2, 0.87, 82, 95, 74, 82, '2026-01-15 03:06:08.381937', '2026-01-15 03:18:28.477895', 7, NULL, 97, 189, 1, '{\"一\": {\"total\": 12.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 13.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 2.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 8.0}, \"卷面\": {\"total\": 74.0}}');
INSERT INTO `scores_algorithmscore` VALUES (98, 100, 90, 92, 97.5, 96, 35, 14, 30, 10, 89, 2, 1.8, 3.68, 0, 21, 28.48, 0.98, 1.5, 1.35, 2.76, 7.8, 8.4, 21.81, 0.84, 1.5, 1.35, 2.76, 3.9, 15.94, 25.45, 0.82, 0, 0, 0, 7.8, 6, 13.8, 0.99, 92, 96, 89, 92, '2026-01-15 03:06:08.400961', '2026-01-15 03:18:28.487672', 7, NULL, 98, 190, 1, '{\"一\": {\"total\": 20.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 13.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 2.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 89.0}}');
INSERT INTO `scores_algorithmscore` VALUES (99, 100, 80, 81, 92.5, 89, 29, 12, 32, 5, 78, 2, 1.6, 3.24, 0, 17.4, 24.24, 0.84, 1.5, 1.2, 2.43, 7.4, 7.2, 19.73, 0.76, 1.5, 1.2, 2.43, 3.7, 17.01, 25.84, 0.83, 0, 0, 0, 7.4, 3, 10.4, 0.74, 82, 89, 78, 82, '2026-01-15 03:06:08.416067', '2026-01-15 03:18:28.499816', 7, NULL, 99, 191, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 12.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 2.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 78.0}}');
INSERT INTO `scores_algorithmscore` VALUES (100, 100, 85, 92, 97.5, 95, 27, 14, 23, 2, 66, 2, 1.7, 3.68, 0, 16.2, 23.58, 0.81, 1.5, 1.27, 2.76, 7.8, 8.4, 21.73, 0.84, 1.5, 1.27, 2.76, 3.9, 12.22, 21.65, 0.7, 0, 0, 0, 7.8, 1.2, 9, 0.64, 78, 95, 66, 78, '2026-01-15 03:06:08.435518', '2026-01-15 03:18:28.510683', 7, NULL, 100, 192, 1, '{\"一\": {\"total\": 12.0}, \"三\": {\"1\": 15.0, \"2\": 6.0, \"3\": 12.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 2.0}, \"卷面\": {\"total\": 66.0}}');
INSERT INTO `scores_algorithmscore` VALUES (101, 100, 75, 96, 97.5, 95, 27, 10, 31, 2, 70, 2, 1.5, 3.84, 0, 16.2, 23.54, 0.81, 1.5, 1.12, 2.88, 7.8, 6, 19.3, 0.74, 1.5, 1.12, 2.88, 3.9, 16.47, 25.87, 0.83, 0, 0, 0, 7.8, 1.2, 9, 0.64, 80, 95, 70, 80, '2026-01-15 03:06:08.456385', '2026-01-15 03:18:28.521901', 7, NULL, 101, 193, 1, '{\"一\": {\"total\": 12.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 11.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 0.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 2.0}, \"卷面\": {\"total\": 70.0}}');
INSERT INTO `scores_algorithmscore` VALUES (102, 100, 95, 95, 90, 93, 29, 14, 23, 0, 66, 2, 1.9, 3.8, 0, 17.4, 25.1, 0.87, 1.5, 1.43, 2.85, 7.2, 8.4, 21.38, 0.82, 1.5, 1.43, 2.85, 3.6, 12.22, 21.6, 0.7, 0, 0, 0, 7.2, 0, 7.2, 0.51, 77, 93, 66, 77, '2026-01-15 03:06:08.475381', '2026-01-15 03:18:28.532979', 7, NULL, 102, 194, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 15.0, \"2\": 6.0, \"3\": 12.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 66.0}}');
INSERT INTO `scores_algorithmscore` VALUES (103, 100, 90, 94, 85, 90, 29, 14, 21, 4, 68, 2, 1.8, 3.76, 0, 17.4, 24.96, 0.86, 1.5, 1.35, 2.82, 6.8, 8.4, 20.87, 0.8, 1.5, 1.35, 2.82, 3.4, 11.16, 20.23, 0.65, 0, 0, 0, 6.8, 2.4, 9.2, 0.66, 77, 90, 68, 77, '2026-01-15 03:06:08.496936', '2026-01-15 03:18:28.544061', 7, NULL, 103, 195, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 15.0, \"2\": 6.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 4.0}, \"卷面\": {\"total\": 68.0}}');
INSERT INTO `scores_algorithmscore` VALUES (104, 100, 90, 88, 75, 83, 29, 0, 26, 7, 62, 2, 1.8, 3.52, 0, 17.4, 24.72, 0.85, 1.5, 1.35, 2.64, 6, 0, 11.49, 0.44, 1.5, 1.35, 2.64, 3, 13.82, 22.31, 0.72, 0, 0, 0, 6, 4.2, 10.2, 0.73, 70, 83, 62, 70, '2026-01-15 03:06:08.517867', '2026-01-15 03:18:28.555175', 7, NULL, 104, 196, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 6.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 0.0, \"3\": 0.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 7.0}, \"卷面\": {\"total\": 62.0}}');
INSERT INTO `scores_algorithmscore` VALUES (105, 100, 75, 95, 82.5, 87, 31, 4, 26, 10, 71, 2, 1.5, 3.8, 0, 18.6, 25.9, 0.89, 1.5, 1.12, 2.85, 6.6, 2.4, 14.47, 0.56, 1.5, 1.12, 2.85, 3.3, 13.82, 22.59, 0.73, 0, 0, 0, 6.6, 6, 12.6, 0.9, 77, 87, 71, 77, '2026-01-15 03:06:08.537471', '2026-01-15 03:18:28.568042', 7, NULL, 105, 197, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 11.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 4.0, \"3\": 0.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 71.0}}');
INSERT INTO `scores_algorithmscore` VALUES (106, 94, 90, 84, 92.5, 90, 20, 2, 25, 7, 54, 1.88, 1.8, 3.36, 0, 12, 19.04, 0.66, 1.41, 1.35, 2.52, 7.4, 1.2, 13.88, 0.53, 1.41, 1.35, 2.52, 3.7, 13.29, 22.27, 0.72, 0, 0, 0, 7.4, 4.2, 11.6, 0.83, 68, 90, 54, 68, '2026-01-15 03:06:08.557488', '2026-01-15 03:18:28.579416', 7, NULL, 106, 198, 1, '{\"一\": {\"total\": 12.0}, \"三\": {\"1\": 8.0, \"2\": 15.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 2.0, \"3\": 0.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 7.0}, \"卷面\": {\"total\": 54.0}}');
INSERT INTO `scores_algorithmscore` VALUES (107, 100, 85, 78, 80, 83, 29, 10, 26, 0, 65, 2, 1.7, 3.12, 0, 17.4, 24.22, 0.84, 1.5, 1.27, 2.34, 6.4, 6, 17.51, 0.67, 1.5, 1.27, 2.34, 3.2, 13.82, 22.13, 0.71, 0, 0, 0, 6.4, 0, 6.4, 0.46, 72, 83, 65, 72, '2026-01-15 03:06:08.580818', '2026-01-15 03:18:28.591404', 7, NULL, 107, 199, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 11.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 0.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 65.0}}');
INSERT INTO `scores_algorithmscore` VALUES (108, 100, 85, 84, 82.5, 85, 33, 14, 26, 10, 83, 2, 1.7, 3.36, 0, 19.8, 26.86, 0.93, 1.5, 1.27, 2.52, 6.6, 8.4, 20.29, 0.78, 1.5, 1.27, 2.52, 3.3, 13.82, 22.41, 0.72, 0, 0, 0, 6.6, 6, 12.6, 0.9, 84, 85, 83, 84, '2026-01-15 03:06:08.604368', '2026-01-15 03:18:28.603879', 7, NULL, 108, 200, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 11.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 83.0}}');
INSERT INTO `scores_algorithmscore` VALUES (109, 96, 75, 82, 77.5, 81, 27, 17, 30, 0, 74, 1.92, 1.5, 3.28, 0, 16.2, 22.9, 0.79, 1.44, 1.12, 2.46, 6.2, 10.2, 21.42, 0.82, 1.44, 1.12, 2.46, 3.1, 15.94, 24.06, 0.78, 0, 0, 0, 6.2, 0, 6.2, 0.44, 77, 81, 74, 77, '2026-01-15 03:06:08.625696', '2026-01-15 03:18:28.614470', 7, NULL, 109, 201, 1, '{\"一\": {\"total\": 12.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 7.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 74.0}}');
INSERT INTO `scores_algorithmscore` VALUES (110, 100, 65, 76, 85, 82, 23, 20, 19, 5, 67, 2, 1.3, 3.04, 0, 13.8, 20.14, 0.69, 1.5, 0.97, 2.28, 6.8, 12, 23.55, 0.91, 1.5, 0.97, 2.28, 3.4, 10.1, 18.25, 0.59, 0, 0, 0, 6.8, 3, 9.8, 0.7, 73, 82, 67, 73, '2026-01-15 03:06:08.648283', '2026-01-15 03:18:28.627514', 7, NULL, 110, 202, 1, '{\"一\": {\"total\": 10.0}, \"三\": {\"1\": 13.0, \"2\": 9.0, \"3\": 5.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 10.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 67.0}}');
INSERT INTO `scores_algorithmscore` VALUES (111, 90, 85, 90.6, 90, 90, 25, 16, 23, 5, 69, 1.8, 1.7, 3.62, 0, 15, 22.12, 0.76, 1.35, 1.27, 2.72, 7.2, 9.6, 22.14, 0.85, 1.35, 1.27, 2.72, 3.6, 12.22, 21.16, 0.68, 0, 0, 0, 7.2, 3, 10.2, 0.73, 77, 90, 69, 77, '2026-01-15 03:06:08.671192', '2026-01-15 03:18:28.638682', 7, NULL, 111, 203, 1, '{\"一\": {\"total\": 10.0}, \"三\": {\"1\": 15.0, \"2\": 12.0, \"3\": 11.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 10.0, \"3\": 6.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 69.0}}');
INSERT INTO `scores_algorithmscore` VALUES (112, 96, 90, 87, 87.5, 89, 29, 14, 35, 8, 86, 1.92, 1.8, 3.48, 0, 17.4, 24.6, 0.85, 1.44, 1.35, 2.61, 7, 8.4, 20.8, 0.8, 1.44, 1.35, 2.61, 3.5, 18.6, 27.5, 0.89, 0, 0, 0, 7, 4.8, 11.8, 0.84, 87, 89, 86, 87, '2026-01-15 03:06:08.695268', '2026-01-15 03:18:28.648846', 7, NULL, 112, 204, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 15.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 8.0}, \"卷面\": {\"total\": 86.0}}');
INSERT INTO `scores_algorithmscore` VALUES (113, 88, 95, 85.6, 95, 92, 29, 14, 30, 5, 78, 1.76, 1.9, 3.42, 0, 17.4, 24.48, 0.84, 1.32, 1.43, 2.57, 7.6, 8.4, 21.32, 0.82, 1.32, 1.43, 2.57, 3.8, 15.94, 25.06, 0.81, 0, 0, 0, 7.6, 3, 10.6, 0.76, 84, 92, 78, 84, '2026-01-15 03:06:08.717962', '2026-01-15 03:18:28.659721', 7, NULL, 113, 205, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 78.0}}');
INSERT INTO `scores_algorithmscore` VALUES (114, 100, 95, 86, 92.5, 92, 23, 6, 25, 7, 61, 2, 1.9, 3.44, 0, 13.8, 21.14, 0.73, 1.5, 1.43, 2.58, 7.4, 3.6, 16.51, 0.64, 1.5, 1.43, 2.58, 3.7, 13.29, 22.5, 0.73, 0, 0, 0, 7.4, 4.2, 11.6, 0.83, 73, 92, 61, 73, '2026-01-15 03:06:08.741450', '2026-01-15 03:18:28.675997', 7, NULL, 114, 206, 1, '{\"一\": {\"total\": 8.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 0.0, \"3\": 6.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 7.0}, \"卷面\": {\"total\": 61.0}}');
INSERT INTO `scores_algorithmscore` VALUES (115, 92, 70, 61, 72.5, 72, 25, 16, 12, 0, 53, 1.84, 1.4, 2.44, 0, 15, 20.68, 0.71, 1.38, 1.05, 1.83, 5.8, 9.6, 19.66, 0.76, 1.38, 1.05, 1.83, 2.9, 6.38, 13.54, 0.44, 0, 0, 0, 5.8, 0, 5.8, 0.41, 61, 72, 53, 61, '2026-03-05 03:19:12.846423', '2026-03-05 03:19:51.404721', 8, NULL, 115, 207, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 11.0, \"2\": 9.0, \"3\": 3.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 6.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 53.0}}');
INSERT INTO `scores_algorithmscore` VALUES (116, 100, 90, 94, 85, 90, 21, 12, 27, 4, 64, 2, 1.8, 3.76, 0, 12.6, 20.16, 0.7, 1.5, 1.35, 2.82, 6.8, 7.2, 19.67, 0.76, 1.5, 1.35, 2.82, 3.4, 14.35, 23.42, 0.76, 0, 0, 0, 6.8, 2.4, 9.2, 0.66, 74, 90, 64, 74, '2026-03-05 03:19:12.873023', '2026-03-05 03:19:51.418064', 8, NULL, 116, 208, 1, '{\"一\": {\"total\": 10.0}, \"三\": {\"1\": 11.0, \"2\": 15.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 2.0, \"2\": 2.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 4.0}, \"卷面\": {\"total\": 64.0}}');
INSERT INTO `scores_algorithmscore` VALUES (117, 96, 80, 98, 97.5, 95, 33, 17, 32, 10, 92, 1.92, 1.6, 3.92, 0, 19.8, 27.24, 0.94, 1.44, 1.2, 2.94, 7.8, 10.2, 23.58, 0.91, 1.44, 1.2, 2.94, 3.9, 17.01, 26.49, 0.85, 0, 0, 0, 7.8, 6, 13.8, 0.99, 93, 95, 92, 93, '2026-03-05 03:19:12.900064', '2026-03-05 03:19:51.432203', 8, NULL, 117, 209, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 12.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 7.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 92.0}}');
INSERT INTO `scores_algorithmscore` VALUES (118, 100, 75, 82, 72.5, 79, 27, 14, 11, 0, 52, 2, 1.5, 3.28, 0, 16.2, 22.98, 0.79, 1.5, 1.12, 2.46, 5.8, 8.4, 19.28, 0.74, 1.5, 1.12, 2.46, 2.9, 5.85, 13.83, 0.45, 0, 0, 0, 5.8, 0, 5.8, 0.41, 63, 79, 52, 63, '2026-03-05 03:19:12.922943', '2026-03-05 03:19:51.446866', 8, NULL, 118, 210, 1, '{\"一\": {\"total\": 12.0}, \"三\": {\"1\": 15.0, \"2\": 11.0, \"3\": 0.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 52.0}}');
INSERT INTO `scores_algorithmscore` VALUES (119, 100, 80, 90, 82.5, 86, 29, 12, 28, 5, 74, 2, 1.6, 3.6, 0, 17.4, 24.6, 0.85, 1.5, 1.2, 2.7, 6.6, 7.2, 19.2, 0.74, 1.5, 1.2, 2.7, 3.3, 14.88, 23.58, 0.76, 0, 0, 0, 6.6, 3, 9.6, 0.69, 79, 86, 74, 79, '2026-03-05 03:19:12.951161', '2026-03-05 03:19:51.459251', 8, NULL, 119, 211, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 15.0, \"2\": 12.0, \"3\": 11.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 2.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 74.0}}');
INSERT INTO `scores_algorithmscore` VALUES (120, 96, 85, 94, 92.5, 92, 29, 14, 32, 7, 82, 1.92, 1.7, 3.76, 0, 17.4, 24.78, 0.85, 1.44, 1.27, 2.82, 7.4, 8.4, 21.33, 0.82, 1.44, 1.27, 2.82, 3.7, 17.01, 26.24, 0.85, 0, 0, 0, 7.4, 4.2, 11.6, 0.83, 86, 92, 82, 86, '2026-03-05 03:19:12.977201', '2026-03-05 03:19:51.469760', 8, NULL, 120, 212, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 13.0, \"2\": 15.0, \"3\": 12.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 7.0}, \"卷面\": {\"total\": 82.0}}');
INSERT INTO `scores_algorithmscore` VALUES (121, 96, 95, 96, 87.5, 92, 33, 10, 25, 0, 68, 1.92, 1.9, 3.84, 0, 19.8, 27.46, 0.95, 1.44, 1.43, 2.88, 7, 6, 18.75, 0.72, 1.44, 1.43, 2.88, 3.5, 13.29, 22.54, 0.73, 0, 0, 0, 7, 0, 7, 0.5, 78, 92, 68, 78, '2026-03-05 03:19:13.001748', '2026-03-05 03:19:51.482715', 8, NULL, 121, 213, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 15.0, \"2\": 11.0, \"3\": 14.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 4.0, \"3\": 6.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 68.0}}');
INSERT INTO `scores_algorithmscore` VALUES (122, 100, 90, 91, 95, 94, 31, 16, 30, 10, 87, 2, 1.8, 3.64, 0, 18.6, 26.04, 0.9, 1.5, 1.35, 2.73, 7.6, 9.6, 22.78, 0.88, 1.5, 1.35, 2.73, 3.8, 15.94, 25.32, 0.82, 0, 0, 0, 7.6, 6, 13.6, 0.97, 90, 94, 87, 90, '2026-03-05 03:19:13.027570', '2026-03-05 03:19:51.497376', 8, NULL, 122, 214, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 13.0, \"2\": 15.0, \"3\": 15.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 6.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 87.0}}');
INSERT INTO `scores_algorithmscore` VALUES (123, 92, 75, 88, 90, 88, 29, 16, 31, 0, 76, 1.84, 1.5, 3.52, 0, 17.4, 24.26, 0.84, 1.38, 1.12, 2.64, 7.2, 9.6, 21.94, 0.84, 1.38, 1.12, 2.64, 3.6, 16.47, 25.21, 0.81, 0, 0, 0, 7.2, 0, 7.2, 0.51, 81, 88, 76, 81, '2026-03-05 03:19:13.057485', '2026-03-05 03:19:51.509543', 8, NULL, 123, 215, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 11.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 6.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 76.0}}');
INSERT INTO `scores_algorithmscore` VALUES (124, 92, 75, 90, 85, 86, 31, 14, 26, 10, 81, 1.84, 1.5, 3.6, 0, 18.6, 25.54, 0.88, 1.38, 1.12, 2.7, 6.8, 8.4, 20.4, 0.78, 1.38, 1.12, 2.7, 3.4, 13.82, 22.42, 0.72, 0, 0, 0, 6.8, 6, 12.8, 0.91, 83, 86, 81, 83, '2026-03-05 03:19:13.083598', '2026-03-05 03:19:51.521496', 8, NULL, 124, 216, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 11.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 81.0}}');
INSERT INTO `scores_algorithmscore` VALUES (125, 98, 90, 92, 82.5, 88, 23, 12, 25, 5, 65, 1.96, 1.8, 3.68, 0, 13.8, 21.24, 0.73, 1.47, 1.35, 2.76, 6.6, 7.2, 19.38, 0.75, 1.47, 1.35, 2.76, 3.3, 13.29, 22.17, 0.72, 0, 0, 0, 6.6, 3, 9.6, 0.69, 74, 88, 65, 74, '2026-03-05 03:19:13.111968', '2026-03-05 03:19:51.535748', 8, NULL, 125, 217, 1, '{\"一\": {\"total\": 8.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 2.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 65.0}}');
INSERT INTO `scores_algorithmscore` VALUES (126, 100, 90, 89, 87.5, 90, 25, 14, 25, 0, 64, 2, 1.8, 3.56, 0, 15, 22.36, 0.77, 1.5, 1.35, 2.67, 7, 8.4, 20.92, 0.8, 1.5, 1.35, 2.67, 3.5, 13.29, 22.31, 0.72, 0, 0, 0, 7, 0, 7, 0.5, 74, 90, 64, 74, '2026-03-05 03:19:13.136653', '2026-03-05 03:19:51.548499', 8, NULL, 126, 218, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 11.0, \"2\": 15.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 64.0}}');
INSERT INTO `scores_algorithmscore` VALUES (127, 100, 80, 91, 85, 88, 31, 14, 24, 7, 76, 2, 1.6, 3.64, 0, 18.6, 25.84, 0.89, 1.5, 1.2, 2.73, 6.8, 8.4, 20.63, 0.79, 1.5, 1.2, 2.73, 3.4, 12.75, 21.58, 0.7, 0, 0, 0, 6.8, 4.2, 11, 0.79, 81, 88, 76, 81, '2026-03-05 03:19:13.162735', '2026-03-05 03:19:51.559120', 8, NULL, 127, 219, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2\": 7.0, \"3\": 12.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 7.0}, \"卷面\": {\"total\": 76.0}}');
INSERT INTO `scores_algorithmscore` VALUES (128, 100, 75, 84, 80, 83, 27, 14, 28, 5, 74, 2, 1.5, 3.36, 0, 16.2, 23.06, 0.8, 1.5, 1.12, 2.52, 6.4, 8.4, 19.94, 0.77, 1.5, 1.12, 2.52, 3.2, 14.88, 23.22, 0.75, 0, 0, 0, 6.4, 3, 9.4, 0.67, 78, 83, 74, 78, '2026-03-05 03:19:13.188621', '2026-03-05 03:19:51.573404', 8, NULL, 128, 220, 1, '{\"一\": {\"total\": 12.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 11.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 2.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 74.0}}');
INSERT INTO `scores_algorithmscore` VALUES (129, 92, 70, 94, 87.5, 88, 31, 14, 31, 10, 86, 1.84, 1.4, 3.76, 0, 18.6, 25.6, 0.88, 1.38, 1.05, 2.82, 7, 8.4, 20.65, 0.79, 1.38, 1.05, 2.82, 3.5, 16.47, 25.22, 0.81, 0, 0, 0, 7, 6, 13, 0.93, 87, 88, 86, 87, '2026-03-05 03:19:13.216122', '2026-03-05 03:19:51.588035', 8, NULL, 129, 221, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 11.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 86.0}}');
INSERT INTO `scores_algorithmscore` VALUES (130, 92, 95, 99, 87.5, 92, 25, 20, 25, 5, 75, 1.84, 1.9, 3.96, 0, 15, 22.7, 0.78, 1.38, 1.43, 2.97, 7, 12, 24.78, 0.95, 1.38, 1.43, 2.97, 3.5, 13.29, 22.57, 0.73, 0, 0, 0, 7, 3, 10, 0.71, 82, 92, 75, 82, '2026-03-05 03:19:13.241940', '2026-03-05 03:19:51.601894', 8, NULL, 130, 222, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 7.0, \"2\": 15.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 10.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 75.0}}');
INSERT INTO `scores_algorithmscore` VALUES (131, 100, 85, 94, 82.5, 88, 31, 9, 27, 5, 72, 2, 1.7, 3.76, 0, 18.6, 26.06, 0.9, 1.5, 1.27, 2.82, 6.6, 5.4, 17.59, 0.68, 1.5, 1.27, 2.82, 3.3, 14.35, 23.24, 0.75, 0, 0, 0, 6.6, 3, 9.6, 0.69, 78, 88, 72, 78, '2026-03-05 03:19:13.266906', '2026-03-05 03:19:51.613988', 8, NULL, 131, 223, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 12.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 4.0, \"3\": 5.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 72.0}}');
INSERT INTO `scores_algorithmscore` VALUES (132, 96, 75, 91, 82.5, 85, 27, 14, 27, 10, 78, 1.92, 1.5, 3.64, 0, 16.2, 23.26, 0.8, 1.44, 1.12, 2.73, 6.6, 8.4, 20.29, 0.78, 1.44, 1.12, 2.73, 3.3, 14.35, 22.94, 0.74, 0, 0, 0, 6.6, 6, 12.6, 0.9, 81, 85, 78, 81, '2026-03-05 03:19:13.293894', '2026-03-05 03:19:51.628073', 8, NULL, 132, 224, 1, '{\"一\": {\"total\": 12.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 12.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 78.0}}');
INSERT INTO `scores_algorithmscore` VALUES (133, 100, 85, 100, 75, 86, 27, 14, 27, 0, 68, 2, 1.7, 4, 0, 16.2, 23.9, 0.82, 1.5, 1.27, 3, 6, 8.4, 20.17, 0.78, 1.5, 1.27, 3, 3, 14.35, 23.12, 0.75, 0, 0, 0, 6, 0, 6, 0.43, 75, 86, 68, 75, '2026-03-05 03:19:13.316823', '2026-03-05 03:19:51.641024', 8, NULL, 133, 225, 1, '{\"一\": {\"total\": 12.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 12.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 68.0}}');
INSERT INTO `scores_algorithmscore` VALUES (134, 100, 90, 92, 82.5, 88, 33, 14, 25, 10, 82, 2, 1.8, 3.68, 0, 19.8, 27.28, 0.94, 1.5, 1.35, 2.76, 6.6, 8.4, 20.61, 0.79, 1.5, 1.35, 2.76, 3.3, 13.29, 22.2, 0.72, 0, 0, 0, 6.6, 6, 12.6, 0.9, 84, 88, 82, 84, '2026-03-05 03:19:13.340830', '2026-03-05 03:19:51.655690', 8, NULL, 134, 226, 1, '{\"一\": {\"total\": 18.0}, \"三\": {\"1\": 15.0, \"2\": 10.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 82.0}}');
INSERT INTO `scores_algorithmscore` VALUES (135, 96, 90, 97, 80, 88, 27, 14, 26, 5, 72, 1.92, 1.8, 3.88, 0, 16.2, 23.8, 0.82, 1.44, 1.35, 2.91, 6.4, 8.4, 20.5, 0.79, 1.44, 1.35, 2.91, 3.2, 13.82, 22.72, 0.73, 0, 0, 0, 6.4, 3, 9.4, 0.67, 78, 88, 72, 78, '2026-03-05 03:19:13.367608', '2026-03-05 03:19:51.668349', 8, NULL, 135, 227, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 11.0, \"2\": 15.0, \"3\": 11.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 72.0}}');
INSERT INTO `scores_algorithmscore` VALUES (136, 100, 90, 93, 85, 89, 25, 14, 21, 5, 65, 2, 1.8, 3.72, 0, 15, 22.52, 0.78, 1.5, 1.35, 2.79, 6.8, 8.4, 20.84, 0.8, 1.5, 1.35, 2.79, 3.4, 11.16, 20.2, 0.65, 0, 0, 0, 6.8, 3, 9.8, 0.7, 75, 89, 65, 75, '2026-03-05 03:19:13.393048', '2026-03-05 03:19:51.682664', 8, NULL, 136, 228, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 11.0, \"2\": 10.0, \"3\": 11.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 4.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 65.0}}');
INSERT INTO `scores_algorithmscore` VALUES (137, 100, 75, 93, 85, 88, 29, 20, 22, 10, 81, 2, 1.5, 3.72, 0, 17.4, 24.62, 0.85, 1.5, 1.12, 2.79, 6.8, 12, 24.21, 0.93, 1.5, 1.12, 2.79, 3.4, 11.69, 20.5, 0.66, 0, 0, 0, 6.8, 6, 12.8, 0.91, 84, 88, 81, 84, '2026-03-05 03:19:13.414856', '2026-03-05 03:19:51.698504', 8, NULL, 137, 229, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 15.0, \"2\": 7.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 10.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 81.0}}');
INSERT INTO `scores_algorithmscore` VALUES (138, 96, 70, 82, 80, 81, 25, 20, 35, 0, 80, 1.92, 1.4, 3.28, 0, 15, 21.6, 0.74, 1.44, 1.05, 2.46, 6.4, 12, 23.35, 0.9, 1.44, 1.05, 2.46, 3.2, 18.6, 26.75, 0.86, 0, 0, 0, 6.4, 0, 6.4, 0.46, 80, 81, 80, 80, '2026-03-05 03:19:13.441727', '2026-03-05 03:19:51.709957', 8, NULL, 138, 230, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 11.0, \"2\": 15.0, \"3\": 15.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 10.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 80.0}}');
INSERT INTO `scores_algorithmscore` VALUES (139, 100, 80, 84, 80, 83, 25, 10, 5, 0, 40, 2, 1.6, 3.36, 0, 15, 21.96, 0.76, 1.5, 1.2, 2.52, 6.4, 6, 17.62, 0.68, 1.5, 1.2, 2.52, 3.2, 2.66, 11.08, 0.36, 0, 0, 0, 6.4, 0, 6.4, 0.46, 57, 83, 40, 57, '2026-03-05 03:19:13.465022', '2026-03-05 03:19:51.723604', 8, NULL, 139, 231, 1, '{\"一\": {\"total\": 14.0}, \"三\": {\"1\": 11.0, \"2\": 0.0, \"3\": 5.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 10.0, \"3\": 0.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 40.0}}');
INSERT INTO `scores_algorithmscore` VALUES (140, 96, 85, 94, 90, 91, 29, 4, 25, 5, 63, 1.92, 1.7, 3.76, 0, 17.4, 24.78, 0.85, 1.44, 1.27, 2.82, 7.2, 2.4, 15.13, 0.58, 1.44, 1.27, 2.82, 3.6, 13.29, 22.42, 0.72, 0, 0, 0, 7.2, 3, 10.2, 0.73, 74, 91, 63, 74, '2026-03-05 03:19:13.490320', '2026-03-05 03:19:51.740882', 8, NULL, 140, 232, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 13.0, \"2\": 7.0, \"3\": 13.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 4.0, \"3\": 0.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 63.0}}');
INSERT INTO `scores_algorithmscore` VALUES (141, 100, 85, 88, 87.5, 89, 27, 10, 27, 5, 69, 2, 1.7, 3.52, 0, 16.2, 23.42, 0.81, 1.5, 1.27, 2.64, 7, 6, 18.41, 0.71, 1.5, 1.27, 2.64, 3.5, 14.35, 23.26, 0.75, 0, 0, 0, 7, 3, 10, 0.71, 77, 89, 69, 77, '2026-03-05 03:19:13.518070', '2026-03-05 03:19:51.755348', 8, NULL, 141, 233, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 11.0, \"2\": 12.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 5.0, \"2\": 0.0, \"3\": 10.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 5.0}, \"卷面\": {\"total\": 69.0}}');
INSERT INTO `scores_algorithmscore` VALUES (142, 100, 90, 86, 95, 93, 31, 4, 16, 0, 51, 2, 1.8, 3.44, 0, 18.6, 25.84, 0.89, 1.5, 1.35, 2.58, 7.6, 2.4, 15.43, 0.59, 1.5, 1.35, 2.58, 3.8, 8.5, 17.73, 0.57, 0, 0, 0, 7.6, 0, 7.6, 0.54, 68, 93, 51, 68, '2026-03-05 03:19:13.545358', '2026-03-05 03:19:51.770422', 8, NULL, 142, 234, 1, '{\"一\": {\"total\": 16.0}, \"三\": {\"1\": 15.0, \"2\": 15.0, \"3\": 1.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 4.0, \"3\": 0.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 0.0}, \"卷面\": {\"total\": 51.0}}');
INSERT INTO `scores_algorithmscore` VALUES (143, 100, 75, 79, 72.5, 78, 27, 4, 20, 10, 61, 2, 1.5, 3.16, 0, 16.2, 22.86, 0.79, 1.5, 1.12, 2.37, 5.8, 2.4, 13.19, 0.51, 1.5, 1.12, 2.37, 2.9, 10.63, 18.52, 0.6, 0, 0, 0, 5.8, 6, 11.8, 0.84, 68, 78, 61, 68, '2026-03-05 03:19:13.568529', '2026-03-05 03:19:51.784224', 8, NULL, 143, 235, 1, '{\"一\": {\"total\": 12.0}, \"三\": {\"1\": 15.0, \"2\": 8.0, \"3\": 12.0, \"2.0\": null, \"3.0\": null}, \"二\": {\"1\": 0.0, \"2\": 4.0, \"3\": 0.0, \"2.0\": null, \"3.0\": null}, \"四\": {\"total\": 10.0}, \"卷面\": {\"total\": 61.0}}');

-- ----------------------------
-- Table structure for scores_gradebook
-- ----------------------------
DROP TABLE IF EXISTS `scores_gradebook`;
CREATE TABLE `scores_gradebook`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `homework1` double NULL DEFAULT NULL,
  `homework2` double NULL DEFAULT NULL,
  `homework3` double NULL DEFAULT NULL,
  `homework4` double NULL DEFAULT NULL,
  `homework5` double NULL DEFAULT NULL,
  `experiment1` double NULL DEFAULT NULL,
  `experiment2` double NULL DEFAULT NULL,
  `attendance1` double NULL DEFAULT NULL,
  `attendance2` double NULL DEFAULT NULL,
  `attendance3` double NULL DEFAULT NULL,
  `attendance4` double NULL DEFAULT NULL,
  `attendance5` double NULL DEFAULT NULL,
  `review_note` double NULL DEFAULT NULL,
  `final_score` double NULL DEFAULT NULL,
  `usual_score` double NULL DEFAULT NULL,
  `total_score` double NULL DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `course_class_id` bigint NOT NULL,
  `created_by_id` bigint NULL DEFAULT NULL,
  `student_id` bigint NOT NULL,
  `updated_by_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `scores_gradebook_student_id_course_class_id_aec9eee8_uniq`(`student_id` ASC, `course_class_id` ASC) USING BTREE,
  INDEX `scores_gradebook_course_class_id_64ea21e1_fk_courses_c`(`course_class_id` ASC) USING BTREE,
  INDEX `scores_gradebook_created_by_id_5a8bbd5c_fk_users_user_id`(`created_by_id` ASC) USING BTREE,
  INDEX `scores_gradebook_updated_by_id_6538656c_fk_users_user_id`(`updated_by_id` ASC) USING BTREE,
  CONSTRAINT `scores_gradebook_course_class_id_64ea21e1_fk_courses_c` FOREIGN KEY (`course_class_id`) REFERENCES `courses_courseclass` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `scores_gradebook_created_by_id_5a8bbd5c_fk_users_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `users_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `scores_gradebook_student_id_07def73e_fk_users_user_id` FOREIGN KEY (`student_id`) REFERENCES `users_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `scores_gradebook_updated_by_id_6538656c_fk_users_user_id` FOREIGN KEY (`updated_by_id`) REFERENCES `users_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 144 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of scores_gradebook
-- ----------------------------
INSERT INTO `scores_gradebook` VALUES (1, 100, 100, 80, 85, 65, 83, 90, 100, 100, 100, 100, 100, 85, 41, 88, 60, '2026-01-08 11:50:55.125692', '2026-01-09 03:22:11.250746', 4, 1, 93, 1);
INSERT INTO `scores_gradebook` VALUES (2, 80, 100, 75, 75, 60, 85, 75, 100, 100, 100, 100, 80, 70, 66, 80, 72, '2026-01-08 11:50:55.139442', '2026-01-09 03:22:11.267540', 4, 1, 94, 1);
INSERT INTO `scores_gradebook` VALUES (3, 100, 100, 90, 90, 70, 75, 75, 100, 100, 100, 100, 100, 85, 77, 83, 79, '2026-01-08 11:50:55.147699', '2026-01-09 03:22:11.282665', 4, 1, 95, 1);
INSERT INTO `scores_gradebook` VALUES (4, 100, 90, 80, 85, 70, 80, 80, 100, 100, 100, 100, 100, 75, 62, 83, 70, '2026-01-08 11:50:55.156007', '2026-01-09 03:22:11.297342', 4, 1, 96, 1);
INSERT INTO `scores_gradebook` VALUES (5, 100, 100, 85, 100, 85, 95, 85, 100, 100, 100, 100, 100, 95, 80, 93, 85, '2026-01-08 11:50:55.162130', '2026-01-09 03:22:11.311933', 4, 1, 97, 1);
INSERT INTO `scores_gradebook` VALUES (6, 100, 85, 90, 85, 80, 75, 90, 100, 100, 100, 100, 100, 95, 63, 88, 73, '2026-01-08 11:50:55.167387', '2026-01-09 03:22:11.327057', 4, 1, 98, 1);
INSERT INTO `scores_gradebook` VALUES (7, 100, 100, 80, 90, 80, 75, 80, 100, 100, 100, 100, 80, 80, 68, 83, 74, '2026-01-08 11:50:55.177152', '2026-01-09 03:22:11.341095', 4, 1, 99, 1);
INSERT INTO `scores_gradebook` VALUES (8, 85, 95, 85, 85, 90, 75, 70, 100, 100, 100, 100, 100, 90, 84, 82, 83, '2026-01-08 11:50:55.182507', '2026-01-09 03:22:11.354127', 4, 1, 100, 1);
INSERT INTO `scores_gradebook` VALUES (9, 100, 80, 85, 75, 90, 75, 75, 100, 100, 100, 100, 80, 85, 40, 82, 57, '2026-01-08 11:50:55.190524', '2026-01-09 03:22:11.365885', 4, 1, 101, 1);
INSERT INTO `scores_gradebook` VALUES (10, 100, 100, 90, 90, 70, 90, 90, 80, 100, 100, 100, 100, 90, 77, 91, 83, '2026-01-08 11:50:55.195600', '2026-01-09 03:22:11.380201', 4, 1, 102, 1);
INSERT INTO `scores_gradebook` VALUES (11, 90, 100, 75, 85, 90, 75, 85, 100, 100, 100, 100, 100, 75, 72, 84, 77, '2026-01-08 11:50:55.204095', '2026-01-09 03:22:11.392936', 4, 1, 103, 1);
INSERT INTO `scores_gradebook` VALUES (12, 100, 100, 85, 100, 75, 85, 75, 100, 100, 100, 100, 80, 88, 90, 86, 88, '2026-01-08 11:50:55.210091', '2026-01-09 03:22:11.407698', 4, 1, 104, 1);
INSERT INTO `scores_gradebook` VALUES (13, 100, 100, 85, 95, 100, 85, 90, 100, 100, 100, 100, 100, 85, 66, 91, 76, '2026-01-08 11:50:55.215682', '2026-01-09 03:22:11.420323', 4, 1, 105, 1);
INSERT INTO `scores_gradebook` VALUES (14, 100, 100, 90, 85, 80, 95, 90, 100, 100, 100, 100, 100, 90, 84, 93, 88, '2026-01-08 11:50:55.223830', '2026-01-09 03:22:11.434043', 4, 1, 106, 1);
INSERT INTO `scores_gradebook` VALUES (15, 90, 80, 70, 70, 70, 75, 70, 100, 100, 100, 100, 100, 65, 63, 76, 68, '2026-01-08 11:50:55.229906', '2026-01-09 03:22:11.448542', 4, 1, 107, 1);
INSERT INTO `scores_gradebook` VALUES (16, 100, 85, 90, 100, 90, 100, 100, 100, 100, 100, 100, 100, 95, 88, 98, 92, '2026-01-08 11:50:55.238941', '2026-01-09 03:22:11.462264', 4, 1, 108, 1);
INSERT INTO `scores_gradebook` VALUES (17, 100, 100, 85, 85, 85, 100, 100, 100, 100, 100, 100, 100, 90, 76, 96, 84, '2026-01-08 11:50:55.247125', '2026-01-09 03:22:11.475365', 4, 1, 109, 1);
INSERT INTO `scores_gradebook` VALUES (18, 90, 90, 75, 85, 85, 75, 90, 100, 100, 100, 100, 100, 80, 74, 85, 78, '2026-01-08 11:50:55.253127', '2026-01-09 03:22:11.488167', 4, 1, 110, 1);
INSERT INTO `scores_gradebook` VALUES (19, 100, 100, 90, 75, 100, 85, 100, 100, 100, 100, 100, 100, 90, 50, 93, 67, '2026-01-08 11:50:55.259636', '2026-01-09 03:22:11.501283', 4, 1, 111, 1);
INSERT INTO `scores_gradebook` VALUES (20, 85, 90, 75, 75, 100, 75, 90, 100, 100, 100, 100, 100, 70, 60, 84, 70, '2026-01-08 11:50:55.265086', '2026-01-09 03:22:11.516475', 4, 1, 112, 1);
INSERT INTO `scores_gradebook` VALUES (21, 75, 80, 75, 70, 90, 75, 75, 100, 100, 100, 100, 100, 75, 66, 79, 71, '2026-01-08 11:50:55.272382', '2026-01-09 03:22:11.531384', 4, 1, 113, 1);
INSERT INTO `scores_gradebook` VALUES (22, 100, 90, 75, 100, 95, 80, 75, 100, 100, 100, 100, 100, 85, 71, 85, 77, '2026-01-08 11:50:55.279230', '2026-01-09 03:22:11.546401', 4, 1, 114, 1);
INSERT INTO `scores_gradebook` VALUES (23, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 95, 93, 99, 95, '2026-01-08 11:50:55.290147', '2026-01-09 03:22:11.561040', 4, 1, 115, 1);
INSERT INTO `scores_gradebook` VALUES (24, 100, 100, 85, 100, 85, 80, 100, 100, 100, 100, 100, 100, 90, 49, 92, 66, '2026-01-08 11:50:55.296448', '2026-01-09 03:22:11.573581', 4, 1, 116, 1);
INSERT INTO `scores_gradebook` VALUES (25, 85, 90, 75, 70, 85, 75, 85, 100, 100, 100, 100, 100, 90, 51, 84, 64, '2026-01-08 11:50:55.303560', '2026-01-09 03:22:11.587332', 4, 1, 117, 1);
INSERT INTO `scores_gradebook` VALUES (26, 80, 100, 80, 90, 100, 75, 90, 100, 100, 100, 100, 100, 78, 70, 86, 76, '2026-01-08 11:50:55.309871', '2026-01-09 03:22:11.601874', 4, 1, 118, 1);
INSERT INTO `scores_gradebook` VALUES (27, 100, 100, 90, 85, 100, 100, 85, 100, 100, 100, 100, 100, 95, 93, 94, 93, '2026-01-08 11:50:55.315932', '2026-01-09 03:22:11.616558', 4, 1, 119, 1);
INSERT INTO `scores_gradebook` VALUES (28, 100, 100, 95, 80, 90, 100, 100, 100, 100, 100, 100, 100, 98, 94, 98, 96, '2026-01-09 10:42:26.286197', '2026-01-09 10:42:26.300905', 5, 1, 120, 1);
INSERT INTO `scores_gradebook` VALUES (29, 80, 80, 85, 90, 85, 85, 85, 100, 100, 100, 100, 100, 85, 96, 87, 92, '2026-01-09 10:42:26.311229', '2026-01-09 10:42:26.321875', 5, 1, 121, 1);
INSERT INTO `scores_gradebook` VALUES (30, 100, 100, 95, 100, 100, 100, 100, 100, 100, 100, 100, 100, 75, 82, 97, 88, '2026-01-09 10:42:26.330070', '2026-01-09 10:42:26.338687', 5, 1, 122, 1);
INSERT INTO `scores_gradebook` VALUES (31, 100, 100, 100, 95, 85, 85, 100, 100, 100, 100, 100, 100, 80, 78, 93, 84, '2026-01-09 10:42:26.345976', '2026-01-09 10:42:26.355575', 5, 1, 123, 1);
INSERT INTO `scores_gradebook` VALUES (32, 100, 100, 100, 100, 90, 90, 85, 100, 100, 100, 100, 100, 80, 88, 91, 89, '2026-01-09 10:42:26.361853', '2026-01-09 10:42:26.370293', 5, 1, 124, 1);
INSERT INTO `scores_gradebook` VALUES (33, 100, 100, 100, 90, 80, 90, 90, 100, 100, 100, 100, 100, 80, 98, 91, 95, '2026-01-09 10:42:26.377610', '2026-01-09 10:42:26.385046', 5, 1, 125, 1);
INSERT INTO `scores_gradebook` VALUES (34, 100, 100, 100, 95, 100, 85, 85, 100, 100, 100, 100, 100, 95, 75, 92, 82, '2026-01-09 10:42:26.391526', '2026-01-09 10:42:26.402241', 5, 1, 126, 1);
INSERT INTO `scores_gradebook` VALUES (35, 100, 100, 95, 85, 85, 100, 90, 100, 100, 100, 100, 100, 80, 86, 93, 89, '2026-01-09 10:42:26.409487', '2026-01-09 10:42:26.421237', 5, 1, 127, 1);
INSERT INTO `scores_gradebook` VALUES (36, 100, 100, 100, 95, 90, 85, 100, 100, 100, 100, 100, 100, 95, 81, 95, 87, '2026-01-09 10:42:26.429674', '2026-01-09 10:42:26.440105', 5, 1, 128, 1);
INSERT INTO `scores_gradebook` VALUES (37, 100, 70, 70, 85, 80, 90, 100, 100, 100, 100, 100, 100, 90, 81, 92, 85, '2026-01-09 10:42:26.447452', '2026-01-09 10:42:26.455785', 5, 1, 129, 1);
INSERT INTO `scores_gradebook` VALUES (38, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 98, 98, 100, 99, '2026-01-09 10:42:26.465691', '2026-01-09 10:42:26.475384', 5, 1, 130, 1);
INSERT INTO `scores_gradebook` VALUES (39, 80, 85, 85, 90, 80, 85, 80, 100, 100, 80, 100, 100, 80, 79, 84, 81, '2026-01-09 10:42:26.482325', '2026-01-09 10:42:26.489620', 5, 1, 131, 1);
INSERT INTO `scores_gradebook` VALUES (40, 85, 85, 100, 80, 85, 75, 75, 100, 100, 100, 100, 100, 65, 84, 80, 82, '2026-01-09 10:42:26.502086', '2026-01-09 10:42:26.514194', 5, 1, 132, 1);
INSERT INTO `scores_gradebook` VALUES (41, 85, 100, 95, 80, 90, 90, 100, 100, 100, 100, 100, 100, 95, 84, 94, 88, '2026-01-09 10:42:26.522537', '2026-01-09 10:42:26.533357', 5, 1, 133, 1);
INSERT INTO `scores_gradebook` VALUES (42, 75, 75, 80, 80, 85, 75, 95, 100, 100, 100, 100, 100, 75, 83, 84, 83, '2026-01-09 10:42:26.541959', '2026-01-09 10:42:26.553759', 5, 1, 134, 1);
INSERT INTO `scores_gradebook` VALUES (43, 85, 80, 75, 75, 80, 85, 95, 100, 80, 100, 80, 100, 80, 89, 86, 88, '2026-01-09 10:42:26.562515', '2026-01-09 10:42:26.573411', 5, 1, 135, 1);
INSERT INTO `scores_gradebook` VALUES (44, 100, 100, 95, 100, 100, 100, 95, 100, 100, 100, 100, 100, 90, 67, 97, 79, '2026-01-09 10:42:26.580818', '2026-01-09 10:42:26.592829', 5, 1, 136, 1);
INSERT INTO `scores_gradebook` VALUES (45, 85, 80, 75, 100, 80, 80, 95, 100, 100, 100, 80, 100, 65, 80, 85, 82, '2026-01-09 10:42:26.599036', '2026-01-09 10:42:26.608846', 5, 1, 137, 1);
INSERT INTO `scores_gradebook` VALUES (46, 100, 100, 95, 100, 100, 100, 100, 100, 100, 100, 100, 100, 85, 95, 98, 96, '2026-01-09 10:42:26.618296', '2026-01-09 10:42:26.630818', 5, 1, 138, 1);
INSERT INTO `scores_gradebook` VALUES (47, 100, 95, 100, 90, 85, 85, 100, 100, 100, 100, 100, 100, 88, 83, 93, 87, '2026-01-09 10:42:26.639417', '2026-01-09 10:42:26.647820', 5, 1, 139, 1);
INSERT INTO `scores_gradebook` VALUES (48, 90, 100, 85, 90, 85, 75, 85, 100, 100, 100, 80, 100, 90, 69, 86, 76, '2026-01-09 10:42:26.655397', '2026-01-09 10:42:26.668942', 5, 1, 140, 1);
INSERT INTO `scores_gradebook` VALUES (49, 100, 100, 90, 100, 90, 100, 100, 100, 100, 100, 100, 100, 95, 84, 98, 90, '2026-01-09 10:42:26.675290', '2026-01-09 10:42:26.686015', 5, 1, 141, 1);
INSERT INTO `scores_gradebook` VALUES (50, 75, 80, 70, 70, 90, 75, 75, 100, 100, 100, 100, 80, 65, 78, 77, 78, '2026-01-09 10:42:26.693311', '2026-01-09 10:42:26.705254', 5, 1, 142, 1);
INSERT INTO `scores_gradebook` VALUES (51, 100, 100, 100, 100, 100, 85, 100, 80, 100, 80, 100, 100, 98, 85, 95, 89, '2026-01-09 10:42:26.712651', '2026-01-09 10:42:26.721211', 5, 1, 143, 1);
INSERT INTO `scores_gradebook` VALUES (52, 100, 100, 100, 85, 85, 85, 80, 100, 100, 100, 100, 100, 75, 90, 87, 89, '2026-01-09 10:42:26.727564', '2026-01-09 10:42:26.740695', 5, 1, 144, 1);
INSERT INTO `scores_gradebook` VALUES (53, 100, 100, 90, 90, 85, 100, 90, 100, 100, 100, 100, 80, 90, 91, 94, 92, '2026-01-09 10:42:26.747933', '2026-01-09 10:42:26.756416', 5, 1, 145, 1);
INSERT INTO `scores_gradebook` VALUES (54, 90, 100, 100, 100, 90, 85, 85, 100, 100, 100, 100, 100, 95, 88, 91, 89, '2026-01-09 10:42:26.765864', '2026-01-09 10:42:26.775722', 5, 1, 146, 1);
INSERT INTO `scores_gradebook` VALUES (55, 80, 85, 75, 75, 90, 80, 95, 100, 100, 100, 100, 100, 80, 68, 86, 75, '2026-01-09 10:42:26.784710', '2026-01-09 10:42:26.793977', 5, 1, 147, 1);
INSERT INTO `scores_gradebook` VALUES (56, 100, 100, 80, 100, 90, 95, 85, 100, 100, 100, 100, 100, 100, 77, 93, 83, '2026-01-09 10:42:26.801937', '2026-01-09 10:42:26.812776', 5, 1, 148, 1);
INSERT INTO `scores_gradebook` VALUES (57, 100, 90, 100, 90, 100, 100, 100, 100, 100, 100, 100, 100, 95, 65, 98, 78, '2026-01-09 10:42:26.821034', '2026-01-09 10:42:26.830688', 5, 1, 149, 1);
INSERT INTO `scores_gradebook` VALUES (58, 100, 100, 100, 95, 85, 90, 100, 100, 100, 100, 100, 100, 80, 77, 94, 84, '2026-01-11 08:00:01.579651', '2026-01-11 08:00:01.612458', 6, 1, 150, 1);
INSERT INTO `scores_gradebook` VALUES (59, 100, 100, 90, 75, 80, 75, 75, 100, 100, 100, 100, 100, 75, 40, 82, 57, '2026-01-11 08:00:01.633055', '2026-01-11 08:00:01.661483', 6, 1, 151, 1);
INSERT INTO `scores_gradebook` VALUES (60, 90, 100, 85, 90, 75, 75, 85, 80, 100, 100, 100, 100, 90, 82, 85, 83, '2026-01-11 08:00:01.680604', '2026-01-11 08:00:01.704055', 6, 1, 152, 1);
INSERT INTO `scores_gradebook` VALUES (61, 70, 60, 70, 70, 70, 75, 75, 100, 100, 100, 100, 100, 85, 87, 78, 83, '2026-01-11 08:00:01.724722', '2026-01-11 08:00:01.749230', 6, 1, 153, 1);
INSERT INTO `scores_gradebook` VALUES (62, 100, 100, 75, 100, 90, 65, 80, 80, 100, 100, 100, 100, 85, 63, 82, 71, '2026-01-11 08:00:01.770232', '2026-01-11 08:00:01.796616', 6, 1, 154, 1);
INSERT INTO `scores_gradebook` VALUES (63, 100, 100, 100, 85, 75, 95, 80, 100, 100, 100, 100, 100, 90, 60, 90, 72, '2026-01-11 08:00:01.817454', '2026-01-11 08:00:01.844982', 6, 1, 155, 1);
INSERT INTO `scores_gradebook` VALUES (64, 100, 95, 95, 95, 80, 100, 90, 100, 80, 100, 100, 100, 85, 83, 93, 87, '2026-01-11 08:00:01.863872', '2026-01-11 08:00:01.889974', 6, 1, 156, 1);
INSERT INTO `scores_gradebook` VALUES (65, 100, 100, 100, 100, 90, 100, 90, 100, 100, 100, 100, 100, 90, 95, 96, 95, '2026-01-11 08:00:01.907052', '2026-01-11 08:00:01.937134', 6, 1, 157, 1);
INSERT INTO `scores_gradebook` VALUES (66, 100, 100, 100, 95, 85, 95, 95, 80, 100, 80, 100, 80, 90, 78, 94, 84, '2026-01-11 08:00:01.957697', '2026-01-11 08:00:01.984341', 6, 1, 158, 1);
INSERT INTO `scores_gradebook` VALUES (67, 100, 95, 85, 100, 70, 85, 80, 100, 80, 100, 100, 100, 85, 70, 86, 76, '2026-01-11 08:00:02.005577', '2026-01-11 08:00:02.030658', 6, 1, 159, 1);
INSERT INTO `scores_gradebook` VALUES (68, 80, 85, 85, 90, 70, 85, 80, 100, 100, 100, 100, 100, 80, 58, 84, 68, '2026-01-11 08:00:02.049002', '2026-01-11 08:00:02.072587', 6, 1, 160, 1);
INSERT INTO `scores_gradebook` VALUES (69, 100, 100, 90, 95, 85, 100, 85, 100, 100, 100, 100, 100, 90, 81, 93, 86, '2026-01-11 08:00:02.092578', '2026-01-11 08:00:02.118558', 6, 1, 161, 1);
INSERT INTO `scores_gradebook` VALUES (70, 100, 100, 100, 100, 90, 100, 95, 100, 100, 100, 100, 80, 95, 71, 97, 81, '2026-01-11 08:00:02.136888', '2026-01-11 08:00:02.164223', 6, 1, 162, 1);
INSERT INTO `scores_gradebook` VALUES (71, 100, 100, 75, 75, 80, 75, 75, 80, 100, 100, 100, 100, 90, 51, 82, 63, '2026-01-11 08:00:02.183915', '2026-01-11 08:00:02.205399', 6, 1, 163, 1);
INSERT INTO `scores_gradebook` VALUES (72, 90, 80, 75, 75, 70, 80, 90, 80, 100, 100, 100, 100, 75, 76, 83, 79, '2026-01-11 08:00:02.223757', '2026-01-11 08:00:02.251002', 6, 1, 164, 1);
INSERT INTO `scores_gradebook` VALUES (73, 100, 100, 100, 100, 70, 100, 95, 100, 100, 100, 100, 100, 90, 72, 96, 82, '2026-01-11 08:00:02.271858', '2026-01-11 08:00:02.301476', 6, 1, 165, 1);
INSERT INTO `scores_gradebook` VALUES (74, 100, 100, 90, 100, 90, 100, 90, 100, 100, 100, 100, 100, 95, 61, 96, 75, '2026-01-11 08:00:02.322573', '2026-01-11 08:00:02.348840', 6, 1, 166, 1);
INSERT INTO `scores_gradebook` VALUES (75, 100, 100, 90, 100, 95, 85, 95, 100, 100, 100, 100, 100, 90, 72, 93, 80, '2026-01-11 08:00:02.368771', '2026-01-11 08:00:02.398767', 6, 1, 167, 1);
INSERT INTO `scores_gradebook` VALUES (76, 100, 100, 100, 100, 100, 100, 90, 100, 100, 100, 100, 80, 95, 79, 96, 86, '2026-01-11 08:00:02.418797', '2026-01-11 08:00:02.443556', 6, 1, 168, 1);
INSERT INTO `scores_gradebook` VALUES (77, 100, 100, 95, 100, 85, 100, 100, 100, 100, 100, 100, 100, 95, 80, 98, 87, '2026-01-11 08:00:02.461884', '2026-01-11 08:00:02.488816', 6, 1, 169, 1);
INSERT INTO `scores_gradebook` VALUES (78, 100, 100, 70, 85, 75, 75, 75, 100, 100, 100, 100, 100, 65, 83, 80, 82, '2026-01-11 08:00:02.509547', '2026-01-11 08:00:02.536143', 6, 1, 170, 1);
INSERT INTO `scores_gradebook` VALUES (79, 100, 85, 85, 100, 95, 75, 80, 100, 100, 100, 100, 100, 65, 65, 83, 72, '2026-01-11 08:00:02.558238', '2026-01-11 08:00:02.582331', 6, 1, 171, 1);
INSERT INTO `scores_gradebook` VALUES (80, 100, 100, 100, 80, 95, 100, 85, 100, 100, 100, 80, 100, 98, 85, 94, 89, '2026-01-11 08:00:02.601016', '2026-01-11 08:00:02.625595', 6, 1, 172, 1);
INSERT INTO `scores_gradebook` VALUES (81, 90, 100, 70, 70, 88, 85, 85, 100, 100, 100, 100, 100, 80, 44, 86, 61, '2026-01-11 08:00:02.644130', '2026-01-11 08:00:02.668422', 6, 1, 173, 1);
INSERT INTO `scores_gradebook` VALUES (82, 100, 100, 100, 100, 95, 85, 90, 100, 80, 100, 100, 100, 95, 63, 92, 75, '2026-01-11 08:00:02.687472', '2026-01-11 08:00:02.713044', 6, 1, 174, 1);
INSERT INTO `scores_gradebook` VALUES (83, 100, 100, 100, 90, 95, 85, 75, 100, 100, 80, 100, 100, 80, 64, 86, 73, '2026-01-11 08:00:02.732275', '2026-01-11 08:00:02.755915', 6, 1, 175, 1);
INSERT INTO `scores_gradebook` VALUES (84, 100, 100, 80, 70, 75, 90, 85, 100, 100, 100, 100, 100, 85, 79, 88, 83, '2026-01-11 08:00:02.776888', '2026-01-11 08:00:02.804390', 6, 1, 176, 1);
INSERT INTO `scores_gradebook` VALUES (85, 90, 100, 100, 100, 80, 100, 85, 100, 100, 100, 100, 100, 95, 78, 94, 84, '2026-01-11 08:00:02.823518', '2026-01-11 08:00:02.850242', 6, 1, 177, 1);
INSERT INTO `scores_gradebook` VALUES (86, 90, 100, 90, 100, 95, 85, 85, 100, 100, 100, 100, 80, 98, 71, 90, 79, '2026-01-11 08:00:02.870853', '2026-01-11 08:00:02.896483', 6, 1, 178, 1);
INSERT INTO `scores_gradebook` VALUES (87, 90, 90, 100, 100, 100, 95, 90, 100, 100, 100, 100, 100, 90, 86, 94, 89, '2026-01-15 03:06:08.179611', '2026-01-15 03:06:08.200817', 7, 1, 179, 1);
INSERT INTO `scores_gradebook` VALUES (88, 85, 90, 85, 100, 100, 90, 85, 100, 100, 80, 80, 100, 80, 81, 88, 84, '2026-01-15 03:06:08.208319', '2026-01-15 03:06:08.218681', 7, 1, 180, 1);
INSERT INTO `scores_gradebook` VALUES (89, 100, 100, 85, 100, 100, 100, 90, 100, 100, 100, 100, 100, 95, 64, 96, 77, '2026-01-15 03:06:08.226227', '2026-01-15 03:06:08.237757', 7, 1, 181, 1);
INSERT INTO `scores_gradebook` VALUES (90, 100, 95, 90, 90, 100, 100, 90, 100, 100, 80, 100, 100, 90, 77, 94, 84, '2026-01-15 03:06:08.244867', '2026-01-15 03:06:08.257879', 7, 1, 182, 1);
INSERT INTO `scores_gradebook` VALUES (91, 100, 100, 100, 80, 100, 95, 100, 100, 100, 100, 100, 100, 98, 66, 98, 79, '2026-01-15 03:06:08.265392', '2026-01-15 03:06:08.275364', 7, 1, 183, 1);
INSERT INTO `scores_gradebook` VALUES (92, 90, 100, 90, 100, 100, 100, 90, 100, 100, 100, 100, 100, 95, 78, 96, 85, '2026-01-15 03:06:08.284734', '2026-01-15 03:06:08.297308', 7, 1, 184, 1);
INSERT INTO `scores_gradebook` VALUES (93, 100, 100, 85, 100, 100, 100, 85, 100, 100, 100, 100, 100, 85, 85, 94, 89, '2026-01-15 03:06:08.305119', '2026-01-15 03:06:08.316383', 7, 1, 185, 1);
INSERT INTO `scores_gradebook` VALUES (94, 100, 90, 100, 100, 85, 100, 95, 100, 100, 80, 100, 100, 95, 82, 96, 88, '2026-01-15 03:06:08.323126', '2026-01-15 03:06:08.336412', 7, 1, 186, 1);
INSERT INTO `scores_gradebook` VALUES (95, 85, 90, 85, 85, 75, 85, 85, 100, 100, 100, 100, 100, 80, 90, 86, 88, '2026-01-15 03:06:08.344950', '2026-01-15 03:06:08.355018', 7, 1, 187, 1);
INSERT INTO `scores_gradebook` VALUES (96, 100, 100, 75, 100, 75, 95, 85, 100, 80, 100, 100, 100, 85, 50, 90, 66, '2026-01-15 03:06:08.362047', '2026-01-15 03:06:08.372180', 7, 1, 188, 1);
INSERT INTO `scores_gradebook` VALUES (97, 100, 100, 85, 100, 100, 85, 100, 100, 100, 100, 100, 100, 98, 74, 95, 82, '2026-01-15 03:06:08.379898', '2026-01-15 03:06:08.391158', 7, 1, 189, 1);
INSERT INTO `scores_gradebook` VALUES (98, 100, 75, 85, 100, 100, 95, 100, 100, 100, 100, 100, 100, 90, 89, 96, 92, '2026-01-15 03:06:08.397417', '2026-01-15 03:06:08.407342', 7, 1, 190, 1);
INSERT INTO `scores_gradebook` VALUES (99, 75, 85, 75, 85, 85, 85, 100, 100, 100, 100, 100, 100, 80, 78, 89, 82, '2026-01-15 03:06:08.414042', '2026-01-15 03:06:08.423619', 7, 1, 191, 1);
INSERT INTO `scores_gradebook` VALUES (100, 100, 100, 75, 100, 85, 95, 100, 100, 100, 100, 100, 100, 85, 66, 95, 78, '2026-01-15 03:06:08.431916', '2026-01-15 03:06:08.443766', 7, 1, 192, 1);
INSERT INTO `scores_gradebook` VALUES (101, 100, 100, 85, 100, 95, 95, 100, 100, 100, 100, 100, 100, 75, 70, 95, 80, '2026-01-15 03:06:08.453301', '2026-01-15 03:06:08.463950', 7, 1, 193, 1);
INSERT INTO `scores_gradebook` VALUES (102, 100, 100, 85, 95, 95, 95, 85, 100, 100, 100, 100, 100, 95, 66, 93, 77, '2026-01-15 03:06:08.473184', '2026-01-15 03:06:08.485230', 7, 1, 194, 1);
INSERT INTO `scores_gradebook` VALUES (103, 100, 85, 100, 100, 85, 85, 85, 100, 100, 100, 100, 100, 90, 68, 90, 77, '2026-01-15 03:06:08.493823', '2026-01-15 03:06:08.505776', 7, 1, 195, 1);
INSERT INTO `scores_gradebook` VALUES (104, 90, 80, 100, 85, 85, 75, 75, 100, 100, 100, 100, 100, 90, 62, 83, 70, '2026-01-15 03:06:08.514716', '2026-01-15 03:06:08.524720', 7, 1, 196, 1);
INSERT INTO `scores_gradebook` VALUES (105, 100, 100, 85, 100, 90, 85, 80, 100, 100, 100, 100, 100, 75, 71, 87, 77, '2026-01-15 03:06:08.534378', '2026-01-15 03:06:08.545042', 7, 1, 197, 1);
INSERT INTO `scores_gradebook` VALUES (106, 75, 85, 80, 90, 90, 85, 100, 100, 90, 80, 100, 100, 90, 54, 90, 68, '2026-01-15 03:06:08.554159', '2026-01-15 03:06:08.565026', 7, 1, 198, 1);
INSERT INTO `scores_gradebook` VALUES (107, 90, 70, 75, 75, 80, 80, 80, 100, 100, 100, 100, 100, 85, 65, 83, 72, '2026-01-15 03:06:08.578280', '2026-01-15 03:06:08.590874', 7, 1, 199, 1);
INSERT INTO `scores_gradebook` VALUES (108, 85, 75, 100, 80, 80, 75, 90, 100, 100, 100, 100, 100, 85, 83, 85, 84, '2026-01-15 03:06:08.600514', '2026-01-15 03:06:08.612568', 7, 1, 200, 1);
INSERT INTO `scores_gradebook` VALUES (109, 100, 80, 75, 80, 75, 80, 75, 100, 100, 80, 100, 100, 75, 74, 81, 77, '2026-01-15 03:06:08.622685', '2026-01-15 03:06:08.635032', 7, 1, 201, 1);
INSERT INTO `scores_gradebook` VALUES (110, 70, 75, 70, 90, 75, 95, 75, 100, 100, 100, 100, 100, 65, 67, 82, 73, '2026-01-15 03:06:08.644726', '2026-01-15 03:06:08.657739', 7, 1, 202, 1);
INSERT INTO `scores_gradebook` VALUES (111, 90, 100, 90, 88, 85, 100, 80, 100, 100, 90, 80, 80, 85, 69, 90, 77, '2026-01-15 03:06:08.668680', '2026-01-15 03:06:08.681306', 7, 1, 203, 1);
INSERT INTO `scores_gradebook` VALUES (112, 90, 95, 90, 80, 80, 100, 75, 100, 100, 100, 100, 80, 90, 86, 89, 87, '2026-01-15 03:06:08.690909', '2026-01-15 03:06:08.704138', 7, 1, 204, 1);
INSERT INTO `scores_gradebook` VALUES (113, 80, 100, 75, 88, 85, 95, 95, 100, 100, 80, 80, 80, 95, 78, 92, 84, '2026-01-15 03:06:08.713954', '2026-01-15 03:06:08.726877', 7, 1, 205, 1);
INSERT INTO `scores_gradebook` VALUES (114, 100, 90, 80, 80, 80, 100, 85, 100, 100, 100, 100, 100, 95, 61, 92, 73, '2026-01-15 03:06:08.737545', '2026-01-15 03:06:08.749513', 7, 1, 206, 1);
INSERT INTO `scores_gradebook` VALUES (115, 75, 80, 75, 75, 0, 70, 75, 100, 80, 80, 100, 100, 70, 53, 72, 61, '2026-03-05 03:19:12.839311', '2026-03-05 03:19:12.859086', 8, 1, 207, 1);
INSERT INTO `scores_gradebook` VALUES (116, 95, 100, 90, 100, 85, 75, 95, 100, 100, 100, 100, 100, 90, 64, 90, 74, '2026-03-05 03:19:12.869095', '2026-03-05 03:19:12.883289', 8, 1, 208, 1);
INSERT INTO `scores_gradebook` VALUES (117, 100, 100, 90, 100, 100, 100, 95, 100, 80, 100, 100, 100, 80, 92, 95, 93, '2026-03-05 03:19:12.895466', '2026-03-05 03:19:12.909756', 8, 1, 209, 1);
INSERT INTO `scores_gradebook` VALUES (118, 75, 85, 100, 75, 75, 75, 70, 100, 100, 100, 100, 100, 75, 52, 79, 63, '2026-03-05 03:19:12.919568', '2026-03-05 03:19:12.934321', 8, 1, 210, 1);
INSERT INTO `scores_gradebook` VALUES (119, 100, 100, 85, 90, 75, 85, 80, 100, 100, 100, 100, 100, 80, 74, 86, 79, '2026-03-05 03:19:12.947206', '2026-03-05 03:19:12.962967', 8, 1, 211, 1);
INSERT INTO `scores_gradebook` VALUES (120, 100, 100, 85, 100, 85, 85, 100, 100, 80, 100, 100, 100, 85, 82, 92, 86, '2026-03-05 03:19:12.974392', '2026-03-05 03:19:12.989243', 8, 1, 212, 1);
INSERT INTO `scores_gradebook` VALUES (121, 100, 100, 100, 80, 100, 95, 80, 100, 80, 100, 100, 100, 95, 68, 92, 78, '2026-03-05 03:19:12.998243', '2026-03-05 03:19:13.011698', 8, 1, 213, 1);
INSERT INTO `scores_gradebook` VALUES (122, 100, 90, 80, 85, 100, 95, 95, 100, 100, 100, 100, 100, 90, 87, 94, 90, '2026-03-05 03:19:13.023216', '2026-03-05 03:19:13.043947', 8, 1, 214, 1);
INSERT INTO `scores_gradebook` VALUES (123, 100, 80, 85, 75, 100, 85, 95, 100, 80, 80, 100, 100, 75, 76, 88, 81, '2026-03-05 03:19:13.053632', '2026-03-05 03:19:13.067802', 8, 1, 215, 1);
INSERT INTO `scores_gradebook` VALUES (124, 100, 100, 85, 90, 75, 85, 85, 100, 80, 80, 100, 100, 75, 81, 86, 83, '2026-03-05 03:19:13.079955', '2026-03-05 03:19:13.095336', 8, 1, 216, 1);
INSERT INTO `scores_gradebook` VALUES (125, 100, 100, 90, 90, 80, 80, 85, 100, 90, 100, 100, 100, 90, 65, 88, 74, '2026-03-05 03:19:13.106951', '2026-03-05 03:19:13.120553', 8, 1, 217, 1);
INSERT INTO `scores_gradebook` VALUES (126, 100, 100, 80, 80, 85, 85, 90, 100, 100, 100, 100, 100, 90, 64, 90, 74, '2026-03-05 03:19:13.131796', '2026-03-05 03:19:13.147287', 8, 1, 218, 1);
INSERT INTO `scores_gradebook` VALUES (127, 85, 100, 100, 85, 85, 85, 85, 100, 100, 100, 100, 100, 80, 76, 88, 81, '2026-03-05 03:19:13.158799', '2026-03-05 03:19:13.172789', 8, 1, 219, 1);
INSERT INTO `scores_gradebook` VALUES (128, 85, 75, 85, 80, 95, 75, 85, 100, 100, 100, 100, 100, 75, 74, 83, 78, '2026-03-05 03:19:13.185014', '2026-03-05 03:19:13.202807', 8, 1, 220, 1);
INSERT INTO `scores_gradebook` VALUES (129, 100, 85, 100, 90, 95, 75, 100, 100, 80, 80, 100, 100, 70, 86, 88, 87, '2026-03-05 03:19:13.212857', '2026-03-05 03:19:13.226175', 8, 1, 221, 1);
INSERT INTO `scores_gradebook` VALUES (130, 100, 100, 100, 95, 100, 90, 85, 100, 80, 80, 100, 100, 95, 75, 92, 82, '2026-03-05 03:19:13.237389', '2026-03-05 03:19:13.251699', 8, 1, 222, 1);
INSERT INTO `scores_gradebook` VALUES (131, 100, 100, 90, 85, 95, 75, 90, 100, 100, 100, 100, 100, 85, 72, 88, 78, '2026-03-05 03:19:13.261860', '2026-03-05 03:19:13.280095', 8, 1, 223, 1);
INSERT INTO `scores_gradebook` VALUES (132, 100, 85, 100, 85, 85, 75, 90, 100, 80, 100, 100, 100, 75, 78, 85, 81, '2026-03-05 03:19:13.290608', '2026-03-05 03:19:13.302960', 8, 1, 224, 1);
INSERT INTO `scores_gradebook` VALUES (133, 100, 100, 100, 100, 100, 75, 75, 100, 100, 100, 100, 100, 85, 68, 86, 75, '2026-03-05 03:19:13.313485', '2026-03-05 03:19:13.325373', 8, 1, 225, 1);
INSERT INTO `scores_gradebook` VALUES (134, 100, 90, 90, 80, 100, 85, 80, 100, 100, 100, 100, 100, 90, 82, 88, 84, '2026-03-05 03:19:13.336443', '2026-03-05 03:19:13.353667', 8, 1, 226, 1);
INSERT INTO `scores_gradebook` VALUES (135, 100, 100, 95, 100, 90, 75, 85, 100, 80, 100, 100, 100, 90, 72, 88, 78, '2026-03-05 03:19:13.364559', '2026-03-05 03:19:13.377653', 8, 1, 227, 1);
INSERT INTO `scores_gradebook` VALUES (136, 85, 100, 100, 90, 90, 85, 85, 100, 100, 100, 100, 100, 90, 65, 89, 75, '2026-03-05 03:19:13.389600', '2026-03-05 03:19:13.402770', 8, 1, 228, 1);
INSERT INTO `scores_gradebook` VALUES (137, 100, 100, 90, 75, 100, 80, 90, 100, 100, 100, 100, 100, 75, 81, 88, 84, '2026-03-05 03:19:13.411872', '2026-03-05 03:19:13.424765', 8, 1, 229, 1);
INSERT INTO `scores_gradebook` VALUES (138, 90, 85, 75, 75, 85, 85, 75, 100, 80, 100, 100, 100, 70, 80, 81, 80, '2026-03-05 03:19:13.437846', '2026-03-05 03:19:13.450862', 8, 1, 230, 1);
INSERT INTO `scores_gradebook` VALUES (139, 90, 85, 75, 85, 85, 85, 75, 100, 100, 100, 100, 100, 80, 40, 83, 57, '2026-03-05 03:19:13.461799', '2026-03-05 03:19:13.474455', 8, 1, 231, 1);
INSERT INTO `scores_gradebook` VALUES (140, 100, 100, 95, 95, 80, 100, 80, 100, 80, 100, 100, 100, 85, 63, 91, 74, '2026-03-05 03:19:13.486437', '2026-03-05 03:19:13.504405', 8, 1, 232, 1);
INSERT INTO `scores_gradebook` VALUES (141, 85, 100, 85, 85, 85, 100, 75, 100, 100, 100, 100, 100, 85, 69, 89, 77, '2026-03-05 03:19:13.514938', '2026-03-05 03:19:13.527343', 8, 1, 233, 1);
INSERT INTO `scores_gradebook` VALUES (142, 100, 100, 75, 75, 80, 100, 90, 100, 100, 100, 100, 100, 90, 51, 93, 68, '2026-03-05 03:19:13.541551', '2026-03-05 03:19:13.556575', 8, 1, 234, 1);
INSERT INTO `scores_gradebook` VALUES (143, 75, 85, 75, 80, 80, 75, 70, 100, 100, 100, 100, 100, 75, 61, 78, 68, '2026-03-05 03:19:13.565068', '2026-03-05 03:19:13.582111', 8, 1, 235, 1);

-- ----------------------------
-- Table structure for scores_score
-- ----------------------------
DROP TABLE IF EXISTS `scores_score`;
CREATE TABLE `scores_score`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `attendance_score` double NULL DEFAULT NULL,
  `homework_score` double NULL DEFAULT NULL,
  `experiment_score` double NULL DEFAULT NULL,
  `review_note_score` double NULL DEFAULT NULL,
  `extra_scores` json NOT NULL,
  `final_score` double NULL DEFAULT NULL,
  `usual_total` double NULL DEFAULT NULL,
  `final_total` double NULL DEFAULT NULL,
  `usual_entry` double NULL DEFAULT NULL,
  `final_entry` double NULL DEFAULT NULL,
  `final_grade` double NULL DEFAULT NULL,
  `grade_point` double NULL DEFAULT NULL,
  `grade_level` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_published` tinyint(1) NOT NULL,
  `published_at` datetime(6) NULL DEFAULT NULL,
  `is_verified` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `course_class_id` bigint NOT NULL,
  `created_by_id` bigint NULL DEFAULT NULL,
  `grading_policy_id` bigint NULL DEFAULT NULL,
  `student_id` bigint NOT NULL,
  `updated_by_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `scores_score_student_id_course_class_id_2664e869_uniq`(`student_id` ASC, `course_class_id` ASC) USING BTREE,
  INDEX `scores_score_course_class_id_376cc059_fk_courses_courseclass_id`(`course_class_id` ASC) USING BTREE,
  INDEX `scores_score_created_by_id_dcd4c71f_fk_users_user_id`(`created_by_id` ASC) USING BTREE,
  INDEX `scores_score_grading_policy_id_76ad8890_fk_courses_g`(`grading_policy_id` ASC) USING BTREE,
  INDEX `scores_score_updated_by_id_44b22769_fk_users_user_id`(`updated_by_id` ASC) USING BTREE,
  CONSTRAINT `scores_score_course_class_id_376cc059_fk_courses_courseclass_id` FOREIGN KEY (`course_class_id`) REFERENCES `courses_courseclass` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `scores_score_created_by_id_dcd4c71f_fk_users_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `users_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `scores_score_grading_policy_id_76ad8890_fk_courses_g` FOREIGN KEY (`grading_policy_id`) REFERENCES `courses_gradingpolicy` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `scores_score_student_id_254b2621_fk_users_user_id` FOREIGN KEY (`student_id`) REFERENCES `users_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `scores_score_updated_by_id_44b22769_fk_users_user_id` FOREIGN KEY (`updated_by_id`) REFERENCES `users_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 122 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of scores_score
-- ----------------------------
INSERT INTO `scores_score` VALUES (1, 100, 86.6, 92.5, 88, '{\"作品\": 88.0, \"报告\": 90.0, \"电子笔记\": 88.0}', 88, 90.30000000000001, 89.875, 91, 89, 90, 4, 'A', 0, NULL, 0, '2025-12-26 13:31:30.219418', '2025-12-26 14:00:55.971768', 1, 1, 1, 3, 1);
INSERT INTO `scores_score` VALUES (2, 100, 74.6, 80.5, 81, '{\"作品\": 70.0, \"报告\": 71.0, \"电子笔记\": 81.0}', 70, 82.55, 73, 82, 73, 77, 2.7, 'B-', 0, NULL, 0, '2025-12-26 13:31:36.703951', '2025-12-26 14:01:03.045793', 1, 1, 1, 4, 1);
INSERT INTO `scores_score` VALUES (3, 100, 88.4, 82.5, 83, '{\"作品\": 75.0, \"报告\": 78.0, \"电子笔记\": 83.0}', 75, 89.95, 78, NULL, NULL, 82.78, 3.3, 'B+', 0, NULL, 0, '2025-12-26 13:31:43.934161', '2025-12-26 13:54:49.009829', 1, 1, 1, 5, 1);
INSERT INTO `scores_score` VALUES (4, 100, 91.2, 86, 83, '{\"作品\": 80.0, \"报告\": 84.0, \"电子笔记\": 83.0}', 80, 91.35000000000001, 83, NULL, NULL, 86.34, 3.7, 'A-', 0, NULL, 0, '2025-12-26 13:31:50.485682', '2025-12-26 13:54:56.115464', 1, 1, 1, 6, 1);
INSERT INTO `scores_score` VALUES (5, 100, 89, 81, 88, '{\"作品\": 75.0, \"报告\": 78.0, \"电子笔记\": 88.0}', 75, 91.5, 77.625, NULL, NULL, 83.175, 3.3, 'B+', 0, NULL, 0, '2025-12-26 13:31:57.170966', '2025-12-26 13:55:02.831140', 1, 1, 1, 7, 1);
INSERT INTO `scores_score` VALUES (6, 100, 82.4, 82.5, 82, '{\"作品\": 80.0, \"报告\": 81.0, \"电子笔记\": 82.0}', 80, 86.70000000000002, 80.99999999999999, NULL, NULL, 83.28, 3.3, 'B+', 0, NULL, 0, '2025-12-26 13:32:03.959772', '2025-12-26 13:55:09.387572', 1, 1, 1, 8, 1);
INSERT INTO `scores_score` VALUES (7, 100, 85.8, 77, 81, '{\"作品\": 80.0, \"报告\": 75.0, \"电子笔记\": 81.0}', 80, 88.15, 77.375, NULL, NULL, 81.685, 3, 'B', 0, NULL, 0, '2025-12-26 13:32:10.633143', '2025-12-26 13:55:16.532649', 1, 1, 1, 9, 1);
INSERT INTO `scores_score` VALUES (8, 100, 92.6, 75.5, 80, '{\"作品\": 65.0, \"报告\": 70.0, \"电子笔记\": 80.0}', 65, 91.29999999999998, 69.5, NULL, NULL, 78.22, 3, 'B', 0, NULL, 0, '2025-12-26 13:32:17.809282', '2025-12-26 13:55:23.107030', 1, 1, 1, 10, 1);
INSERT INTO `scores_score` VALUES (9, 100, 92.8, 85.5, 86, '{\"作品\": 78.0, \"报告\": 80.0, \"电子笔记\": 86.0}', 78, 92.89999999999999, 80.625, NULL, NULL, 85.535, 3.7, 'A-', 0, NULL, 0, '2025-12-26 13:32:26.049254', '2025-12-26 13:55:30.255213', 1, 1, 1, 11, 1);
INSERT INTO `scores_score` VALUES (10, 100, 86, 85, 92, '{\"作品\": 80.0, \"报告\": 82.0, \"电子笔记\": 92.0}', 80, 91.00000000000001, 81.99999999999999, NULL, NULL, 85.6, 3.7, 'A-', 0, NULL, 0, '2025-12-26 13:32:33.774301', '2025-12-26 13:55:36.742997', 1, 1, 1, 12, 1);
INSERT INTO `scores_score` VALUES (11, 100, 93.6, 84.5, 80, '{\"作品\": 75.0, \"报告\": 78.0, \"电子笔记\": 80.0}', 75, 91.8, 78.5, NULL, NULL, 83.82, 3.3, 'B+', 0, NULL, 0, '2025-12-26 13:32:44.478469', '2025-12-26 13:55:44.217805', 1, 1, 1, 13, 1);
INSERT INTO `scores_score` VALUES (12, 100, 91.2, 84.5, 85, '{\"作品\": 80.0, \"报告\": 80.0, \"电子笔记\": 85.0}', 80, 91.85, 81.125, NULL, NULL, 85.41499999999999, 3.7, 'A-', 0, NULL, 0, '2025-12-26 13:32:59.409169', '2025-12-26 13:55:51.070171', 1, 1, 1, 14, 1);
INSERT INTO `scores_score` VALUES (13, 100, 93.8, 85.5, 93, '{\"作品\": 89.0, \"报告\": 83.0, \"电子笔记\": 93.0}', 89, 95.15, 85.87499999999999, 90, 85, 87, 3.7, 'A-', 0, NULL, 0, '2025-12-26 13:33:14.179926', '2025-12-26 13:55:58.992133', 1, 1, 1, 15, 1);
INSERT INTO `scores_score` VALUES (14, 100, 95, 77.5, 78, '{\"作品\": 65.0, \"报告\": 68.0, \"电子笔记\": 78.0}', 65, 91.99999999999999, 69.25, 85, 69, 75, 2.7, 'B-', 0, NULL, 0, '2025-12-26 13:33:29.561044', '2025-12-26 13:56:11.413711', 1, 1, 1, 16, 1);
INSERT INTO `scores_score` VALUES (15, 100, 92.8, 85.5, 82, '{\"作品\": 90.0, \"报告\": 84.0, \"电子笔记\": 82.0}', 90, 91.9, 86.62499999999999, 89, 86, 87, 3.7, 'A-', 0, NULL, 0, '2025-12-26 13:33:44.757794', '2025-12-26 13:56:23.631245', 1, 1, 1, 17, 1);
INSERT INTO `scores_score` VALUES (16, 100, 94.8, 78.5, 78, '{\"作品\": 78.0, \"报告\": 73.0, \"电子笔记\": 78.0}', 78, 91.9, 76.25, 85, 76, 80, 3, 'B', 0, NULL, 0, '2025-12-26 13:33:59.440244', '2025-12-26 13:56:36.466142', 1, 1, 1, 18, 1);
INSERT INTO `scores_score` VALUES (17, 100, 94, 82.5, 82, '{\"作品\": 83.0, \"报告\": 78.0, \"电子笔记\": 82.0}', 83, 92.5, 80.99999999999999, 88, 80, 83, 3.3, 'B+', 0, NULL, 0, '2025-12-26 13:34:14.298294', '2025-12-26 13:56:48.954006', 1, 1, 1, 19, 1);
INSERT INTO `scores_score` VALUES (18, 100, 89.2, 81.5, 81, '{\"作品\": 75.0, \"报告\": 75.0, \"电子笔记\": 81.0}', 75, 89.85, 76.62499999999999, 86, 76, 80, 3, 'B', 0, NULL, 0, '2025-12-26 13:34:28.975767', '2025-12-26 13:57:01.713328', 1, 1, 1, 20, 1);
INSERT INTO `scores_score` VALUES (19, 100, 93.8, 86.5, 93, '{\"作品\": 85.0, \"报告\": 84.0, \"电子笔记\": 93.0}', 85, 95.15, 85, 91, 85, 87, 3.7, 'A-', 0, NULL, 0, '2025-12-26 13:34:43.597879', '2025-12-26 13:57:14.280351', 1, 1, 1, 21, 1);
INSERT INTO `scores_score` VALUES (20, 100, 95, 77.5, 75, '{\"作品\": 84.0, \"报告\": 75.0, \"电子笔记\": 75.0}', 84, 91.25, 79, 84, 79, 81, 3, 'B', 0, NULL, 0, '2025-12-26 13:34:58.307510', '2025-12-26 13:57:26.764716', 1, 1, 1, 22, 1);
INSERT INTO `scores_score` VALUES (21, 100, 92.4, 86.5, 94, '{\"作品\": 80.0, \"报告\": 85.0, \"电子笔记\": 94.0}', 80, 94.69999999999999, 83.49999999999999, 91, 83, 86, 3.7, 'A-', 0, NULL, 0, '2025-12-26 13:35:12.959835', '2025-12-26 13:57:38.952028', 1, 1, 1, 23, 1);
INSERT INTO `scores_score` VALUES (22, 100, 52, 86.5, 72, '{\"作品\": 85.0, \"报告\": 83.0, \"电子笔记\": 72.0}', 85, 69, 84.62499999999999, 78, 84, 82, 3.3, 'B+', 0, NULL, 0, '2025-12-26 13:35:27.893786', '2025-12-26 13:57:51.643109', 1, 1, 1, 24, 1);
INSERT INTO `scores_score` VALUES (23, 100, 91.6, 84, 82, '{\"作品\": 85.0, \"报告\": 82.0, \"电子笔记\": 82.0}', 85, 91.3, 83.62499999999999, 88, 83, 85, 3.7, 'A-', 0, NULL, 0, '2025-12-26 13:35:42.799992', '2025-12-26 13:58:04.159516', 1, 1, 1, 25, 1);
INSERT INTO `scores_score` VALUES (24, 100, 86, 83.5, 78, '{\"作品\": 85.0, \"报告\": 80.0, \"电子笔记\": 78.0}', 85, 87.5, 82.75, 86, 82, 84, 3.3, 'B+', 0, NULL, 0, '2025-12-26 13:35:57.876950', '2025-12-26 13:58:16.598119', 1, 1, 1, 26, 1);
INSERT INTO `scores_score` VALUES (25, 100, 91.4, 87.5, 80, '{\"作品\": 88.0, \"报告\": 85.0, \"电子笔记\": 80.0}', 88, 90.7, 86.75, 89, 86, 87, 3.7, 'A-', 0, NULL, 0, '2025-12-26 13:36:13.129887', '2025-12-26 13:58:29.175665', 1, 1, 1, 27, 1);
INSERT INTO `scores_score` VALUES (26, 100, 93, 85, 92, '{\"作品\": 75.0, \"报告\": 78.0, \"电子笔记\": 92.0}', 75, 94.5, 78.625, 90, 78, 83, 3.3, 'B+', 0, NULL, 0, '2025-12-26 13:36:28.132564', '2025-12-26 13:58:41.670867', 1, 1, 1, 28, 1);
INSERT INTO `scores_score` VALUES (27, 100, 96.6, 84, 90, '{\"作品\": 75.0, \"报告\": 78.0, \"电子笔记\": 90.0}', 75, 95.8, 78.37499999999999, 90, 78, 83, 3.3, 'B+', 0, NULL, 0, '2025-12-26 13:36:43.163286', '2025-12-26 13:58:53.833638', 1, 1, 1, 29, 1);
INSERT INTO `scores_score` VALUES (28, 100, 91.8, 83, 78, '{\"作品\": 81.0, \"报告\": 80.0, \"电子笔记\": 78.0}', 81, 90.39999999999999, 81.125, 87, 81, 83, 3.3, 'B+', 0, NULL, 0, '2025-12-26 13:36:58.061375', '2025-12-26 13:59:06.597001', 1, 1, 1, 30, 1);
INSERT INTO `scores_score` VALUES (29, 100, 93.2, 81.5, 83, '{\"作品\": 75.0, \"报告\": 78.0, \"电子笔记\": 83.0}', 75, 92.35, 77.74999999999999, 87, 77, 81, 3, 'B', 0, NULL, 0, '2025-12-26 13:37:12.939688', '2025-12-26 13:59:19.179614', 1, 1, 1, 31, 1);
INSERT INTO `scores_score` VALUES (30, 100, 93.4, 92.5, 84, '{\"作品\": 95.0, \"报告\": 88.0, \"电子笔记\": 84.0}', 95, 92.69999999999999, 91.75, 93, 91, 92, 4, 'A', 0, NULL, 0, '2025-12-26 13:37:27.968239', '2025-12-26 13:59:31.741397', 1, 1, 1, 32, 1);
INSERT INTO `scores_score` VALUES (31, 90, 81.4, 85, 75, '{\"作品\": 80.0, \"报告\": 83.0, \"电子笔记\": 75.0}', 80, 81.95, 82, 83, 82, 82, 3.3, 'B+', 0, NULL, 0, '2025-12-28 03:07:56.843595', '2025-12-28 03:07:56.843595', 2, 1, 1, 33, 1);
INSERT INTO `scores_score` VALUES (32, 100, 95.8, 85, 78, '{\"作品\": 85.0, \"报告\": 78.0, \"电子笔记\": 78.0}', 85, 92.39999999999999, 82, 89, 82, 85, 3.7, 'A-', 0, NULL, 0, '2025-12-28 03:07:56.843595', '2025-12-28 03:07:56.843595', 2, 1, 1, 34, 1);
INSERT INTO `scores_score` VALUES (33, 100, 93.2, 90, 81, '{\"作品\": 90.0, \"报告\": 91.0, \"电子笔记\": 81.0}', 90, 91.85, 90, 91, 90, 90, 4, 'A', 0, NULL, 0, '2025-12-28 03:07:56.843595', '2025-12-28 03:07:56.843595', 2, 1, 1, 35, 1);
INSERT INTO `scores_score` VALUES (34, 100, 86.4, 82, 69, '{\"作品\": 85.0, \"报告\": 83.0, \"电子笔记\": 69.0}', 85, 85.44999999999999, 83, 84, 83, 83, 3.3, 'B+', 0, NULL, 0, '2025-12-28 03:07:56.844610', '2025-12-28 03:07:56.844610', 2, 1, 1, 36, 1);
INSERT INTO `scores_score` VALUES (35, 100, 82.8, 87, 71, '{\"作品\": 95.0, \"报告\": 90.0, \"电子笔记\": 71.0}', 95, 84.14999999999999, 91, 86, 91, 89, 3.7, 'A-', 0, NULL, 0, '2025-12-28 03:07:56.844610', '2025-12-28 03:07:56.844610', 2, 1, 1, 37, 1);
INSERT INTO `scores_score` VALUES (36, 100, 77, 88.5, 68, '{\"作品\": 84.0, \"报告\": 80.0, \"电子笔记\": 68.0}', 84, 80.5, 83, 84, 83, 83, 3.3, 'B+', 0, NULL, 0, '2025-12-28 03:07:56.844610', '2025-12-28 03:07:56.844610', 2, 1, 1, 38, 1);
INSERT INTO `scores_score` VALUES (37, 90, 60.2, 73.5, 70, '{\"作品\": 70.0, \"报告\": 73.0, \"电子笔记\": 70.0}', 70, 70.1, 72, 72, 72, 72, 2.3, 'C+', 0, NULL, 0, '2025-12-28 03:07:56.844610', '2025-12-28 03:07:56.844610', 2, 1, 1, 39, 1);
INSERT INTO `scores_score` VALUES (38, 100, 76.6, 77, 70, '{\"作品\": 78.0, \"报告\": 73.0, \"电子笔记\": 70.0}', 78, 80.8, 75, 79, 75, 77, 2.7, 'B-', 0, NULL, 0, '2025-12-28 03:07:56.844610', '2025-12-28 03:07:56.844610', 2, 1, 1, 40, 1);
INSERT INTO `scores_score` VALUES (39, 100, 83, 81, 72, '{\"作品\": 85.0, \"报告\": 78.0, \"电子笔记\": 72.0}', 85, 84.49999999999999, 81, 83, 81, 82, 3.3, 'B+', 0, NULL, 0, '2025-12-28 03:07:56.844610', '2025-12-28 03:07:56.844610', 2, 1, 1, 41, 1);
INSERT INTO `scores_score` VALUES (40, 100, 74.8, 83.5, 78, '{\"作品\": 85.0, \"报告\": 80.0, \"电子笔记\": 78.0}', 85, 81.9, 82, 83, 82, 82, 3.3, 'B+', 0, NULL, 0, '2025-12-28 03:07:56.844610', '2025-12-28 03:07:56.844610', 2, 1, 1, 42, 1);
INSERT INTO `scores_score` VALUES (41, 100, 88.4, 91, 76, '{\"作品\": 89.0, \"报告\": 90.0, \"电子笔记\": 76.0}', 89, 88.2, 89, 90, 89, 89, 3.7, 'A-', 0, NULL, 0, '2025-12-28 03:07:56.844610', '2025-12-28 03:07:56.844610', 2, 1, 1, 43, 1);
INSERT INTO `scores_score` VALUES (42, 100, 95.6, 91.5, 86, '{\"作品\": 85.0, \"报告\": 88.0, \"电子笔记\": 86.0}', 85, 94.3, 87, 93, 87, 89, 3.7, 'A-', 0, NULL, 0, '2025-12-28 03:07:56.844610', '2025-12-28 03:07:56.844610', 2, 1, 1, 44, 1);
INSERT INTO `scores_score` VALUES (43, 100, 82, 75, 79, '{\"作品\": 70.0, \"报告\": 71.0, \"电子笔记\": 79.0}', 70, 85.74999999999999, 71, 80, 71, 75, 2.7, 'B-', 0, NULL, 0, '2025-12-28 03:07:56.844610', '2025-12-28 03:07:56.844610', 2, 1, 1, 45, 1);
INSERT INTO `scores_score` VALUES (44, 100, 84.4, 73, 77, '{\"作品\": 70.0, \"报告\": 73.0, \"电子笔记\": 77.0}', 70, 86.44999999999999, 71, 80, 71, 75, 2.7, 'B-', 0, NULL, 0, '2025-12-28 03:07:56.844610', '2025-12-28 03:07:56.844610', 2, 1, 1, 46, 1);
INSERT INTO `scores_score` VALUES (45, 100, 92.6, 84.5, 85, '{\"作品\": 80.0, \"报告\": 82.0, \"电子笔记\": 85.0}', 80, 92.54999999999998, 81, 89, 81, 84, 3.3, 'B+', 0, NULL, 0, '2025-12-28 03:07:56.844610', '2025-12-28 03:07:56.844610', 2, 1, 1, 47, 1);
INSERT INTO `scores_score` VALUES (46, 100, 92, 85, 88, '{\"作品\": 80.0, \"报告\": 84.0, \"电子笔记\": 88.0}', 80, 93, 82, 89, 82, 85, 3.7, 'A-', 0, NULL, 0, '2025-12-28 03:07:56.844610', '2025-12-28 03:07:56.844610', 2, 1, 1, 48, 1);
INSERT INTO `scores_score` VALUES (47, 100, 87.2, 78.5, 80, '{\"作品\": 70.0, \"报告\": 75.0, \"电子笔记\": 80.0}', 70, 88.6, 74, 84, 74, 78, 3, 'B', 0, NULL, 0, '2025-12-28 03:07:56.844610', '2025-12-28 03:07:56.844610', 2, 1, 1, 49, 1);
INSERT INTO `scores_score` VALUES (48, 100, 93.2, 82, 81, '{\"作品\": 75.0, \"报告\": 80.0, \"电子笔记\": 81.0}', 75, 91.85, 78, 87, 78, 82, 3.3, 'B+', 0, NULL, 0, '2025-12-28 03:07:56.844610', '2025-12-28 03:07:56.844610', 2, 1, 1, 50, 1);
INSERT INTO `scores_score` VALUES (49, 100, 91.2, 85.5, 86, '{\"作品\": 80.0, \"报告\": 84.0, \"电子笔记\": 86.0}', 80, 92.10000000000001, 82, 89, 82, 85, 3.7, 'A-', 0, NULL, 0, '2025-12-28 03:07:56.844610', '2025-12-28 03:07:56.844610', 2, 1, 1, 51, 1);
INSERT INTO `scores_score` VALUES (50, 100, 95.6, 87.5, 90, '{\"作品\": 80.0, \"报告\": 85.0, \"电子笔记\": 90.0}', 80, 95.30000000000001, 83, 91, 83, 86, 3.7, 'A-', 0, NULL, 0, '2025-12-28 03:07:56.844610', '2025-12-28 03:07:56.844610', 2, 1, 1, 52, 1);
INSERT INTO `scores_score` VALUES (51, 90, 74.8, 77, 75, '{\"作品\": 75.0, \"报告\": 78.0, \"电子笔记\": 75.0}', 75, 78.64999999999999, 76, 78, 76, 77, 2.7, 'B-', 0, NULL, 0, '2025-12-28 03:07:56.844610', '2025-12-28 03:07:56.844610', 2, 1, 1, 53, 1);
INSERT INTO `scores_score` VALUES (52, 100, 91.8, 93.5, 91, '{\"作品\": 88.0, \"报告\": 90.0, \"电子笔记\": 91.0}', 88, 93.64999999999999, 90, 94, 90, 92, 4, 'A', 0, NULL, 0, '2025-12-28 03:07:56.844610', '2025-12-28 03:07:56.844610', 2, 1, 1, 54, 1);
INSERT INTO `scores_score` VALUES (53, 100, 91.2, 94, 86, '{\"作品\": 84.0, \"报告\": 89.0, \"电子笔记\": 86.0}', 84, 92.10000000000001, 88, 93, 88, 90, 4, 'A', 0, NULL, 0, '2025-12-28 03:07:56.844610', '2025-12-28 03:07:56.844610', 2, 1, 1, 55, 1);
INSERT INTO `scores_score` VALUES (54, 100, 90.2, 94, 90, '{\"作品\": 95.0, \"报告\": 93.0, \"电子笔记\": 90.0}', 95, 92.60000000000001, 93, 93, 93, 93, 4, 'A', 0, NULL, 0, '2025-12-28 03:07:56.844610', '2025-12-28 03:07:56.844610', 2, 1, 1, 56, 1);
INSERT INTO `scores_score` VALUES (55, 100, 82.4, 85, 75, '{\"作品\": 85.0, \"报告\": 84.0, \"电子笔记\": 75.0}', 85, 84.95, 84, 85, 84, 84, 3.3, 'B+', 0, NULL, 0, '2025-12-28 03:07:56.844610', '2025-12-28 03:07:56.844610', 2, 1, 1, 57, 1);
INSERT INTO `scores_score` VALUES (56, 100, 78, 79, 76, '{\"作品\": 73.0, \"报告\": 75.0, \"电子笔记\": 76.0}', 73, 83, 75, 81, 75, 77, 2.7, 'B-', 0, NULL, 0, '2025-12-28 03:07:56.844610', '2025-12-28 03:07:56.844610', 2, 1, 1, 58, 1);
INSERT INTO `scores_score` VALUES (57, 100, 88.6, 72.5, 79, '{\"作品\": 63.0, \"报告\": 68.0, \"电子笔记\": 79.0}', 63, 89.04999999999998, 67, 81, 67, 73, 2.3, 'C+', 0, NULL, 0, '2025-12-28 03:07:56.845761', '2025-12-28 03:07:56.845761', 2, 1, 1, 59, 1);
INSERT INTO `scores_score` VALUES (58, 100, 81.2, 77, 77, '{\"作品\": 70.0, \"报告\": 74.0, \"电子笔记\": 77.0}', 70, 84.85, 73, 81, 73, 76, 2.7, 'B-', 0, NULL, 0, '2025-12-28 03:07:56.845761', '2025-12-28 03:07:56.845761', 2, 1, 1, 60, 1);
INSERT INTO `scores_score` VALUES (59, 100, 83.8, 91, 84, '{\"作品\": 89.0, \"报告\": 89.0, \"电子笔记\": 84.0}', 89, 87.89999999999999, 89, 89, 89, 89, 3.7, 'A-', 0, NULL, 0, '2025-12-28 03:07:56.845761', '2025-12-28 03:07:56.845761', 2, 1, 1, 61, 1);
INSERT INTO `scores_score` VALUES (62, 90, 93.4, 78, 78, '{\"作品\": 75.0, \"报告\": 75.0, \"电子笔记\": 78.0}', 75, 88.7, 75, 83, 75, 78, 3, 'B', 0, NULL, 0, '2025-12-28 03:50:45.153066', '2025-12-28 03:50:45.153066', 3, 1, 1, 63, 1);
INSERT INTO `scores_score` VALUES (63, 100, 90.4, 77.5, 85, '{\"作品\": 74.0, \"报告\": 73.0, \"电子笔记\": 85.0}', 74, 91.44999999999999, 74, 84, 74, 78, 3, 'B', 0, NULL, 0, '2025-12-28 03:50:45.153066', '2025-12-28 03:50:45.153066', 3, 1, 1, 64, 1);
INSERT INTO `scores_score` VALUES (64, 100, 91.4, 91, 76, '{\"作品\": 80.0, \"报告\": 88.0, \"电子笔记\": 76.0}', 80, 89.7, 85, 90, 85, 87, 3.7, 'A-', 0, NULL, 0, '2025-12-28 03:50:45.153066', '2025-12-28 03:50:45.153066', 3, 1, 1, 65, 1);
INSERT INTO `scores_score` VALUES (65, 100, 95, 88, 84, '{\"作品\": 81.0, \"报告\": 84.0, \"电子笔记\": 84.0}', 81, 93.49999999999999, 83, 91, 83, 86, 3.7, 'A-', 0, NULL, 0, '2025-12-28 03:50:45.153066', '2025-12-28 03:50:45.153066', 3, 1, 1, 66, 1);
INSERT INTO `scores_score` VALUES (66, 100, 93.6, 89, 86, '{\"作品\": 78.0, \"报告\": 85.0, \"电子笔记\": 86.0}', 78, 93.3, 83, 91, 83, 86, 3.7, 'A-', 0, NULL, 0, '2025-12-28 03:50:45.153066', '2025-12-28 03:50:45.153066', 3, 1, 1, 67, 1);
INSERT INTO `scores_score` VALUES (67, 100, 88.4, 82.5, 80, '{\"作品\": 80.0, \"报告\": 78.0, \"电子笔记\": 80.0}', 80, 89.20000000000002, 79, 86, 79, 82, 3.3, 'B+', 0, NULL, 0, '2025-12-28 03:50:45.153066', '2025-12-28 03:50:45.153066', 3, 1, 1, 68, 1);
INSERT INTO `scores_score` VALUES (68, 100, 95.6, 91, 84, '{\"作品\": 98.0, \"报告\": 89.0, \"电子笔记\": 84.0}', 98, 93.79999999999998, 92, 92, 92, 92, 4, 'A', 0, NULL, 0, '2025-12-28 03:50:45.153066', '2025-12-28 03:50:45.153066', 3, 1, 1, 69, 1);
INSERT INTO `scores_score` VALUES (69, 90, 85, 74, 78, '{\"作品\": 70.0, \"报告\": 65.0, \"电子笔记\": 78.0}', 70, 84.49999999999999, 69, 79, 69, 73, 2.3, 'C+', 0, NULL, 0, '2025-12-28 03:50:45.153066', '2025-12-28 03:50:45.153066', 3, 1, 1, 70, 1);
INSERT INTO `scores_score` VALUES (70, 100, 78.8, 85, 85, '{\"作品\": 85.0, \"报告\": 80.0, \"电子笔记\": 85.0}', 85, 85.64999999999999, 83, 85, 83, 84, 3.3, 'B+', 0, NULL, 0, '2025-12-28 03:50:45.153066', '2025-12-28 03:50:45.153066', 3, 1, 1, 71, 1);
INSERT INTO `scores_score` VALUES (71, 100, 85.4, 67.5, 76, '{\"作品\": 0.0, \"报告\": 60.0, \"电子笔记\": 76.0}', 0, 86.70000000000002, 39, 77, 39, 54, 0, 'F', 0, NULL, 0, '2025-12-28 03:50:45.153066', '2025-12-28 03:50:45.153066', 3, 1, 1, 72, 1);
INSERT INTO `scores_score` VALUES (72, 100, 94.6, 85.5, 90, '{\"作品\": 85.0, \"报告\": 80.0, \"电子笔记\": 90.0}', 85, 94.8, 83, 90, 83, 86, 3.7, 'A-', 0, NULL, 0, '2025-12-28 03:50:45.153066', '2025-12-28 03:50:45.153066', 3, 1, 1, 73, 1);
INSERT INTO `scores_score` VALUES (73, 100, 87.8, 70, 88, '{\"作品\": 61.0, \"报告\": 60.0, \"电子笔记\": 88.0}', 61, 90.89999999999999, 62, 80, 62, 69, 2, 'C', 0, NULL, 0, '2025-12-28 03:50:45.153066', '2025-12-28 03:50:45.153066', 3, 1, 1, 74, 1);
INSERT INTO `scores_score` VALUES (74, 100, 83.4, 75.5, 86, '{\"作品\": 75.0, \"报告\": 70.0, \"电子笔记\": 86.0}', 75, 88.2, 73, 82, 73, 77, 2.7, 'B-', 0, NULL, 0, '2025-12-28 03:50:45.153066', '2025-12-28 03:50:45.153066', 3, 1, 1, 75, 1);
INSERT INTO `scores_score` VALUES (75, 100, 83.6, 78.5, 85, '{\"作品\": 84.0, \"报告\": 75.0, \"电子笔记\": 85.0}', 84, 88.05, 79, 83, 79, 81, 3, 'B', 0, NULL, 0, '2025-12-28 03:50:45.153066', '2025-12-28 03:50:45.153066', 3, 1, 1, 76, 1);
INSERT INTO `scores_score` VALUES (76, 100, 100, 93, 78, '{\"作品\": 85.0, \"报告\": 90.0, \"电子笔记\": 78.0}', 85, 94.49999999999999, 88, 94, 88, 90, 4, 'A', 0, NULL, 0, '2025-12-28 03:50:45.153066', '2025-12-28 03:50:45.153066', 3, 1, 1, 77, 1);
INSERT INTO `scores_score` VALUES (77, 100, 88.4, 76.5, 81, '{\"作品\": 75.0, \"报告\": 70.0, \"电子笔记\": 81.0}', 75, 89.45, 73, 83, 73, 77, 2.7, 'B-', 0, NULL, 0, '2025-12-28 03:50:45.153066', '2025-12-28 03:50:45.153066', 3, 1, 1, 78, 1);
INSERT INTO `scores_score` VALUES (78, 100, 88.4, 32.5, 64, '{\"作品\": 68.0, \"报告\": 62.0, \"电子笔记\": 64.0}', 68, 85.19999999999999, 56, 59, 56, 57, 0, 'F', 0, NULL, 0, '2025-12-28 03:50:45.153066', '2025-12-28 03:50:45.153066', 3, 1, 1, 79, 1);
INSERT INTO `scores_score` VALUES (79, 100, 83.2, 71.5, 80, '{\"作品\": 65.0, \"报告\": 68.0, \"电子笔记\": 80.0}', 65, 86.6, 67, 79, 67, 72, 2.3, 'C+', 0, NULL, 0, '2025-12-28 03:50:45.153066', '2025-12-28 03:50:45.153066', 3, 1, 1, 80, 1);
INSERT INTO `scores_score` VALUES (80, 100, 81.6, 80, 82, '{\"作品\": 84.0, \"报告\": 78.0, \"电子笔记\": 82.0}', 84, 86.3, 80, 83, 80, 81, 3, 'B', 0, NULL, 0, '2025-12-28 03:50:45.153066', '2025-12-28 03:50:45.153066', 3, 1, 1, 81, 1);
INSERT INTO `scores_score` VALUES (81, 100, 89.4, 84.5, 78, '{\"作品\": 80.0, \"报告\": 80.0, \"电子笔记\": 78.0}', 80, 89.20000000000002, 81, 87, 81, 83, 3.3, 'B+', 0, NULL, 0, '2025-12-28 03:50:45.153066', '2025-12-28 03:50:45.153066', 3, 1, 1, 82, 1);
INSERT INTO `scores_score` VALUES (82, 100, 91, 77.5, 76, '{\"作品\": 75.0, \"报告\": 73.0, \"电子笔记\": 76.0}', 75, 89.49999999999999, 74, 83, 74, 78, 3, 'B', 0, NULL, 0, '2025-12-28 03:50:45.153066', '2025-12-28 03:50:45.153066', 3, 1, 1, 83, 1);
INSERT INTO `scores_score` VALUES (83, 100, 88, 94.5, 76, '{\"作品\": 90.0, \"报告\": 93.0, \"电子笔记\": 76.0}', 90, 88, 92, 91, 92, 92, 4, 'A', 0, NULL, 0, '2025-12-28 03:50:45.154111', '2025-12-28 03:50:45.154111', 3, 1, 1, 84, 1);
INSERT INTO `scores_score` VALUES (84, 100, 91.4, 90, 78, '{\"作品\": 85.0, \"报告\": 88.0, \"电子笔记\": 78.0}', 85, 90.19999999999999, 87, 90, 87, 88, 3.7, 'A-', 0, NULL, 0, '2025-12-28 03:50:45.154111', '2025-12-28 03:50:45.154111', 3, 1, 1, 85, 1);
INSERT INTO `scores_score` VALUES (85, 100, 84.2, 82.5, 76, '{\"作品\": 83.0, \"报告\": 78.0, \"电子笔记\": 76.0}', 83, 86.1, 80, 84, 80, 82, 3.3, 'B+', 0, NULL, 0, '2025-12-28 03:50:45.154111', '2025-12-28 03:50:45.154111', 3, 1, 1, 86, 1);
INSERT INTO `scores_score` VALUES (86, 90, 79.8, 75.5, 74, '{\"作品\": 75.0, \"报告\": 70.0, \"电子笔记\": 74.0}', 75, 80.89999999999999, 73, 78, 73, 75, 2.7, 'B-', 0, NULL, 0, '2025-12-28 03:50:45.154111', '2025-12-28 03:50:45.154111', 3, 1, 1, 87, 1);
INSERT INTO `scores_score` VALUES (87, 100, 98, 87, 88, '{\"作品\": 85.0, \"报告\": 83.0, \"电子笔记\": 88.0}', 85, 96.00000000000001, 84, 92, 84, 87, 3.7, 'A-', 0, NULL, 0, '2025-12-28 03:50:45.154111', '2025-12-28 03:50:45.154111', 3, 1, 1, 88, 1);
INSERT INTO `scores_score` VALUES (88, 90, 85.6, 77.5, 76, '{\"作品\": 75.0, \"报告\": 75.0, \"电子笔记\": 76.0}', 75, 84.3, 75, 81, 75, 77, 2.7, 'B-', 0, NULL, 0, '2025-12-28 03:50:45.154111', '2025-12-28 03:50:45.154111', 3, 1, 1, 89, 1);
INSERT INTO `scores_score` VALUES (89, 100, 85.2, 76, 78, '{\"作品\": 75.0, \"报告\": 73.0, \"电子笔记\": 78.0}', 75, 87.10000000000001, 74, 82, 74, 77, 2.7, 'B-', 0, NULL, 0, '2025-12-28 03:50:45.154111', '2025-12-28 03:50:45.154111', 3, 1, 1, 90, 1);
INSERT INTO `scores_score` VALUES (90, 100, 84.2, 80.5, 88, '{\"作品\": 81.0, \"报告\": 80.0, \"电子笔记\": 88.0}', 81, 89.1, 80, 85, 80, 82, 3.3, 'B+', 0, NULL, 0, '2025-12-28 03:50:45.154111', '2025-12-28 03:50:45.154111', 3, 1, 1, 91, 1);
INSERT INTO `scores_score` VALUES (91, 100, 90.2, 88, 82, '{\"作品\": 83.0, \"报告\": 85.0, \"电子笔记\": 82.0}', 83, 90.60000000000002, 85, 89, 85, 87, 3.7, 'A-', 0, NULL, 0, '2025-12-28 03:50:45.154111', '2025-12-28 03:50:45.154111', 3, 1, 1, 92, 1);
INSERT INTO `scores_score` VALUES (92, 90, 93.4, 78, 78, '{\"作品\": 75.0, \"报告\": 75.0, \"电子笔记\": 78.0}', 75, 88.7, 75, 83, 75, 78, 3, 'B', 0, NULL, 0, '2026-01-15 02:18:06.228048', '2026-01-15 02:18:06.228048', 9, 1, 1, 63, 1);
INSERT INTO `scores_score` VALUES (93, 100, 90.4, 77.5, 85, '{\"作品\": 74.0, \"报告\": 73.0, \"电子笔记\": 85.0}', 74, 91.44999999999999, 74, 84, 74, 78, 3, 'B', 0, NULL, 0, '2026-01-15 02:18:06.228048', '2026-01-15 02:18:06.228048', 9, 1, 1, 64, 1);
INSERT INTO `scores_score` VALUES (94, 100, 91.4, 91, 76, '{\"作品\": 80.0, \"报告\": 88.0, \"电子笔记\": 76.0}', 80, 89.7, 85, 90, 85, 87, 3.7, 'A-', 0, NULL, 0, '2026-01-15 02:18:06.228048', '2026-01-15 02:18:06.228048', 9, 1, 1, 65, 1);
INSERT INTO `scores_score` VALUES (95, 100, 95, 88, 84, '{\"作品\": 81.0, \"报告\": 84.0, \"电子笔记\": 84.0}', 81, 93.49999999999999, 83, 91, 83, 86, 3.7, 'A-', 0, NULL, 0, '2026-01-15 02:18:06.228048', '2026-01-15 02:18:06.228048', 9, 1, 1, 66, 1);
INSERT INTO `scores_score` VALUES (96, 100, 93.6, 89, 86, '{\"作品\": 78.0, \"报告\": 85.0, \"电子笔记\": 86.0}', 78, 93.3, 83, 91, 83, 86, 3.7, 'A-', 0, NULL, 0, '2026-01-15 02:18:06.228048', '2026-01-15 02:18:06.228048', 9, 1, 1, 67, 1);
INSERT INTO `scores_score` VALUES (97, 100, 88.4, 82.5, 80, '{\"作品\": 80.0, \"报告\": 78.0, \"电子笔记\": 80.0}', 80, 89.20000000000002, 79, 86, 79, 82, 3.3, 'B+', 0, NULL, 0, '2026-01-15 02:18:06.228048', '2026-01-15 02:18:06.228048', 9, 1, 1, 68, 1);
INSERT INTO `scores_score` VALUES (98, 100, 95.6, 91, 84, '{\"作品\": 98.0, \"报告\": 89.0, \"电子笔记\": 84.0}', 98, 93.79999999999998, 92, 92, 92, 92, 4, 'A', 0, NULL, 0, '2026-01-15 02:18:06.228048', '2026-01-15 02:18:06.228048', 9, 1, 1, 69, 1);
INSERT INTO `scores_score` VALUES (99, 90, 85, 74, 78, '{\"作品\": 70.0, \"报告\": 65.0, \"电子笔记\": 78.0}', 70, 84.49999999999999, 69, 79, 69, 73, 2.3, 'C+', 0, NULL, 0, '2026-01-15 02:18:06.228048', '2026-01-15 02:18:06.228048', 9, 1, 1, 70, 1);
INSERT INTO `scores_score` VALUES (100, 100, 78.8, 85, 85, '{\"作品\": 85.0, \"报告\": 80.0, \"电子笔记\": 85.0}', 85, 85.64999999999999, 83, 85, 83, 84, 3.3, 'B+', 0, NULL, 0, '2026-01-15 02:18:06.228048', '2026-01-15 02:18:06.228048', 9, 1, 1, 71, 1);
INSERT INTO `scores_score` VALUES (101, 100, 85.4, 67.5, 76, '{\"作品\": 0.0, \"报告\": 60.0, \"电子笔记\": 76.0}', 0, 86.70000000000002, 39, 77, 39, 54, 0, 'F', 0, NULL, 0, '2026-01-15 02:18:06.228048', '2026-01-15 02:18:06.228048', 9, 1, 1, 72, 1);
INSERT INTO `scores_score` VALUES (102, 100, 94.6, 85.5, 90, '{\"作品\": 85.0, \"报告\": 80.0, \"电子笔记\": 90.0}', 85, 94.8, 83, 90, 83, 86, 3.7, 'A-', 0, NULL, 0, '2026-01-15 02:18:06.228048', '2026-01-15 02:18:06.228048', 9, 1, 1, 73, 1);
INSERT INTO `scores_score` VALUES (103, 100, 87.8, 70, 88, '{\"作品\": 61.0, \"报告\": 60.0, \"电子笔记\": 88.0}', 61, 90.89999999999999, 62, 80, 62, 69, 2, 'C', 0, NULL, 0, '2026-01-15 02:18:06.228048', '2026-01-15 02:18:06.228048', 9, 1, 1, 74, 1);
INSERT INTO `scores_score` VALUES (104, 100, 83.4, 75.5, 86, '{\"作品\": 75.0, \"报告\": 70.0, \"电子笔记\": 86.0}', 75, 88.2, 73, 82, 73, 77, 2.7, 'B-', 0, NULL, 0, '2026-01-15 02:18:06.228048', '2026-01-15 02:18:06.228048', 9, 1, 1, 75, 1);
INSERT INTO `scores_score` VALUES (105, 100, 83.6, 78.5, 85, '{\"作品\": 84.0, \"报告\": 75.0, \"电子笔记\": 85.0}', 84, 88.05, 79, 83, 79, 81, 3, 'B', 0, NULL, 0, '2026-01-15 02:18:06.228048', '2026-01-15 02:18:06.228048', 9, 1, 1, 76, 1);
INSERT INTO `scores_score` VALUES (106, 100, 100, 93, 78, '{\"作品\": 85.0, \"报告\": 90.0, \"电子笔记\": 78.0}', 85, 94.49999999999999, 88, 94, 88, 90, 4, 'A', 0, NULL, 0, '2026-01-15 02:18:06.228048', '2026-01-15 02:18:06.228048', 9, 1, 1, 77, 1);
INSERT INTO `scores_score` VALUES (107, 100, 88.4, 76.5, 81, '{\"作品\": 75.0, \"报告\": 70.0, \"电子笔记\": 81.0}', 75, 89.45, 73, 83, 73, 77, 2.7, 'B-', 0, NULL, 0, '2026-01-15 02:18:06.228048', '2026-01-15 02:18:06.228048', 9, 1, 1, 78, 1);
INSERT INTO `scores_score` VALUES (108, 100, 88.4, 32.5, 64, '{\"作品\": 68.0, \"报告\": 62.0, \"电子笔记\": 64.0}', 68, 85.19999999999999, 56, 59, 56, 57, 0, 'F', 0, NULL, 0, '2026-01-15 02:18:06.228048', '2026-01-15 02:18:06.228048', 9, 1, 1, 79, 1);
INSERT INTO `scores_score` VALUES (109, 100, 83.2, 71.5, 80, '{\"作品\": 65.0, \"报告\": 68.0, \"电子笔记\": 80.0}', 65, 86.6, 67, 79, 67, 72, 2.3, 'C+', 0, NULL, 0, '2026-01-15 02:18:06.228048', '2026-01-15 02:18:06.228048', 9, 1, 1, 80, 1);
INSERT INTO `scores_score` VALUES (110, 100, 81.6, 80, 82, '{\"作品\": 84.0, \"报告\": 78.0, \"电子笔记\": 82.0}', 84, 86.3, 80, 83, 80, 81, 3, 'B', 0, NULL, 0, '2026-01-15 02:18:06.228048', '2026-01-15 02:18:06.228048', 9, 1, 1, 81, 1);
INSERT INTO `scores_score` VALUES (111, 100, 89.4, 84.5, 78, '{\"作品\": 80.0, \"报告\": 80.0, \"电子笔记\": 78.0}', 80, 89.20000000000002, 81, 87, 81, 83, 3.3, 'B+', 0, NULL, 0, '2026-01-15 02:18:06.228048', '2026-01-15 02:18:06.228048', 9, 1, 1, 82, 1);
INSERT INTO `scores_score` VALUES (112, 100, 91, 77.5, 76, '{\"作品\": 75.0, \"报告\": 73.0, \"电子笔记\": 76.0}', 75, 89.49999999999999, 74, 83, 74, 78, 3, 'B', 0, NULL, 0, '2026-01-15 02:18:06.229317', '2026-01-15 02:18:06.229317', 9, 1, 1, 83, 1);
INSERT INTO `scores_score` VALUES (113, 100, 88, 94.5, 76, '{\"作品\": 90.0, \"报告\": 93.0, \"电子笔记\": 76.0}', 90, 88, 92, 91, 92, 92, 4, 'A', 0, NULL, 0, '2026-01-15 02:18:06.229317', '2026-01-15 02:18:06.229317', 9, 1, 1, 84, 1);
INSERT INTO `scores_score` VALUES (114, 100, 91.4, 90, 78, '{\"作品\": 85.0, \"报告\": 88.0, \"电子笔记\": 78.0}', 85, 90.19999999999999, 87, 90, 87, 88, 3.7, 'A-', 0, NULL, 0, '2026-01-15 02:18:06.229317', '2026-01-15 02:18:06.229317', 9, 1, 1, 85, 1);
INSERT INTO `scores_score` VALUES (115, 100, 84.2, 82.5, 76, '{\"作品\": 83.0, \"报告\": 78.0, \"电子笔记\": 76.0}', 83, 86.1, 80, 84, 80, 82, 3.3, 'B+', 0, NULL, 0, '2026-01-15 02:18:06.229317', '2026-01-15 02:18:06.229317', 9, 1, 1, 86, 1);
INSERT INTO `scores_score` VALUES (116, 90, 79.8, 75.5, 74, '{\"作品\": 75.0, \"报告\": 70.0, \"电子笔记\": 74.0}', 75, 80.89999999999999, 73, 78, 73, 75, 2.7, 'B-', 0, NULL, 0, '2026-01-15 02:18:06.229317', '2026-01-15 02:18:06.229317', 9, 1, 1, 87, 1);
INSERT INTO `scores_score` VALUES (117, 100, 98, 87, 88, '{\"作品\": 85.0, \"报告\": 83.0, \"电子笔记\": 88.0}', 85, 96.00000000000001, 84, 92, 84, 87, 3.7, 'A-', 0, NULL, 0, '2026-01-15 02:18:06.229317', '2026-01-15 02:18:06.229317', 9, 1, 1, 88, 1);
INSERT INTO `scores_score` VALUES (118, 90, 85.6, 77.5, 76, '{\"作品\": 75.0, \"报告\": 75.0, \"电子笔记\": 76.0}', 75, 84.3, 75, 81, 75, 77, 2.7, 'B-', 0, NULL, 0, '2026-01-15 02:18:06.229317', '2026-01-15 02:18:06.229317', 9, 1, 1, 89, 1);
INSERT INTO `scores_score` VALUES (119, 100, 85.2, 76, 78, '{\"作品\": 75.0, \"报告\": 73.0, \"电子笔记\": 78.0}', 75, 87.10000000000001, 74, 82, 74, 77, 2.7, 'B-', 0, NULL, 0, '2026-01-15 02:18:06.229317', '2026-01-15 02:18:06.229317', 9, 1, 1, 90, 1);
INSERT INTO `scores_score` VALUES (120, 100, 84.2, 80.5, 88, '{\"作品\": 81.0, \"报告\": 80.0, \"电子笔记\": 88.0}', 81, 89.1, 80, 85, 80, 82, 3.3, 'B+', 0, NULL, 0, '2026-01-15 02:18:06.229317', '2026-01-15 02:18:06.229317', 9, 1, 1, 91, 1);
INSERT INTO `scores_score` VALUES (121, 100, 90.2, 88, 82, '{\"作品\": 83.0, \"报告\": 85.0, \"电子笔记\": 82.0}', 83, 90.60000000000002, 85, 89, 85, 87, 3.7, 'A-', 0, NULL, 0, '2026-01-15 02:18:06.229317', '2026-01-15 02:18:06.229317', 9, 1, 1, 92, 1);

-- ----------------------------
-- Table structure for scores_scoreadjustment
-- ----------------------------
DROP TABLE IF EXISTS `scores_scoreadjustment`;
CREATE TABLE `scores_scoreadjustment`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `adjustment_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `reason` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `original_value` json NOT NULL,
  `new_value` json NOT NULL,
  `is_approved` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `adjusted_by_id` bigint NULL DEFAULT NULL,
  `approved_by_id` bigint NULL DEFAULT NULL,
  `score_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `scores_scoreadjustment_adjusted_by_id_096afba6_fk_users_user_id`(`adjusted_by_id` ASC) USING BTREE,
  INDEX `scores_scoreadjustment_approved_by_id_fd558873_fk_users_user_id`(`approved_by_id` ASC) USING BTREE,
  INDEX `scores_scoreadjustment_score_id_a1cc8460_fk_scores_score_id`(`score_id` ASC) USING BTREE,
  CONSTRAINT `scores_scoreadjustment_adjusted_by_id_096afba6_fk_users_user_id` FOREIGN KEY (`adjusted_by_id`) REFERENCES `users_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `scores_scoreadjustment_approved_by_id_fd558873_fk_users_user_id` FOREIGN KEY (`approved_by_id`) REFERENCES `users_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `scores_scoreadjustment_score_id_a1cc8460_fk_scores_score_id` FOREIGN KEY (`score_id`) REFERENCES `scores_score` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of scores_scoreadjustment
-- ----------------------------

-- ----------------------------
-- Table structure for scores_scoreimportlog
-- ----------------------------
DROP TABLE IF EXISTS `scores_scoreimportlog`;
CREATE TABLE `scores_scoreimportlog`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `total_rows` int NOT NULL,
  `success_rows` int NOT NULL,
  `failed_rows` int NOT NULL,
  `error_log` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `column_mapping` json NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `completed_at` datetime(6) NULL DEFAULT NULL,
  `course_class_id` bigint NULL DEFAULT NULL,
  `imported_by_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `scores_scoreimportlo_course_class_id_4d3e0d41_fk_courses_c`(`course_class_id` ASC) USING BTREE,
  INDEX `scores_scoreimportlog_imported_by_id_9d5fb501_fk_users_user_id`(`imported_by_id` ASC) USING BTREE,
  CONSTRAINT `scores_scoreimportlo_course_class_id_4d3e0d41_fk_courses_c` FOREIGN KEY (`course_class_id`) REFERENCES `courses_courseclass` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `scores_scoreimportlog_imported_by_id_9d5fb501_fk_users_user_id` FOREIGN KEY (`imported_by_id`) REFERENCES `users_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of scores_scoreimportlog
-- ----------------------------
INSERT INTO `scores_scoreimportlog` VALUES (1, '初始成绩.xlsx', '', 30, 30, 0, '', '{\"final\": \"作品\", \"homework\": \"作业成绩\", \"attendance\": \"点名\", \"experiment\": \"实验\", \"student_id\": \"学号\", \"review_note\": \"电子笔记\", \"student_name\": \"姓名\"}', 'completed', '2025-12-26 13:31:30.189821', '2025-12-26 13:37:43.023023', 1, 1);
INSERT INTO `scores_scoreimportlog` VALUES (2, '初始成绩.xlsx', '', 30, 30, 0, '', '{\"final\": \"作品\", \"homework\": \"作业成绩\", \"attendance\": \"点名\", \"experiment\": \"实验\", \"student_id\": \"学号\", \"review_note\": \"电子笔记\", \"student_name\": \"姓名\"}', 'completed', '2025-12-26 13:32:15.154402', '2025-12-26 13:39:08.292432', 1, 1);
INSERT INTO `scores_scoreimportlog` VALUES (3, '初始成绩.xlsx', '', 30, 30, 0, '', '{\"final\": \"作品\", \"homework\": \"作业成绩\", \"attendance\": \"点名\", \"experiment\": \"实验\", \"student_id\": \"学号\", \"review_note\": \"电子笔记\", \"student_name\": \"姓名\"}', 'completed', '2025-12-26 13:54:35.945951', '2025-12-26 13:59:44.254476', 1, 1);
INSERT INTO `scores_scoreimportlog` VALUES (4, '初始成绩.xlsx', '', 30, 0, 0, NULL, '{\"final\": \"作品\", \"homework\": \"作业成绩\", \"attendance\": \"点名\", \"experiment\": \"实验\", \"student_id\": \"学号\", \"review_note\": \"电子笔记\", \"student_name\": \"姓名\"}', 'processing', '2025-12-26 14:00:55.912192', NULL, 1, 1);
INSERT INTO `scores_scoreimportlog` VALUES (5, '初始成绩.xlsx', '', 30, 30, 0, '', '{\"final\": \"作品\", \"homework\": \"作业成绩\", \"attendance\": \"点名\", \"experiment\": \"实验\", \"student_id\": \"学号\", \"review_note\": \"电子笔记\", \"student_name\": \"姓名\"}', 'completed', '2025-12-26 14:05:40.382381', '2025-12-26 14:05:40.489692', 1, 1);
INSERT INTO `scores_scoreimportlog` VALUES (6, '初始成绩-模板.xlsx', '', 30, 30, 0, '', '{\"final\": \"作品\", \"homework\": \"作业成绩\", \"attendance\": \"点名\", \"experiment\": \"实验\", \"student_id\": \"学号\", \"review_note\": \"电子笔记\", \"student_name\": \"姓名\"}', 'completed', '2025-12-28 03:07:56.823049', '2025-12-28 03:07:56.855576', 2, 1);
INSERT INTO `scores_scoreimportlog` VALUES (7, '初始成绩-模板.xlsx', '', 30, 30, 0, '', '{\"final\": \"作品\", \"homework\": \"作业成绩\", \"attendance\": \"点名\", \"experiment\": \"实验\", \"student_id\": \"学号\", \"review_note\": \"电子笔记\", \"student_name\": \"姓名\"}', 'completed', '2025-12-28 03:50:45.133939', '2025-12-28 03:50:45.163604', 3, 1);
INSERT INTO `scores_scoreimportlog` VALUES (8, '初始成绩-模板.xlsx', '', 0, 0, 0, '', '{\"姓名\": \"student_name\", \"学号\": \"student_id\", \"期末\": \"final_score\", \"作业1\": \"homework1\", \"作业2\": \"homework2\", \"作业3\": \"homework3\", \"作业4\": \"homework4\", \"作业5\": \"homework5\", \"实验1\": \"experiment1\", \"实验2\": \"experiment2\", \"考勤1\": \"attendance1\", \"考勤2\": \"attendance2\", \"考勤3\": \"attendance3\", \"考勤4\": \"attendance4\", \"考勤5\": \"attendance5\", \"Unnamed: 15\": \"student_name\", \"Unnamed: 16\": \"student_name\", \"Unnamed: 17\": \"student_name\", \"Unnamed: 18\": \"student_name\", \"复习\\n笔记\": \"review_note\"}', 'completed', '2026-01-08 10:42:39.660751', '2026-01-08 10:42:39.687704', 4, 1);
INSERT INTO `scores_scoreimportlog` VALUES (9, '初始成绩-模板.xlsx', '', 0, 0, 0, '', '{\"姓名\": \"student_name\", \"学号\": \"student_id\", \"期末\": \"final_score\", \"作业1\": \"homework1\", \"作业2\": \"homework2\", \"作业3\": \"homework3\", \"作业4\": \"homework4\", \"作业5\": \"homework5\", \"实验1\": \"experiment1\", \"实验2\": \"experiment2\", \"考勤1\": \"attendance1\", \"考勤2\": \"attendance2\", \"考勤3\": \"attendance3\", \"考勤4\": \"attendance4\", \"考勤5\": \"attendance5\", \"Unnamed: 15\": \"student_name\", \"Unnamed: 16\": \"student_name\", \"Unnamed: 17\": \"student_name\", \"Unnamed: 18\": \"student_name\", \"复习\\n笔记\": \"review_note\"}', 'completed', '2026-01-08 10:43:04.005362', '2026-01-08 10:43:04.016862', 4, 1);
INSERT INTO `scores_scoreimportlog` VALUES (10, '初始成绩-模板.xlsx', '', 27, 27, 0, '', '{\"姓名\": \"student_name\", \"学号\": \"student_id\", \"期末\": \"final_score\", \"作业1\": \"homework1\", \"作业2\": \"homework2\", \"作业3\": \"homework3\", \"作业4\": \"homework4\", \"作业5\": \"homework5\", \"实验1\": \"experiment1\", \"实验2\": \"experiment2\", \"考勤1\": \"attendance1\", \"考勤2\": \"attendance2\", \"考勤3\": \"attendance3\", \"考勤4\": \"attendance4\", \"考勤5\": \"attendance5\", \"Unnamed: 15\": \"student_name\", \"Unnamed: 16\": \"student_name\", \"Unnamed: 17\": \"student_name\", \"Unnamed: 18\": \"student_name\", \"复习\\n笔记\": \"review_note\"}', 'completed', '2026-01-08 11:50:55.087603', '2026-01-08 11:50:55.322030', 4, 1);
INSERT INTO `scores_scoreimportlog` VALUES (11, '初始成绩-模板.xlsx', '', 27, 27, 0, '', '{\"姓名\": \"student_name\", \"学号\": \"student_id\", \"期末\": \"final_score\", \"作业1\": \"homework1\", \"作业2\": \"homework2\", \"作业3\": \"homework3\", \"作业4\": \"homework4\", \"作业5\": \"homework5\", \"实验1\": \"experiment1\", \"实验2\": \"experiment2\", \"考勤1\": \"attendance1\", \"考勤2\": \"attendance2\", \"考勤3\": \"attendance3\", \"考勤4\": \"attendance4\", \"考勤5\": \"attendance5\", \"Unnamed: 15\": \"student_name\", \"Unnamed: 16\": \"student_name\", \"Unnamed: 17\": \"student_name\", \"Unnamed: 18\": \"student_name\", \"复习\\n笔记\": \"review_note\"}', 'completed', '2026-01-08 11:55:19.959461', '2026-01-08 11:55:20.144119', 4, 1);
INSERT INTO `scores_scoreimportlog` VALUES (12, '初始成绩-模板.xlsx', '', 27, 27, 0, '', '{\"姓名\": \"student_name\", \"学号\": \"student_id\", \"期末\": \"final_score\", \"作业1\": \"homework1\", \"作业2\": \"homework2\", \"作业3\": \"homework3\", \"作业4\": \"homework4\", \"作业5\": \"homework5\", \"实验1\": \"experiment1\", \"实验2\": \"experiment2\", \"考勤1\": \"attendance1\", \"考勤2\": \"attendance2\", \"考勤3\": \"attendance3\", \"考勤4\": \"attendance4\", \"考勤5\": \"attendance5\", \"Unnamed: 15\": \"student_name\", \"Unnamed: 16\": \"student_name\", \"Unnamed: 17\": \"student_name\", \"Unnamed: 18\": \"student_name\", \"复习\\n笔记\": \"review_note\"}', 'completed', '2026-01-08 11:59:34.524143', '2026-01-08 11:59:34.704679', 4, 1);
INSERT INTO `scores_scoreimportlog` VALUES (13, '初始成绩_卷面_模板.xlsx', '', 27, 27, 0, '', '{\"一\": \"homework1\", \"三\": \"homework3\", \"二\": \"homework2\", \"四\": \"homework4\", \"姓名\": \"student_name\", \"学号\": \"student_id\", \"Unnamed: 4\": \"student_name\", \"Unnamed: 5\": \"student_name\", \"Unnamed: 7\": \"student_name\", \"Unnamed: 8\": \"student_name\"}', 'completed', '2026-01-09 03:14:57.251409', '2026-01-09 03:14:57.713621', 4, 1);
INSERT INTO `scores_scoreimportlog` VALUES (14, '初始成绩-模板.xlsx', '', 27, 27, 0, '', '{\"姓名\": \"student_name\", \"学号\": \"student_id\", \"期末\": \"final_score\", \"作业1\": \"homework1\", \"作业2\": \"homework2\", \"作业3\": \"homework3\", \"作业4\": \"homework4\", \"作业5\": \"homework5\", \"实验1\": \"experiment1\", \"实验2\": \"experiment2\", \"考勤1\": \"attendance1\", \"考勤2\": \"attendance2\", \"考勤3\": \"attendance3\", \"考勤4\": \"attendance4\", \"考勤5\": \"attendance5\", \"Unnamed: 15\": \"student_name\", \"Unnamed: 16\": \"student_name\", \"Unnamed: 17\": \"student_name\", \"Unnamed: 18\": \"student_name\", \"复习\\n笔记\": \"review_note\"}', 'completed', '2026-01-09 03:22:11.229661', '2026-01-09 03:22:11.624076', 4, 1);
INSERT INTO `scores_scoreimportlog` VALUES (15, '2.初始成绩-模板.xlsx', '', 30, 30, 0, '', '{\"姓名\": \"student_name\", \"学号\": \"student_id\", \"期末\": \"final_score\", \"作业1\": \"homework1\", \"作业2\": \"homework2\", \"作业3\": \"homework3\", \"作业4\": \"homework4\", \"作业5\": \"homework5\", \"实验1\": \"experiment1\", \"实验2\": \"experiment2\", \"考勤1\": \"attendance1\", \"考勤2\": \"attendance2\", \"考勤3\": \"attendance3\", \"考勤4\": \"attendance4\", \"考勤5\": \"attendance5\", \"Unnamed: 15\": \"student_name\", \"Unnamed: 16\": \"student_name\", \"Unnamed: 17\": \"student_name\", \"Unnamed: 18\": \"student_name\", \"复习\\n笔记\": \"review_note\"}', 'completed', '2026-01-09 10:42:26.273545', '2026-01-09 10:42:26.840945', 5, 1);
INSERT INTO `scores_scoreimportlog` VALUES (16, '2.初始成绩_记分册-模板.xlsx', '', 29, 29, 0, '', '{\"姓名\": \"student_name\", \"学号\": \"student_id\", \"期末\": \"final_score\", \"作业1\": \"homework1\", \"作业2\": \"homework2\", \"作业3\": \"homework3\", \"作业4\": \"homework4\", \"作业5\": \"homework5\", \"实验1\": \"experiment1\", \"实验2\": \"experiment2\", \"考勤1\": \"attendance1\", \"考勤2\": \"attendance2\", \"考勤3\": \"attendance3\", \"考勤4\": \"attendance4\", \"考勤5\": \"attendance5\", \"Unnamed: 15\": \"student_name\", \"Unnamed: 16\": \"student_name\", \"Unnamed: 17\": \"student_name\", \"Unnamed: 18\": \"student_name\", \"复习\\n笔记\": \"review_note\"}', 'completed', '2026-01-11 08:00:01.555900', '2026-01-11 08:00:02.916175', 6, 1);
INSERT INTO `scores_scoreimportlog` VALUES (17, '初始成绩-模板.xlsx', '', 30, 30, 0, '', '{\"final\": \"作品\", \"homework\": \"作业成绩\", \"attendance\": \"点名\", \"experiment\": \"实验\", \"student_id\": \"学号\", \"review_note\": \"电子笔记\", \"student_name\": \"姓名\"}', 'completed', '2026-01-15 02:18:06.199835', '2026-01-15 02:18:06.247110', 9, 1);
INSERT INTO `scores_scoreimportlog` VALUES (18, '初始成绩-模板.xlsx', '', 30, 30, 0, '', '{\"final\": \"作品\", \"homework\": \"作业成绩\", \"attendance\": \"点名\", \"experiment\": \"实验\", \"student_id\": \"学号\", \"review_note\": \"电子笔记\", \"student_name\": \"姓名\"}', 'completed', '2026-01-15 02:26:24.280216', '2026-01-15 02:26:24.428929', 9, 1);
INSERT INTO `scores_scoreimportlog` VALUES (19, '2.初始成绩_记分册-模板.xlsx', '', 28, 28, 0, '', '{\"姓名\": \"student_name\", \"学号\": \"student_id\", \"期末\": \"final_score\", \"作业1\": \"homework1\", \"作业2\": \"homework2\", \"作业3\": \"homework3\", \"作业4\": \"homework4\", \"作业5\": \"homework5\", \"实验1\": \"experiment1\", \"实验2\": \"experiment2\", \"考勤1\": \"attendance1\", \"考勤2\": \"attendance2\", \"考勤3\": \"attendance3\", \"考勤4\": \"attendance4\", \"考勤5\": \"attendance5\", \"Unnamed: 15\": \"student_name\", \"Unnamed: 16\": \"student_name\", \"Unnamed: 17\": \"student_name\", \"Unnamed: 18\": \"student_name\", \"复习\\n笔记\": \"review_note\"}', 'completed', '2026-01-15 03:06:08.163915', '2026-01-15 03:06:08.759449', 7, 1);
INSERT INTO `scores_scoreimportlog` VALUES (20, '2.初始成绩_记分册-模板.xlsx', '', 29, 29, 0, '', '{\"姓名\": \"student_name\", \"学号\": \"student_id\", \"期末\": \"final_score\", \"作业1\": \"homework1\", \"作业2\": \"homework2\", \"作业3\": \"homework3\", \"作业4\": \"homework4\", \"作业5\": \"homework5\", \"实验1\": \"experiment1\", \"实验2\": \"experiment2\", \"考勤1\": \"attendance1\", \"考勤2\": \"attendance2\", \"考勤3\": \"attendance3\", \"考勤4\": \"attendance4\", \"考勤5\": \"attendance5\", \"Unnamed: 15\": \"student_name\", \"Unnamed: 16\": \"student_name\", \"Unnamed: 17\": \"student_name\", \"Unnamed: 18\": \"student_name\", \"复习\\n笔记\": \"review_note\"}', 'completed', '2026-03-05 03:19:12.809833', '2026-03-05 03:19:13.594292', 8, 1);

-- ----------------------------
-- Table structure for users_studentprofile
-- ----------------------------
DROP TABLE IF EXISTS `users_studentprofile`;
CREATE TABLE `users_studentprofile`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `student_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `grade` int NOT NULL,
  `class_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `major` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `enrollment_date` date NOT NULL,
  `expected_graduation` date NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `student_id`(`student_id` ASC) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `users_studentprofile_user_id_d0e95184_fk_users_user_id` FOREIGN KEY (`user_id`) REFERENCES `users_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 234 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users_studentprofile
-- ----------------------------
INSERT INTO `users_studentprofile` VALUES (1, '202205100109', 2021, '', '', '2025-12-26', '2029-12-26', 3);
INSERT INTO `users_studentprofile` VALUES (2, '202207070404', 2021, '', '', '2025-12-26', '2029-12-26', 4);
INSERT INTO `users_studentprofile` VALUES (3, '202207070414', 2021, '', '', '2025-12-26', '2029-12-26', 5);
INSERT INTO `users_studentprofile` VALUES (4, '202207070417', 2021, '', '', '2025-12-26', '2029-12-26', 6);
INSERT INTO `users_studentprofile` VALUES (5, '202207070424', 2021, '', '', '2025-12-26', '2029-12-26', 7);
INSERT INTO `users_studentprofile` VALUES (6, '202207070602', 2021, '', '', '2025-12-26', '2029-12-26', 8);
INSERT INTO `users_studentprofile` VALUES (7, '202207070607', 2021, '', '', '2025-12-26', '2029-12-26', 9);
INSERT INTO `users_studentprofile` VALUES (8, '202207070608', 2021, '', '', '2025-12-26', '2029-12-26', 10);
INSERT INTO `users_studentprofile` VALUES (9, '202207070611', 2021, '', '', '2025-12-26', '2029-12-26', 11);
INSERT INTO `users_studentprofile` VALUES (10, '202207070614', 2021, '', '', '2025-12-26', '2029-12-26', 12);
INSERT INTO `users_studentprofile` VALUES (11, '202207070615', 2021, '', '', '2025-12-26', '2029-12-26', 13);
INSERT INTO `users_studentprofile` VALUES (12, '202207070620', 2021, '', '', '2025-12-26', '2029-12-26', 14);
INSERT INTO `users_studentprofile` VALUES (13, '202207070621', 2021, '', '', '2025-12-26', '2029-12-26', 15);
INSERT INTO `users_studentprofile` VALUES (14, '202207070626', 2021, '', '', '2025-12-26', '2029-12-26', 16);
INSERT INTO `users_studentprofile` VALUES (15, '202207070706', 2021, '', '', '2025-12-26', '2029-12-26', 17);
INSERT INTO `users_studentprofile` VALUES (16, '202207070708', 2021, '', '', '2025-12-26', '2029-12-26', 18);
INSERT INTO `users_studentprofile` VALUES (17, '202207070709', 2021, '', '', '2025-12-26', '2029-12-26', 19);
INSERT INTO `users_studentprofile` VALUES (18, '202207070902', 2021, '', '', '2025-12-26', '2029-12-26', 20);
INSERT INTO `users_studentprofile` VALUES (19, '202207070905', 2021, '', '', '2025-12-26', '2029-12-26', 21);
INSERT INTO `users_studentprofile` VALUES (20, '202207070922', 2021, '', '', '2025-12-26', '2029-12-26', 22);
INSERT INTO `users_studentprofile` VALUES (21, '202207071013', 2021, '', '', '2025-12-26', '2029-12-26', 23);
INSERT INTO `users_studentprofile` VALUES (22, '202207071203', 2021, '', '', '2025-12-26', '2029-12-26', 24);
INSERT INTO `users_studentprofile` VALUES (23, '202207071209', 2021, '', '', '2025-12-26', '2029-12-26', 25);
INSERT INTO `users_studentprofile` VALUES (24, '202207071213', 2021, '', '', '2025-12-26', '2029-12-26', 26);
INSERT INTO `users_studentprofile` VALUES (25, '202208010208', 2021, '', '', '2025-12-26', '2029-12-26', 27);
INSERT INTO `users_studentprofile` VALUES (26, '202209040120', 2021, '', '', '2025-12-26', '2029-12-26', 28);
INSERT INTO `users_studentprofile` VALUES (27, '202209040216', 2021, '', '', '2025-12-26', '2029-12-26', 29);
INSERT INTO `users_studentprofile` VALUES (28, '202214090118', 2021, '', '', '2025-12-26', '2029-12-26', 30);
INSERT INTO `users_studentprofile` VALUES (29, '202215030120', 2021, '', '', '2025-12-26', '2029-12-26', 31);
INSERT INTO `users_studentprofile` VALUES (30, 'BS2207070327', 2021, '', '', '2025-12-26', '2029-12-26', 32);
INSERT INTO `users_studentprofile` VALUES (31, '202107070722', 2021, '', '', '2025-12-28', '2029-12-28', 33);
INSERT INTO `users_studentprofile` VALUES (32, '202206010217', 2021, '', '', '2025-12-28', '2029-12-28', 34);
INSERT INTO `users_studentprofile` VALUES (33, '202206040121', 2021, '', '', '2025-12-28', '2029-12-28', 35);
INSERT INTO `users_studentprofile` VALUES (34, '202207070106', 2021, '', '', '2025-12-28', '2029-12-28', 36);
INSERT INTO `users_studentprofile` VALUES (35, '202207070108', 2021, '', '', '2025-12-28', '2029-12-28', 37);
INSERT INTO `users_studentprofile` VALUES (36, '202207070112', 2021, '', '', '2025-12-28', '2029-12-28', 38);
INSERT INTO `users_studentprofile` VALUES (37, '202207070116', 2021, '', '', '2025-12-28', '2029-12-28', 39);
INSERT INTO `users_studentprofile` VALUES (38, '202207070118', 2021, '', '', '2025-12-28', '2029-12-28', 40);
INSERT INTO `users_studentprofile` VALUES (39, '202207070119', 2021, '', '', '2025-12-28', '2029-12-28', 41);
INSERT INTO `users_studentprofile` VALUES (40, '202207070323', 2021, '', '', '2025-12-28', '2029-12-28', 42);
INSERT INTO `users_studentprofile` VALUES (41, '202207070403', 2021, '', '', '2025-12-28', '2029-12-28', 43);
INSERT INTO `users_studentprofile` VALUES (42, '202207070412', 2021, '', '', '2025-12-28', '2029-12-28', 44);
INSERT INTO `users_studentprofile` VALUES (43, '202207070802', 2021, '', '', '2025-12-28', '2029-12-28', 45);
INSERT INTO `users_studentprofile` VALUES (44, '202207070803', 2021, '', '', '2025-12-28', '2029-12-28', 46);
INSERT INTO `users_studentprofile` VALUES (45, '202207070809', 2021, '', '', '2025-12-28', '2029-12-28', 47);
INSERT INTO `users_studentprofile` VALUES (46, '202207070810', 2021, '', '', '2025-12-28', '2029-12-28', 48);
INSERT INTO `users_studentprofile` VALUES (47, '202207070811', 2021, '', '', '2025-12-28', '2029-12-28', 49);
INSERT INTO `users_studentprofile` VALUES (48, '202207070815', 2021, '', '', '2025-12-28', '2029-12-28', 50);
INSERT INTO `users_studentprofile` VALUES (49, '202207070816', 2021, '', '', '2025-12-28', '2029-12-28', 51);
INSERT INTO `users_studentprofile` VALUES (50, '202207070818', 2021, '', '', '2025-12-28', '2029-12-28', 52);
INSERT INTO `users_studentprofile` VALUES (51, '202207070820', 2021, '', '', '2025-12-28', '2029-12-28', 53);
INSERT INTO `users_studentprofile` VALUES (52, '202207070824', 2021, '', '', '2025-12-28', '2029-12-28', 54);
INSERT INTO `users_studentprofile` VALUES (53, '202207070911', 2021, '', '', '2025-12-28', '2029-12-28', 55);
INSERT INTO `users_studentprofile` VALUES (54, '202207071124', 2021, '', '', '2025-12-28', '2029-12-28', 56);
INSERT INTO `users_studentprofile` VALUES (55, '202211070104', 2021, '', '', '2025-12-28', '2029-12-28', 57);
INSERT INTO `users_studentprofile` VALUES (56, '202212050417', 2021, '', '', '2025-12-28', '2029-12-28', 58);
INSERT INTO `users_studentprofile` VALUES (57, '202215030214', 2021, '', '', '2025-12-28', '2029-12-28', 59);
INSERT INTO `users_studentprofile` VALUES (58, '202215050402', 2021, '', '', '2025-12-28', '2029-12-28', 60);
INSERT INTO `users_studentprofile` VALUES (59, 'BS2207070126', 2021, '', '', '2025-12-28', '2029-12-28', 61);
INSERT INTO `users_studentprofile` VALUES (60, '22', 2021, '', '', '2025-12-28', '2029-12-28', 62);
INSERT INTO `users_studentprofile` VALUES (61, '202207070102', 2021, '', '', '2025-12-28', '2029-12-28', 63);
INSERT INTO `users_studentprofile` VALUES (62, '202207070502', 2021, '', '', '2025-12-28', '2029-12-28', 64);
INSERT INTO `users_studentprofile` VALUES (63, '202207070508', 2021, '', '', '2025-12-28', '2029-12-28', 65);
INSERT INTO `users_studentprofile` VALUES (64, '202207070514', 2021, '', '', '2025-12-28', '2029-12-28', 66);
INSERT INTO `users_studentprofile` VALUES (65, '202207070520', 2021, '', '', '2025-12-28', '2029-12-28', 67);
INSERT INTO `users_studentprofile` VALUES (66, '202207070522', 2021, '', '', '2025-12-28', '2029-12-28', 68);
INSERT INTO `users_studentprofile` VALUES (67, '202207070523', 2021, '', '', '2025-12-28', '2029-12-28', 69);
INSERT INTO `users_studentprofile` VALUES (68, '202207070524', 2021, '', '', '2025-12-28', '2029-12-28', 70);
INSERT INTO `users_studentprofile` VALUES (69, '202207070601', 2021, '', '', '2025-12-28', '2029-12-28', 71);
INSERT INTO `users_studentprofile` VALUES (70, '202207070808', 2021, '', '', '2025-12-28', '2029-12-28', 72);
INSERT INTO `users_studentprofile` VALUES (71, '202207070826', 2021, '', '', '2025-12-28', '2029-12-28', 73);
INSERT INTO `users_studentprofile` VALUES (72, '202207070904', 2021, '', '', '2025-12-28', '2029-12-28', 74);
INSERT INTO `users_studentprofile` VALUES (73, '202207070906', 2021, '', '', '2025-12-28', '2029-12-28', 75);
INSERT INTO `users_studentprofile` VALUES (74, '202207070908', 2021, '', '', '2025-12-28', '2029-12-28', 76);
INSERT INTO `users_studentprofile` VALUES (75, '202207070909', 2021, '', '', '2025-12-28', '2029-12-28', 77);
INSERT INTO `users_studentprofile` VALUES (76, '202207070912', 2021, '', '', '2025-12-28', '2029-12-28', 78);
INSERT INTO `users_studentprofile` VALUES (77, '202207070921', 2021, '', '', '2025-12-28', '2029-12-28', 79);
INSERT INTO `users_studentprofile` VALUES (78, '202207070924', 2021, '', '', '2025-12-28', '2029-12-28', 80);
INSERT INTO `users_studentprofile` VALUES (79, '202207071002', 2021, '', '', '2025-12-28', '2029-12-28', 81);
INSERT INTO `users_studentprofile` VALUES (80, '202207071005', 2021, '', '', '2025-12-28', '2029-12-28', 82);
INSERT INTO `users_studentprofile` VALUES (81, '202207071006', 2021, '', '', '2025-12-28', '2029-12-28', 83);
INSERT INTO `users_studentprofile` VALUES (82, '202207071009', 2021, '', '', '2025-12-28', '2029-12-28', 84);
INSERT INTO `users_studentprofile` VALUES (83, '202207071016', 2021, '', '', '2025-12-28', '2029-12-28', 85);
INSERT INTO `users_studentprofile` VALUES (84, '202207071018', 2021, '', '', '2025-12-28', '2029-12-28', 86);
INSERT INTO `users_studentprofile` VALUES (85, '202207071025', 2021, '', '', '2025-12-28', '2029-12-28', 87);
INSERT INTO `users_studentprofile` VALUES (86, '202207071216', 2021, '', '', '2025-12-28', '2029-12-28', 88);
INSERT INTO `users_studentprofile` VALUES (87, '202209010204', 2021, '', '', '2025-12-28', '2029-12-28', 89);
INSERT INTO `users_studentprofile` VALUES (88, '202209040116', 2021, '', '', '2025-12-28', '2029-12-28', 90);
INSERT INTO `users_studentprofile` VALUES (89, '202215050307', 2021, '', '', '2025-12-28', '2029-12-28', 91);
INSERT INTO `users_studentprofile` VALUES (90, 'BS2207070527', 2021, '', '', '2025-12-28', '2029-12-28', 92);
INSERT INTO `users_studentprofile` VALUES (91, '201507010413', 2022, '', '', '2026-01-08', '2030-01-08', 93);
INSERT INTO `users_studentprofile` VALUES (92, '202109100908', 2022, '', '', '2026-01-08', '2030-01-08', 94);
INSERT INTO `users_studentprofile` VALUES (93, '202301020120', 2022, '', '', '2026-01-08', '2030-01-08', 95);
INSERT INTO `users_studentprofile` VALUES (94, '202301080216', 2022, '', '', '2026-01-08', '2030-01-08', 96);
INSERT INTO `users_studentprofile` VALUES (95, '202304070208', 2022, '', '', '2026-01-08', '2030-01-08', 97);
INSERT INTO `users_studentprofile` VALUES (96, '202305040226', 2022, '', '', '2026-01-08', '2030-01-08', 98);
INSERT INTO `users_studentprofile` VALUES (97, '202306010301', 2022, '', '', '2026-01-08', '2030-01-08', 99);
INSERT INTO `users_studentprofile` VALUES (98, '202306040104', 2022, '', '', '2026-01-08', '2030-01-08', 100);
INSERT INTO `users_studentprofile` VALUES (99, '202308020218', 2022, '', '', '2026-01-08', '2030-01-08', 101);
INSERT INTO `users_studentprofile` VALUES (100, '202308030207', 2022, '', '', '2026-01-08', '2030-01-08', 102);
INSERT INTO `users_studentprofile` VALUES (101, '202308130120', 2022, '', '', '2026-01-08', '2030-01-08', 103);
INSERT INTO `users_studentprofile` VALUES (102, '202309010107', 2022, '', '', '2026-01-08', '2030-01-08', 104);
INSERT INTO `users_studentprofile` VALUES (103, '202309040114', 2022, '', '', '2026-01-08', '2030-01-08', 105);
INSERT INTO `users_studentprofile` VALUES (104, '202309040130', 2022, '', '', '2026-01-08', '2030-01-08', 106);
INSERT INTO `users_studentprofile` VALUES (105, '202309040210', 2022, '', '', '2026-01-08', '2030-01-08', 107);
INSERT INTO `users_studentprofile` VALUES (106, '202309040229', 2022, '', '', '2026-01-08', '2030-01-08', 108);
INSERT INTO `users_studentprofile` VALUES (107, '202309100517', 2022, '', '', '2026-01-08', '2030-01-08', 109);
INSERT INTO `users_studentprofile` VALUES (108, '202309100911', 2022, '', '', '2026-01-08', '2030-01-08', 110);
INSERT INTO `users_studentprofile` VALUES (109, '202311020306', 2022, '', '', '2026-01-08', '2030-01-08', 111);
INSERT INTO `users_studentprofile` VALUES (110, '202311030108', 2022, '', '', '2026-01-08', '2030-01-08', 112);
INSERT INTO `users_studentprofile` VALUES (111, '202311030110', 2022, '', '', '2026-01-08', '2030-01-08', 113);
INSERT INTO `users_studentprofile` VALUES (112, '202311100123', 2022, '', '', '2026-01-08', '2030-01-08', 114);
INSERT INTO `users_studentprofile` VALUES (113, '202312050424', 2022, '', '', '2026-01-08', '2030-01-08', 115);
INSERT INTO `users_studentprofile` VALUES (114, '202315010129', 2022, '', '', '2026-01-08', '2030-01-08', 116);
INSERT INTO `users_studentprofile` VALUES (115, '202315010202', 2022, '', '', '2026-01-08', '2030-01-08', 117);
INSERT INTO `users_studentprofile` VALUES (116, '202315010225', 2022, '', '', '2026-01-08', '2030-01-08', 118);
INSERT INTO `users_studentprofile` VALUES (117, '202315020327', 2022, '', '', '2026-01-08', '2030-01-08', 119);
INSERT INTO `users_studentprofile` VALUES (118, '202209100312', 2022, '', '', '2026-01-08', '2030-01-08', 120);
INSERT INTO `users_studentprofile` VALUES (119, '202307070103', 2022, '', '', '2026-01-08', '2030-01-08', 121);
INSERT INTO `users_studentprofile` VALUES (120, '202307070108', 2022, '', '', '2026-01-08', '2030-01-08', 122);
INSERT INTO `users_studentprofile` VALUES (121, '202307070113', 2022, '', '', '2026-01-08', '2030-01-08', 123);
INSERT INTO `users_studentprofile` VALUES (122, '202307070119', 2022, '', '', '2026-01-08', '2030-01-08', 124);
INSERT INTO `users_studentprofile` VALUES (123, '202307070204', 2022, '', '', '2026-01-08', '2030-01-08', 125);
INSERT INTO `users_studentprofile` VALUES (124, '202307070210', 2022, '', '', '2026-01-08', '2030-01-08', 126);
INSERT INTO `users_studentprofile` VALUES (125, '202307070314', 2022, '', '', '2026-01-08', '2030-01-08', 127);
INSERT INTO `users_studentprofile` VALUES (126, '202307070406', 2022, '', '', '2026-01-08', '2030-01-08', 128);
INSERT INTO `users_studentprofile` VALUES (127, '202307070510', 2022, '', '', '2026-01-08', '2030-01-08', 129);
INSERT INTO `users_studentprofile` VALUES (128, '202307070603', 2022, '', '', '2026-01-08', '2030-01-08', 130);
INSERT INTO `users_studentprofile` VALUES (129, '202307070604', 2022, '', '', '2026-01-08', '2030-01-08', 131);
INSERT INTO `users_studentprofile` VALUES (130, '202307070703', 2022, '', '', '2026-01-08', '2030-01-08', 132);
INSERT INTO `users_studentprofile` VALUES (131, '202307070705', 2022, '', '', '2026-01-08', '2030-01-08', 133);
INSERT INTO `users_studentprofile` VALUES (132, '202307070707', 2022, '', '', '2026-01-08', '2030-01-08', 134);
INSERT INTO `users_studentprofile` VALUES (133, '202307070709', 2022, '', '', '2026-01-08', '2030-01-08', 135);
INSERT INTO `users_studentprofile` VALUES (134, '202307070722', 2022, '', '', '2026-01-08', '2030-01-08', 136);
INSERT INTO `users_studentprofile` VALUES (135, '202307070806', 2022, '', '', '2026-01-08', '2030-01-08', 137);
INSERT INTO `users_studentprofile` VALUES (136, '202307070808', 2022, '', '', '2026-01-08', '2030-01-08', 138);
INSERT INTO `users_studentprofile` VALUES (137, '202307071003', 2022, '', '', '2026-01-08', '2030-01-08', 139);
INSERT INTO `users_studentprofile` VALUES (138, '202307071005', 2022, '', '', '2026-01-08', '2030-01-08', 140);
INSERT INTO `users_studentprofile` VALUES (139, '202307071018', 2022, '', '', '2026-01-08', '2030-01-08', 141);
INSERT INTO `users_studentprofile` VALUES (140, '202307071024', 2022, '', '', '2026-01-08', '2030-01-08', 142);
INSERT INTO `users_studentprofile` VALUES (141, '202307071104', 2022, '', '', '2026-01-08', '2030-01-08', 143);
INSERT INTO `users_studentprofile` VALUES (142, '202307071108', 2022, '', '', '2026-01-08', '2030-01-08', 144);
INSERT INTO `users_studentprofile` VALUES (143, '202307071202', 2022, '', '', '2026-01-08', '2030-01-08', 145);
INSERT INTO `users_studentprofile` VALUES (144, '202307071210', 2022, '', '', '2026-01-08', '2030-01-08', 146);
INSERT INTO `users_studentprofile` VALUES (145, '202307071220', 2022, '', '', '2026-01-08', '2030-01-08', 147);
INSERT INTO `users_studentprofile` VALUES (146, '202307071223', 2022, '', '', '2026-01-08', '2030-01-08', 148);
INSERT INTO `users_studentprofile` VALUES (147, 'BS2307070714', 2022, '', '', '2026-01-08', '2030-01-08', 149);
INSERT INTO `users_studentprofile` VALUES (148, '202307070209', 2022, '', '', '2026-01-08', '2030-01-08', 150);
INSERT INTO `users_studentprofile` VALUES (149, '202307070310', 2022, '', '', '2026-01-08', '2030-01-08', 151);
INSERT INTO `users_studentprofile` VALUES (150, '202307070401', 2022, '', '', '2026-01-08', '2030-01-08', 152);
INSERT INTO `users_studentprofile` VALUES (151, '202307070405', 2022, '', '', '2026-01-08', '2030-01-08', 153);
INSERT INTO `users_studentprofile` VALUES (152, '202307070410', 2022, '', '', '2026-01-08', '2030-01-08', 154);
INSERT INTO `users_studentprofile` VALUES (153, '202307070424', 2022, '', '', '2026-01-08', '2030-01-08', 155);
INSERT INTO `users_studentprofile` VALUES (154, '202307070502', 2022, '', '', '2026-01-08', '2030-01-08', 156);
INSERT INTO `users_studentprofile` VALUES (155, '202307070504', 2022, '', '', '2026-01-08', '2030-01-08', 157);
INSERT INTO `users_studentprofile` VALUES (156, '202307070506', 2022, '', '', '2026-01-08', '2030-01-08', 158);
INSERT INTO `users_studentprofile` VALUES (157, '202307070507', 2022, '', '', '2026-01-08', '2030-01-08', 159);
INSERT INTO `users_studentprofile` VALUES (158, '202307070508', 2022, '', '', '2026-01-08', '2030-01-08', 160);
INSERT INTO `users_studentprofile` VALUES (159, '202307070515', 2022, '', '', '2026-01-08', '2030-01-08', 161);
INSERT INTO `users_studentprofile` VALUES (160, '202307070519', 2022, '', '', '2026-01-08', '2030-01-08', 162);
INSERT INTO `users_studentprofile` VALUES (161, '202307070524', 2022, '', '', '2026-01-08', '2030-01-08', 163);
INSERT INTO `users_studentprofile` VALUES (162, '202307070605', 2022, '', '', '2026-01-08', '2030-01-08', 164);
INSERT INTO `users_studentprofile` VALUES (163, '202307070606', 2022, '', '', '2026-01-08', '2030-01-08', 165);
INSERT INTO `users_studentprofile` VALUES (164, '202307070607', 2022, '', '', '2026-01-08', '2030-01-08', 166);
INSERT INTO `users_studentprofile` VALUES (165, '202307070615', 2022, '', '', '2026-01-08', '2030-01-08', 167);
INSERT INTO `users_studentprofile` VALUES (166, '202307070618', 2022, '', '', '2026-01-08', '2030-01-08', 168);
INSERT INTO `users_studentprofile` VALUES (167, '202307070619', 2022, '', '', '2026-01-08', '2030-01-08', 169);
INSERT INTO `users_studentprofile` VALUES (168, '202307070701', 2022, '', '', '2026-01-08', '2030-01-08', 170);
INSERT INTO `users_studentprofile` VALUES (169, '202307070704', 2022, '', '', '2026-01-08', '2030-01-08', 171);
INSERT INTO `users_studentprofile` VALUES (170, '202307070710', 2022, '', '', '2026-01-08', '2030-01-08', 172);
INSERT INTO `users_studentprofile` VALUES (171, '202307070724', 2022, '', '', '2026-01-08', '2030-01-08', 173);
INSERT INTO `users_studentprofile` VALUES (172, '202307070804', 2022, '', '', '2026-01-08', '2030-01-08', 174);
INSERT INTO `users_studentprofile` VALUES (173, '202307070809', 2022, '', '', '2026-01-08', '2030-01-08', 175);
INSERT INTO `users_studentprofile` VALUES (174, '202307070913', 2022, '', '', '2026-01-08', '2030-01-08', 176);
INSERT INTO `users_studentprofile` VALUES (175, '202307071203', 2022, '', '', '2026-01-08', '2030-01-08', 177);
INSERT INTO `users_studentprofile` VALUES (176, 'BS2307070611', 2022, '', '', '2026-01-08', '2030-01-08', 178);
INSERT INTO `users_studentprofile` VALUES (177, '202307070101', 2022, '', '', '2026-01-08', '2030-01-08', 179);
INSERT INTO `users_studentprofile` VALUES (178, '202307070102', 2022, '', '', '2026-01-08', '2030-01-08', 180);
INSERT INTO `users_studentprofile` VALUES (179, '202307070107', 2022, '', '', '2026-01-08', '2030-01-08', 181);
INSERT INTO `users_studentprofile` VALUES (180, '202307070109', 2022, '', '', '2026-01-08', '2030-01-08', 182);
INSERT INTO `users_studentprofile` VALUES (181, '202307070110', 2022, '', '', '2026-01-08', '2030-01-08', 183);
INSERT INTO `users_studentprofile` VALUES (182, '202307070115', 2022, '', '', '2026-01-08', '2030-01-08', 184);
INSERT INTO `users_studentprofile` VALUES (183, '202307070118', 2022, '', '', '2026-01-08', '2030-01-08', 185);
INSERT INTO `users_studentprofile` VALUES (184, '202307070120', 2022, '', '', '2026-01-08', '2030-01-08', 186);
INSERT INTO `users_studentprofile` VALUES (185, '202307070123', 2022, '', '', '2026-01-08', '2030-01-08', 187);
INSERT INTO `users_studentprofile` VALUES (186, '202307070201', 2022, '', '', '2026-01-08', '2030-01-08', 188);
INSERT INTO `users_studentprofile` VALUES (187, '202307070215', 2022, '', '', '2026-01-08', '2030-01-08', 189);
INSERT INTO `users_studentprofile` VALUES (188, '202307070305', 2022, '', '', '2026-01-08', '2030-01-08', 190);
INSERT INTO `users_studentprofile` VALUES (189, '202307070309', 2022, '', '', '2026-01-08', '2030-01-08', 191);
INSERT INTO `users_studentprofile` VALUES (190, '202307070311', 2022, '', '', '2026-01-08', '2030-01-08', 192);
INSERT INTO `users_studentprofile` VALUES (191, '202307070316', 2022, '', '', '2026-01-08', '2030-01-08', 193);
INSERT INTO `users_studentprofile` VALUES (192, '202307070624', 2022, '', '', '2026-01-08', '2030-01-08', 194);
INSERT INTO `users_studentprofile` VALUES (193, '202307070801', 2022, '', '', '2026-01-08', '2030-01-08', 195);
INSERT INTO `users_studentprofile` VALUES (194, '202307070803', 2022, '', '', '2026-01-08', '2030-01-08', 196);
INSERT INTO `users_studentprofile` VALUES (195, '202307070807', 2022, '', '', '2026-01-08', '2030-01-08', 197);
INSERT INTO `users_studentprofile` VALUES (196, '202307070812', 2022, '', '', '2026-01-08', '2030-01-08', 198);
INSERT INTO `users_studentprofile` VALUES (197, '202307070815', 2022, '', '', '2026-01-08', '2030-01-08', 199);
INSERT INTO `users_studentprofile` VALUES (198, '202307070822', 2022, '', '', '2026-01-08', '2030-01-08', 200);
INSERT INTO `users_studentprofile` VALUES (199, '202307070826', 2022, '', '', '2026-01-08', '2030-01-08', 201);
INSERT INTO `users_studentprofile` VALUES (200, '202307071103', 2022, '', '', '2026-01-08', '2030-01-08', 202);
INSERT INTO `users_studentprofile` VALUES (201, '202307071119', 2022, '', '', '2026-01-08', '2030-01-08', 203);
INSERT INTO `users_studentprofile` VALUES (202, '202307071204', 2022, '', '', '2026-01-08', '2030-01-08', 204);
INSERT INTO `users_studentprofile` VALUES (203, '202307071207', 2022, '', '', '2026-01-08', '2030-01-08', 205);
INSERT INTO `users_studentprofile` VALUES (204, '202307071217', 2022, '', '', '2026-01-08', '2030-01-08', 206);
INSERT INTO `users_studentprofile` VALUES (205, '202207020110', 2022, '', '', '2026-01-08', '2030-01-08', 207);
INSERT INTO `users_studentprofile` VALUES (206, '202307070117', 2022, '', '', '2026-01-08', '2030-01-08', 208);
INSERT INTO `users_studentprofile` VALUES (207, '202307070205', 2022, '', '', '2026-01-08', '2030-01-08', 209);
INSERT INTO `users_studentprofile` VALUES (208, '202307070212', 2022, '', '', '2026-01-08', '2030-01-08', 210);
INSERT INTO `users_studentprofile` VALUES (209, '202307070518', 2022, '', '', '2026-01-08', '2030-01-08', 211);
INSERT INTO `users_studentprofile` VALUES (210, '202307070902', 2022, '', '', '2026-01-08', '2030-01-08', 212);
INSERT INTO `users_studentprofile` VALUES (211, '202307070903', 2022, '', '', '2026-01-08', '2030-01-08', 213);
INSERT INTO `users_studentprofile` VALUES (212, '202307070905', 2022, '', '', '2026-01-08', '2030-01-08', 214);
INSERT INTO `users_studentprofile` VALUES (213, '202307070906', 2022, '', '', '2026-01-08', '2030-01-08', 215);
INSERT INTO `users_studentprofile` VALUES (214, '202307070911', 2022, '', '', '2026-01-08', '2030-01-08', 216);
INSERT INTO `users_studentprofile` VALUES (215, '202307070912', 2022, '', '', '2026-01-08', '2030-01-08', 217);
INSERT INTO `users_studentprofile` VALUES (216, '202307070919', 2022, '', '', '2026-01-08', '2030-01-08', 218);
INSERT INTO `users_studentprofile` VALUES (217, '202307070922', 2022, '', '', '2026-01-08', '2030-01-08', 219);
INSERT INTO `users_studentprofile` VALUES (218, '202307070926', 2022, '', '', '2026-01-08', '2030-01-08', 220);
INSERT INTO `users_studentprofile` VALUES (219, '202307071010', 2022, '', '', '2026-01-08', '2030-01-08', 221);
INSERT INTO `users_studentprofile` VALUES (220, '202307071014', 2022, '', '', '2026-01-08', '2030-01-08', 222);
INSERT INTO `users_studentprofile` VALUES (221, '202307071015', 2022, '', '', '2026-01-08', '2030-01-08', 223);
INSERT INTO `users_studentprofile` VALUES (222, '202307071016', 2022, '', '', '2026-01-08', '2030-01-08', 224);
INSERT INTO `users_studentprofile` VALUES (223, '202307071019', 2022, '', '', '2026-01-08', '2030-01-08', 225);
INSERT INTO `users_studentprofile` VALUES (224, '202307071021', 2022, '', '', '2026-01-08', '2030-01-08', 226);
INSERT INTO `users_studentprofile` VALUES (225, '202307071025', 2022, '', '', '2026-01-08', '2030-01-08', 227);
INSERT INTO `users_studentprofile` VALUES (226, '202307071026', 2022, '', '', '2026-01-08', '2030-01-08', 228);
INSERT INTO `users_studentprofile` VALUES (227, '202307071112', 2022, '', '', '2026-01-08', '2030-01-08', 229);
INSERT INTO `users_studentprofile` VALUES (228, '202307071114', 2022, '', '', '2026-01-08', '2030-01-08', 230);
INSERT INTO `users_studentprofile` VALUES (229, '202307071122', 2022, '', '', '2026-01-08', '2030-01-08', 231);
INSERT INTO `users_studentprofile` VALUES (230, '202307071215', 2022, '', '', '2026-01-08', '2030-01-08', 232);
INSERT INTO `users_studentprofile` VALUES (231, 'BS2307070423', 2022, '', '', '2026-01-08', '2030-01-08', 233);
INSERT INTO `users_studentprofile` VALUES (232, 'BS2307070520', 2022, '', '', '2026-01-08', '2030-01-08', 234);
INSERT INTO `users_studentprofile` VALUES (233, 'BS2307071225', 2022, '', '', '2026-01-08', '2030-01-08', 235);

-- ----------------------------
-- Table structure for users_teacherprofile
-- ----------------------------
DROP TABLE IF EXISTS `users_teacherprofile`;
CREATE TABLE `users_teacherprofile`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `research_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `office` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `users_teacherprofile_user_id_976ceafc_fk_users_user_id` FOREIGN KEY (`user_id`) REFERENCES `users_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users_teacherprofile
-- ----------------------------

-- ----------------------------
-- Table structure for users_user
-- ----------------------------
DROP TABLE IF EXISTS `users_user`;
CREATE TABLE `users_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `last_login` datetime(6) NULL DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `first_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `last_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `user_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `employee_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `department` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_verified` tinyint(1) NOT NULL,
  `last_login_ip` char(39) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `login_count` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  UNIQUE INDEX `employee_id`(`employee_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 238 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users_user
-- ----------------------------
INSERT INTO `users_user` VALUES (1, 'pbkdf2_sha256$1000000$UGlLpCsA3cfnx8PkgiL2Kv$qokt6K9IR5edNQ7izqenQ7bdtMI5n8BMGbg0ymv12us=', '2025-12-09 10:08:11.881970', 1, 'admin', '', '', '3494662508@qq.com', 1, 1, '2025-12-09 10:04:16.893303', 'teacher', NULL, NULL, NULL, '', 0, '127.0.0.1', 19);
INSERT INTO `users_user` VALUES (3, '!J9HIZPxDo1JDrEB7AKK23iifP3Pl1RwjD9Emmbo9', NULL, 0, '202205100109', '姜依顺', '', '', 0, 1, '2025-12-26 12:46:51.502561', 'student', '202205100109', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (4, '!dVYIA80ANWULjmY4GJr49wMT2nR9HQ1KnqANnAYG', NULL, 0, '202207070404', '赵元浩', '', '', 0, 1, '2025-12-26 12:46:51.519811', 'student', '202207070404', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (5, '!FDjYAgX8hfd83e0nlZ1PcFElswRdv9txjISFePVi', NULL, 0, '202207070414', '张一一', '', '', 0, 1, '2025-12-26 12:46:51.533946', 'student', '202207070414', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (6, '!UXF7hrD9P92k7yopqIEPlvnRR3yTTUGDdw1Fwfh3', NULL, 0, '202207070417', '贺亚妮', '', '', 0, 1, '2025-12-26 12:46:51.546217', 'student', '202207070417', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (7, '!Bbr3J0zcDqMU1soRL7egSdx6etfRLlxkoAqDP40C', NULL, 0, '202207070424', '贾家宝', '', '', 0, 1, '2025-12-26 12:46:51.557374', 'student', '202207070424', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (8, '!vN1opWju1pJ62eKbuCWDbMgx57H4H55tnBhfvsec', NULL, 0, '202207070602', '王家玺', '', '', 0, 1, '2025-12-26 12:46:51.569671', 'student', '202207070602', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (9, '!AXdUzv0lCWYnBvzdD0XbWnUOuvV2WmTeM43n9Ql6', NULL, 0, '202207070607', '宿焕祺', '', '', 0, 1, '2025-12-26 12:46:51.581061', 'student', '202207070607', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (10, '!I0FKGpZORuuXZAbyK3O7LPvJMIUD293bfLdg3K9q', NULL, 0, '202207070608', '郭铭枭', '', '', 0, 1, '2025-12-26 12:46:51.593427', 'student', '202207070608', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (11, '!EjKH0R1DTPSzooJh6QeX143cLPTnhKUrUQ9VIC0q', NULL, 0, '202207070611', '武泽正', '', '', 0, 1, '2025-12-26 12:46:51.603564', 'student', '202207070611', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (12, '!6OGOMBJujKWowNWCIVy0VdFc8XcYqCgb5aMLfgGA', NULL, 0, '202207070614', '苏程伟', '', '', 0, 1, '2025-12-26 12:46:51.616150', 'student', '202207070614', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (13, '!Fu0AG5oQBogLQMsUQDveLJSjHFfH5grkaS7DpBv0', NULL, 0, '202207070615', '张钧栋', '', '', 0, 1, '2025-12-26 12:46:51.627426', 'student', '202207070615', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (14, '!wcTBlBVqk6Q45gXyqEyRkmBFAyaxRWzFoOeyZNt2', NULL, 0, '202207070620', '徐琳', '', '', 0, 1, '2025-12-26 12:46:51.637813', 'student', '202207070620', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (15, '!PqqSqgprR3BcAzHGuNwJLxKU2FFzlofW7HsoLVYD', NULL, 0, '202207070621', '拓梦菲', '', '', 0, 1, '2025-12-26 12:46:51.649125', 'student', '202207070621', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (16, '!3Zw2Up1zBOkmEnFJtR4LwPxybQHbNUav7fVg5813', NULL, 0, '202207070626', '张珈宁', '', '', 0, 1, '2025-12-26 12:46:51.659488', 'student', '202207070626', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (17, '!DGXvGA5hSOtIF7dbr5yyuefDjijMauMnyNv47nxP', NULL, 0, '202207070706', '于鑫洪', '', '', 0, 1, '2025-12-26 12:46:51.669902', 'student', '202207070706', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (18, '!x6TbEb6aDxzxhykEcTEq3seR7PHfcbHvH9pcVaXN', NULL, 0, '202207070708', '王睿', '', '', 0, 1, '2025-12-26 12:46:51.680092', 'student', '202207070708', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (19, '!JMk9YI73uNOXmMELhYlwwDg8SI3abwtzjNOPSozG', NULL, 0, '202207070709', '朱嘉熙', '', '', 0, 1, '2025-12-26 12:46:51.690305', 'student', '202207070709', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (20, '!sGfCkWZBYSNSTgvXZyx3FRZDqLBecKcZFsiSAO0x', NULL, 0, '202207070902', '祁敬雯', '', '', 0, 1, '2025-12-26 12:46:51.701624', 'student', '202207070902', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (21, '!mvBWvxtHIRC7FYfVym5hkhar9uvrXjkd1oHIwIUr', NULL, 0, '202207070905', '胡红艳', '', '', 0, 1, '2025-12-26 12:46:51.711770', 'student', '202207070905', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (22, '!UaSNYcgyn5scAwC4835Zt8UsvfxIpfOJNWbVlU1x', NULL, 0, '202207070922', '朱雨凡', '', '', 0, 1, '2025-12-26 12:46:51.722046', 'student', '202207070922', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (23, '!Q6JbJvxh0W3LC6mRr8qkWnjiKd0mhghLOmiFbRY7', NULL, 0, '202207071013', '陈思洁', '', '', 0, 1, '2025-12-26 12:46:51.732319', 'student', '202207071013', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (24, '!GxUic39e9hD68JcxMf7pLrGeSaSAnXNAcxGApXgi', NULL, 0, '202207071203', '蔡文泽', '', '', 0, 1, '2025-12-26 12:46:51.743520', 'student', '202207071203', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (25, '!OgyMv2YSdnlsbF06jUyiTt6AafRTuVJceAS2gZbY', NULL, 0, '202207071209', '刘启华', '', '', 0, 1, '2025-12-26 12:46:51.755031', 'student', '202207071209', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (26, '!JFewZinHNmf4OM2G4LgTYhOhqsreXODMPYs0DYWI', NULL, 0, '202207071213', '李仕元', '', '', 0, 1, '2025-12-26 12:46:51.765293', 'student', '202207071213', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (27, '!ckXcxeZhIwknbqockZ2P97ldNPNUM9xNl3xaAqjK', NULL, 0, '202208010208', '夏梓仪', '', '', 0, 1, '2025-12-26 12:46:51.776570', 'student', '202208010208', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (28, '!goJbtLGCnz0MVDQhV91zp1e00JvHt3XJFQoYjXXC', NULL, 0, '202209040120', '龚晨熙', '', '', 0, 1, '2025-12-26 12:46:51.787007', 'student', '202209040120', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (29, '!ikOLXFJcPfAeyHsnBX8Jy2kh4tZjFzB85Tz4lvWx', NULL, 0, '202209040216', '钟佩娟', '', '', 0, 1, '2025-12-26 12:46:51.798413', 'student', '202209040216', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (30, '!VzoF6mLXjfEMrsCDYEpYo3eEurcJ8oxiOPte5xCZ', NULL, 0, '202214090118', '张佳悦', '', '', 0, 1, '2025-12-26 12:46:51.809806', 'student', '202214090118', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (31, '!H6Eog1HQvQeBqj2gLo8PHxQ2uCWzcgmAfmfAcp3S', NULL, 0, '202215030120', '景佳玥', '', '', 0, 1, '2025-12-26 12:46:51.819991', 'student', '202215030120', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (32, '!DvpokikMNGNOpjJZLw4zYBb79Wpicd9GC5fXWFgw', NULL, 0, 'BS2207070327', '邵文昊', '', '', 0, 1, '2025-12-26 12:46:51.832777', 'student', 'BS2207070327', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (33, '!dLOakzYPjyFiLW2AOUHAhp7U2c5MUR8f62D01D3k', NULL, 0, '202107070722', '石磊', '', '', 0, 1, '2025-12-28 03:06:58.307607', 'student', '202107070722', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (34, '!0iNQVrEQrCFmqkc82wVpHQ5ihA7XypAfiOblOCdc', NULL, 0, '202206010217', '常尹立', '', '', 0, 1, '2025-12-28 03:06:58.321605', 'student', '202206010217', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (35, '!Cgaxe9oIQQ1L3oNZp7hqnQPzWLzZJZvXwtigFIqa', NULL, 0, '202206040121', '吴佳杰', '', '', 0, 1, '2025-12-28 03:06:58.334962', 'student', '202206040121', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (36, '!eOKM6zEQgCXBpuqq3VXB9EBDMfvUyD6VYxfRljTQ', NULL, 0, '202207070106', '李想想', '', '', 0, 1, '2025-12-28 03:06:58.347546', 'student', '202207070106', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (37, '!h0LfIujd5xEK1CbiUmeVCfyHsIwDsvBTCGRsYUi1', NULL, 0, '202207070108', '李忠艺', '', '', 0, 1, '2025-12-28 03:06:58.358779', 'student', '202207070108', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (38, '!fFcGhaIm6OpfUjsIER2s429JSVf6rjZWWmqyHKpA', NULL, 0, '202207070112', '邢宇航', '', '', 0, 1, '2025-12-28 03:06:58.373696', 'student', '202207070112', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (39, '!diumCaFNmcaVocXEGsD8bN13dq0FbRNPW6QeEmDy', NULL, 0, '202207070116', '颜赟喆', '', '', 0, 1, '2025-12-28 03:06:58.385479', 'student', '202207070116', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (40, '!zOFyMqSP6WH5073hrP7DQGcD9CqagleLYrOtiGSW', NULL, 0, '202207070118', '赵嘉拓', '', '', 0, 1, '2025-12-28 03:06:58.397897', 'student', '202207070118', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (41, '!wvUYagkuf63I1AH3kkY0Gj8jCtv6XgX7XJurfE6h', NULL, 0, '202207070119', '王润东', '', '', 0, 1, '2025-12-28 03:06:58.412022', 'student', '202207070119', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (42, '!cg2IyJCGaYjRbw5ZQKWAztMOTGU5LkyLZoBfH5lX', NULL, 0, '202207070323', '刘瑞兆', '', '', 0, 1, '2025-12-28 03:06:58.425434', 'student', '202207070323', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (43, '!mV0Npi5402en6qwK0qdRxeQpD1VywwMm7rfHHCXz', NULL, 0, '202207070403', '李咏仪', '', '', 0, 1, '2025-12-28 03:06:58.436518', 'student', '202207070403', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (44, '!cFDcAOepyeVQSpcK1ZhjuwF4kvGMDGQvG6sNyyl1', NULL, 0, '202207070412', '王雅兰', '', '', 0, 1, '2025-12-28 03:06:58.448103', 'student', '202207070412', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (45, '!TCdZyNAHgQJE4n5h73dGPjcL6iqdNfOzKv2pItCe', NULL, 0, '202207070802', '章恒毅', '', '', 0, 1, '2025-12-28 03:06:58.465717', 'student', '202207070802', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (46, '!WvSowYV2jK4XAVhjc3uY93cNG9xKLIy0yTWfMJr2', NULL, 0, '202207070803', '熊世玉', '', '', 0, 1, '2025-12-28 03:06:58.478561', 'student', '202207070803', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (47, '!7NwfdE9dYKdjyLMDIKjGbP4pbn1ts02PatXfetoE', NULL, 0, '202207070809', '曹鹏浩', '', '', 0, 1, '2025-12-28 03:06:58.490666', 'student', '202207070809', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (48, '!V2EQYKq5zYuRpIAKt9Bfv3Tu7L9o7jI9YrGi6S2Z', NULL, 0, '202207070810', '吕阳', '', '', 0, 1, '2025-12-28 03:06:58.503508', 'student', '202207070810', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (49, '!OWdmjuwsi0wlQWwGy67U6U2fbDCeRy0MdtZOLJ4j', NULL, 0, '202207070811', '边裕彤', '', '', 0, 1, '2025-12-28 03:06:58.515046', 'student', '202207070811', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (50, '!xm8N93wqSk21soNiK1yC2QQe9yl7NNYP7ooXqtJi', NULL, 0, '202207070815', '崔雨晴', '', '', 0, 1, '2025-12-28 03:06:58.527731', 'student', '202207070815', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (51, '!Q7xl6Y7Jtmvz5OAuew5rGD1nZzHiBaQrKI9gBWJ8', NULL, 0, '202207070816', '高思雨', '', '', 0, 1, '2025-12-28 03:06:58.539632', 'student', '202207070816', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (52, '!cYEQxo6JiCoiOQ0W9QDV4zQ0tG9tIUAcIDVMlmxI', NULL, 0, '202207070818', '赵洁宁', '', '', 0, 1, '2025-12-28 03:06:58.550890', 'student', '202207070818', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (53, '!K2TqQAA6dK7WRhYSBJ3IJvq3eokfy8ckzSbTe29S', NULL, 0, '202207070820', '张井然', '', '', 0, 1, '2025-12-28 03:06:58.560772', 'student', '202207070820', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (54, '!9mke0UYf07HbIY12r1uJ7ZAmoMDHTRPC7Z1TDGp4', NULL, 0, '202207070824', '王书婷', '', '', 0, 1, '2025-12-28 03:06:58.572114', 'student', '202207070824', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (55, '!9nRDnhbuWvFD0sFD0Y4KJRX9dlIkaOWEn9KvAbYp', NULL, 0, '202207070911', '秦淑惠', '', '', 0, 1, '2025-12-28 03:06:58.582989', 'student', '202207070911', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (56, '!oSifObgSV51lavFR8XYiSchW1fEU4i2B1b0LfrwM', NULL, 0, '202207071124', '高嘉婷', '', '', 0, 1, '2025-12-28 03:06:58.594075', 'student', '202207071124', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (57, '!gslJEM9Nm93hi4bI95g2zXLCiGA3QiJ94e9WClry', NULL, 0, '202211070104', '翟宇驰', '', '', 0, 1, '2025-12-28 03:06:58.605592', 'student', '202211070104', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (58, '!ijMNs53SOvXpZFISPPZvMTAoxNKOwlSoUzqZ8oEe', NULL, 0, '202212050417', '杨乐', '', '', 0, 1, '2025-12-28 03:06:58.617659', 'student', '202212050417', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (59, '!snIBwfRRzu5WKeA8gJr2EAsH67NZMhg33Qf6jGwx', NULL, 0, '202215030214', '赵子安', '', '', 0, 1, '2025-12-28 03:06:58.628175', 'student', '202215030214', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (60, '!oXaMHekqy2Ri2g1xeh57c9rnpnIqcx2mbngznNee', NULL, 0, '202215050402', '孙梦佟', '', '', 0, 1, '2025-12-28 03:06:58.639636', 'student', '202215050402', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (61, '!BIeES6kBbELvpXzg47luT9221S2iKOLhRQmGartW', NULL, 0, 'BS2207070126', '王恩雨', '', '', 0, 1, '2025-12-28 03:06:58.651118', 'student', 'BS2207070126', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (62, '!ghbZVAI0L3kstlU7dqTjWslbWEygY68YZmCHoviC', NULL, 0, '22', '测试', '', '', 0, 1, '2025-12-28 03:37:20.490662', 'student', '22', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (63, '!JB8nepptUxyCb8rCMjcv56cRj81Hy8QZAT98Eavm', NULL, 0, '202207070102', '吴永晗', '', '', 0, 1, '2025-12-28 03:50:08.733026', 'student', '202207070102', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (64, '!qQJzi5hrioHB2SPS3vuofpoIVF0Ht8PQ0RJn18E1', NULL, 0, '202207070502', '孙超凡', '', '', 0, 1, '2025-12-28 03:50:08.750449', 'student', '202207070502', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (65, '!P7GbwYCGPY8XWjIM3sfwDeWzILFkkngNj22MQXgQ', NULL, 0, '202207070508', '宋博豪', '', '', 0, 1, '2025-12-28 03:50:08.766361', 'student', '202207070508', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (66, '!ZnWlm9guEgRMoijRco60dgCFQloKT64b39PuFPW3', NULL, 0, '202207070514', '李青', '', '', 0, 1, '2025-12-28 03:50:08.781986', 'student', '202207070514', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (67, '!E7n2oOtRvvnTrnrpSNX5EutbFkkXnWBiCyLUwh0k', NULL, 0, '202207070520', '刘淑慧', '', '', 0, 1, '2025-12-28 03:50:08.799089', 'student', '202207070520', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (68, '!fd4CuQCzRQXCjJd8MEEaqoXD1CR4P0SbzC6VQGHg', NULL, 0, '202207070522', '陈龙威', '', '', 0, 1, '2025-12-28 03:50:08.814188', 'student', '202207070522', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (69, '!HHjQ5HGm2aVt4Q33yXwX45ZYPDdASdjwTCjDax6R', NULL, 0, '202207070523', '张文博', '', '', 0, 1, '2025-12-28 03:50:08.830131', 'student', '202207070523', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (70, '!tCyVWVXODEuuDpSxEz4mbLhNwctNJbn1TRBxDxhC', NULL, 0, '202207070524', '白佳睿', '', '', 0, 1, '2025-12-28 03:50:08.846467', 'student', '202207070524', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (71, '!eYZxtOlS7541PZi1Z5Vbs9lSexDsryPzE0yG6UZX', NULL, 0, '202207070601', '米新玮', '', '', 0, 1, '2025-12-28 03:50:08.860138', 'student', '202207070601', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (72, '!Q9b4Zf1tOlsMWiXrfvctHwiEQ7hk05nS0IlcqHDH', NULL, 0, '202207070808', '张夏玮', '', '', 0, 1, '2025-12-28 03:50:08.873906', 'student', '202207070808', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (73, '!ykPljPU72OHGv8kCLVF2S1kdlfSF3bYCTrDTY8ck', NULL, 0, '202207070826', '马纹纹', '', '', 0, 1, '2025-12-28 03:50:08.886259', 'student', '202207070826', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (74, '!rP3LcjNulZXMyKu6pAbq7J63qyRl3nJkhdswSnfC', NULL, 0, '202207070904', '张嘉庆', '', '', 0, 1, '2025-12-28 03:50:08.898832', 'student', '202207070904', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (75, '!4v1inwyehagu1IcTYKf1myUb5GxF2VQpQLW6Zirr', NULL, 0, '202207070906', '唐晨超', '', '', 0, 1, '2025-12-28 03:50:08.909840', 'student', '202207070906', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (76, '!uWbCT3LBXV74quO9jYyJwww0jrd2sbdiTb9F0UOv', NULL, 0, '202207070908', '焦嘉豪', '', '', 0, 1, '2025-12-28 03:50:08.921343', 'student', '202207070908', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (77, '!AssupemrBPfd7yrMJtoUQRjqYVoRAIQa1xUlhM0c', NULL, 0, '202207070909', '肖毅帆', '', '', 0, 1, '2025-12-28 03:50:08.933576', 'student', '202207070909', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (78, '!aUJJlR88DbIGZdPXr3yq5bNvaZvtvkpqHYZGrMpV', NULL, 0, '202207070912', '王铂清', '', '', 0, 1, '2025-12-28 03:50:08.944886', 'student', '202207070912', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (79, '!2L2OZ5JzPoVKyz28Z67FLEoob2vaD2GI0ClYanr0', NULL, 0, '202207070921', '夏少康', '', '', 0, 1, '2025-12-28 03:50:08.957495', 'student', '202207070921', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (80, '!7guus0CB611SLo0p9MzWGezzRl4qPyI7uBrOMTaU', NULL, 0, '202207070924', '常宇哲', '', '', 0, 1, '2025-12-28 03:50:08.969872', 'student', '202207070924', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (81, '!NUzKAeVZ9ieuxACm3SWKBMZJlDPaTetEqJljhZRu', NULL, 0, '202207071002', '王平', '', '', 0, 1, '2025-12-28 03:50:08.982491', 'student', '202207071002', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (82, '!RDloojdMHQRe1zvVP6USmlBbaZDG3uculwEpaYvo', NULL, 0, '202207071005', '郭雨欣', '', '', 0, 1, '2025-12-28 03:50:08.991822', 'student', '202207071005', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (83, '!ze9qPCc5j1t20qtI7hz8rkwq3eiijXr3CTL4box3', NULL, 0, '202207071006', '庞亚典', '', '', 0, 1, '2025-12-28 03:50:09.003821', 'student', '202207071006', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (84, '!FBOUsINukJxBIwtdoRJqItMU7nl4FHwFmwKrgoIr', NULL, 0, '202207071009', '高宇辉', '', '', 0, 1, '2025-12-28 03:50:09.014304', 'student', '202207071009', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (85, '!Yyp4K3lLfxaCOMf4ph0R5Uh1TP0V5X3MhstkLFfT', NULL, 0, '202207071016', '李小雅', '', '', 0, 1, '2025-12-28 03:50:09.024649', 'student', '202207071016', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (86, '!Z2Y30y4EoC2dCh7Kq3OPwagMAd0hFuLSdRCywgQ7', NULL, 0, '202207071018', '冯仁泽', '', '', 0, 1, '2025-12-28 03:50:09.036670', 'student', '202207071018', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (87, '!lSWgoQEleu5O79xuDLDhpZsGK3rIxi7OxwcqLAKV', NULL, 0, '202207071025', '陈洋', '', '', 0, 1, '2025-12-28 03:50:09.049313', 'student', '202207071025', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (88, '!mV7GoiXg2v2csx5IHx5KpS1oTCoBxK9P49UA2BES', NULL, 0, '202207071216', '张思瑶', '', '', 0, 1, '2025-12-28 03:50:09.061293', 'student', '202207071216', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (89, '!utzHXbYerQ8HT264o2UcKolB80fAmrleqNAJfnvI', NULL, 0, '202209010204', '宋映衡', '', '', 0, 1, '2025-12-28 03:50:09.073892', 'student', '202209010204', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (90, '!rttbFk1AgnG0KWl8aM2Y9l0PZzICNSv1qZWAq2Nf', NULL, 0, '202209040116', '许思翔', '', '', 0, 1, '2025-12-28 03:50:09.086587', 'student', '202209040116', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (91, '!aGabrAC4UpYoW5ulWnR9WOiGwVrEuiog3r4OGTuO', NULL, 0, '202215050307', '刘俊杰', '', '', 0, 1, '2025-12-28 03:50:09.099000', 'student', '202215050307', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (92, '!E0y8ObMoFU4z8EwsvMxPQmFMHS8GVl62jnASRqE6', NULL, 0, 'BS2207070527', '高正坤', '', '', 0, 1, '2025-12-28 03:50:09.111580', 'student', 'BS2207070527', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (93, '!fzT7ekYdsAZgeEDcr43YdDWqdEG3U7BRYFMloHJz', NULL, 0, '201507010413', '路伟', '', '', 0, 1, '2026-01-08 09:44:41.420196', 'student', '201507010413', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (94, '!7r4lnKtq3OyqJ2CT8S5f1QjNulhKKTX5wk1isVVv', NULL, 0, '202109100908', '刘洋', '', '', 0, 1, '2026-01-08 09:44:41.455501', 'student', '202109100908', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (95, '!AgAJoIVeE4ENHd2Q6MXPhYenTOv8wrOGAj1ySf4o', NULL, 0, '202301020120', '朱鑫磊', '', '', 0, 1, '2026-01-08 09:44:41.475296', 'student', '202301020120', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (96, '!2G5QHmnZSQyqn5hI6RdcEF4nAB7CPFUjAjDHI3mH', NULL, 0, '202301080216', '王欣悦', '', '', 0, 1, '2026-01-08 09:44:41.492457', 'student', '202301080216', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (97, '!wO0LcPDyJ3O0jichBPTGlscw9R7rX71UiX2MphId', NULL, 0, '202304070208', '高凯航', '', '', 0, 1, '2026-01-08 09:44:41.507082', 'student', '202304070208', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (98, '!NBUEs78kER2mbdSWOtS7SOw5IW4jnZ42TkJHi9f9', NULL, 0, '202305040226', '马沛鑫', '', '', 0, 1, '2026-01-08 09:44:41.523122', 'student', '202305040226', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (99, '!Cms9qwdw0nC9q9F2y6mzddROWCUbKaKUsTMBGjhr', NULL, 0, '202306010301', '王嘉政', '', '', 0, 1, '2026-01-08 09:44:41.538462', 'student', '202306010301', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (100, '!uqg2BfWHM4ov2yu86FGGktxJBzY7o1fyUfKYaD9m', NULL, 0, '202306040104', '陈子豪', '', '', 0, 1, '2026-01-08 09:44:41.554531', 'student', '202306040104', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (101, '!fbeuhek1tvQAV0niVNnZWItWhOwy8DL1bk7688wl', NULL, 0, '202308020218', '苗迪', '', '', 0, 1, '2026-01-08 09:44:41.569318', 'student', '202308020218', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (102, '!6Vsx5C0dvCHbAeA7qztipm3fyoQXrXxIkLSVhzcz', NULL, 0, '202308030207', '吴湛博', '', '', 0, 1, '2026-01-08 09:44:41.583364', 'student', '202308030207', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (103, '!5fqEEvRF7vG1ycosriwBPBRS6WtwG4M7qNKZjAum', NULL, 0, '202308130120', '韩佩蓉', '', '', 0, 1, '2026-01-08 09:44:41.597093', 'student', '202308130120', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (104, '!CYTqO4BZ4sSh6tOxqVjEMR1qux09p7mSelrN5Oer', NULL, 0, '202309010107', '魏江华', '', '', 0, 1, '2026-01-08 09:44:41.611156', 'student', '202309010107', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (105, '!SFWvS6btifHVmAGJsPh4n2w9Jxq7bjuWUPP0YdCU', NULL, 0, '202309040114', '冯真礼', '', '', 0, 1, '2026-01-08 09:44:41.626631', 'student', '202309040114', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (106, '!8kRCfya4wr7J7gAvtCRiUvmULlOGYvWX78yhJGKh', NULL, 0, '202309040130', '吴冰倩', '', '', 0, 1, '2026-01-08 09:44:41.641354', 'student', '202309040130', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (107, '!TUaR17C0q5p6dj65OFZ93ySryjIJ2KNFtQSDMaO3', NULL, 0, '202309040210', '焦煜文', '', '', 0, 1, '2026-01-08 09:44:41.655766', 'student', '202309040210', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (108, '!Sykme25L5aFapx0J2IjJUN2w9zHsrQf0Hk8wRDF7', NULL, 0, '202309040229', '李婷', '', '', 0, 1, '2026-01-08 09:44:41.669705', 'student', '202309040229', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (109, '!gJjoYBkIWtrn9asIPsiAbp8WqcjxMrLI3YL49Xuh', NULL, 0, '202309100517', '沈旺', '', '', 0, 1, '2026-01-08 09:44:41.684185', 'student', '202309100517', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (110, '!QgYo7tZiNUtaBD24QwKkFKC2ZM32vEj2pn1ISJO6', NULL, 0, '202309100911', '高程阳', '', '', 0, 1, '2026-01-08 09:44:41.698258', 'student', '202309100911', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (111, '!Cv00aPIGsFTjkIbkD8I9v38rCEZYcvsXNH8Scsv8', NULL, 0, '202311020306', '胡伟豪', '', '', 0, 1, '2026-01-08 09:44:41.713645', 'student', '202311020306', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (112, '!eSKoe9oZ7Kiwnsm51as8P53KSQKDFtoWqwxnw0ai', NULL, 0, '202311030108', '刘宇翔', '', '', 0, 1, '2026-01-08 09:44:41.727391', 'student', '202311030108', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (113, '!K1ybl1qWRWt3kEhp7n58wO2FnoZ2tOqRnBAc2ZXj', NULL, 0, '202311030110', '吕继杰', '', '', 0, 1, '2026-01-08 09:44:41.741614', 'student', '202311030110', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (114, '!wEQORViKAWcPOxXHGswF23yvM40uMfnUI5zNiDnM', NULL, 0, '202311100123', '吴柯佳', '', '', 0, 1, '2026-01-08 09:44:41.757151', 'student', '202311100123', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (115, '!h08oduXmnt1Pf24VSwrJylFTOQFzvkQ7wMhFaDnB', NULL, 0, '202312050424', '周燕萍', '', '', 0, 1, '2026-01-08 09:44:41.773615', 'student', '202312050424', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (116, '!OG2YPgZkXcx0lTKHolxXyLPMq0Dz7bOnMRim8x4y', NULL, 0, '202315010129', '彭洋', '', '', 0, 1, '2026-01-08 09:44:41.790548', 'student', '202315010129', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (117, '!W3Zr2wsXDE7Q7JX1wzLJG8xPLjkNcT4gqQ4IhtDk', NULL, 0, '202315010202', '余仁宏', '', '', 0, 1, '2026-01-08 09:44:41.803191', 'student', '202315010202', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (118, '!5aHczAZqDHo37ZRwWaXpV5t6DXw9xFhEawChFNRd', NULL, 0, '202315010225', '秦凯', '', '', 0, 1, '2026-01-08 09:44:41.819241', 'student', '202315010225', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (119, '!G8nEjRqRTVsILGjWqhrOA97GJUug8oCdTNEUlcbG', NULL, 0, '202315020327', '周志莹', '', '', 0, 1, '2026-01-08 09:44:41.833779', 'student', '202315020327', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (120, '!zBVleZMIu8YoH09QNPUTGUJBBXaOM23Uq0qwyWXL', NULL, 0, '202209100312', '丁媛媛', '', '', 0, 1, '2026-01-08 09:47:04.283452', 'student', '202209100312', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (121, '!mqZ6Ffxuig1LCM6sCfCyFCLsXOFFoElEMxS4x3yh', NULL, 0, '202307070103', '沙宇豪', '', '', 0, 1, '2026-01-08 09:47:04.296705', 'student', '202307070103', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (122, '!nOw5am37ZxYXc32G3hy3Xm1DhApYBSc8v3Z8fR3E', NULL, 0, '202307070108', '任煜文', '', '', 0, 1, '2026-01-08 09:47:04.309813', 'student', '202307070108', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (123, '!65EVm6I51ImI3ANUNKefnA6Rg3Cy2fUg209Uv50Z', NULL, 0, '202307070113', '张文龙', '', '', 0, 1, '2026-01-08 09:47:04.322243', 'student', '202307070113', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (124, '!VbTA6k6gbZMDPHTMMB9f4ToGzQQolLgs56ZreT9I', NULL, 0, '202307070119', '惠永琦', '', '', 0, 1, '2026-01-08 09:47:04.333910', 'student', '202307070119', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (125, '!ujuuxN3TWnKXf4RQxBszq9RVCvfmOMkySeak8BA0', NULL, 0, '202307070204', '李高见', '', '', 0, 1, '2026-01-08 09:47:04.345913', 'student', '202307070204', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (126, '!jQ4ChLljJEjNRsSQg8n9HeH9uCrYlmXN2qxreknv', NULL, 0, '202307070210', '周晶晶', '', '', 0, 1, '2026-01-08 09:47:04.358049', 'student', '202307070210', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (127, '!QZcwgYGwKbrh6Ly7RGNQb0v4GxQmHAmtzNsAviwl', NULL, 0, '202307070314', '李博妮', '', '', 0, 1, '2026-01-08 09:47:04.370011', 'student', '202307070314', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (128, '!tcJGPEd0jfav6l7T0tHrvqRgQV6sC5sBw6UegSKn', NULL, 0, '202307070406', '高千惠', '', '', 0, 1, '2026-01-08 09:47:04.382444', 'student', '202307070406', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (129, '!eSVs06OOgjqTLHKsBKyqOfWueRSb6QI8Sl20I8Nb', NULL, 0, '202307070510', '刘苗苗', '', '', 0, 1, '2026-01-08 09:47:04.395010', 'student', '202307070510', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (130, '!VRLOfnKge6FSjmWPEN2KXwLJT1s8JRnyjereOqpO', NULL, 0, '202307070603', '崔琳婧', '', '', 0, 1, '2026-01-08 09:47:04.406407', 'student', '202307070603', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (131, '!QPqfxgQb3AkxGitQ82OHmC7mCDj4W2BfELf8uF3x', NULL, 0, '202307070604', '张忠来', '', '', 0, 1, '2026-01-08 09:47:04.419939', 'student', '202307070604', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (132, '!KC5jmj47bw0f4LwocZ9SfhSwmQu3OtHQUmklZiZ7', NULL, 0, '202307070703', '苏旭超', '', '', 0, 1, '2026-01-08 09:47:04.431970', 'student', '202307070703', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (133, '!ufrqcAPiMvDEMr80zvklAonGeJgJsjixiF4KfAB8', NULL, 0, '202307070705', '魏林苹', '', '', 0, 1, '2026-01-08 09:47:04.445966', 'student', '202307070705', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (134, '!mZqDmgDFYVUWmjVf8QXqeAzg1pAmYGqWgb8EM5XQ', NULL, 0, '202307070707', '李克韬', '', '', 0, 1, '2026-01-08 09:47:04.458797', 'student', '202307070707', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (135, '!cDI8CNTTwpHSrHVXt91tD9P0IqjO5Esv7RZ1NE94', NULL, 0, '202307070709', '马浩宇', '', '', 0, 1, '2026-01-08 09:47:04.474930', 'student', '202307070709', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (136, '!GC6928zxV1idD09COO0ckpnkkPuR6OijuyPSlDj6', NULL, 0, '202307070722', '张佳默', '', '', 0, 1, '2026-01-08 09:47:04.485967', 'student', '202307070722', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (137, '!M1tm1Bs04NHHDU1RSqCgmkh8bmFGqQGAXs4631BP', NULL, 0, '202307070806', '王涛', '', '', 0, 1, '2026-01-08 09:47:04.498312', 'student', '202307070806', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (138, '!uTGkairR1g9WgyThUnzpaqQwxWzd2AXKbze0c0Bb', NULL, 0, '202307070808', '杜叶茜', '', '', 0, 1, '2026-01-08 09:47:04.511042', 'student', '202307070808', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (139, '!zt698XVSTFlB0LHyDdkzvk13SSROQdPNOh4zgKK7', NULL, 0, '202307071003', '李舒婷', '', '', 0, 1, '2026-01-08 09:47:04.523571', 'student', '202307071003', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (140, '!PAnlt9vD4nzY3hkie3rQwTSogux54PFLugP0Oeo2', NULL, 0, '202307071005', '胡婉', '', '', 0, 1, '2026-01-08 09:47:04.536424', 'student', '202307071005', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (141, '!vISULmNcmhLNDKi1mAxdfs30WB3Ma89SjM0zBciV', NULL, 0, '202307071018', '丁福珍', '', '', 0, 1, '2026-01-08 09:47:04.547602', 'student', '202307071018', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (142, '!Q9AQgEJB6JTnZoJTxMzu2F7KosQsrCLZFbXt7n2q', NULL, 0, '202307071024', '高续', '', '', 0, 1, '2026-01-08 09:47:04.557986', 'student', '202307071024', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (143, '!zOeGjc8oSYkJkGgASkjHADkBujjib3DX9nM52twn', NULL, 0, '202307071104', '单小容', '', '', 0, 1, '2026-01-08 09:47:04.569598', 'student', '202307071104', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (144, '!kjqSytUat4Y7ufyymA4cucifTUeTq9T1RMHuQQ3i', NULL, 0, '202307071108', '冯一鸣', '', '', 0, 1, '2026-01-08 09:47:04.582059', 'student', '202307071108', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (145, '!bBwHigZnl8DATBxUktypui1gFgnxs8Z6jzILO7No', NULL, 0, '202307071202', '万展瑜', '', '', 0, 1, '2026-01-08 09:47:04.592261', 'student', '202307071202', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (146, '!hKfj1ldc2HPSiJvJcjnxUrc5OlGbvWgKW4wej21P', NULL, 0, '202307071210', '李梅婷', '', '', 0, 1, '2026-01-08 09:47:04.604338', 'student', '202307071210', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (147, '!s9U3SZ1MGrDUpWs981QtBO4wN440zNjKPZxyT0KG', NULL, 0, '202307071220', '张皓渊', '', '', 0, 1, '2026-01-08 09:47:04.617690', 'student', '202307071220', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (148, '!nJfBTwVW2Kg7TTWg9EEqEFdOtvKsPySR9yJHxe7T', NULL, 0, '202307071223', '张城玮', '', '', 0, 1, '2026-01-08 09:47:04.629298', 'student', '202307071223', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (149, '!lSKljlCQLzdO8oCyo6k81FlhBblYiI1dXLQ9OXq7', NULL, 0, 'BS2307070714', '韩欣妮', '', '', 0, 1, '2026-01-08 09:47:04.640670', 'student', 'BS2307070714', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (150, '!cIisdMoMXsvX5sVi7dFfip0MUTRKzerNnhdE78tD', NULL, 0, '202307070209', '黄恺芸', '', '', 0, 1, '2026-01-08 09:47:44.627804', 'student', '202307070209', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (151, '!oo1Hkp7rzKVKzZpcx6LhAbN0VIBojkMrzHB2xcOV', NULL, 0, '202307070310', '高俊彦', '', '', 0, 1, '2026-01-08 09:47:44.641570', 'student', '202307070310', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (152, '!Y90laAxJQN7wz5mUjgg47HGSemEKqMOcCAKRsWzX', NULL, 0, '202307070401', '张正元', '', '', 0, 1, '2026-01-08 09:47:44.652372', 'student', '202307070401', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (153, '!y2RtP9FkWRZMKNjz8lfEPZKG28NfdLEfdvaqQwWM', NULL, 0, '202307070405', '胡小鹏', '', '', 0, 1, '2026-01-08 09:47:44.664058', 'student', '202307070405', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (154, '!FsshtnMLctgThgLN2aLz6tXyeyQJ3iogPMeH1uUD', NULL, 0, '202307070410', '李浩扬', '', '', 0, 1, '2026-01-08 09:47:44.673658', 'student', '202307070410', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (155, '!FZ3VMAJP7yFSegD6vmZw6pBrdtDrE25ZkuEXm5pz', NULL, 0, '202307070424', '邹伟', '', '', 0, 1, '2026-01-08 09:47:44.686474', 'student', '202307070424', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (156, '!Gr0YeMGlFAUG0tL8ogvn4VfhLjYB9m5CRGWRDHgz', NULL, 0, '202307070502', '闫策', '', '', 0, 1, '2026-01-08 09:47:44.697887', 'student', '202307070502', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (157, '!xXJhQBqVrpV6xlNVAQXk3DqB29oZvuiPy5hDiorC', NULL, 0, '202307070504', '郑芯蕊', '', '', 0, 1, '2026-01-08 09:47:44.709521', 'student', '202307070504', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (158, '!Ogjt4U9N3Y7hXLuOG7xEtOhuXNt72pMGsBhXItbo', NULL, 0, '202307070506', '吕文豪', '', '', 0, 1, '2026-01-08 09:47:44.719454', 'student', '202307070506', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (159, '!ctq7xjrhFOCqpUxhvlWCWYYqB7EGNDlM4ILLTdrK', NULL, 0, '202307070507', '成家远', '', '', 0, 1, '2026-01-08 09:47:44.729873', 'student', '202307070507', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (160, '!gpOJBOlA3G49lbE0Vc4reSmgOlYAkJnlJfKoUiJ9', NULL, 0, '202307070508', '谢秦勇', '', '', 0, 1, '2026-01-08 09:47:44.742464', 'student', '202307070508', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (161, '!4juXn7yz9z68bvzcErtyLgglVrdfEzThFzE1eT2k', NULL, 0, '202307070515', '许凡吉', '', '', 0, 1, '2026-01-08 09:47:44.757431', 'student', '202307070515', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (162, '!Zsj6NIJmaGnSMuKqQHgZneOt3MEPlXaw4qNtUCme', NULL, 0, '202307070519', '段雪婷', '', '', 0, 1, '2026-01-08 09:47:44.770271', 'student', '202307070519', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (163, '!nYGCxm3rlim5aZfidrII3vgxVlCepfWRAtCaVKYd', NULL, 0, '202307070524', '刘文文', '', '', 0, 1, '2026-01-08 09:47:44.783625', 'student', '202307070524', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (164, '!ZMxMnqnDZJrIjkjp44JsrEE46usjlmifZnrNh9XH', NULL, 0, '202307070605', '金涵宇', '', '', 0, 1, '2026-01-08 09:47:44.795832', 'student', '202307070605', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (165, '!kKyOOpKiPVBcMwf9X4mY1QjwyFr60q5TtC8rPqLP', NULL, 0, '202307070606', '陈馨宁', '', '', 0, 1, '2026-01-08 09:47:44.806344', 'student', '202307070606', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (166, '!1zMNQRAcC1tEPmn2fUUTH1jKX3FPMUPBBvlmdnrB', NULL, 0, '202307070607', '王俊明', '', '', 0, 1, '2026-01-08 09:47:44.819943', 'student', '202307070607', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (167, '!cMgFL7t1xxhkU2BXNkIUY1oLDyBpzPyjCJQAwwas', NULL, 0, '202307070615', '陈怡文', '', '', 0, 1, '2026-01-08 09:47:44.833161', 'student', '202307070615', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (168, '!kAvdAASnGcSJeciIrkVEDGNyumHPX9vKdCQGli3s', NULL, 0, '202307070618', '董吉婷', '', '', 0, 1, '2026-01-08 09:47:44.847335', 'student', '202307070618', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (169, '!QhrATcCukOpYfOH9x0debpBEirWJMXZRqt9ET8D2', NULL, 0, '202307070619', '王嫘', '', '', 0, 1, '2026-01-08 09:47:44.856970', 'student', '202307070619', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (170, '!4SL8gtw1N5amNqfMHX7ChzQkFjvGu9cml1Uie3CO', NULL, 0, '202307070701', '闫晓博', '', '', 0, 1, '2026-01-08 09:47:44.869471', 'student', '202307070701', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (171, '!xOWGOFNUWWap6KrLTwV0xpUeBJ80LuJ5nfp0m3RA', NULL, 0, '202307070704', '苏菲娅', '', '', 0, 1, '2026-01-08 09:47:44.882160', 'student', '202307070704', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (172, '!fswysjHoZK6UHBI33vyg5mwp5OZci0xJ0ziJuuZL', NULL, 0, '202307070710', '袁婧涵', '', '', 0, 1, '2026-01-08 09:47:44.894969', 'student', '202307070710', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (173, '!uiY5ogr9CcBtH5wxj2eQQIqT1Ul9FlVglhqJCJaR', NULL, 0, '202307070724', '杨洋', '', '', 0, 1, '2026-01-08 09:47:44.905609', 'student', '202307070724', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (174, '!avQsJcZYAmZQQ1d1eNFuVDWVgQdpD6c6PUZtuZV5', NULL, 0, '202307070804', '陈小雨', '', '', 0, 1, '2026-01-08 09:47:44.922436', 'student', '202307070804', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (175, '!9uJGADgpgsVN2D78OLiP9pGUe5aT2BrbPfmVeKrG', NULL, 0, '202307070809', '王佳琦', '', '', 0, 1, '2026-01-08 09:47:44.935134', 'student', '202307070809', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (176, '!Ae3H8ggGtjN101JpEusj00GCmoS052KVdaNXM89s', NULL, 0, '202307070913', '张健岗', '', '', 0, 1, '2026-01-08 09:47:44.949882', 'student', '202307070913', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (177, '!w5kqMUdQrymuwvx25JHIvaYeqFZPg9fVbN04TVOP', NULL, 0, '202307071203', '李睿萦', '', '', 0, 1, '2026-01-08 09:47:44.963162', 'student', '202307071203', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (178, '!xJ0J3emcqCXpxFpSYaq5qfhqgZRNHQHTfsWIvypg', NULL, 0, 'BS2307070611', '陈昱池', '', '', 0, 1, '2026-01-08 09:47:44.975735', 'student', 'BS2307070611', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (179, '!fKTzvqmxEfV869tNmt3Fh5FkZblp5TWiRDlWeZIO', NULL, 0, '202307070101', '朱永琪', '', '', 0, 1, '2026-01-08 09:48:29.963033', 'student', '202307070101', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (180, '!xrNZ2fLWI1CkQNaWqyWVLHNt8HROs3r0rq9oRXLy', NULL, 0, '202307070102', '宫奎璋', '', '', 0, 1, '2026-01-08 09:48:29.976825', 'student', '202307070102', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (181, '!FoOVy3Fs4GFI7MutxNZFUdSo64PPrDwKkWYAwnbE', NULL, 0, '202307070107', '徐乐乐', '', '', 0, 1, '2026-01-08 09:48:29.988476', 'student', '202307070107', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (182, '!3UM5AfIu1ekvrl9XZepuwoKNl8GWH5dY7skANUrn', NULL, 0, '202307070109', '刘俊杰', '', '', 0, 1, '2026-01-08 09:48:30.001777', 'student', '202307070109', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (183, '!DRCwNCdzU4PTEZ4Rn1ZrtoiaLZUS0ya6IZf8N1jG', NULL, 0, '202307070110', '张欣钰', '', '', 0, 1, '2026-01-08 09:48:30.014523', 'student', '202307070110', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (184, '!hNIGo6D7PXmgRUqgMqEFapzqWUOGhTqPN4olWTmm', NULL, 0, '202307070115', '苟斯涵', '', '', 0, 1, '2026-01-08 09:48:30.027502', 'student', '202307070115', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (185, '!Jy3gOHqlZUxl4stUg7yUN8mUVxQLjrg7w4hHt698', NULL, 0, '202307070118', '段欣欣', '', '', 0, 1, '2026-01-08 09:48:30.041577', 'student', '202307070118', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (186, '!HKa177wTtcVqYzw6NyS5A7OymHgaNLKvqU6MJbXZ', NULL, 0, '202307070120', '杨宇涵', '', '', 0, 1, '2026-01-08 09:48:30.054666', 'student', '202307070120', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (187, '!LD7qKepGW6x8KminTRaIuegnwVP0xdaqNcWqTwAN', NULL, 0, '202307070123', '谢佳伟', '', '', 0, 1, '2026-01-08 09:48:30.068088', 'student', '202307070123', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (188, '!PD2ek0FrAHm7QhNKYruHZkC3Xcw7snEIqhQIYr7o', NULL, 0, '202307070201', '朱致言', '', '', 0, 1, '2026-01-08 09:48:30.081893', 'student', '202307070201', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (189, '!28cCbDnVLchsqpqvys9XfUKiqLoY7vw62mv8CiID', NULL, 0, '202307070215', '冯亦涵', '', '', 0, 1, '2026-01-08 09:48:30.096712', 'student', '202307070215', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (190, '!gmGxxasfqLpAxTpHoA9VLhUGhZqK3KloxiRKKOvL', NULL, 0, '202307070305', '张博雄', '', '', 0, 1, '2026-01-08 09:48:30.110588', 'student', '202307070305', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (191, '!LFUdmzKGppc5W60INwjhN1GYPH0wPJznKM4DNFQc', NULL, 0, '202307070309', '吴雨霏', '', '', 0, 1, '2026-01-08 09:48:30.123320', 'student', '202307070309', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (192, '!3275C95KfHqBQuqTNFtZZ5DRsw7FOOfd6QMj06vm', NULL, 0, '202307070311', '杨继云', '', '', 0, 1, '2026-01-08 09:48:30.136479', 'student', '202307070311', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (193, '!LX2cPJFZvcxI9PWvvXUwfIWlwkjb4wWaZiKtSFzs', NULL, 0, '202307070316', '刘泽宇', '', '', 0, 1, '2026-01-08 09:48:30.149162', 'student', '202307070316', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (194, '!IoAbFaZq0IS8GhhWCv3BxlsB13WKF7FIhLaBHL3p', NULL, 0, '202307070624', '张丹丹', '', '', 0, 1, '2026-01-08 09:48:30.161787', 'student', '202307070624', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (195, '!gZvmwhJ6JZd3faVfLSQC6124NZ8SfDUhXoda3Jkv', NULL, 0, '202307070801', '袁鑫博', '', '', 0, 1, '2026-01-08 09:48:30.173282', 'student', '202307070801', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (196, '!uzI8vCVVANmChGEIsERFX5oJD5jlG2xWMCBT9WXW', NULL, 0, '202307070803', '姚龙飞', '', '', 0, 1, '2026-01-08 09:48:30.185806', 'student', '202307070803', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (197, '!awJdvJWhSxB3WR1TnCSQ4wuuPEpg65IvJagZSnzQ', NULL, 0, '202307070807', '李鑫', '', '', 0, 1, '2026-01-08 09:48:30.199065', 'student', '202307070807', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (198, '!2WwBhhEn9hJDPMIu59qfWnUwHkQZvCCMZGdh7ep4', NULL, 0, '202307070812', '张悦', '', '', 0, 1, '2026-01-08 09:48:30.210827', 'student', '202307070812', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (199, '!KuMQjU3GhK4WFtNZhJiJ7CWsr7kAhrUHwYzk4y00', NULL, 0, '202307070815', '王伊浩', '', '', 0, 1, '2026-01-08 09:48:30.223439', 'student', '202307070815', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (200, '!eCCYcdMRSL3nSOnaDX8DmsyD5UperjzQQ7MP70gb', NULL, 0, '202307070822', '张子林', '', '', 0, 1, '2026-01-08 09:48:30.236232', 'student', '202307070822', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (201, '!yY5Oqa2scUpRRDptucxKTr8YwkLp5O4uZ6YhCwTU', NULL, 0, '202307070826', '李兴祎', '', '', 0, 1, '2026-01-08 09:48:30.247926', 'student', '202307070826', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (202, '!vuaXAuhhfrKiwGqi9ZY1PPLRudGd19vwRJGudJiO', NULL, 0, '202307071103', '贾德政', '', '', 0, 1, '2026-01-08 09:48:30.261361', 'student', '202307071103', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (203, '!MSJIHr0DD4GTaES0ysV7hq4R3Nf7sSp8ZnVjzKqc', NULL, 0, '202307071119', '向梦璐', '', '', 0, 1, '2026-01-08 09:48:30.271923', 'student', '202307071119', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (204, '!6G7O4FwnyuRKU7XWPv54z8VY08tx3QfC3KlaFgRu', NULL, 0, '202307071204', '戴紫云', '', '', 0, 1, '2026-01-08 09:48:30.283203', 'student', '202307071204', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (205, '!nu7ajLN1C5WgPB3lR3JsOTP4LDEs57XNsefPY1el', NULL, 0, '202307071207', '沈长婷', '', '', 0, 1, '2026-01-08 09:48:30.295170', 'student', '202307071207', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (206, '!gtccnYjR9SO0Anz4dmI1xSafB4FksJMgLiwEktT5', NULL, 0, '202307071217', '吴宇轩', '', '', 0, 1, '2026-01-08 09:48:30.307901', 'student', '202307071217', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (207, '!BtwaWR7usRVGV5fufvnVPvAj3h2yqL4RoiQX6k8w', NULL, 0, '202207020110', '黄皓轩', '', '', 0, 1, '2026-01-08 09:56:11.579156', 'student', '202207020110', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (208, '!yDql6klvJwjELcRfi54lCx7q5Cnx7WMivcmrc6WW', NULL, 0, '202307070117', '唐景前', '', '', 0, 1, '2026-01-08 09:56:11.594259', 'student', '202307070117', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (209, '!iEVS8Z4sWp7BUxDhS5SlYk8jvtkHC5HWLpjwnKJ5', NULL, 0, '202307070205', '段玉珍', '', '', 0, 1, '2026-01-08 09:56:11.606409', 'student', '202307070205', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (210, '!f6E0UEMWzTwT5KV6CN4tcHrDTmPCgzeBVTeZSN9A', NULL, 0, '202307070212', '毛博学', '', '', 0, 1, '2026-01-08 09:56:11.617414', 'student', '202307070212', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (211, '!B3TCVFg6p82WNtOU498DNQsInRL9WuWqgrr4TzBi', NULL, 0, '202307070518', '李佳乐', '', '', 0, 1, '2026-01-08 09:56:11.629061', 'student', '202307070518', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (212, '!qfi9NO2jVKAGqwKJZEDggOAW72ahHiHJln3IjrAv', NULL, 0, '202307070902', '陈千寻', '', '', 0, 1, '2026-01-08 09:56:11.640542', 'student', '202307070902', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (213, '!rFAGM5IWrsDXMpgrHSXl8Iq93CBAPkz95Do1Hm0p', NULL, 0, '202307070903', '许韫', '', '', 0, 1, '2026-01-08 09:56:11.652396', 'student', '202307070903', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (214, '!5xJSdG937RolU9ZqI2lQ9S10KPJFSXywZt4KNpo9', NULL, 0, '202307070905', '文湘', '', '', 0, 1, '2026-01-08 09:56:11.677847', 'student', '202307070905', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (215, '!DOBuHPwQLp2ZYjmN0onYPKe95XGc3ePs9lSmXF2T', NULL, 0, '202307070906', '冷飞', '', '', 0, 1, '2026-01-08 09:56:11.689422', 'student', '202307070906', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (216, '!XvDWIzJjldS0YwpG7tTyahY6iz69TlULIJqAvtT8', NULL, 0, '202307070911', '张煜科', '', '', 0, 1, '2026-01-08 09:56:11.701861', 'student', '202307070911', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (217, '!POkq9wDWWeKLNsQqxUKmjPHn2dOrVHBhzZeFWuUH', NULL, 0, '202307070912', '王俊弛', '', '', 0, 1, '2026-01-08 09:56:11.714523', 'student', '202307070912', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (218, '!0SkmXlEPs21FJIZDhDH0hDD6wYoJ12xEB1SSoi5v', NULL, 0, '202307070919', '李慧', '', '', 0, 1, '2026-01-08 09:56:11.727623', 'student', '202307070919', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (219, '!NNFocjQKkfARko0t1ra6OAtS6qPZF0JIvV5Zk4zL', NULL, 0, '202307070922', '曹章阳', '', '', 0, 1, '2026-01-08 09:56:11.738158', 'student', '202307070922', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (220, '!hsk5oPkVPqzqU4ItefOQe9grjGZbZ7dzM5HTBIdD', NULL, 0, '202307070926', '马成', '', '', 0, 1, '2026-01-08 09:56:11.750843', 'student', '202307070926', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (221, '!W8nGp2dZfocCR1Jz4wHq0l62EN5hWcKuoE1f9tA1', NULL, 0, '202307071010', '孙一凡', '', '', 0, 1, '2026-01-08 09:56:11.761177', 'student', '202307071010', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (222, '!EvPbYNf3MBhNfu5qJYS1BfWVgNsJV4bYFY4dTcNe', NULL, 0, '202307071014', '向李楠', '', '', 0, 1, '2026-01-08 09:56:11.773760', 'student', '202307071014', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (223, '!qqHdagokxmGKa3v9paslsOJF2fAlgnPUsUZcCfvM', NULL, 0, '202307071015', '席瑞', '', '', 0, 1, '2026-01-08 09:56:11.785197', 'student', '202307071015', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (224, '!UdQi4hsKZO0HrPnNbUtLYlYyu91owf6mGQ61MlDp', NULL, 0, '202307071016', '井文超', '', '', 0, 1, '2026-01-08 09:56:11.797961', 'student', '202307071016', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (225, '!4hHY3nXocFGx2sqcUJjrwfs7UDNlEZOgOHQEasF8', NULL, 0, '202307071019', '李金泽', '', '', 0, 1, '2026-01-08 09:56:11.808077', 'student', '202307071019', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (226, '!jJ2uUAXszNtpgN0Fuuu3VBKZXTowHBO1pQapaZ4y', NULL, 0, '202307071021', '徐思鹏', '', '', 0, 1, '2026-01-08 09:56:11.819878', 'student', '202307071021', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (227, '!qJ1ItrIB8Gu8xE2mc38as3lwb5ZAgnAfPIJhTpwk', NULL, 0, '202307071025', '李佳岳', '', '', 0, 1, '2026-01-08 09:56:11.831265', 'student', '202307071025', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (228, '!pPJk4dDALdAZtZikr8HCEbXhT7zuyzlbXDe7CrMy', NULL, 0, '202307071026', '闫恒宇', '', '', 0, 1, '2026-01-08 09:56:11.844146', 'student', '202307071026', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (229, '!i4HdJl9Qm35rz1G4XbNoW79UnKTIPPSpJeCtv0iv', NULL, 0, '202307071112', '刘紫悦', '', '', 0, 1, '2026-01-08 09:56:11.858212', 'student', '202307071112', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (230, '!w818B0hhBF0MSehgrKVjUrABxJUXzi7WHeQs4Xfg', NULL, 0, '202307071114', '吴天昊', '', '', 0, 1, '2026-01-08 09:56:11.869600', 'student', '202307071114', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (231, '!55sERi7CArJ1gp5K2Cpfb93xTBrLA6mgiBkABxzI', NULL, 0, '202307071122', '孔令德', '', '', 0, 1, '2026-01-08 09:56:11.881216', 'student', '202307071122', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (232, '!Qjwvg3dUSHTjC93BcP42tkZ5UmMWYepJ0j3oc3Zh', NULL, 0, '202307071215', '董翔', '', '', 0, 1, '2026-01-08 09:56:11.892936', 'student', '202307071215', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (233, '!42JUEHASv2JOM6ynskYpsrP1fqmp2BHp84LIUcAm', NULL, 0, 'BS2307070423', '赵新宇', '', '', 0, 1, '2026-01-08 09:56:11.903406', 'student', 'BS2307070423', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (234, '!1JOGsPiWjJLAdZF9FeX16clHva9EUooBLjpDGiNz', NULL, 0, 'BS2307070520', '陈浩', '', '', 0, 1, '2026-01-08 09:56:11.916351', 'student', 'BS2307070520', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (235, '!UaTOYnGOx3wOBcHfD4gP4x7WnkiKeIhiRygqho9r', NULL, 0, 'BS2307071225', '叶泽', '', '', 0, 1, '2026-01-08 09:56:11.928231', 'student', 'BS2307071225', NULL, NULL, '', 0, NULL, 0);
INSERT INTO `users_user` VALUES (236, 'pbkdf2_sha256$1000000$UieQay9Jlz74n1VbU6M1ua$3YnFLTl0QV7Za5zaxyhOgoaa8Darx8JwOAeuJQyLAq4=', NULL, 0, 'ceshi', '', '', '', 0, 1, '2026-01-11 06:57:30.265476', 'teacher', NULL, NULL, NULL, '', 0, '127.0.0.1', 2);

-- ----------------------------
-- Table structure for users_user_groups
-- ----------------------------
DROP TABLE IF EXISTS `users_user_groups`;
CREATE TABLE `users_user_groups`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `users_user_groups_user_id_group_id_b88eab82_uniq`(`user_id` ASC, `group_id` ASC) USING BTREE,
  INDEX `users_user_groups_group_id_9afc8d0e_fk_auth_group_id`(`group_id` ASC) USING BTREE,
  CONSTRAINT `users_user_groups_group_id_9afc8d0e_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `users_user_groups_user_id_5f6f5a90_fk_users_user_id` FOREIGN KEY (`user_id`) REFERENCES `users_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users_user_groups
-- ----------------------------

-- ----------------------------
-- Table structure for users_user_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `users_user_user_permissions`;
CREATE TABLE `users_user_user_permissions`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `users_user_user_permissions_user_id_permission_id_43338c45_uniq`(`user_id` ASC, `permission_id` ASC) USING BTREE,
  INDEX `users_user_user_perm_permission_id_0b93982e_fk_auth_perm`(`permission_id` ASC) USING BTREE,
  CONSTRAINT `users_user_user_perm_permission_id_0b93982e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `users_user_user_permissions_user_id_20aca447_fk_users_user_id` FOREIGN KEY (`user_id`) REFERENCES `users_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users_user_user_permissions
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
