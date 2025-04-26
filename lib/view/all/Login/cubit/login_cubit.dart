import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common_controller/MiscController.dart';
import 'login_repoitory.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState>{

  final _loginRepository = LoginRepository();
  final _miscController = MiscController();

  LoginCubit(): super(LoginInitial(isPasswordVisible: false,message: "",success: false));

  static LoginCubit get(context) => BlocProvider.of(context);

  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

//PasswordVisibility
  updatePasswordVisibility({required bool isVisible}) {
    emit(LoginInitial.copyWith(isPasswordVisible: isVisible, success: false, message: ''));
  }

  //API Call
  loginApiCall({required BuildContext context,required bool isPasswordVisible,required String username,required String password}){
    _miscController.showProgressDialog(context: context, subTitle: 'We are checking login.');

      _loginRepository.login(username: username.trim(), password: password.trim(), isOnlineApp: true, isFromSplash: false, onLoginResult: (isSuccess, message) {
      _miscController.navigateBack(context: context);

      emit(LoginInitial(isPasswordVisible: isPasswordVisible, message: message, success: isSuccess));

    },);

  }



}