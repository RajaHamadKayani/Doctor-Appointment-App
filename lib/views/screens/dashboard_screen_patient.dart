import 'package:doctor_appointment_app/services/firestore_services.dart';
import 'package:doctor_appointment_app/utils/app_colors.dart';
import 'package:doctor_appointment_app/views/screens/sign_in_screen.dart';
import 'package:doctor_appointment_app/views/widgets/patient_side_drawer.dart';
import 'package:doctor_appointment_app/views/widgets/search_doctor_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreenPatient extends StatefulWidget {
  final Map<String, dynamic> userData;

  const DashboardScreenPatient({super.key, required this.userData});

  @override
  State<DashboardScreenPatient> createState() => _DashboardScreenPatientState();
}

class _DashboardScreenPatientState extends State<DashboardScreenPatient> {
  TextEditingController searchController = TextEditingController();
  final FirestoreServices _firestoreServices = Get.put(FirestoreServices());
  List<Map<String, dynamic>> doctors = [];
  List<Map<String, dynamic>> filteredDoctors = [];
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
    _firestoreServices.testFetch();
    searchController.addListener(_filterDoctors);
  }

  void _fetchDoctors() async {
    try {
      List<Map<String, dynamic>> fetchedDoctors =
          await _firestoreServices.fetchAllDoctors();
      print("Fetched doctors: $fetchedDoctors"); // Debug print
      setState(() {
        doctors = fetchedDoctors;
        filteredDoctors = fetchedDoctors;
      });
    } catch (e) {
      print("Error fetching doctors: $e");
    }
  }

  void _filterDoctors() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredDoctors = doctors.where((doctor) {
        return doctor['specialization'].toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: PatientSideDrawer(
          name: widget.userData["name"],
          email: widget.userData["email"],
          image: widget.userData["imageUrl"],
        ),
      ),
      key: globalKey,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, AppColors.gradient],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInScreen()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(9),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "My Doctors",
                          style: GoogleFonts.rubik(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: IconButton(
                        onPressed: () {
                          globalKey.currentState!.openDrawer();
                        },
                        icon: Icon(
                          Icons.menu,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SearchDoctorTextField(
                  controller: searchController,
                  hintText: "Search by specialization",
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredDoctors.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final doctor = filteredDoctors[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: ListTile(
                              leading: Image.network(
                                doctor['imageUrl'],
                              ),
                              title: Text(
                                doctor['name'],
                                style: GoogleFonts.rubik(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${doctor['specialization']}",
                                    style: GoogleFonts.rubik(
                                        color: AppColors.primaryColor,
                                        fontSize: 13),
                                  ),
                                  Text(
                                    "${doctor['experience']}",
                                    style: GoogleFonts.rubik(
                                        color: Colors.black, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
