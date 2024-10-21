class AppNotification {
  final String id;
  final String subject;
  final String message;
   bool unread;
  final String notificationModel;
  final String notificationRef;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.subject,
    required this.message,
    required this.unread,
    required this.notificationModel,
    required this.notificationRef,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['_id'],
      subject: json['subject'],
      message: json['message'],
      unread: json['unread'],
      notificationModel: json['notificationModel'],
      notificationRef: json['notification_ref'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }


Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['subject'] = subject;
    data['message'] = message;
    data['unread'] = unread;
    data['notificationModel'] = notificationModel;
    data['notification_ref'] = notificationRef;
    data['createdAt'] = createdAt;
    return data;
  }
}
