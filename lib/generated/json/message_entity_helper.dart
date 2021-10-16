import 'package:task/model/message_entity.dart';

messageEntityFromJson(MessageEntity data, Map<String, dynamic> json) {
	if (json['timestamp'] != null) {
		data.timestamp = json['timestamp'].toString();
	}
	if (json['send_by'] != null) {
		data.sendBy = json['send_by'].toString();
	}
	if (json['text'] != null) {
		data.text = json['text'].toString();
	}
	if (json['image'] != null) {
		data.image = json['image'].toString();
	}
	return data;
}

Map<String, dynamic> messageEntityToJson(MessageEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['timestamp'] = entity.timestamp;
	data['send_by'] = entity.sendBy;
	data['text'] = entity.text;
	data['image'] = entity.image;
	return data;
}