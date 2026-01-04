import 'package:dream_reader/domain/entities/dream_response.dart';

abstract class DreamAnalysisRepository {
  Future<DreamResponse> analyzeDream(String text);
  Future<void> updateDreamImage(int index, String imageUrl);
  List<dynamic> getDreams();
  Future<void> seedDatabase();
}
