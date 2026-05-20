import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/moodtype_repository.dart';
import '../models/journal_entry_model.dart';
import '../models/mood_profile_model.dart';
import '../models/wallpaper_preview_model.dart';

class LocalJournalDatasource {
  const LocalJournalDatasource();

  static const String _timelineKey = 'moodtype_timeline_v1';

  Future<void> saveTimelineItem({
    required JournalEntryModel entry,
    required MoodProfileModel moodProfile,
    required WallpaperPreviewModel wallpaper,
  }) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final List<String> cachedItems =
        preferences.getStringList(_timelineKey) ?? <String>[];

    final Map<String, dynamic> payload = <String, dynamic>{
      'entry': entry.toMap(),
      'moodProfile': moodProfile.toMap(),
      'wallpaper': wallpaper.toMap(),
    };

    cachedItems.insert(0, jsonEncode(payload));
    await preferences.setStringList(_timelineKey, cachedItems.take(100).toList());
  }

  Future<List<JournalTimelineItem>> fetchTimelineItems() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final List<String> cachedItems =
        preferences.getStringList(_timelineKey) ?? <String>[];

    return cachedItems.map((String raw) {
      final Map<String, dynamic> json =
          (jsonDecode(raw) as Map<Object?, Object?>).cast<String, dynamic>();
      final JournalEntryModel entry =
          JournalEntryModel.fromMap(json['entry'] as Map<String, dynamic>? ?? <String, dynamic>{});
      final MoodProfileModel profile =
          MoodProfileModel.fromMap(json['moodProfile'] as Map<String, dynamic>? ?? <String, dynamic>{});
      final WallpaperPreviewModel wallpaper = WallpaperPreviewModel.fromMap(
        json['wallpaper'] as Map<String, dynamic>? ?? <String, dynamic>{},
      );

      return JournalTimelineItem(
        entry: entry,
        moodProfile: profile,
        wallpaperPreview: wallpaper,
      );
    }).toList();
  }
}
