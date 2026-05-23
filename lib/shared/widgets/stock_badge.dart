import 'package:flutter/material.dart';
import '../../app/theme.dart';

class StockBadge extends StatelessWidget {
  final String status;
  final bool small;

  const StockBadge({super.key, required this.status, this.small = false});

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 10,
        vertical: small ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: config.$1.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: config.$1.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: small ? 5 : 7,
            height: small ? 5 : 7,
            decoration: BoxDecoration(
              color: config.$1,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: small ? 4 : 5),
          Text(
            config.$2,
            style: TextStyle(
              color: config.$1,
              fontSize: small ? 11 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  (Color, String) _getConfig() {
    switch (status) {
      case 'available':
        return (MedoqColors.greenAvailable, 'Disponible');
      case 'limited':
        return (MedoqColors.orangeLimited, 'Stock limité');
      case 'unavailable':
        return (MedoqColors.redError, 'Indisponible');
      default:
        return (MedoqColors.textSecondary, status);
    }
  }
}
