import 'package:flutter/material.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/data/repositories/auth/auth_repository.dart';
import 'package:papers_for_peers/presentation/modules/login_v2/login_demo.dart';
import 'package:provider/provider.dart';

class WrapperDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthRepository _authRepository = context.select((AuthRepository repo) => repo);

    // todo remove
    _authRepository.logoutUser();

    return StreamBuilder(
      stream: _authRepository.user,
      builder: (context, snapshot) {
        UserModel? user = snapshot.data as UserModel?;
        if (user == null) {
          print("WRAPPER DEMO: USER NULL");
        } else {
          print("WRAPPER DEMO: USER NOT NULL: $user");
        }
        return LoginDemo();
      },
    );
  }
}
