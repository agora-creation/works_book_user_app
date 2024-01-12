import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:works_book_user_app/models/user.dart';
import 'package:works_book_user_app/services/fm.dart';
import 'package:works_book_user_app/services/user.dart';

enum AuthStatus {
  authenticated,
  uninitialized,
  authenticating,
  unauthenticated,
}

class UserProvider with ChangeNotifier {
  AuthStatus _status = AuthStatus.uninitialized;
  AuthStatus get status => _status;
  FirebaseAuth? auth;
  User? _authUser;
  User? get authUser => _authUser;
  FmServices fmServices = FmServices();
  UserService userService = UserService();
  UserModel? _user;
  UserModel? get user => _user;

  UserProvider.initialize() : auth = FirebaseAuth.instance {
    auth?.authStateChanges().listen(_onStateChanged);
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    String? error;
    if (email == '') return 'メールアドレスを入力してください';
    if (password == '') return 'パスワードを入力してください';
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      final result = await auth?.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _authUser = result?.user;
      String token = await fmServices.getToken() ?? '';
      userService.update({
        'id': _authUser?.uid,
        'token': token,
      });
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      error = 'ログインに失敗しました';
    }
    return error;
  }

  Future signOut() async {
    await auth?.signOut();
    _status = AuthStatus.unauthenticated;
    _user = null;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  // Future<String?> updateName({required String name}) async {
  //   String? error;
  //   if (_group == null) return '会社・組織名の変更に失敗しました';
  //   if (name == '') return '会社・組織名を入力してください';
  //   try {
  //     groupService.update({
  //       'id': _group?.id,
  //       'name': name,
  //     });
  //   } catch (e) {
  //     error = e.toString();
  //   }
  //   return error;
  // }

  Future reloadUserModel() async {
    _user = await userService.select(_authUser?.uid);
    notifyListeners();
  }

  Future _onStateChanged(User? authUser) async {
    if (authUser == null) {
      _status = AuthStatus.unauthenticated;
    } else {
      _authUser = authUser;
      _status = AuthStatus.authenticated;
      _user = await userService.select(_authUser?.uid);
    }
    notifyListeners();
  }
}
