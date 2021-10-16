import 'package:task/generated/json/base/json_convert_content.dart';

class User with JsonConvert<User> {
	String? id;
	String? name;
	String? image;
}
