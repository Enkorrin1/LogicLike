import 'package:flutter/material.dart';

import '../../domain/daily_challenge.dart';
import '../../domain/family_profile.dart';
import '../../theme/app_theme.dart';
import '../../widgets/playful_ui.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({
    required this.profile,
    required this.onChallengeComplete,
    required this.onPracticeComplete,
    super.key,
  });

  final FamilyProfile profile;
  final Future<void> Function(DailyChallenge challenge) onChallengeComplete;
  final Future<void> Function(DailyChallenge challenge) onPracticeComplete;

  @override
  Widget build(BuildContext context) {
    final daily = dailyChallengesForAge(profile.childAge);
    final areas = puzzleAreasForAge(profile.childAge);
    final completedToday = profile.completedOn(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: const Text('Игры для мозга')),
      body: PlayfulBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          children: [
            _DailyQuestPanel(
              completedToday: completedToday,
              daily: daily,
              onStart: (puzzle, index) => _openPuzzle(
                context,
                puzzle: puzzle,
                number: index + 1,
                total: daily.length,
                mode: _PuzzleMode.daily,
                completedToday: completedToday,
              ),
            ),
            const SizedBox(height: 18),
            _BrainGymHeader(areasCount: areas.length),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: areas.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
              itemBuilder: (context, index) {
                final area = areas[index];
                return _BrainAreaCard(
                  area: area,
                  color: _areaColor(index),
                  icon: _areaIcon(area.id),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => _PuzzleAreaScreen(
                          area: area,
                          areaIndex: index,
                          onStart: (puzzle, puzzleIndex) => _openPuzzle(
                            context,
                            puzzle: puzzle,
                            number: puzzleIndex + 1,
                            total: area.puzzles.length,
                            mode: _PuzzleMode.practice,
                            completedToday: completedToday,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openPuzzle(
    BuildContext context, {
    required DailyChallenge puzzle,
    required int number,
    required int total,
    required _PuzzleMode mode,
    required bool completedToday,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _PuzzlePlayScreen(
          puzzle: puzzle,
          number: number,
          total: total,
          mode: mode,
          completedToday: completedToday,
          onComplete: () {
            return mode == _PuzzleMode.daily
                ? onChallengeComplete(puzzle)
                : onPracticeComplete(puzzle);
          },
        ),
      ),
    );
  }
}

enum _PuzzleMode { daily, practice }

class _DailyQuestPanel extends StatelessWidget {
  const _DailyQuestPanel({
    required this.completedToday,
    required this.daily,
    required this.onStart,
  });

  final bool completedToday;
  final List<DailyChallenge> daily;
  final void Function(DailyChallenge puzzle, int index) onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF2A8), Color(0xFFFFB6C7), Color(0xFFA9F4E8)],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppPalette.coral.withValues(alpha: 0.18),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconBadge(
                icon: Icons.local_fire_department_rounded,
                color: Colors.white,
                iconColor: AppPalette.coral,
                size: 58,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      completedToday
                          ? 'День закрыт'
                          : 'Обязательное на сегодня',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      completedToday
                          ? 'Награда получена. Можно повторять или играть свободно.'
                          : 'Пройди эти задания, чтобы сохранить серию.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppPalette.ink,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < daily.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == daily.length - 1 ? 0 : 10),
              child: _DailyQuestRow(
                puzzle: daily[i],
                index: i,
                completedToday: completedToday,
                onTap: () => onStart(daily[i], i),
              ),
            ),
        ],
      ),
    );
  }
}

class _DailyQuestRow extends StatelessWidget {
  const _DailyQuestRow({
    required this.puzzle,
    required this.index,
    required this.completedToday,
    required this.onTap,
  });

  final DailyChallenge puzzle;
  final int index;
  final bool completedToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.82),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              IconBadge(
                icon: completedToday ? Icons.replay_rounded : _dailyIcon(index),
                color: _areaColor(index).withValues(alpha: 0.28),
                iconColor: _areaColor(index),
                size: 50,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      puzzle.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      puzzle.skill,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              InfoPill(
                icon: Icons.timer_rounded,
                label: '${puzzle.minutes} мин',
                color: AppPalette.surfaceBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrainGymHeader extends StatelessWidget {
  const _BrainGymHeader({required this.areasCount});

  final int areasCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const IconBadge(
          icon: Icons.psychology_alt_rounded,
          color: Color(0xFFEDEAFF),
          iconColor: AppPalette.lavender,
          size: 46,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Тренажер мозга',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                '$areasCount областей, играй в любом порядке',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BrainAreaCard extends StatelessWidget {
  const _BrainAreaCard({
    required this.area,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final BrainArea area;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.96),
                color.withValues(alpha: 0.62)
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.22),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconBadge(
                icon: icon,
                color: Colors.white.withValues(alpha: 0.86),
                iconColor: AppPalette.ink,
                size: 54,
              ),
              const Spacer(),
              Text(
                area.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                area.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.extension_rounded,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 5),
                  Text(
                    '${area.puzzles.length} игры',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PuzzleAreaScreen extends StatelessWidget {
  const _PuzzleAreaScreen({
    required this.area,
    required this.areaIndex,
    required this.onStart,
  });

  final BrainArea area;
  final int areaIndex;
  final void Function(DailyChallenge puzzle, int index) onStart;

  @override
  Widget build(BuildContext context) {
    final color = _areaColor(areaIndex);

    return Scaffold(
      appBar: AppBar(title: Text(area.title)),
      body: PlayfulBackground(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          itemCount: area.puzzles.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _AreaHero(
                  area: area, color: color, icon: _areaIcon(area.id));
            }

            final puzzleIndex = index - 1;
            final puzzle = area.puzzles[puzzleIndex];
            return _FreePuzzleCard(
              puzzle: puzzle,
              color: color,
              onTap: () => onStart(puzzle, puzzleIndex),
            );
          },
        ),
      ),
    );
  }
}

class _AreaHero extends StatelessWidget {
  const _AreaHero({
    required this.area,
    required this.color,
    required this.icon,
  });

  final BrainArea area;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.62)],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: Row(
        children: [
          IconBadge(
            icon: icon,
            color: Colors.white.withValues(alpha: 0.9),
            iconColor: AppPalette.ink,
            size: 64,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  area.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  area.subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FreePuzzleCard extends StatelessWidget {
  const _FreePuzzleCard({
    required this.puzzle,
    required this.color,
    required this.onTap,
  });

  final DailyChallenge puzzle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PlayfulCard(
      borderColor: color.withValues(alpha: 0.35),
      child: Row(
        children: [
          IconBadge(
            icon: Icons.auto_awesome_rounded,
            color: color.withValues(alpha: 0.22),
            iconColor: color,
            size: 54,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(puzzle.title,
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  puzzle.prompt,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          IconButton.filled(
            onPressed: onTap,
            icon: const Icon(Icons.play_arrow_rounded),
            style: IconButton.styleFrom(backgroundColor: color),
          ),
        ],
      ),
    );
  }
}

class _PuzzlePlayScreen extends StatefulWidget {
  const _PuzzlePlayScreen({
    required this.puzzle,
    required this.number,
    required this.total,
    required this.mode,
    required this.completedToday,
    required this.onComplete,
  });

  final DailyChallenge puzzle;
  final int number;
  final int total;
  final _PuzzleMode mode;
  final bool completedToday;
  final Future<void> Function() onComplete;

  @override
  State<_PuzzlePlayScreen> createState() => _PuzzlePlayScreenState();
}

class _PuzzlePlayScreenState extends State<_PuzzlePlayScreen> {
  String? _selectedAnswer;
  bool _showHint = false;
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (_selectedAnswer == null || _isSubmitting) {
      return;
    }

    setState(() => _isSubmitting = true);
    await widget.onComplete();

    if (!mounted) {
      return;
    }

    setState(() => _isSubmitting = false);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            widget.mode == _PuzzleMode.daily && !widget.completedToday
                ? 'Задание дня засчитано!'
                : 'Отличная тренировка!',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final isDaily = widget.mode == _PuzzleMode.daily;

    return Scaffold(
      appBar: AppBar(title: Text(isDaily ? 'Задание дня' : 'Головоломка')),
      body: PlayfulBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
          children: [
            _ProgressHeader(
              current: widget.number,
              total: widget.total,
              label: isDaily ? 'Ежедневный путь' : 'Свободная игра',
            ),
            const SizedBox(height: 16),
            PlayfulCard(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TaskIntro(puzzle: widget.puzzle),
                  const SizedBox(height: 18),
                  const _PatternStrip(),
                  const SizedBox(height: 18),
                  _QuestionBubble(prompt: widget.puzzle.prompt),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: () => setState(() => _showHint = !_showHint),
                    icon: Icon(
                      _showHint
                          ? Icons.visibility_off_rounded
                          : Icons.tips_and_updates_rounded,
                    ),
                    label: Text(
                        _showHint ? 'Скрыть подсказку' : 'Показать подсказку'),
                  ),
                  if (_showHint) ...[
                    const SizedBox(height: 12),
                    const _HintBox(),
                  ],
                  const SizedBox(height: 16),
                  for (final option in _answerOptions)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _AnswerOption(
                        option: option,
                        selected: _selectedAnswer == option.label,
                        onTap: () =>
                            setState(() => _selectedAnswer = option.label),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _StickyAnswerBar(
        enabled: _selectedAnswer != null,
        loading: _isSubmitting,
        selectedAnswer: _selectedAnswer,
        onSubmit: _submit,
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.current,
    required this.total,
    required this.label,
  });

  final int current;
  final int total;
  final String label;

  @override
  Widget build(BuildContext context) {
    return PlayfulCard(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      borderColor: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 3),
                Text(
                  'Шаг $current из $total',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: (current / total).clamp(0, 1).toDouble(),
                    minHeight: 12,
                    backgroundColor: AppPalette.mint.withValues(alpha: 0.42),
                    valueColor: const AlwaysStoppedAnimation(AppPalette.teal),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          const InfoPill(
            icon: Icons.favorite_rounded,
            label: '5',
            color: Color(0xFFFFE8F0),
          ),
        ],
      ),
    );
  }
}

class _TaskIntro extends StatelessWidget {
  const _TaskIntro({required this.puzzle});

  final DailyChallenge puzzle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const IconBadge(
          icon: Icons.help_rounded,
          color: Color(0xFFFFECA8),
          iconColor: AppPalette.teal,
          size: 58,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(puzzle.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(puzzle.skill, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _PatternStrip extends StatelessWidget {
  const _PatternStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6DE),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _PatternItem(shape: _PatternShape.circle, color: AppPalette.teal),
          _PatternItem(shape: _PatternShape.square, color: Color(0xFF5F8BEF)),
          _PatternItem(shape: _PatternShape.circle, color: AppPalette.teal),
          _PatternItem(shape: _PatternShape.square, color: Color(0xFF5F8BEF)),
          _PatternQuestion(),
        ],
      ),
    );
  }
}

enum _PatternShape { circle, square }

class _PatternItem extends StatelessWidget {
  const _PatternItem({required this.shape, required this.color});

  final _PatternShape shape;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppPalette.ink.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Container(
        width: 29,
        height: 29,
        decoration: BoxDecoration(
          color: color,
          shape: shape == _PatternShape.circle
              ? BoxShape.circle
              : BoxShape.rectangle,
          borderRadius:
              shape == _PatternShape.square ? BorderRadius.circular(7) : null,
        ),
      ),
    );
  }
}

class _PatternQuestion extends StatelessWidget {
  const _PatternQuestion();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFFFE89A),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: const Text(
        '?',
        style: TextStyle(
          color: Color(0xFFFF9F2E),
          fontSize: 28,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _QuestionBubble extends StatelessWidget {
  const _QuestionBubble({required this.prompt});

  final String prompt;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppPalette.surfaceBlue,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(prompt, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

class _HintBox extends StatelessWidget {
  const _HintBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4CF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppPalette.mango),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_rounded, color: Color(0xFFFFA726)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Правило повторяется. Найди начало нового повтора.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF7A5A1A),
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerOptionData {
  const _AnswerOptionData({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

const _answerOptions = [
  _AnswerOptionData(
    label: 'Треугольник',
    icon: Icons.change_history_rounded,
    color: Color(0xFFECE8FF),
  ),
  _AnswerOptionData(
    label: 'Круг',
    icon: Icons.circle_rounded,
    color: Color(0xFFDDF7F3),
  ),
  _AnswerOptionData(
    label: 'Квадрат',
    icon: Icons.square_rounded,
    color: Color(0xFFE4EDFF),
  ),
];

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _AnswerOptionData option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:
              selected ? AppPalette.mint.withValues(alpha: 0.44) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppPalette.teal : AppPalette.border,
            width: selected ? 2 : 1.2,
          ),
        ),
        child: Row(
          children: [
            IconBadge(
              icon: option.icon,
              color: option.color,
              iconColor: selected ? AppPalette.teal : AppPalette.lavender,
              size: 50,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(option.label,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppPalette.teal,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}

class _StickyAnswerBar extends StatelessWidget {
  const _StickyAnswerBar({
    required this.enabled,
    required this.loading,
    required this.selectedAnswer,
    required this.onSubmit,
  });

  final bool enabled;
  final bool loading;
  final String? selectedAnswer;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppPalette.surface,
        boxShadow: [
          BoxShadow(
            color: AppPalette.ink.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedAnswer == null
                      ? 'Выбери ответ'
                      : 'Ответ: $selectedAnswer',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: enabled ? AppPalette.ink : AppPalette.muted,
                      ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 170,
                child: FilledButton.icon(
                  onPressed: enabled && !loading ? onSubmit : null,
                  icon: loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_rounded),
                  label: Text(loading ? 'Проверяем' : 'Проверить'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _areaColor(int index) {
  return switch (index % 5) {
    0 => AppPalette.coral,
    1 => AppPalette.lavender,
    2 => AppPalette.teal,
    3 => AppPalette.mango,
    _ => AppPalette.sky,
  };
}

IconData _areaIcon(String id) {
  return switch (id) {
    'logic' => Icons.psychology_alt_rounded,
    'memory' => Icons.style_rounded,
    'attention' => Icons.center_focus_strong_rounded,
    'math' => Icons.calculate_rounded,
    _ => Icons.grid_view_rounded,
  };
}

IconData _dailyIcon(int index) {
  return switch (index) {
    0 => Icons.looks_one_rounded,
    1 => Icons.looks_two_rounded,
    _ => Icons.looks_3_rounded,
  };
}
