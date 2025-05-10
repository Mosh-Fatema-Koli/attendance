import 'dart:io';

import 'package:attendance/common_model/UserInfo.dart';
import 'package:attendance/view/widgets/framework/rf_box_decoration.dart';
import 'package:attendance/view/widgets/framework/rf_text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../api_service/Constant.dart';
import '../../../api_service/app_cash.dart';
import '../../../api_service/colors.dart';
import '../../../common_controller/MiscController.dart';
import '../../widgets/framework/C_button.dart';
import '../../widgets/framework/rf_text.dart';
import '../nab_bar.dart';
import 'cubit/update_profile_cubit.dart';

class UpdateProfile extends StatelessWidget {
  final UserInfo userInfo;

  final miscController = MiscController();

  UpdateProfile({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: userInfo.name ?? "");
    final phoneController = TextEditingController(text: userInfo.phone ?? "");
    final birthController = TextEditingController(text: userInfo.joiningDate ?? "");
    final emailController = TextEditingController(text: userInfo.email ?? "");

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.appbarColor,
            AppColors.bodyColor,
            AppColors.bodyColor,
            AppColors.bodyColor,
            AppColors.bodyColor,
          ],
        ),
      ),
      child: BlocProvider(
  create: (context) => UpdateProfileCubit(),
  child: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    final cubit = context.read<UpdateProfileCubit>();
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => miscController.navigateBack(context: context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          title: RFText(
            text: "Edit Profile",
            color: Colors.black,
            size: 20.sp,
            weight: FontWeight.bold,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50.h),
              GestureDetector(
                onTap: () {
                  cubit.selectImage();
                },
                child: Container(
                    height: 120.h,
                    width: 120.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                       border: Border.all(width: 5,color: AppColors.primaryColor)
                    ),
                  child: ClipOval(

                    child: state.cameraPath.isNotEmpty
                        ? Image.file(
                          File(state.cameraPath),
                          fit: BoxFit.cover,
                          width: 100.w,
                          height: 100.h,
                        )
                        : AppCache().userInfo!.image !=null? CachedNetworkImage(
                      imageUrl: "${Constant.imageUrl}${AppCache().userInfo!.image}",
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                              colorFilter:
                              ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
                        ),
                      ),
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>   Image.asset(
                        "assets/images/man.png",
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.contain,
                      ),
                    ):
                    Image.asset(
                      "assets/images/man.png",
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              RFText(
                text: AppCache().userInfo?.name ?? "Not Found",
                weight: FontWeight.bold,
                size: 18.sp,
              ),
              RFText(
                  text: AppCache().userInfo?.email ??
                      "Not Found"),
              RFText(
                  text: "User Name: ${AppCache().userInfo?.username ?? "Not Found"}"),

              SizedBox(height: 20.h),
              _buildField("Name","Enter your name", nameController,),
              _buildField("Phone","Enter your phone", phoneController),
              _buildDateField("Date of birth","Enter your date of birth", birthController, context),
              _buildField("Email","Enter your email", emailController,readOnly: true),
            ],
          ),
        ),
        bottomNavigationBar: Wrap(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0).w,
                child: CButton(
                  buttonText: "Update",
                  onTap: () {
                    if(nameController.text.isNotEmpty ||phoneController.text.isNotEmpty ||birthController.text.isNotEmpty ||emailController.text.isNotEmpty){
                              cubit.updateProfile(
                                name: nameController.text,
                                phone: phoneController.text,
                                dob: birthController.text,
                                imagePath: state.cameraPath,
                                onComplete: (isSuccess, message) {
                                  miscController.navigateTo(context: context, page: NavbarPage(initialIndex: 1));
                                  miscController.toast(msg: message);
                              }, context: context,);
                    }else{
                      miscController.toast(
                        msg: "Please add your all information",
                        position: ToastGravity.TOP,
                      );
                    }
                    // Update logic here
                    debugPrint("Name: ${nameController.text}");
                    debugPrint("Phone: ${phoneController.text}");
                    debugPrint("Email: ${emailController.text}");
                  },
                ),
              ),
            ),
          ],
        ),
      );
  },
),
),
    );
  }

  Widget _buildField(String name,String hint, TextEditingController controller, {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5).w,
      child: Container(
        decoration: RFBoxDecoration(border: Border.all(color: Colors.black,style: BorderStyle.solid,width: 2)).build(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10).w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RFText(text: name,color: Colors.grey,),
              TextField(
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                ),
                controller: controller,
                readOnly: readOnly,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(String name, String hint, TextEditingController controller,BuildContext context, {bool readOnly = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5).w,
      child: Container(
        decoration: RFBoxDecoration(
          border: Border.all(color: Colors.black, style: BorderStyle.solid, width: 2),
        ).build(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10).w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RFText(text: name, color: Colors.grey),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context:context, // or use `context` directly if you're within a build method
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    controller.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: hint,
                      border: InputBorder.none,
                    ),
                    controller: controller,
                    readOnly: readOnly,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
