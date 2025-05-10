import 'dart:io';

import 'package:attendance/api_service/colors.dart';
import 'package:attendance/view/all/Home/cubit/dashbord/dashboard_cubit.dart';
import 'package:attendance/view/all/nab_bar.dart';
import 'package:attendance/view/widgets/framework/rf_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common_controller/MiscController.dart';
import '../../widgets/framework/rf_button.dart';
import 'cubit/check_in_cubit.dart';
import 'cubit/check_in_state.dart';

class CheckIn extends StatefulWidget {
  final bool checkIn;

  const CheckIn({super.key, required this.checkIn});

  @override
  _CheckInState createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  final _miscController = MiscController();
  late CheckInCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = CheckInCubit();
    _cubit.pickImageFromCamera(); // Open camera initially
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _cubit),
        BlocProvider(create: (_) => DashboardCubit()),
      ],
      child: BlocBuilder<CheckInCubit, CheckInState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primaryColor,
              leading: IconButton(
                onPressed: () => _miscController.navigateBack(context: context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              title: RFText(
                text: widget.checkIn ? "Check-In" : "Check-Out",
                color: Colors.white,
              ),
            ),
            body: Column(
              children: [
                if (state is CheckInLoaded) ...[
                  Expanded(
                    child: Image.file(
                      File(state.cameraPath),
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                  _buildSendButton(context, state.cameraPath),
                ] else if (state is CheckInError) ...[
                  Expanded(
                    child: Center(child: Text('No image captured. Please return to the home screen.')),
                  ),
                ] else ...[
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  /// ✅ Send Button (Check-In, Check-Out) with Retake
  Widget _buildSendButton(BuildContext context, String imagePath) {
    return Container(
      color: AppColors.primaryColor,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.h),
          child: Column(
            children: [
              RFButton(
                buttonRadius: 30,
                buttonColor: AppColors.appbarColor,
                text: widget.checkIn ? "Check In" : "Check Out",
                onPressed: () {
                  _cubit.submitData(
                    context: context,
                    attendance_type: widget.checkIn ? 0 : 1,
                    image: imagePath,
                    onComplete: (isSuccess, message) {
                      context.read<DashboardCubit>().loadData();
                      _miscController.navigateTo(
                        context: context,
                        page: NavbarPage(initialIndex: 0),
                      );
                      _miscController.toast(
                        msg: message,
                        position: ToastGravity.BOTTOM,
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 10.h),
              RFButton(
                buttonRadius: 30,
                borderColor: Colors.white,
                borderWidth: 2,
                text: "Retake",
                onPressed: () {
                  _cubit.pickImageFromCamera(); // Reopen camera
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
