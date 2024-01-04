
import 'package:flutter/material.dart';

class OrderUtil {
  static OrderStatus getStatusFromInt(int status) {
    return OrderStatus.values.firstWhere(
          (e) => e.index == status,
      orElse: () => OrderStatus.PENDING, // Default case if status is not found
    );
  }

  static String getLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.PENDING:
        return 'Pending';
      case OrderStatus.PROCESSING:
        return 'Processing';
      case OrderStatus.APPROVED:
        return 'Approved';
      case OrderStatus.REJECTED:
        return 'Rejected';
      case OrderStatus.SHIPPED:
        return 'Shipped';
      case OrderStatus.DELIVERED:
        return 'Delivered';
      case OrderStatus.RECEIVED:
        return 'Received';
      case OrderStatus.INTRANSIT:
        return 'In Transit';
      default:
        return 'Unknown';
    }
  }

  static Color getColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.PENDING:
        return Colors.orange;
      case OrderStatus.PROCESSING:
        return Colors.blue;
      case OrderStatus.APPROVED:
        return Colors.lightGreen;
      case OrderStatus.REJECTED:
        return Colors.red;
      case OrderStatus.SHIPPED:
        return Colors.purple;
      case OrderStatus.DELIVERED:
        return Colors.green;
      case OrderStatus.RECEIVED:
        return Colors.deepOrange;
      case OrderStatus.INTRANSIT:
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  static Widget statusChip(int statusValue) {
    OrderStatus status = getStatusFromInt(statusValue);
    return Chip(
      label: Text(getLabel(status), style: const TextStyle(color: Colors.white)),
      backgroundColor: getColor(status),
    );
  }

  static Widget statusText(int statusValue) {
    OrderStatus status = getStatusFromInt(statusValue);
    return Text(
        getLabel(status),
        style: TextStyle(color: getColor(status)),
    );
  }


}

enum OrderStatus {
  REJECTED,
  PENDING,
  PROCESSING,
  APPROVED,
  SHIPPED,
  DELIVERED,
  RECEIVED,
  INTRANSIT,
}
