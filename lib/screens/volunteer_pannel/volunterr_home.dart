import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../../utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VolunteerHomeScreen extends StatefulWidget {
  String ?volunteerName;
   VolunteerHomeScreen({super.key,this.volunteerName});

  @override
  _VolunteerHomeScreenState createState() => _VolunteerHomeScreenState();
}

class _VolunteerHomeScreenState extends State<VolunteerHomeScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future _sendDonation() async {
       String imgUrl;
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = FirebaseStorage.instance.ref().child("images/").child('me$fileName');
      await reference.putFile(_selectedImage!);
      imgUrl = await reference.getDownloadURL();

      //donation
       if (_selectedImage == null || _descriptionController.text.isEmpty || _quantityController.text.isEmpty) {
         // Show an error message or prompt the user to fill in all the fields
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
             backgroundColor: primaryColor,
             content: Center(child: Text("Complete all above details"))));
         return;
       }

       String description = _descriptionController.text;
       int quantity = int.parse(_quantityController.text);

       // Upload the image to Firebase Storage and get the download URL
       final user=FirebaseAuth.instance;

       // Save the donation details with the image URL to Firestore
       CollectionReference ref= FirebaseFirestore.instance.collection('donations');
       ref.doc(user.currentUser?.uid).set({
         'description': description,
         'quantity': quantity,
         'volunteerName':widget.volunteerName,
         'volunteerId': FirebaseAuth.instance.currentUser?.uid,
         'imageUrl': imgUrl,

       });



    // Display a success message or navigate to the confirmation screen
    // as per your app flow
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        title: Text('Send Donation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Send a Food Donation',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                _pickImage(ImageSource.gallery);
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _selectedImage != null
                    ? Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                )
                    : Icon(
                  Icons.camera_alt,
                  color: Colors.grey[600],
                  size: 50,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: Size(MediaQuery.of(context).size.width, 50)
              ),
              onPressed: _sendDonation,
              child: Text('Donate',
              style: TextStyle(
                fontSize: 20
              ),),
            ),
          ],
        ),
      ),
    );

  }
}



