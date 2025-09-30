import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  // AI-powered search suggestions
  Future<List<String>> getSearchSuggestions(String query) async {
    try {
      // Simulate AI-powered search suggestions
      // In a real app, you would call an AI API
      final suggestions = <String>[];
      
      if (query.isNotEmpty) {
        // Add common bishop names
        final commonNames = ['يوحنا', 'بولس', 'بطرس', 'مرقس', 'لوقا', 'متى'];
        for (final name in commonNames) {
          if (name.toLowerCase().contains(query.toLowerCase())) {
            suggestions.add(name);
          }
        }
        
        // Add common titles
        final commonTitles = ['مطران', 'أسقف', 'كاهن', 'شماس'];
        for (final title in commonTitles) {
          if (title.toLowerCase().contains(query.toLowerCase())) {
            suggestions.add(title);
          }
        }
        
        // Add common dioceses
        final commonDioceses = ['القاهرة', 'الإسكندرية', 'أسيوط', 'المنيا'];
        for (final diocese in commonDioceses) {
          if (diocese.toLowerCase().contains(query.toLowerCase())) {
            suggestions.add(diocese);
          }
        }
      }
      
      return suggestions.take(5).toList();
    } catch (e) {
      return [];
    }
  }

  // AI-powered data analysis
  Future<Map<String, dynamic>> analyzeBishopData(List<Map<String, dynamic>> bishops) async {
    try {
      final analysis = <String, dynamic>{};
      
      // Count by diocese
      final dioceseCount = <String, int>{};
      for (final bishop in bishops) {
        final diocese = bishop['diocese'] as String? ?? 'غير محدد';
        dioceseCount[diocese] = (dioceseCount[diocese] ?? 0) + 1;
      }
      
      // Count by title
      final titleCount = <String, int>{};
      for (final bishop in bishops) {
        final title = bishop['title'] as String? ?? 'غير محدد';
        titleCount[title] = (titleCount[title] ?? 0) + 1;
      }
      
      // Age analysis
      final ages = <int>[];
      for (final bishop in bishops) {
        final birthDate = bishop['birthDate'] as int?;
        if (birthDate != null) {
          final age = DateTime.now().year - DateTime.fromMillisecondsSinceEpoch(birthDate).year;
          ages.add(age);
        }
      }
      
      analysis['total_bishops'] = bishops.length;
      analysis['diocese_distribution'] = dioceseCount;
      analysis['title_distribution'] = titleCount;
      analysis['average_age'] = ages.isNotEmpty ? ages.reduce((a, b) => a + b) / ages.length : 0;
      analysis['youngest_age'] = ages.isNotEmpty ? ages.reduce((a, b) => a < b ? a : b) : 0;
      analysis['oldest_age'] = ages.isNotEmpty ? ages.reduce((a, b) => a > b ? a : b) : 0;
      
      return analysis;
    } catch (e) {
      return {};
    }
  }

  // AI-powered recommendations
  Future<List<String>> getRecommendations(Map<String, dynamic> userData) async {
    try {
      final recommendations = <String>[];
      
      // Analyze user behavior
      final searchHistory = userData['search_history'] as List<String>? ?? [];
      final favoriteDioceses = userData['favorite_dioceses'] as List<String>? ?? [];
      
      // Recommend based on search history
      if (searchHistory.isNotEmpty) {
        final mostSearched = _getMostFrequentItems(searchHistory);
        for (final item in mostSearched) {
          recommendations.add('قد تكون مهتماً بـ: $item');
        }
      }
      
      // Recommend based on favorite dioceses
      if (favoriteDioceses.isNotEmpty) {
        for (final diocese in favoriteDioceses) {
          recommendations.add('أساقفة جديدون في $diocese');
        }
      }
      
      // General recommendations
      recommendations.add('تصفح أحدث الأساقفة المضافين');
      recommendations.add('استكشف الأبرشيات المختلفة');
      recommendations.add('اطلع على التقارير الإحصائية');
      
      return recommendations.take(5).toList();
    } catch (e) {
      return [];
    }
  }

  // AI-powered text analysis
  Future<Map<String, dynamic>> analyzeText(String text) async {
    try {
      final analysis = <String, dynamic>{};
      
      // Word count
      analysis['word_count'] = text.split(' ').length;
      
      // Character count
      analysis['character_count'] = text.length;
      
      // Language detection (simplified)
      final arabicChars = RegExp(r'[\u0600-\u06FF]');
      final englishChars = RegExp(r'[a-zA-Z]');
      
      final arabicCount = arabicChars.allMatches(text).length;
      final englishCount = englishChars.allMatches(text).length;
      
      if (arabicCount > englishCount) {
        analysis['language'] = 'arabic';
      } else if (englishCount > arabicCount) {
        analysis['language'] = 'english';
      } else {
        analysis['language'] = 'mixed';
      }
      
      // Sentiment analysis (simplified)
      final positiveWords = ['جيد', 'ممتاز', 'رائع', 'جميل', 'مفيد'];
      final negativeWords = ['سيء', 'مؤلم', 'حزين', 'صعب', 'مشكلة'];
      
      int positiveScore = 0;
      int negativeScore = 0;
      
      for (final word in positiveWords) {
        if (text.toLowerCase().contains(word)) {
          positiveScore++;
        }
      }
      
      for (final word in negativeWords) {
        if (text.toLowerCase().contains(word)) {
          negativeScore++;
        }
      }
      
      if (positiveScore > negativeScore) {
        analysis['sentiment'] = 'positive';
      } else if (negativeScore > positiveScore) {
        analysis['sentiment'] = 'negative';
      } else {
        analysis['sentiment'] = 'neutral';
      }
      
      return analysis;
    } catch (e) {
      return {};
    }
  }

  // AI-powered image analysis
  Future<Map<String, dynamic>> analyzeImage(String imagePath) async {
    try {
      // Simulate AI image analysis
      // In a real app, you would call an AI vision API
      final analysis = <String, dynamic>{};
      
      analysis['has_face'] = true; // Simulated
      analysis['face_count'] = 1; // Simulated
      analysis['image_quality'] = 'good'; // Simulated
      analysis['dominant_colors'] = ['blue', 'white', 'black']; // Simulated
      analysis['objects_detected'] = ['person', 'clothing']; // Simulated
      
      return analysis;
    } catch (e) {
      return {};
    }
  }

  // AI-powered data validation
  Future<Map<String, dynamic>> validateBishopData(Map<String, dynamic> bishopData) async {
    try {
      final validation = <String, dynamic>{};
      final errors = <String>[];
      final warnings = <String>[];
      
      // Validate name
      final name = bishopData['name'] as String? ?? '';
      if (name.isEmpty) {
        errors.add('الاسم مطلوب');
      } else if (name.length < 2) {
        warnings.add('الاسم قصير جداً');
      }
      
      // Validate title
      final title = bishopData['title'] as String? ?? '';
      if (title.isEmpty) {
        errors.add('اللقب مطلوب');
      }
      
      // Validate diocese
      final diocese = bishopData['diocese'] as String? ?? '';
      if (diocese.isEmpty) {
        errors.add('الأبرشية مطلوبة');
      }
      
      // Validate dates
      final birthDate = bishopData['birthDate'] as int?;
      final ordinationDate = bishopData['ordinationDate'] as int?;
      
      if (birthDate != null && ordinationDate != null) {
        final birth = DateTime.fromMillisecondsSinceEpoch(birthDate);
        final ordination = DateTime.fromMillisecondsSinceEpoch(ordinationDate);
        
        if (ordination.isBefore(birth)) {
          errors.add('تاريخ الرسامة يجب أن يكون بعد تاريخ الميلاد');
        }
        
        final ageAtOrdination = ordination.year - birth.year;
        if (ageAtOrdination < 25) {
          warnings.add('عمر الرسامة أقل من 25 سنة');
        }
      }
      
      // Validate email
      final email = bishopData['email'] as String? ?? '';
      if (email.isNotEmpty) {
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(email)) {
          errors.add('البريد الإلكتروني غير صحيح');
        }
      }
      
      // Validate phone
      final phone = bishopData['phoneNumber'] as String? ?? '';
      if (phone.isNotEmpty) {
        final phoneRegex = RegExp(r'^[0-9+\-\s()]+$');
        if (!phoneRegex.hasMatch(phone)) {
          errors.add('رقم الهاتف غير صحيح');
        }
      }
      
      validation['is_valid'] = errors.isEmpty;
      validation['errors'] = errors;
      validation['warnings'] = warnings;
      
      return validation;
    } catch (e) {
      return {
        'is_valid': false,
        'errors': ['خطأ في التحقق من البيانات'],
        'warnings': [],
      };
    }
  }

  // AI-powered duplicate detection
  Future<List<Map<String, dynamic>>> findDuplicates(List<Map<String, dynamic>> bishops) async {
    try {
      final duplicates = <Map<String, dynamic>>[];
      final processed = <String>[];
      
      for (int i = 0; i < bishops.length; i++) {
        final bishop1 = bishops[i];
        final id1 = bishop1['id'] as String? ?? '';
        
        if (processed.contains(id1)) continue;
        
        for (int j = i + 1; j < bishops.length; j++) {
          final bishop2 = bishops[j];
          final id2 = bishop2['id'] as String? ?? '';
          
          if (processed.contains(id2)) continue;
          
          // Check for similarity
          final similarity = _calculateSimilarity(bishop1, bishop2);
          if (similarity > 0.8) {
            duplicates.add({
              'bishop1': bishop1,
              'bishop2': bishop2,
              'similarity': similarity,
            });
            processed.add(id1);
            processed.add(id2);
          }
        }
      }
      
      return duplicates;
    } catch (e) {
      return [];
    }
  }

  // Calculate similarity between two bishops
  double _calculateSimilarity(Map<String, dynamic> bishop1, Map<String, dynamic> bishop2) {
    double similarity = 0.0;
    int comparisons = 0;
    
    // Compare names
    final name1 = (bishop1['name'] as String? ?? '').toLowerCase();
    final name2 = (bishop2['name'] as String? ?? '').toLowerCase();
    if (name1.isNotEmpty && name2.isNotEmpty) {
      similarity += _calculateStringSimilarity(name1, name2);
      comparisons++;
    }
    
    // Compare titles
    final title1 = (bishop1['title'] as String? ?? '').toLowerCase();
    final title2 = (bishop2['title'] as String? ?? '').toLowerCase();
    if (title1.isNotEmpty && title2.isNotEmpty) {
      similarity += _calculateStringSimilarity(title1, title2);
      comparisons++;
    }
    
    // Compare dioceses
    final diocese1 = (bishop1['diocese'] as String? ?? '').toLowerCase();
    final diocese2 = (bishop2['diocese'] as String? ?? '').toLowerCase();
    if (diocese1.isNotEmpty && diocese2.isNotEmpty) {
      similarity += _calculateStringSimilarity(diocese1, diocese2);
      comparisons++;
    }
    
    return comparisons > 0 ? similarity / comparisons : 0.0;
  }

  // Calculate string similarity
  double _calculateStringSimilarity(String str1, String str2) {
    if (str1 == str2) return 1.0;
    if (str1.isEmpty || str2.isEmpty) return 0.0;
    
    final longer = str1.length > str2.length ? str1 : str2;
    final shorter = str1.length > str2.length ? str2 : str1;
    
    if (longer.length == 0) return 1.0;
    
    final distance = _levenshteinDistance(longer, shorter);
    return (longer.length - distance) / longer.length;
  }

  // Calculate Levenshtein distance
  int _levenshteinDistance(String str1, String str2) {
    final matrix = List.generate(
      str1.length + 1,
      (i) => List.generate(str2.length + 1, (j) => 0),
    );
    
    for (int i = 0; i <= str1.length; i++) {
      matrix[i][0] = i;
    }
    
    for (int j = 0; j <= str2.length; j++) {
      matrix[0][j] = j;
    }
    
    for (int i = 1; i <= str1.length; i++) {
      for (int j = 1; j <= str2.length; j++) {
        final cost = str1[i - 1] == str2[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    
    return matrix[str1.length][str2.length];
  }

  // Get most frequent items
  List<String> _getMostFrequentItems(List<String> items) {
    final frequency = <String, int>{};
    
    for (final item in items) {
      frequency[item] = (frequency[item] ?? 0) + 1;
    }
    
    final sortedItems = frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedItems.take(3).map((e) => e.key).toList();
  }
}
