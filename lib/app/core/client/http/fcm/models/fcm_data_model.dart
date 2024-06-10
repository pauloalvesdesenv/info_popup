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
        "message": {
          "token": token,
          "notification": {"title": title, "body": description},
          "android": {
            "notification": {"click_action": "TOP_STORY_ACTIVITY"}
          },
          "apns": {
            "payload": {
              "aps": {"category": "NEW_MESSAGE_CATEGORY"}
            }
          }
        }
      };
}
