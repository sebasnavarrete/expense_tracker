import 'package:expense_tracker/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 75, 148, 143),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 99, 125),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) {
    runApp(
      ProviderScope(
        child: MaterialApp(
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: kDarkColorScheme.primary,
            colorScheme: kDarkColorScheme,
            appBarTheme: const AppBarTheme().copyWith(
              backgroundColor: kDarkColorScheme.onPrimaryContainer,
              foregroundColor: kDarkColorScheme.primaryContainer,
            ),
            cardTheme: const CardTheme().copyWith(
              color: kDarkColorScheme.secondaryContainer,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: kDarkColorScheme.primaryContainer,
              ),
            ),
            textTheme: GoogleFonts.ibmPlexSansTextTheme(),
            dropdownMenuTheme: ThemeData().dropdownMenuTheme.copyWith(
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
            snackBarTheme: const SnackBarThemeData().copyWith(
              elevation: 20,
              contentTextStyle: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          theme: ThemeData().copyWith(
            primaryColor: kColorScheme.primary,
            colorScheme: kColorScheme,
            appBarTheme: const AppBarTheme().copyWith(
              backgroundColor: kColorScheme.onPrimaryContainer,
              foregroundColor: kColorScheme.primaryContainer,
            ),
            cardTheme: const CardTheme().copyWith(
              color: kColorScheme.secondaryContainer,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorScheme.primaryContainer,
              ),
            ),
            textTheme: GoogleFonts.ibmPlexSansTextTheme(),
            dropdownMenuTheme: ThemeData().dropdownMenuTheme.copyWith(
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
            snackBarTheme: const SnackBarThemeData().copyWith(
              elevation: 20,
              contentTextStyle: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          themeMode: ThemeMode.light,
          home: const TabsScreen(),
        ),
      ),
    );
  });
}
