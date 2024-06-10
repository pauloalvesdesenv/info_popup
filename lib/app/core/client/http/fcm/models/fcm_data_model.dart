class FCMDataModel {
  final String title;
  final String description;
  final String token;

  FCMDataModel({
    required this.title,
    required this.description,
    required this.token,
  });

  Map<String, dynamic> toMap() => {
        "notification": {
          "title": title,
          "body": description,
          "click_action": null,
          "icon": null
        },
        "data": {"type": "type", "data": "data"},
        "to": token
      };
}
