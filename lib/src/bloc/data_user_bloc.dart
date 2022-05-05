import 'package:new_brunner_app/src/core/preferences.dart';
import 'package:rxdart/rxdart.dart';

class DataUserBloc {
  final _dataUserController = BehaviorSubject<UserModel>();

  Stream<UserModel> get userStream => _dataUserController.stream;

  dispose() {
    _dataUserController.close();
  }

  void obtenerUser() async {
    UserModel userModel = UserModel();
    userModel.idUser = await Preferences.readData('id_user');
    userModel.idPerson = await Preferences.readData('id_person');
    userModel.userNickname = await Preferences.readData('user_nickname');
    userModel.userEmail = await Preferences.readData('user_email');
    userModel.userImage = await Preferences.readData('image');
    userModel.personName = await Preferences.readData('person_name');
    userModel.personSurname = await Preferences.readData('person_surname');
    userModel.idRoleUser = await Preferences.readData('id_rol');
    userModel.roleName = await Preferences.readData('rol_nombre');
    _dataUserController.sink.add(userModel);
  }
}

class UserModel {
  String? idUser;
  String? idPerson;
  String? userNickname;
  String? userEmail;
  String? userImage;
  String? personName;
  String? personSurname;
  String? idRoleUser;
  String? roleName;

  UserModel({
    this.idUser,
    this.idPerson,
    this.userNickname,
    this.userEmail,
    this.userImage,
    this.personName,
    this.personSurname,
    this.idRoleUser,
    this.roleName,
  });
}
