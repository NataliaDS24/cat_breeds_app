import 'package:cat_breeds_app/domain/entities/breed.dart';
import 'package:flutter/material.dart';

class DetailCardProvider extends ChangeNotifier {
  final Breed breed;

  DetailCardProvider({
    required this.breed,
  });
}
