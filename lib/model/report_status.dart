import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum ReportStatus { sent, inProgress, completed, rejected }

class Report {
  final String id;
  final String userId;
  final String disasterType;
  final String imagePath;
  final double latitude;
  final double longitude;
  final String keterangan;
  final Timestamp timestamp;
  final ReportStatus status;

  Report({
    required this.id,
    required this.userId,
    required this.disasterType,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.keterangan,
    required this.timestamp,
    required this.status,
  });

  factory Report.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Report(
      id: snapshot.id,
      userId: data['userId'] ?? '',
      disasterType: data['disasterType'] ?? '',
      imagePath: data['imageUrl'] ?? '',
      latitude: (data['location'] as GeoPoint).latitude,
      longitude: (data['location'] as GeoPoint).longitude,
      keterangan: data['description'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      status: _getStatusFromString(data['status'] ?? ''),
    );
  }

  static ReportStatus _getStatusFromString(String statusString) {
    switch (statusString) {
      case 'sent':
        return ReportStatus.sent;
      case 'inProgress':
        return ReportStatus.inProgress;
      case 'completed':
        return ReportStatus.completed;
      case 'rejected':
        return ReportStatus.rejected;
      default:
        return ReportStatus.sent;
    }
  }

  Icon getStatusIcon() {
    switch (status) {
      case ReportStatus.sent:
        return Icon(Icons.send);
      case ReportStatus.inProgress:
        return Icon(Icons.hourglass_top);
      case ReportStatus.completed:
        return Icon(Icons.done);
      case ReportStatus.rejected:
        return Icon(Icons.close);
    }
  }

  String getFormattedTimestamp() {
    final DateTime date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }
}
