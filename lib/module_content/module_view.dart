import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../data/content_repository.dart';
import '../../models/app_copy.dart';
import '../../shared/widgets.dart';

class ModuleScreen extends StatelessWidget {
  const ModuleScreen({
    super.key,
    required this.copy,
    required this.moduleId,
    required this.progress,
    required this.onCompleteComponent,
    required this.onBack,
  });
  final AppCopy copy;
  final String moduleId;
  final double progress;
  final Future<void> Function(
    String moduleId,
    String componentId,
    Iterable<String> requiredComponentIds,
  )
  onCompleteComponent;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 18, 20, 48),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 430),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
              label: Text(copy.back),
            ),
            const SizedBox(height: 17),
            Text(
              copy.strings['part_one'],
              style: const TextStyle(
                color: AppColors.violet,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              copy.core,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              copy.moduleSummary,
              style: const TextStyle(color: Color(0xFF716B80)),
            ),
            const SizedBox(height: 14),
            Text(
              '${(progress * 100).round()}%',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            LinearProgressIndicator(
              value: progress,
              color: AppColors.violet,
              backgroundColor: AppColors.lilac,
            ),
            const SizedBox(height: 24),
            MarkdownModule(
              copy: copy,
              moduleId: moduleId,
              onCompleteComponent: onCompleteComponent,
            ),
          ],
        ),
      ),
    ),
  );
}

class MarkdownModule extends StatelessWidget {
  const MarkdownModule({
    super.key,
    required this.copy,
    required this.moduleId,
    required this.onCompleteComponent,
  });
  final AppCopy copy;
  final String moduleId;
  final Future<void> Function(
    String moduleId,
    String componentId,
    Iterable<String> requiredComponentIds,
  )
  onCompleteComponent;
  @override
  Widget build(BuildContext context) => FutureBuilder<String>(
    future: ContentRepository().loadModuleMarkdown(moduleId, copy.locale),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        );
      }
      final blocks = _markdownBlocks(snapshot.data!);
      final componentIds = blocks
          .map((block) => block.componentId)
          .whereType<String>()
          .toList();
      return _LessonFlow(
        children: [
          for (final block in blocks)
            LessonCard(
              kind: copy.strings['content'],
              title: block.title,
              body: block.body,
              media:
                  block.title.startsWith('Film') ||
                  block.title.startsWith('Video:'),
              onComplete: block.componentId == null
                  ? null
                  : () => onCompleteComponent(
                      moduleId,
                      block.componentId!,
                      componentIds,
                    ),
            ),
        ],
      );
    },
  );

  List<_MarkdownBlock> _markdownBlocks(String source) =>
      source.trim().split('\n## ').map((section) {
        final lines = section.replaceFirst(RegExp(r'^#\s*'), '').split('\n');
        final body = lines.skip(1).join('\n').trim();
        final component = RegExp(
          r'<!--\s*component:\s*([^\s>]+)\s+required\s*-->',
        ).firstMatch(body);
        return _MarkdownBlock(
          lines.first.trim(),
          body.replaceFirst(component?.group(0) ?? '', '').trim(),
          component?.group(1),
        );
      }).toList();
}

class _MarkdownBlock {
  const _MarkdownBlock(this.title, this.body, this.componentId);
  final String title, body;
  final String? componentId;
}

class _LessonFlow extends StatelessWidget {
  const _LessonFlow({required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned(
        left: 0,
        right: 0,
        top: 20,
        bottom: 20,
        child: Center(
          child: Container(
            width: 4,
            decoration: BoxDecoration(
              color: AppColors.mint.withValues(alpha: .75),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
      Column(children: children),
    ],
  );
}

class LessonCard extends StatelessWidget {
  const LessonCard({
    super.key,
    required this.kind,
    required this.title,
    this.body,
    this.media = false,
    this.characters = false,
    this.onComplete,
  });
  final String kind, title;
  final String? body;
  final bool media, characters;
  final Future<void> Function()? onComplete;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(
      left: media ? 20 : 0,
      right: media ? 0 : 20,
      bottom: 18,
    ),
    child: SoftPanel(
      accent: media ? AppColors.mint : AppColors.peach,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            kind,
            style: const TextStyle(
              color: AppColors.violet,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 7),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          if (body != null) ...[
            const SizedBox(height: 8),
            Text(body!, style: const TextStyle(fontSize: 14)),
          ],
          if (media) ...[const SizedBox(height: 14), const MediaPlaceholder()],
          if (characters) ...[const SizedBox(height: 14), const CharacterRow()],
          if (onComplete != null) ...[
            const SizedBox(height: 14),
            FilledButton(
              onPressed: onComplete,
              child: const Text('Markera som klar'),
            ),
          ],
        ],
      ),
    ),
  );
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key, required this.copy});
  final AppCopy copy;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 20, bottom: 18),
    child: SoftPanel(
      accent: AppColors.butter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            copy.strings['assignment'],
            style: const TextStyle(
              color: AppColors.violet,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 7),
          Text(copy.activity, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            copy.strings['activity_intro'],
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          ExpansionTile(
            title: Text(copy.strings['activity_examples']),
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(copy.strings['activity_examples_placeholder']),
              ),
            ],
          ),
          _Question(label: copy.strings['activity_what']),
          _Question(label: copy.strings['activity_when']),
          _Question(label: copy.strings['activity_feeling']),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {},
            child: Text(copy.strings['save_plan']),
          ),
        ],
      ),
    ),
  );
}

class _Question extends StatelessWidget {
  const _Question({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 14),
    child: TextField(decoration: InputDecoration(labelText: label)),
  );
}

class MediaPlaceholder extends StatelessWidget {
  const MediaPlaceholder({super.key});
  @override
  Widget build(BuildContext context) => Container(
    height: 110,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.sky, AppColors.lilac, AppColors.peach],
      ),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(18),
        topRight: Radius.circular(11),
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(18),
      ),
    ),
    child: const Center(
      child: Icon(Icons.play_arrow_rounded, size: 52, color: AppColors.violet),
    ),
  );
}

class CharacterRow extends StatelessWidget {
  const CharacterRow({super.key});
  @override
  Widget build(BuildContext context) => const Row(
    children: [
      Expanded(child: CharacterBadge(name: 'Noa')),
      SizedBox(width: 8),
      Expanded(child: CharacterBadge(name: 'Yasmin')),
      SizedBox(width: 8),
      Expanded(child: CharacterBadge(name: 'Kim')),
    ],
  );
}

class CharacterBadge extends StatelessWidget {
  const CharacterBadge({super.key, required this.name});
  final String name;
  @override
  Widget build(BuildContext context) => Container(
    height: 74,
    alignment: Alignment.bottomCenter,
    padding: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: AppColors.lilac, width: 2),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}
