class Message {
  Message({
    required this.msg,
    required this.sentTime,
    required this.fromId,
    required this.readTime,
    required this.msgType,
    required this.toId,
  });
  late String msg;
  late String sentTime;
  late String fromId;
  late String readTime;
  late Type msgType;
  late String toId;
  
  Message.fromJson(Map<String, dynamic> json){
    msg = json['msg'].toString();
    sentTime = json['sent_time'].toString();
    fromId = json['from_Id'].toString();
    readTime = json['read_time'].toString();
    msgType = json['msg_type'].toString() == Type.image.name ? Type.image : Type.text;
    toId = json['to_Id'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    _data['sent_time'] = sentTime;
    _data['from_Id'] = fromId;
    _data['read_time'] = readTime;
    _data['msg_type'] = msgType.name;
    _data['to_Id'] = toId;
    return _data;
  }
}
enum Type {text, image}