import 'package:flutter/material.dart';
import 'package:flutterdapp/parentModel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<ParentModel>(
          builder: (context, listModel, _) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 1.3,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35.0),
                  color: Color.fromARGB(255, 151, 3, 236),
                ),
                child: MaterialButton(
                  onPressed: () async {
                    await listModel.getCoordinates();
                  },
                  child: Text(
                    'View Employee Location',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                listModel.isLoading
                    ? "Employee Last known Location: \nNo Data"
                    : "Coordinates:\n${listModel.latitude}, ${listModel.longitude}",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              Container(
                width: MediaQuery.of(context).size.width / 1.3,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35.0),
                  color: Color.fromARGB(255, 223, 167, 0),
                ),
                child: MaterialButton(
                  onPressed: () async {
                    final String googleMapsUrl =
                        "https://www.google.com/maps/search/?api=1&query=${listModel.latitude},${listModel.longitude}";
                    final String appleMapsUrl =
                        "https://maps.apple.com/?q=${listModel.latitude},${listModel.longitude}";
                    if (await canLaunch(googleMapsUrl)) {
                      await launch(googleMapsUrl);
                    }
                    if (await canLaunch(appleMapsUrl)) {
                      await launch(appleMapsUrl, forceSafariVC: false);
                    } else {
                      throw "Couldn't launch URL";
                    }
                  },
                  child: Text(
                    'View in Maps',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
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
