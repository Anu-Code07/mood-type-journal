import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/glass_panel.dart';
import '../bloc/moodtype_bloc.dart';
import '../bloc/moodtype_event.dart';
import '../bloc/moodtype_state.dart';

class JournalInputCard extends StatefulWidget {
  const JournalInputCard({required this.data, super.key});

  final MoodTypeViewData data;

  @override
  State<JournalInputCard> createState() => _JournalInputCardState();
}

class _JournalInputCardState extends State<JournalInputCard> {
  late final TextEditingController _controller;

  static const List<String> _quickTags = <String>[
    'peaceful',
    'grateful',
    'overwhelmed',
    'healing',
    'focused',
    'late-night',
  ];

  static const List<String> _emojiSet = <String>[
    '😌',
    '🙂',
    '🥹',
    '😵‍💫',
    '🔥',
    '🌧️',
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.data.journalText);
  }

  @override
  void didUpdateWidget(covariant JournalInputCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data.journalText != _controller.text) {
      _controller.text = widget.data.journalText;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'AI Journal Input',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Text(
            'Write your day as it felt. MoodType maps emotion into visual memory.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            maxLines: 6,
            minLines: 6,
            decoration: const InputDecoration(
              hintText:
                  'Today felt peaceful and slow... or maybe exhausted but proud.',
              suffixIcon: _LiveCursorIndicator(),
            ),
            onChanged: (String value) {
              context.read<MoodTypeBloc>().add(JournalTextChanged(value));
            },
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickTags.map((String tag) {
              final bool isSelected = widget.data.quickTags.contains(tag);
              return FilterChip(
                selected: isSelected,
                label: Text(tag),
                onSelected: (_) =>
                    context.read<MoodTypeBloc>().add(QuickTagToggled(tag)),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: Wrap(
                  spacing: 6,
                  children: _emojiSet.map((String emoji) {
                    final bool selected = widget.data.selectedEmoji == emoji;
                    return ChoiceChip(
                      label: Text(emoji),
                      selected: selected,
                      onSelected: (_) =>
                          context.read<MoodTypeBloc>().add(MoodEmojiSelected(emoji)),
                    );
                  }).toList(),
                ),
              ),
              IconButton(
                tooltip: 'Voice-to-text (integration point)',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Voice-to-text can be connected with speech_to_text.'),
                    ),
                  );
                },
                icon: const Icon(Icons.mic_none_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LiveCursorIndicator extends StatefulWidget {
  const _LiveCursorIndicator();

  @override
  State<_LiveCursorIndicator> createState() => _LiveCursorIndicatorState();
}

class _LiveCursorIndicatorState extends State<_LiveCursorIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 850),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      child: const Padding(
        padding: EdgeInsets.only(right: 12),
        child: VerticalDivider(width: 1, thickness: 2),
      ),
    );
  }
}
