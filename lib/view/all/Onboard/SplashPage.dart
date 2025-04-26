import 'package:attendance/api_service/colors.dart';
import 'package:attendance/view/all/Login/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common_controller/MiscController.dart';
import '../nab_bar.dart';
import 'cubit/splash_cubit.dart';


class SplashPage extends StatelessWidget {
  SplashPage({super.key});

  final MiscController _miscController = MiscController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => SplashCubit()),
        ],
        child: BlocConsumer<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state is SplashInitial) {
              if(state.needLogin) {
                _miscController.navigateTo(context: context,page:  LoginPage());
              } else {
                if(state.success) {
                  _miscController.navigateTo(context: context, page: NavbarPage(initialIndex: 0));
                } else {
                  if(state.message.isNotEmpty){
                  dialog(context: context, success: state.success, message: state.message);
                  }
                }
              }
            }
          },
          builder: (context, state) {
            return Container(
              color: AppColors.primaryColor,
                child: Image.asset('assets/images/applogo.png',color: Colors.white, ));
          },
        ));
  }

  //region dialog
  Future dialog({required BuildContext context, required bool success, required String message}) async {
    await _miscController.showGraphicalDialog(
        context: context,
        cancelable: false,
        imagePath: success ? 'assets/images/check.png' : 'assets/images/no.png',
        title: 'Attention Please',
        subTitle: message,
        okText: 'OKAY',
        okPressed: () {
          Navigator.pop(context);
        });
  }
//endregion
}
