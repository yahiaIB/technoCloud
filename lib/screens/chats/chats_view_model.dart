import 'package:task/model/users_entity.dart';
import 'package:task/repository/user_repository.dart';
import 'package:task/viewmodels/base_model.dart';

class ChatsViewModel extends BaseViewModel{

  UserRepository userRepository = UserRepository();

  List<User> _users = [];

  List<User>? get users => _users;


  getUsers() async {
    setBusy(true);
    try{
      _users = await userRepository.getUsers();
      setBusy(false);
      notifyListeners();
    }catch(e){
      setBusy(false);
      print(e);
    }
  }
}