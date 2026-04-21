📊 学生成绩数据化分析管理系统
Student Performance Digital Analysis & Management System
📖 项目简介这是一套 ✨ 前后端分离 的高校成绩管理平台，基于 Python + Django + Vue3 开发，实现成绩从录入、计算、管理到分析、可视化的全流程数字化解决方案。
🎯 核心定位一站式闭环全流程：🟢 成绩录入 → 🟡 智能计算 → 🔵 统一管理 → 🟣 多维分析 → 🟠 报表导出
⚡ 核心功能
👥 多角色分级权限：管理员 / 教师 / 学生
🏫 课程、班级、师生信息一体化全局管理
📥 Excel 批量成绩导入，智能字段识别
⚙️ 自定义评分公式，自动核算平时 / 期末 / 总成绩
📈 成绩分布统计、班级横向对比、历史趋势分析
🎯 课程目标达成度自动计算 + 可视化图表展示
📄 成绩报告一键生成、导出、在线打印
🛠️ 技术栈🔧 后端Python Django DRF JWT Redis Celery MySQL
🎨 前端Vue3 Element Plus ECharts
📊 数据处理Pandas NumPy Excel解析
✨ 项目亮点
🧩 前后端解耦架构，快速迭代、轻松部署扩容
🔐 完善权限体系，数据隔离、安全可靠
🚀 Redis 缓存 + Celery 异步任务，系统高性能高并发
📉 丰富可视化数据分析图表，教学质量直观呈现
🏫 深度贴合高校教务场景，开箱即可投入使用
🚀 安装与运行后端启动
进入后端目录cd backend
安装依赖pip install -r requirements.txt
配置数据库（MySQL）修改 config/settings.py 中的数据库信息
执行迁移python manage.py makemigrationspython manage.py migrate
创建超级管理员python manage.py createsuperuser
启动服务python manage.py runserver
前端启动
进入前端目录cd frontend
安装依赖npm install
启动项目npm run serve
💡 项目总结高效智能、数据驱动、灵活可配置的高校成绩全流程管理与教学质量智能分析系统。