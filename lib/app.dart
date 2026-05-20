import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/journal/data/datasources/fake_ai_mood_datasource.dart';
import 'features/journal/data/datasources/local_journal_datasource.dart';
import 'features/journal/data/repositories/moodtype_repository_impl.dart';
import 'features/journal/domain/usecases/analyze_journal_entry.dart';
import 'features/journal/domain/usecases/generate_wallpaper_preview.dart';
import 'features/journal/domain/usecases/get_mood_timeline.dart';
import 'features/journal/domain/usecases/save_journal_experience.dart';
import 'features/journal/presentation/bloc/moodtype_bloc.dart';
import 'features/journal/presentation/pages/moodtype_home_page.dart';

class MoodTypeApp extends StatelessWidget {
  const MoodTypeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final MoodTypeRepositoryImpl repository = MoodTypeRepositoryImpl(
      moodAiDatasource: const FakeAiMoodDatasource(),
      localJournalDatasource: const LocalJournalDatasource(),
    );

    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<MoodTypeBloc>(
          create: (_) => MoodTypeBloc(
            analyzeJournalEntry: AnalyzeJournalEntry(repository),
            generateWallpaperPreview: GenerateWallpaperPreview(repository),
            saveJournalExperience: SaveJournalExperience(repository),
            getMoodTimeline: GetMoodTimeline(repository),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkEmotionTheme,
        home: const MoodTypeHomePage(),
      ),
    );
  }
}
