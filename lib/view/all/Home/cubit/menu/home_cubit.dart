
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/menu_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState>{
  HomeCubit():super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);


  final List menuList=[
    MenuModel(name: "Total Present",image: ""),
    MenuModel(name: "Total Absent",image: ""),
    MenuModel(name: "TL_Hours",image: ""),
    MenuModel(name: "Total late",image: ""),
    MenuModel(name: "Total early",image: ""),
    MenuModel(name: "TE_Hours",image: ""),
  ];

}