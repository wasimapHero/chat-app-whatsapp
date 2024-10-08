class Chat_cartUserModel {
  String? image;
  String? about;
  String? name;
  String? lastActive;
  bool? isOnline;
  String? pushToken;
  String? id;
  String? email;

  Chat_cartUserModel(
      {this.image,
      this.about,
      this.name,
      this.lastActive,
      this.isOnline,
      this.pushToken,
      this.id,
      this.email});

  Chat_cartUserModel.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? "";
    about = json['about'] ?? "";
    name = json['name'] ?? "";
    lastActive = json['last_active'] ?? "";
    isOnline = json['is_online'] ?? false;
    pushToken = json['push_token'] ?? "";
    id = json['id'] ?? "";
    email = json['email'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['about'] = this.about;
    data['name'] = this.name;
    data['last_active'] = this.lastActive;
    data['is_online'] = this.isOnline;
    data['push_token'] = this.pushToken;
    data['id'] = this.id;
    data['email'] = this.email;
    return data;
  }
}
