// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// enum ReportStatus { sent, inProgress, completed, rejected }

// class DisasterReport {
//   final String id;
//   final String userId;
//   final String disasterType;
//   final String imagePath;
//   final double latitude;
//   final double longitude;
//   final String description;
//   final int timestamp;
//   final ReportStatus status;

//   DisasterReport({
//     required this.id,
//     required this.userId,
//     required this.disasterType,
//     required this.imagePath,
//     required this.latitude,
//     required this.longitude,
//     required this.description,
//     required this.timestamp,
//     required this.status,
//   });

//   factory DisasterReport.fromSnapshot(DocumentSnapshot snapshot) {
//     return DisasterReport(
//       id: snapshot.id,
//       userId: snapshot['userId'] ?? '',
//       disasterType: snapshot['disasterType'] ?? '',
//       imagePath: snapshot['imagePath'] ?? '',
//       latitude: (snapshot['latitude'] ?? 0.0) as double,
//       longitude: (snapshot['longitude'] ?? 0.0) as double,
//       description: snapshot['description'] ?? '',
//       timestamp: (snapshot['timestamp'] ?? 0) as int,
//       status: _getStatusFromString(snapshot['status'] ?? ''),
//     );
//   }

//   static ReportStatus _getStatusFromString(String statusString) {
//     switch (statusString) {
//       case 'sent':
//         return ReportStatus.sent;
//       case 'inProgress':
//         return ReportStatus.inProgress;
//       case 'completed':
//         return ReportStatus.completed;
//       case 'rejected':
//         return ReportStatus.rejected;
//       default:
//         return ReportStatus.sent;
//     }
//   }

//   Icon getStatusIcon() {
//     switch (status) {
//       case ReportStatus.sent:
//         return Icon(Icons.send);
//       case ReportStatus.inProgress:
//         return Icon(Icons.hourglass_top);
//       case ReportStatus.completed:
//         return Icon(Icons.done);
//       case ReportStatus.rejected:
//         return Icon(Icons.close);
//     }
//   }
// }

