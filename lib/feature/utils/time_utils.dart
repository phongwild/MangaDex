String timeAgo(String utcDateTime) {
  try {
    // 1️⃣ Parse chuỗi thời gian từ UTC
    DateTime utcTime = DateTime.parse(utcDateTime);

    // 2️⃣ Chuyển sang múi giờ Việt Nam (GMT+7)
    DateTime updateTime = utcTime.toUtc().add(const Duration(hours: 7));

    // 3️⃣ Lấy thời gian hiện tại theo múi giờ Việt Nam
    DateTime now = DateTime.now().toUtc().add(const Duration(hours: 7));

    // 4️⃣ Tính khoảng cách thời gian
    Duration difference = now.difference(updateTime);

    // 5️⃣ Hiển thị thời gian theo kiểu "X năm X tháng X ngày X giờ X phút trước"
    if (difference.inDays >= 365) {
      int years = (difference.inDays / 365).floor();
      return '$years năm trước';
    } else if (difference.inDays >= 30) {
      int months = (difference.inDays / 30).floor();
      return '$months tháng trước';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa mới cập nhật';
    }
  } catch (e) {
    return 'Lỗi định dạng ngày giờ';
  }
}

String timeAgoComment(String utcDateTime) {
  try {
    // 1️⃣ Parse chuỗi thời gian từ UTC
    DateTime utcTime = DateTime.parse(utcDateTime);

    // 2️⃣ Chuyển sang múi giờ Việt Nam (GMT+7)
    DateTime updateTime = utcTime.toUtc().add(const Duration(hours: 7));

    // 3️⃣ Lấy thời gian hiện tại theo múi giờ Việt Nam
    DateTime now = DateTime.now().toUtc().add(const Duration(hours: 7));

    // 4️⃣ Tính khoảng cách thời gian
    Duration difference = now.difference(updateTime);

    // 5️⃣ Hiển thị thời gian theo kiểu "X năm X tháng X ngày X giờ X phút trước"
    if (difference.inDays >= 365) {
      int years = (difference.inDays / 365).floor();
      return '$years năm trước';
    } else if (difference.inDays >= 30) {
      int months = (difference.inDays / 30).floor();
      return '$months tháng trước';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa gửi';
    }
  } catch (e) {
    return 'Lỗi định dạng ngày giờ';
  }
}
