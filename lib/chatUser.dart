// ignore_for_file: file_names, non_constant_identifier_names

class ChatUser {
  ChatUser({
    required this.image,
    required this.about,
    required this.name,
    required this.mobile_number,
    required this.address,
    required this.createdAt,
    required this.isOnline,
    required this.id,
    required this.lastActive,
    required this.email,
    required this.pushToken,
    required this.home_location,
  });
  late String image;
  late String about;
  late String name;
  late String mobile_number;
  late Map<String, dynamic> address;
  late Map<String, dynamic> home_location;
  late String createdAt;
  late bool isOnline;
  late String id;
  late String lastActive;
  late String email;
  late String pushToken;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    about = json['about'] ?? '';
    name = json['name'] ?? '';
    mobile_number = json['mobile_number'] ?? '';
    address = json['address'] ?? '';
    home_location = json['home_location'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? '';
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['mobile_number'] = mobile_number;
    data['address'] = address;
    data['home_location'] = home_location;

    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['email'] = email;
    data['push_token'] = pushToken;
    return data;
  }
}
