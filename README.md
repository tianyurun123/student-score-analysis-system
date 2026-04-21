# 学生成绩数据化分析管理系统
Student Performance Digital Analysis & Management System

## 项目简介
本项目是一套前后端分离的高校成绩管理平台，基于 Python + Django + Vue3 开发，实现成绩从录入、计算、管理到分析、可视化的全流程数字化解决方案。

## 核心定位
一站式解决：成绩录入 → 计算 → 管理 → 分析 → 报表导出

## 核心功能
- 多角色权限管理：管理员、教师、学生
- 课程、班级、教师、学生信息管理
- Excel 批量成绩导入与自动字段识别
- 自定义成绩公式，自动计算平时成绩、期末成绩、总成绩
- 成绩分布、班级对比、趋势分析
- 课程目标达成度计算与可视化展示
- 成绩报告生成、导出、打印

## 技术栈
### 后端
Python, Django, Django REST Framework, JWT, Redis, Celery, MySQL

### 前端
Vue3, Element Plus, ECharts

### 数据处理
Pandas, NumPy, Excel 解析

## 项目亮点
- 前后端分离架构，易于扩展与部署
- 多角色权限控制，安全可靠
- Redis 缓存与异步任务提升系统性能
- 数据可视化展示，直观呈现教学质量
- 贴合高校教务场景，可直接部署使用

## 安装与运行

### 后端启动
cd backend
pip install -r requirements.txt
python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver

### 前端启动
cd frontend
npm install
npm run serve

## 项目总结
高效、数据驱动、可配置的高校成绩全流程管理与智能分析系统。
