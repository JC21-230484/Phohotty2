import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class GoogleVisionService {
  final String apiKey;

  GoogleVisionService({required this.apiKey});

  Future<List<String>> analyzeLabels(Uint8List bytes) async {
    if (apiKey.isEmpty) {
      throw Exception('Google Vision API key is empty. Provide a valid key.');
    }

    final base64Image = base64Encode(bytes);

    final url = Uri.parse(
      'https://vision.googleapis.com/v1/images:annotate?key=$apiKey',
    );

    final body = {
      'requests': [
        {
          'image': {'content': base64Image},
          'features': [
            {'type': 'LABEL_DETECTION', 'maxResults': 10}
          ],
          'imageContext': {
            'languageHints': ['ja']
          }
        }
      ]
    };

    final response = await http
        .post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Vision API error (${response.statusCode}): ${response.body}');
    }

    final result = jsonDecode(response.body);
    if (result['responses'] == null || result['responses'].isEmpty) {
      return [];
    }

    final labels = result['responses'][0]['labelAnnotations'];
    if (labels == null) return [];

    // Safely map descriptions and remove duplicates
    final out = <String>{};
    for (final e in labels) {
      final desc = e['description'];
      if (desc is String && desc.isNotEmpty) out.add(desc);
    }

    return out.toList();
  }
}