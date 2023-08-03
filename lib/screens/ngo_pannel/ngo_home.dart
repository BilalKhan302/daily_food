import 'package:daily_food/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NGOHomeScreen extends StatefulWidget {
  const NGOHomeScreen({super.key});

  @override
  State<NGOHomeScreen> createState() => _NGOHomeScreenState();
}

class _NGOHomeScreenState extends State<NGOHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text('NGO Home'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('donations').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final documents = snapshot.data?.docs;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 10.0, // Spacing between columns
                mainAxisSpacing: 10.0,
              ),
              itemCount: documents?.length,
              itemBuilder: (context, index) {
                final document = documents?[index];

                // Customize this widget based on your data structure
                return ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      width: 300, // Set the desired width for the card
                      height: 250, // Set the desired height for the card
                      child: Card(
                        child: CachedNetworkImage(
                          imageUrl: document?['imageUrl'],
                          fit: BoxFit.cover,
                          height: double.infinity, // Increase the height of the image to fit the card
                          width: double.infinity, // Increase the width of the image to fit the card
                        ),
                      ),
                    ).box.white.roundedSM.clip(Clip.antiAlias).shadow.make(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Name of Volunteer:",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        document?['volunteerName'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Description: ${document?['description']}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Quantity: ${document?['quantity']}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ).box.white.roundedSM.clip(Clip.antiAlias).shadow.make();

              },
            ),
          );
        },
      ),
    );
  }
}
