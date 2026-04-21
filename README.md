# 学生成绩管理与分析系统

## 项目简介

这是一个基于 Django + Vue 3 的大学生成绩管理与分析系统，支持教学大纲解析、Excel成绩导入、动态成绩计算、数据分析和报告打印等功能。

## 技术栈

### 后端
- Django 5.2.5
- Django REST Framework
- MySQL
- JWT 认证
- Celery (异步任务)
- pandas (数据处理)
- openpyxl (Excel处理)
- pdfplumber (PDF解析)
- python-docx (Word解析)

### 前端
- Vue 3
- Element Plus
- Pinia (状态管理)
- Vue Router
- Axios
- ECharts (数据可视化)
- XLSX (Excel处理)

## 核心功能

### 1. 用户认证系统
- 支持教师、学生、管理员等多种角色
- JWT Token 认证
- 权限控制

### 2. 教学大纲管理
- 支持上传 PDF、Word 格式的教学大纲
- 自动解析课程信息和成绩评定方式
- 根据大纲内容建议需要的成绩字段

### 3. 课程管理
- 创建和管理课程
- 设置课程基本信息（代码、名称、学分、学时等）
- 管理课程班级
- 配置评分政策（平时分、期末分比例）

### 4. Excel成绩导入
- 支持 Excel 文件导入
- 自动识别学生信息（学号、姓名、班级）
- 自动识别成绩列（考勤、作业、实验、笔记、期末等）
- 支持动态字段识别（如：电子笔记、作品、报告等）
- 数据预览和验证
- 批量导入成绩

### 5. 成绩计算
- 支持自定义计算公式
  - 平时成绩公式：如 `(点名*0.05+电子笔记*0.05+作业成绩*0.1)/0.2`
  - 期末成绩公式：如 `(作品+报告)/2`
- 自动计算最终成绩、绩点和等级
- 支持不同课程的评分政策

### 6. 成绩管理
- 成绩列表展示
- 成绩编辑和修改
- 成绩发布/取消发布
- 成绩导出为 Excel

### 7. 数据分析
- 课程成绩统计（平均分、最高分、最低分、及格率等）
- 成绩分布分析
- 班级对比分析
- 学生成绩趋势分析
- 成绩构成分析
- 数据可视化图表

### 8. 报告打印
- 课程成绩报告
- 学生成绩单
- 支持打印预览
- HTML格式报告

### 9. 学生管理
- 学生信息录入
- 批量导入学生
- 学生选课管理

### 10. 班级管理
- 创建和管理班级
- 添加学生到班级
- 班级统计信息

## 项目结构

```
score_analysis/
├── backend/                 # Django 后端
│   ├── apps/
│   │   ├── users/          # 用户管理
│   │   ├── courses/        # 课程管理
│   │   ├── scores/         # 成绩管理
│   │   ├── analysis/       # 数据分析
│   │   ├── reports/        # 报告生成
│   │   └── common/         # 公共功能
│   ├── config/             # 项目配置
│   ├── utils/              # 工具类
│   │   ├── calculator.py   # 成绩计算器
│   │   ├── excel_parser.py # Excel解析
│   │   ├── syllabus_parser.py # 大纲解析
│   │   └── file_handler.py # 文件处理
│   └── requirements.txt    # 依赖包
├── frontend/               # Vue 前端
│   ├── src/
│   │   ├── api/            # API接口
│   │   ├── components/     # 组件
│   │   ├── views/          # 页面
│   │   ├── stores/         # 状态管理
│   │   ├── router/         # 路由
│   │   └── utils/          # 工具函数
│   └── package.json
└── README.md
```

## 安装和运行

### 后端设置

1. 安装依赖：
```bash
cd backend
pip install -r requirements.txt
```

2. 配置数据库：
编辑 `backend/config/settings.py`，修改数据库配置：
```python
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.mysql",
        "NAME": "student-scores",
        "USER": "root",
        "PASSWORD": "your_password",
        "HOST": "localhost",
        "PORT": "3306",
    }
}
```

3. 运行迁移：
```bash
python manage.py makemigrations
python manage.py migrate
```

4. 创建超级用户：
```bash
python manage.py createsuperuser
```

5. 运行开发服务器：
```bash
python manage.py runserver
```

### 前端设置

1. 安装依赖：
```bash
cd frontend
npm install
```

2. 运行开发服务器：
```bash
npm run serve
```

3. 构建生产版本：
```bash
npm run build
```

## 使用说明

### 1. 登录系统
- 访问 `http://localhost:8080`
- 使用教师账号登录

### 2. 创建课程
- 进入"课程管理"
- 点击"新建课程"
- 填写课程信息
- 上传教学大纲（可选）

### 3. 上传教学大纲
- 在课程详情页点击"上传大纲"
- 选择 PDF 或 Word 文件
- 系统自动解析并提取成绩评定信息

### 4. 导入成绩
- 进入"成绩管理" -> "导入成绩"
- 选择课程班级
- 上传 Excel 文件
- 预览数据
- 确认导入

### 5. Excel 文件格式要求

Excel 文件应包含以下列（列名支持多种命名方式）：
- 学号（必填）：学号、student_id、id
- 姓名（必填）：姓名、name、student_name
- 班级（可选）：班级、class、class_name
- 成绩列（可选）：
  - 考勤：考勤、attendance、点名
  - 作业：作业、homework、作业成绩
  - 实验：实验、experiment、实验成绩
  - 笔记：复习笔记、review、笔记
  - 期末：期末、final、期末成绩
  - 其他：电子笔记、作品、报告等（自动识别）

### 6. 设置计算公式

在课程评分政策中，可以设置自定义公式：

**平时成绩公式示例：**
```
(点名*0.05+电子笔记*0.05+作业成绩*0.1)/0.2
```

**期末成绩公式示例：**
```
(作品+报告)/2
```

### 7. 查看分析报告
- 进入"数据分析"
- 选择课程或班级
- 查看统计信息和图表

### 8. 打印报告
- 进入"报告打印"
- 选择课程班级
- 点击"打印报告"
- 在浏览器中打印

## 功能补充建议

除了已实现的功能，还可以考虑添加：

1. **成绩申诉功能**
   - 学生可以提交成绩申诉
   - 教师审核和处理申诉

2. **成绩预警**
   - 自动识别低分学生
   - 发送预警通知

3. **成绩趋势分析**
   - 多学期成绩对比
   - 成绩变化趋势图

4. **批量操作**
   - 批量发布成绩
   - 批量修改成绩

5. **数据备份和恢复**
   - 定期备份数据
   - 数据恢复功能

6. **消息通知**
   - 成绩发布通知
   - 系统消息推送

7. **移动端支持**
   - 响应式设计优化
   - 移动端适配

8. **成绩排名**
   - 班级排名
   - 课程排名
   - 综合排名

9. **成绩统计报表**
   - 多维度统计
   - 自定义报表

10. **权限细化**
    - 更细粒度的权限控制
    - 角色权限管理

## API 文档

访问 `http://localhost:8000/swagger/` 查看完整的 API 文档。

## 开发说明

### 代码规范
- 后端遵循 PEP 8 规范
- 前端遵循 ESLint 规范
- 使用中文注释

### 数据库设计
- 使用 MySQL 数据库
- 支持事务处理
- 索引优化

### 安全考虑
- JWT Token 认证
- 密码加密存储
- SQL 注入防护
- XSS 防护
- CSRF 防护

## 许可证

MIT License

## 联系方式

如有问题或建议，请联系开发团队。

