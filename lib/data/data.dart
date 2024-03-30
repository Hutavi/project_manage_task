import 'package:flutter/material.dart';

import '../constants/color.dart';
import '../constants/image_assets.dart';

List<Map<String, String>> quickCreateList = [
  {
    'icon': 'lib/assets/images/home_page/bottom_dialog/project_icon.png',
    'title': 'Dự án',
    'route_name': '/createProject'
  },
  {
    'icon': 'lib/assets/images/home_page/bottom_dialog/task_icon.png',
    'title': 'Tác vụ',
    'route_name': '/createProjectTask'
  },
  {
    'icon': 'lib/assets/images/home_page/bottom_dialog/todo_list_icon.png',
    'title': 'To do list',
    'route_name': '/addPersonalTask'
  },
  {
    'icon': 'lib/assets/images/home_page/bottom_dialog/category_icon.png',
    'title': 'Hạng mục',
    'route_name': '/createProjectCategory'
  },
  {
    'icon': 'lib/assets/images/home_page/bottom_dialog/off_date_icon.png',
    'title': 'Nghỉ phép',
    'route_name': '/createLeaving'
  },
  {
    'icon': 'lib/assets/images/home_page/bottom_dialog/report_icon.png',
    'title': 'Báo cáo CV',
    'route_name': '/creatReportPage'
  }
];

List<Map<String, String>> projectList = [
  {
    'name': 'Dự án phát triển phần mềm',
    'finishPlanDate': '23/4/2023',
    'member-quantity': '24',
    'task-done': '30/50',
    'startDate': '25/4/2023',
    'finishDate': '26/4/2023',
    'state': 'Trễ hạn',
    'progress': '90',
    'type': "Customize",
    'description': "Mô tả của đồ án phát triển phần mềm",
    'assign': '["Bùi Quang Thành", "Đinh Nguyễn Duy Khang"]'
  },
  {
    'name': 'Dự án quản lí nhân viên',
    'finishPlanDate': '23/4/2023',
    'member-quantity': '24',
    'task-done': '30/50',
    'startDate': '25/4/2023',
    'finishDate': '26/4/2023',
    'state': 'Đang tiến hành',
    'progress': '80',
    'type': "Customize",
    'description': "Mô tả của đồ án phát triển phần mềm",
    'assign': '["Bùi Quang Thành", "Đinh Nguyễn Duy Khang"]'
  },
  {
    'name': 'Dự án quản lí nhân sự',
    'finishPlanDate': '23/4/2023',
    'member-quantity': '24',
    'task-done': '30/50',
    'startDate': '25/4/2023',
    'finishDate': '26/4/2023',
    'state': 'Đang tiến hành',
    'progress': '80',
    'type': "Customize",
    'description': "Mô tả của đồ án phát triển phần mềm",
    'assign': '["Bùi Quang Thành", "Đinh Nguyễn Duy Khang"]'
  },
  {
    'name': 'Dự án phát triển phần mềm',
    'finishPlanDate': '23/4/2023',
    'member-quantity': '24',
    'task-done': '0/50',
    'state': 'Kế hoạch',
    'startDate': '25/4/2023',
    'finishDate': '26/4/2023',
    'progress': '0',
    'type': "Customize",
    'description': "Mô tả của đồ án phát triển phần mềm",
    'assign': '["Bùi Quang Thành", "Đinh Nguyễn Duy Khang"]'
  },
  {
    'name': 'Dự án phát triển ứng dụng',
    'finishPlanDate': '23/4/2023',
    'member-quantity': '24',
    'task-done': '0/50',
    'startDate': '25/4/2023',
    'finishDate': '26/4/2023',
    'state': 'Kế hoạch',
    'progress': '0',
    'type': "Customize",
    'description': "Mô tả của đồ án phát triển phần mềm",
    'assign': '["Bùi Quang Thành", "Đinh Nguyễn Duy Khang"]'
  },
  {
    'name': 'Dự án phát triển phần mềm',
    'finishPlanDate': '23/4/2023',
    'member-quantity': '24',
    'task-done': '30/50',
    'startDate': '25/4/2023',
    'finishDate': '26/4/2023',
    'state': 'Trễ hạn',
    'progress': '90',
    'type': "Customize",
    'description': "Mô tả của đồ án phát triển phần mềm",
    'assign': '["Bùi Quang Thành", "Đinh Nguyễn Duy Khang"]'
  },
  {
    'name': 'Dự án phát triển phần mềm',
    'finishPlanDate': '23/4/2023',
    'startDate': '25/4/2023',
    'finishDate': '26/4/2023',
    'member-quantity': '24',
    'task-done': '0/50',
    'state': 'Hoàn thành',
    'progress': '100',
    'type': "Customize",
    'description': "Mô tả của đồ án phát triển phần mềm",
    'assign': '["Bùi Quang Thành", "Đinh Nguyễn Duy Khang"]'
  },
  {
    'name': 'Dự án phát triển ứng dụng',
    'finishPlanDate': '23/4/2023',
    'member-quantity': '24',
    'task-done': '0/50',
    'startDate': '25/4/2023',
    'finishDate': '26/4/2023',
    'state': 'Hoàn thành',
    'progress': '100',
    'type': "Customize",
    'description': "Mô tả của đồ án phát triển phần mềm",
    'assign': '["Bùi Quang Thành", "Đinh Nguyễn Duy Khang"]'
  },
];

List<Map<String, String>> taskList = [
  {
    'task-name': 'Lên kết hoạch thiết kế cơ sở dữ liệu',
    'project': 'Dự án LiveSpo',
    'startDay': '10/4/2022',
    'finishDay': '21/04/2002',
    'startPlanDay': "21/05/2022",
    'finishPlanDay': "20/05/2022",
    'progress': "20",
    'priority': 'Cao',
    'day-lefts': '7',
    'state': 'Đang tiến hành',
    'category': 'Hạng mục 2',
    'assign': '["Bùi Quang Thành", "Đinh Nguyễn Duy Khang"]',
    'description': "Đây là mô tả"
  },
  {
    'task-name': 'Lên kết hoạch thiết kế cơ sở dữ liệu',
    'project': 'Dự án LiveSpo',
    'startDay': '10/4/2022',
    'finishDay': '21/04/2002',
    'startPlanDay': "21/05/2022",
    'finishPlanDay': "20/05/2022",
    'progress': "20",
    'priority': 'Cao',
    'day-lefts': '7',
    'state': 'Kế hoạch',
    'category': 'Hạng mục 2',
    'assign': '["Bùi Quang Thành", "Đinh Nguyễn Duy Khang"]',
    'description': "Đây là mô tả"
  },
  {
    'task-name': 'Lên kết hoạch thiết kế cơ sở dữ liệu',
    'project': 'Dự án LiveSpo',
    'startDay': '10/4/2022',
    'finishDay': '21/04/2002',
    'startPlanDay': "21/05/2022",
    'finishPlanDay': "20/05/2022",
    'progress': "20",
    'priority': 'Cao',
    'day-lefts': '7',
    'state': 'Trễ hạn',
    'category': 'Hạng mục 3',
    'assign': '["Bùi Quang Thành", "Đinh Nguyễn Duy Khang"]',
    'description': "Đây là mô tả"
  },
  {
    'task-name': 'Lên kết hoạch thiết kế cơ sở dữ liệu',
    'project': 'Dự án LiveSpo',
    'startDay': '10/4/2022',
    'finishDay': '21/04/2002',
    'startPlanDay': "21/05/2022",
    'finishPlanDay': "20/05/2022",
    'progress': "20",
    'priority': 'Cao',
    'day-lefts': '7',
    'state': 'Kế hoạch',
    'category': 'Hạng mục 4',
    'assign': '["Bùi Quang Thành", "Đinh Nguyễn Duy Khang"]',
    'description': "Đây là mô tả"
  },
  {
    'task-name': 'Lên kết hoạch thiết kế cơ sở dữ liệu',
    'project': 'Dự án LiveSpo',
    'startDay': '10/4/2022',
    'finishDay': '21/04/2002',
    'startPlanDay': "21/05/2022",
    'finishPlanDay': "20/05/2022",
    'progress': "20",
    'priority': 'Cao',
    'day-lefts': '7',
    'state': 'Trễ hạn',
    'category': 'Hạng mục 5',
    'assign': '["Bùi Quang Thành", "Đinh Nguyễn Duy Khang"]',
    'description': "Đây là mô tả"
  },
  {
    'task-name': 'Lên kết hoạch thiết kế cơ sở dữ liệu',
    'project': 'Dự án LiveSpo',
    'startDay': '10/4/2022',
    'finishDay': '21/04/2002',
    'startPlanDay': "21/05/2022",
    'finishPlanDay': "20/05/2022",
    'progress': "20",
    'priority': 'Cao',
    'day-lefts': '7',
    'state': 'Đang tiến hành',
    'category': 'Hạng mục 6',
    'assign': '["Bùi Quang Thành", "Đinh Nguyễn Duy Khang"]',
    'description': "Đây là mô tả"
  },
  {
    'task-name': 'Lên kết hoạch thiết kế cơ sở dữ liệu',
    'project': 'Dự án LiveSpo',
    'startDay': '10/4/2022',
    'finishDay': '21/04/2002',
    'startPlanDay': "21/05/2022",
    'finishPlanDay': "20/05/2022",
    'progress': "20",
    'priority': 'Cao',
    'day-lefts': '7',
    'state': 'Hoàn thành',
    'category': 'Hạng mục 7',
    'assign': '["Bùi Quang Thành", "Đinh Nguyễn Duy Khang"]',
    'description': "Đây là mô tả"
  },
  {
    'task-name': 'Lên kết hoạch thiết kế cơ sở dữ liệu',
    'project': 'Dự án LiveSpo',
    'startDay': '10/4/2022',
    'finishDay': '21/04/2002',
    'startPlanDay': "21/05/2022",
    'finishPlanDay': "20/05/2022",
    'progress': "20",
    'priority': 'Cao',
    'day-lefts': '7',
    'state': 'Hoàn thành',
    'category': 'Hạng mục 8',
    'assign': '["Bùi Quang Thành", "Đinh Nguyễn Duy Khang"]',
    'description': "Đây là mô tả"
  },
  {
    'task-name': 'Lên kết hoạch thiết kế cơ sở dữ liệu',
    'project': 'Dự án LiveSpo',
    'startDay': '10/4/2022',
    'finishDay': '21/04/2002',
    'startPlanDay': "21/05/2022",
    'finishPlanDay': "20/05/2022",
    'progress': "20",
    'priority': 'Cao',
    'day-lefts': '7',
    'state': 'Kế hoạch',
    'category': 'Hạng mục 9',
    'assign': '["Bùi Quang Thành", "Đinh Nguyễn Duy Khang"]',
    'description': "Đây là mô tả"
  },
  {
    'task-name': 'Lên kết hoạch thiết kế cơ sở dữ liệu',
    'project': 'Dự án LiveSpo',
    'startDay': '10/4/2022',
    'finishDay': '21/04/2002',
    'startPlanDay': "21/05/2022",
    'finishPlanDay': "20/05/2022",
    'progress': "20",
    'priority': 'Cao',
    'day-lefts': '7',
    'state': 'Hoàn thành',
    'category': 'Hạng mục 10',
    'assign': '["Bùi Quang Thành", "Đinh Nguyễn Duy Khang"]',
    'description': "Đây là mô tả"
  },
];

List<Map<String, String>> reportList = [
  {
    'name': 'Báo cáo công việc ngày 23/11/2024',
    'date': '23/11/2023',
    'reporter': 'Đinh Nguyễn Duy Khang',
  },
  {
    'name': 'Báo cáo công việc ngày 23/11/2024',
    'date': '23/11/2023',
    'reporter': 'Đinh Nguyễn Duy Khang',
  },
  {
    'name': 'Báo cáo công việc ngày 23/11/2024',
    'date': '23/11/2023',
    'reporter': 'Đinh Nguyễn Duy Khang',
  },
  {
    'name': 'Báo cáo công việc ngày 23/11/2024',
    'date': '23/11/2023',
    'reporter': 'Đinh Nguyễn Duy Khang',
  },
];

List<Map<String, String>> categoryList = [
  {
    'name': 'Triển khai dự án',
    'project': 'Dự án LivePo',
    'owner': 'Bùi Quang Thành',
    'task-done': '40',
    'progress': '60'
  },
  {
    'name': 'Triển khai dự án',
    'project': 'Dự án LivePo',
    'owner': 'Bùi Quang Thành',
    'task-done': '40',
    'progress': '20'
  },
  {
    'name': 'Triển khai dự án',
    'project': 'Dự án LivePo',
    'owner': 'Bùi Quang Thành',
    'task-done': '40',
    'progress': '40'
  },
  {
    'name': 'Triển khai dự án',
    'project': 'Dự án LivePo',
    'owner': 'Bùi Quang Thành',
    'task-done': '40',
    'progress': '80'
  },
  {
    'name': 'Triển khai dự án',
    'project': 'Dự án LivePo',
    'owner': 'Bùi Quang Thành',
    'task-done': '40',
    'progress': '50'
  },
];

// List<Map<String, String>> LeavingList = [
//   {
//     'name': 'Bùi Quang Thành',
//     'type': 'Nghỉ phép',
//     'date': '26/07/2023',
//     'status': 'Đã duyệt',
//   },
//   {
//     'name': 'Huỳnh Tấn Vinh',
//     'type': 'Nghỉ phép',
//     'date': '26/07/2023',
//     'status': 'Không phê duyệt',
//   },
//   {
//     'name': 'Đinh Nguyên Duy Khang',
//     'type': 'Nghỉ phép',
//     'date': '26/07/2023',
//     'status': 'Đã duyệt',
//   },
//   {
//     'name': 'Nguyễn Quốc Sự',
//     'type': 'Nghỉ thai sản',
//     'date': '26/03/2023',
//     'status': 'Đã duyệt',
//   },
//   {
//     'name': 'Trần Thiên Tường',
//     'type': 'Nghỉ phép',
//     'date': '26/07/2023',
//     'status': 'Không phê duyệt',
//   },
// ];

final List<Map<String, Object>> optionsData = [
  {
    'icon': 'lib/assets/images/home_page/options_dialog/todo_list_icon.png',
    'title': 'To do list',
    'router': '/todolistPage'
  },
  {
    'icon': 'lib/assets/images/home_page/options_dialog/project_icon.png',
    'title': 'Dự án',
    'router': '/listProject'
  },
  {
    'icon': 'lib/assets/images/home_page/options_dialog/category_icon.png',
    'title': 'Hạng mục',
    'router': '/listCatoryProject'
  },
  {
    'icon': 'lib/assets/images/home_page/options_dialog/task_icon.png',
    'title': 'Tác vụ dự án',
    'router': '/listTaskProject'
  },
  {
    'icon': 'lib/assets/images/home_page/options_dialog/report_icon.png',
    'title': 'Báo cáo',
    'router': '/listReport'
  },
  {
    'icon': 'lib/assets/images/home_page/options_dialog/off_date_icon.png',
    'title': 'Nghỉ phép',
    'router': '/listLeaving'
  },
  {
    'icon': 'lib/assets/images/home_page/options_dialog/settings.png',
    'title': 'Cài đặt',
    'router': '/settingPage'
  },
];

const time_list = [
  'Hôm nay',
  'Tuần này',
  'Tháng này',
  'Tất cả',
];

const time_list_2 = [
  {
    'label': 'Hôm nay',
    'color': COLOR_DONE,
  },
  {
    'label': 'Tuần này',
    'color': COLOR_DONE,
  },
  {
    'label': 'Tháng này',
    'color': COLOR_DONE,
  },
  {
    'label': 'Chọn khoảng thời gian',
    'color': COLOR_DONE,
  }
];

const status_list = [
  {
    'label': 'Kế hoạch',
    'color': COLOR_PLAN,
    'value': 'plan',
  },
  {
    'label': 'Đang tiến hành',
    'color': COLOR_INPROGRESS,
    'value': 'In Progress'
  },
  {
    'label': 'Hoàn thành',
    'color': COLOR_GREEN,
    'value': 'Completed',
  },
  {
    'label': 'Trễ hạn',
    'color': COLOR_LATE,
    'value': 'late',
  },
];
List<String> typeLeaving = [
  'Nghỉ phép',
  'Nghỉ bệnh',
  'Nghỉ thai sản',
  'Xin làm ở nhà',
  'Khác',
];

const priority_list = [
  {
    'label': 'Thấp',
    'value': 'low',
    'color': COLOR_GREEN,
  },
  {
    'label': 'Trung Bình',
    'value': 'normal',
    'color': COLOR_INPROGRESS,
  },
  {
    'label': 'Cao',
    'value': 'high',
    'color': COLOR_LATE,
  },
];

List<String> typeOptionList = [
  'Customize',
  'Cloud',
  'Khác',
];

List<String> projectOptionList = [
  'Dự án kiểm thử phần mềm',
  'Dự án quản lí chi tiêu',
  'Dự án tạo các thông báo đẩy tự động',
];

List<String> categoryOptionList = [
  'Hạng mục 1',
  'Hạng mục 2',
  'Hạng mục 3',
  'Hạng mục 4',
];

List<String> stateOptionList = [
  'Đang tiến hành',
  'Kế hoạch',
  'Hoàn thành',
];

List<String> stateOptioEventList = [
  'Lên kế hoạch',
  'Đã kết thúc',
  'Hủy',
];

List<String> priorityOptionList = [
  'Thấp',
  'Trung bình',
  'Cao',
];

List<String> eventsStatusList = [
  'Thấp',
  'Trung bình',
  'Cao',
];
List<String> progresses = [
  '0',
  '10',
  '20',
  '30',
  '40',
  '50',
  '60',
  '70',
  '80',
  '90',
  '100'
]; // dropdown list for progress

List<Map<String, Object>> projectDetailChild = [
  {
    'icon': 'lib/assets/images/detail_project/progress_icon.png',
    'title': 'Tiến độ',
    'route_name': '',
    'color': const Color.fromARGB(255, 218, 119, 242),
  },
  {
    'icon': 'lib/assets/images/home_page/bottom_dialog/todo_list_icon.png',
    'title': 'Tác vụ',
    'route_name': '',
    'color': COLOR_PLAN,
  },
  {
    'icon': 'lib/assets/images/home_page/bottom_dialog/category_icon.png',
    'title': 'Hạng mục',
    'route_name': '',
    'color': COLOR_TEST,
  },
  {
    'icon': 'lib/assets/images/detail_project/member_icon.png',
    'title': 'Thành viên',
    'route_name': '',
    'color': const Color.fromARGB(255, 255, 169, 37),
  },
  {
    'icon': 'lib/assets/images/detail_project/document_icon.png',
    'title': 'Tài liệu',
    'route_name': '',
    'color': COLOR_INPROGRESS,
  },
  {
    'icon': 'lib/assets/images/detail_project/comment_icon.png',
    'title': 'Bình luận',
    'route_name': '',
    'color': COLOR_TEXT_MAIN,
  }
];

List<Map<String, String>> mentorList = [
  {
    'name': 'Bùi Quang Thành',
    'role': 'Mobile app devoloper',
    'mail': 'bqthanh11@gmail.com',
    'avatar': 'lib/assets/images/home_page/user_icon.png',
  },
  {
    'name': 'Lê Thị Thắm',
    'role': 'Mobile app devoloper',
    'mail': 'bqthanh11@gmail.com',
    'avatar': 'lib/assets/images/home_page/user_icon.png',
  },
];

List<Map<String, String>> memberList = [
  {
    'name': 'Huỳnh Tấn Vinh',
    'role': 'Mobile app devoloper',
    'mail': 'huynhtanvinh11@gmail.com',
    'avatar': 'lib/assets/images/home_page/user_icon.png',
  },
  {
    'name': 'Đinh Nguyễn Duy Khang',
    'role': 'Mobile app devoloper',
    'mail': 'dndkhang@gmail.com',
    'avatar': 'lib/assets/images/home_page/user_icon.png',
  },
  {
    'name': 'Nguyễn Văn Minh',
    'role': 'Mobile app devoloper',
    'mail': 'nvminh2211@gmail.com',
    'avatar': 'lib/assets/images/home_page/user_icon.png',
  },
  {
    'name': 'Huỳnh Tấn Vinh',
    'role': 'Mobile app devoloper',
    'mail': 'huynhtanvinh11@gmail.com',
    'avatar': 'lib/assets/images/home_page/user_icon.png',
  },
  {
    'name': 'Đinh Nguyễn Duy Khang',
    'role': 'Mobile app devoloper',
    'mail': 'dndkhang@gmail.com',
    'avatar': 'lib/assets/images/home_page/user_icon.png',
  },
  {
    'name': 'Nguyễn Văn Minh',
    'role': 'Mobile app devoloper',
    'mail': 'nvminh2211@gmail.com',
    'avatar': 'lib/assets/images/home_page/user_icon.png',
  },
];

List<Map<String, String>> notificationUpdateList = [
  {
    'type': 'update',
    'seen': 'false',
    'content':
        'Task Meeting "Họp review App CloudWORK" sẽ diễn ra trong 1 giờ nữa!',
    'time': 'Hôm nay',
  },
  {
    'type': 'update',
    'seen': 'false',
    'content':
        'Task Meeting "Họp review App CloudWORK" sẽ diễn ra trong 1 giờ nữa!',
    'time': 'Hôm nay',
  },
  {
    'type': 'comment',
    'seen': 'false',
    'content': 'Tấn Vinh đã bình luận vào dự án gì đó!',
    'time': 'Hôm nay',
  },
  {
    'type': 'file',
    'seen': 'false',
    'content': 'Quang Thành đã thêm một file mới vào dự án gì đó!',
    'time': 'Hôm nay',
  },
  {
    'type': 'update',
    'seen': 'true',
    'content':
        'Task Meeting "Họp review App CloudWORK" sẽ diễn ra trong 1 giờ nữa!',
    'time': 'Hôm nay',
  },
];

List<Map<String, Object>> _notificationActivityList = [
  {
    'state': 'Trễ hạn',
    'data': [
      {
        'type': 'late',
        'seen': 'false',
        'content': 'Công việc “Thiết kế dữ liệu” đã quá hạn 2 ngày ',
        'time': '13-08-2023 11:59 PM',
      },
      {
        'type': 'late',
        'seen': 'false',
        'content': 'Công việc “Vẽ mockup” đã quá hạn 1 ngày ',
        'time': '13-08-2023 11:59 PM',
      },
      {
        'type': 'late',
        'seen': 'true',
        'content': 'Công việc “Thiết kế dữ liệu” đã quá hạn 2 ngày ',
        'time': '13-08-2023 11:59 PM',
      },
    ]
  },
  {
    'state': 'Sắp đến hạn',
    'data': [
      {
        'type': 'progress',
        'seen': 'false',
        'content': 'Công việc “Thiết kế dữ liệu” phải hoàn thành trong hôm nay',
        'time': '13-08-2023 11:59 PM',
      },
      {
        'type': 'progress',
        'seen': 'false',
        'content': 'Công việc “Vẽ mockup” phải hoàn trong ',
        'time': '13-08-2023 11:59 PM',
      },
      {
        'type': 'progress',
        'seen': 'false',
        'content': 'Công việc “Vẽ mockup” phải hoàn trong ',
        'time': '13-08-2023 11:59 PM',
      },
      {
        'type': 'progress',
        'seen': 'true',
        'content': 'Công việc “Thiết kế dữ liệu” đã quá hạn 2 ngày ',
        'time': 'Hôm nay',
      },
    ]
  },
  {
    'state': 'Mới được giao',
    'data': [
      {
        'type': 'plan',
        'seen': 'false',
        'content': 'Công việc “Thiết kế dữ liệu” phải hoàn thành trong hôm nay',
        'time': '13-08-2023 11:59 PM',
      },
      {
        'type': 'plan',
        'seen': 'false',
        'content': 'Công việc “Vẽ mockup” phải hoàn trong ',
        'time': '13-08-2023 11:59 PM',
      },
      {
        'type': 'plan',
        'seen': 'true',
        'content': 'Công việc “Thiết kế dữ liệu” đã quá hạn 2 ngày ',
        'time': 'Hôm nay',
      },
    ]
  },
];
