import 'package:task/model/users_entity.dart';

userFromJson(User data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['image'] != null) {
		data.image = json['image'].toString();
	}
	return data;
}

Map<String, dynamic> userToJson(User entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['image'] = entity.image;
	return data;
}