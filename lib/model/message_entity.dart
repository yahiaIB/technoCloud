import 'package:task/generated/json/base/json_convert_content.dart';
import 'package:task/generated/json/base/json_field.dart';

class MessageEntity with JsonConvert<MessageEntity> {
	String? timestamp;
	@JSONField(name: "send_by")
	String? sendBy;
	String? text;
	String? image;
}
