
import 'dart:io';

import 'package:attendance/view/all/WFH/wfh_entry/cubit/wfhentry_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../../../api_service/colors.dart';
import '../../../../common_controller/MiscController.dart';
import '../../../widgets/framework/C_button.dart';
import '../../../widgets/framework/rf_box_decoration.dart';
import '../../../widgets/framework/rf_date_picker.dart';
import '../../../widgets/framework/rf_text.dart';
import '../../../widgets/framework/rf_text_field.dart';
import '../../nab_bar.dart';

class WFHEntryPage extends StatelessWidget {
  WFHEntryPage({super.key});

  final miscController = MiscController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController reasonController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => WfhentryCubit(),
      child: BlocConsumer<WfhentryCubit, WfhentryState>(
        listener: (context, state) {
        },
        builder: (context, state) {
          final cubit = context.read<WfhentryCubit>();


          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.appbarColor,
                  AppColors.bodyColor,
                  AppColors.bodyColor,
                  AppColors.bodyColor,
                ],
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  onPressed: () => miscController.navigateBack(context: context),
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                ),
                title: RFText(
                  text: "Submit Approval",
                  color: Colors.black,
                  size: 20.sp,
                  weight: FontWeight.bold,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10).w,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          cubit.selectImage();
                        },
                        child: Container(
                          height: 200.w,
                          width: double.infinity,
                          decoration: RFBoxDecoration().build(),
                          alignment: Alignment.center,
                          child: state.cameraPath.isEmpty
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo),
                              RFText(text: "Add image")
                            ],
                          )
                              : Image.file(
                            File(state.cameraPath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h,),
                      RFDatePicker(
                        name: "Start Date",
                        decoration: RFBoxDecoration().build(),
                        hintText: 'Choose Date',
                        suffixIcon: Icon(Icons.arrow_drop_down, size: 20.h),
                        controller: startDateController,
                        onChange: (dateValue, jsonMapResult) {
                          startDateController.text=dateValue;
                        },
                      ),
                      SizedBox(height: 10.h),
                      RFDatePicker(
                        name: "End Date",
                        decoration: RFBoxDecoration().build(),
                        hintText: 'Choose Date',
                        suffixIcon: Icon(Icons.arrow_drop_down, size: 20.h),
                        controller: endDateController,
                        onChange: (dateValue, jsonMapResult) {
                          endDateController.text=dateValue;

                        },
                      ),
                      SizedBox(height: 10.h),
                      _buildField("Reason ","Write Reason", reasonController,),
                      SizedBox(height: 10.h),

                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Wrap(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0).w,
                      child: CButton(
                        buttonText: "Submit Approval",
                        onTap: () {
                         if (reasonController.text.isEmpty) {
                            miscController.toast(
                              msg: "Please write reason",
                              position: ToastGravity.TOP,
                            );
                          } else if (startDateController.text.isEmpty ||
                              endDateController.text.isEmpty) {
                            miscController.toast(
                              msg: "Please select both start and end dates.",
                              position: ToastGravity.TOP,
                            );
                          } else {
                            try {
                              print("Start Date: ${startDateController.text}");
                              print("End Date: ${endDateController.text}");

                              DateFormat inputFormat = DateFormat("dd-MM-yyyy");
                              DateTime start = inputFormat.parse(startDateController.text);
                              DateTime end = inputFormat.parse(endDateController.text);

                              if (start.isAfter(end)) {
                                miscController.toast(
                                  msg: "Start date cannot be after end date.",
                                  position: ToastGravity.TOP,
                                );
                              } else {


                                cubit.submitData(
                                  context: context,
                                  startDate: startDateController.text, // Still dd-MM-yyyy
                                  endDate: endDateController.text,
                                  reason: reasonController.text,
                                  imagePath: state.cameraPath,
                                  onComplete: (isSuccess, message) {
                                    miscController.navigateTo(context: context, page: NavbarPage(initialIndex: 1));
                                    miscController.toast(msg: message);
                                  },
                                );
                              }
                            } catch (e) {
                              miscController.toast(
                                msg: "Date format is incorrect. Please re-select dates.",
                                position: ToastGravity.TOP,
                              );
                            }

                          }
                        },

                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  Widget _buildField(String name,String hint, TextEditingController controller, {bool readOnly = false}) {
    return Container(
      decoration: RFBoxDecoration().build(),
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
    );
  }
}