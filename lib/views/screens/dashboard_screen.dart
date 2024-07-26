import 'package:doctor_appointment_app/services/firestore_services.dart';
import 'package:doctor_appointment_app/utils/app_colors.dart';
import 'package:doctor_appointment_app/views/screens/sign_in_screen.dart';
import 'package:doctor_appointment_app/views/widgets/admin_side_drawer.dart';
import 'package:doctor_appointment_app/views/widgets/search_doctor_text_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DashboardScreenAdmin extends StatefulWidget {
  final Map<String, dynamic> userData; // Assuming userData is passed to this widget

  const DashboardScreenAdmin({super.key, required this.userData});

  @override
  State<DashboardScreenAdmin> createState() => _DashboardScreenAdminState();
}

class _DashboardScreenAdminState extends State<DashboardScreenAdmin> {
  TextEditingController searchController = TextEditingController();
  final FirestoreServices _firestoreServices = Get.put(FirestoreServices());
  late String adminId;
  List<Map<String, dynamic>> doctors = [];
  List<Map<String, dynamic>> filteredDoctors = [];
  File? _selectedImage;
  bool isLoading = false; // To manage loading state

  @override
  void initState() {
    super.initState();
    adminId = widget.userData["uid"];
    _fetchDoctors();
    searchController.addListener(_filterDoctors);
  }

  void _fetchDoctors() async {
    List<Map<String, dynamic>> fetchedDoctors = await _firestoreServices.fetchDoctors(adminId);
    setState(() {
      doctors = fetchedDoctors;
      filteredDoctors = fetchedDoctors;
    });
  }

  void _filterDoctors() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredDoctors = doctors.where((doctor) {
        return doctor['specialization'].toLowerCase().contains(query);
      }).toList();
    });
  }
  GlobalKey<ScaffoldState> globalKey=GlobalKey<ScaffoldState>();

  Future<void> _selectImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  void _showAddDoctorDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController specializationController = TextEditingController();
    TextEditingController experienceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Add Doctor"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _selectImage,
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: _selectedImage == null
                            ? Center(child: Text("Select Image"))
                            : Image.file(_selectedImage!, fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
                    SizedBox(height: 8),
                    TextField(controller: specializationController, decoration: InputDecoration(labelText: "Specialization")),
                    SizedBox(height: 8),
                    TextField(controller: experienceController, decoration: InputDecoration(labelText: "Experience")),
                    if (isLoading) SizedBox(height: 16),
                    if (isLoading) CircularProgressIndicator(),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });

                    if (_selectedImage != null) {
                      // Upload image
                      final firebaseStorage = FirebaseStorage.instance;
                      final ref = firebaseStorage.ref().child('doctor_images').child('image_${DateTime.now()}.jpg');
                      await ref.putFile(_selectedImage!);
                      final imageUrl = await ref.getDownloadURL();

                      // Add doctor
                      await _firestoreServices.addDoctor(
                        adminId: adminId,
                        name: nameController.text,
                        specialization: specializationController.text,
                        experience: experienceController.text,
                        imageUrl: imageUrl,
                      );

                      // Refresh the list
                      _fetchDoctors();

                      // Close the dialog
                      Navigator.pop(context);
                    }

                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Text("Add Doctor"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: AdminSideDrawer(
      name:widget.userData["name"],
      email:widget.userData["email"],
      image:widget.userData["imageUrl"]
      ),),
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
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
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
                          onTap: (){
                                            
                          },
                          child: IconButton(onPressed: (){
                            globalKey.currentState!.openDrawer();
                          }, icon: Icon(Icons.menu,
                          color: Colors.black,)),
                        )
                  ],
                ),
                const SizedBox(height: 30),
                SearchDoctorTextField(
                  controller: searchController,
                  hintText: "Search by specialization",
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: filteredDoctors.isEmpty
                      ? Center(child: Text("No doctor is added by you"))
                      : ListView.builder(
                          itemCount: filteredDoctors.length,
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
                                      style: GoogleFonts.rubik(color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${doctor['specialization']}",
                                          style: GoogleFonts.rubik(color: AppColors.primaryColor, fontSize: 13),
                                        ),
                                        Text(
                                          "${doctor['experience']}",
                                          style: GoogleFonts.rubik(color: Colors.black, fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: _showAddDoctorDialog,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
