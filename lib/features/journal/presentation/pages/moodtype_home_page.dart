import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/animated_ambient_background.dart';
import '../bloc/moodtype_bloc.dart';
import '../bloc/moodtype_event.dart';
import '../bloc/moodtype_state.dart';
import '../widgets/journal_input_card.dart';
import '../widgets/mood_timeline_panel.dart';
import '../widgets/typography_transformer_panel.dart';
import '../widgets/wallpaper_preview_card.dart';

class MoodTypeHomePage extends StatelessWidget {
  const MoodTypeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MoodTypeBloc, MoodTypeState>(
      listenWhen: (MoodTypeState previous, MoodTypeState current) =>
          current is MoodTypeError || current is MoodTypeSaved,
      listener: (BuildContext context, MoodTypeState state) {
        if (state is MoodTypeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is MoodTypeSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Memory saved to your mood timeline.')),
          );
        }
      },
      builder: (BuildContext context, MoodTypeState state) {
        final MoodTypeViewData data = state.data;
        final List<Color> palette = _toColors(data);

        return AnimatedAmbientBackground(
          palette: palette,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text('MoodType Journal'),
              centerTitle: false,
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Chip(
                    label: Text(
                      data.moodProfile?.aestheticTheme ?? 'future memory lab',
                    ),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    JournalInputCard(data: data),
                    const SizedBox(height: 16),
                    TypographyTransformerPanel(data: data),
                    const SizedBox(height: 16),
                    WallpaperPreviewCard(data: data),
                    const SizedBox(height: 16),
                    MoodTimelinePanel(items: data.timeline),
                  ]
                      .animate(interval: 120.ms)
                      .fadeIn(duration: 420.ms)
                      .slideY(begin: 0.06, end: 0),
                ),
              ),
            ),
            bottomSheet: _ActionDock(state: state),
          ),
        );
      },
    );
  }

  List<Color> _toColors(MoodTypeViewData data) {
    if (data.moodProfile == null || data.moodProfile!.palette.isEmpty) {
      return const <Color>[
        Color(0xFF0F172A),
        Color(0xFF111827),
        Color(0xFF4C1D95),
      ];
    }
    return data.moodProfile!.palette.map((int value) => Color(value)).toList();
  }
}

class _ActionDock extends StatelessWidget {
  const _ActionDock({required this.state});

  final MoodTypeState state;

  @override
  Widget build(BuildContext context) {
    final bool isLoading = state is MoodTypeLoading || state is MoodTypeSaving;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: FilledButton.icon(
              onPressed: isLoading
                  ? null
                  : () => context.read<MoodTypeBloc>().add(const AnalyzePressed()),
              icon: const Icon(Icons.auto_awesome),
              label: Text(isLoading ? 'Crafting...' : 'Transform Mood'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: isLoading
                  ? null
                  : () => context
                      .read<MoodTypeBloc>()
                      .add(const SaveJournalExperiencePressed()),
              icon: const Icon(Icons.download),
              label: const Text('Save Memory'),
            ),
          ),
        ],
      ),
    );
  }
}
