import 'package:doctor_appointment_app/utils/app_colors.dart';
import 'package:doctor_appointment_app/utils/constants.dart';
import 'package:doctor_appointment_app/view_model/signout_controller.dart';
import 'package:doctor_appointment_app/views/widgets/authentication_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PatientSideDrawer extends StatefulWidget {
  final String name;
  final String email;
  final String image;
  const PatientSideDrawer(
      {super.key,
      required this.email,
      required this.image,
      required this.name});

  @override
  State<PatientSideDrawer> createState() => _PatientSideDrawerState();
}

class _PatientSideDrawerState extends State<PatientSideDrawer> {
  LogoutController logoutController=Get.put(LogoutController());
   void _showDialogAndNavigate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AuthenticationDialogBox(
          title: "Sign out Successfully!",
          onDialogDismissed: () {},
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1.0,
      width: MediaQuery.of(context).size.width * 1.0,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColors.drawerBegin, AppColors.drawerEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          widget.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: GoogleFonts.rubik(
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.email,
                          style: GoogleFonts.rubik(
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w300,
                              fontSize: 10),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xffFF0000)),
                    child: IconButton(
                      onPressed: () {},
                      icon: FittedBox(
                        fit: BoxFit.cover,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: Constants.drawerTitle.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 21),
                        child: ListTile(
                          title: Text(
                            Constants.drawerTitle[index],
                            style: GoogleFonts.rubik(
                                color: Color(0xffffffff),
                                fontWeight: FontWeight.w300,
                                fontSize: 16),
                          ),
                          leading: Image.asset(Constants.drawerIcons[index]),
                          trailing:
                              Image.asset("assets/images/arrow_forward.png"),
                        ),
                      );
                    })),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: (){
               logoutController.signOut(context).then((value){
                _showDialogAndNavigate();
               }); 
              },
              child: ListTile(
                title: Text(
                  "Logout",
                  style: GoogleFonts.rubik(
                      color: Color(0xffffffff),
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
                leading: Image.asset("assets/images/logout.png"),
                trailing: Image.asset("assets/images/arrow_forward.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
