import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class Helper {
  IconData? deserializeIconString(String icon) {
    if (icon.isEmpty) {
      return const IconData(0xe3af, fontFamily: 'MaterialIcons');
    }
    final iconData = jsonDecode(icon);
    return deserializeIcon(Map<String, dynamic>.from(iconData),
        iconPack: IconPack.allMaterial);
  }
}
