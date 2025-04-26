part of 'splash_cubit.dart';

@immutable
abstract class SplashState {}

class SplashInitial extends SplashState {
  final bool needLogin, success;
  final String message;

  SplashInitial({required this.needLogin,required this.success,required this.message});

  static SplashInitial copyWith({required bool needLogin,required bool success,required String message}){
    return SplashInitial(needLogin: needLogin, success: success, message: message);
  }


  @override
  List<Object> get props => [needLogin,success,message];
}
