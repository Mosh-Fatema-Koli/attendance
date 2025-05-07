
import 'package:attendance/view/all/Profile/profile_page.dart';
import 'package:attendance/view/widgets/framework/rf_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api_service/Constant.dart';
import '../../common_controller/MiscController.dart';
import '../../api_service/colors.dart';
import 'Home/page/home_page.dart';
import 'check_in/check_in.dart';

class NavbarPage extends StatefulWidget {
  final int initialIndex;  // rename for clarity
  NavbarPage({Key? key, required this.initialIndex}) : super(key: key);

  @override
  State<NavbarPage> createState() => _NavbarPageState();
}

class _NavbarPageState extends State<NavbarPage> {
  final _miscController = MiscController();
  late int selectedIndex;
  bool isLoading = false; // Loading state
  late PageController pageController;

  final List<Widget> pages = [
    Homepage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize selectedIndex from widget
    selectedIndex = widget.initialIndex;
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, Object? result) async {
        if (didPop) {
          return;
        }
        await _miscController.showAppExitDialog(context: context);
      },
      child: Stack(
        children: [
          Scaffold(
            body: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: pages,
            ),
            floatingActionButton: buildFloatingActionButton(),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              height: 70.w,
              color: AppColors.save_white,
              elevation: 20,
              shape: const CircularNotchedRectangle(),
              notchMargin: 10.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildNavBarItem(0, Icons.home, 'Home'),
                  Column(
                    children: [
                      SizedBox(height: 23.h),
                      RFText(text: "  Present", size: 14.sp, textAlign: TextAlign.center),
                    ],
                  ),
                  buildNavBarItem(1, Icons.person, 'Profile'),
                ],
              ),
            ),
          ),

          // Transparent Loading Overlay
          if (isLoading)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.2), // Semi-transparent overlay
                height: 50.h, // Adjust height as needed
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildFloatingActionButton() {
    return FloatingActionButton(
      shape: const CircleBorder(),
      onPressed: () async {
        // setState(() => isLoading = true);
        // await Future.delayed(Duration(seconds: 2)); // Simulate loading
        // setState(() => isLoading = false);
        SharedPreferences pref = await _miscController.pref();
        String? checkin= _miscController.prefGetString(pref: pref, key: Constant.checkIn)??"";
        String? checkOut= _miscController.prefGetString(pref: pref, key: Constant.checkOut)??"";
         checkin=="null"?_miscController.navigateTo(context: context, page: CheckIn(checkIn: true)):checkOut=="null"?_miscController.navigateTo(context: context, page: CheckIn(checkIn: false)):_miscController.toast(msg: "already Submitted",position: ToastGravity.BOTTOM);
      },
     // backgroundColor: AppColors.primaryColor,
      elevation: 10.0,
      child: Container(
      width:MediaQuery.of(context).size.width ,
      height:MediaQuery.of(context).size.height ,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
             color: AppColors.primaryColor
             // borderRadius: BorderRadius.circular(10),

          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0).w,
            child: Image.asset("assets/images/img.png", fit: BoxFit.contain),
          )),
    );
  }

  Widget buildNavBarItem(int index, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
          pageController.jumpToPage(selectedIndex);
        });
      },
      child: Column(
        children: [
          Icon(icon, size: 25.w, color: selectedIndex == index ? Colors.black87 : Colors.grey.shade500),
          RFText(text: label, size: 14.sp)
        ],
      ),
    );
  }
}
