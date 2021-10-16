import 'package:task/model/users_entity.dart';
import 'package:task/repository/user_repository.dart';

import 'base_model.dart';

enum AppStatus {
  uninitialized,
  authenticated,
  authenticating,
  unauthenticated
}

class AuthenticationViewModel extends BaseViewModel {
  AppStatus _status = AppStatus.uninitialized;

  AppStatus get status => _status;

  UserRepository userRepository = UserRepository();

  User? user;

  setStatus(AppStatus status) {
    _status = status;
    notifyListeners();
  }

  init(){
    user = userRepository.getUserLocal();
    if(user == null ){
      setStatus(AppStatus.authenticating);
    }else{
      setStatus(AppStatus.authenticated);
    }
  }

  createUser(image , name) async {
    try {
      setBusy(true);
      user = await userRepository.createUser(image,name);
      setStatus(AppStatus.authenticated);
      setBusy(false);
    }catch(e){
      setBusy(false);
      rethrow;
    }
  }

}