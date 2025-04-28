import 'package:flutter/material.dart';

class InfoUserCall extends StatelessWidget {
  const InfoUserCall(
      {super.key, required this.callerName, required this.status});

  final String callerName;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 120.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Text(
              callerName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 35.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
