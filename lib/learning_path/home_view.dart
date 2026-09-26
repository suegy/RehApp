import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../module_content/module_view.dart';
import '../../models/app_copy.dart';
import '../../models/app_content.dart';
import '../../shared/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.locale,
    required this.strings,
    required this.modules,
    required this.progressFor,
    required this.onCompleteComponent,
    required this.onLocaleChanged,
    required this.onLogout,
  });
  final String locale;
  final AppStrings strings;
  final List<ModuleDefinition> modules;
  final double Function(String moduleId) progressFor;
  final Future<void> Function(
    String moduleId,
    String componentId,
    Iterable<String> requiredComponentIds,
  )
  onCompleteComponent;
  final ValueChanged<String> onLocaleChanged;
  final VoidCallback onLogout;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _menuOpen = false;
  String? _selectedModuleId;
  @override
  Widget build(BuildContext context) {
    final copy = AppCopy(widget.locale, widget.strings);
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: MaterialTexture(color: AppColors.paper)),
          SafeArea(
            child: Column(
              children: [
                AppHeader(
                  copy: copy,
                  menuOpen: _menuOpen,
                  onMenuOpen: (value) => setState(() => _menuOpen = value),
                  onLocaleChanged: widget.onLocaleChanged,
                  onLogout: widget.onLogout,
                ),
                NoticeBanner(copy: copy),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollUpdateNotification &&
                          _menuOpen) {
                        setState(() => _menuOpen = false);
                      }
                      return false;
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: _selectedModuleId != null
                          ? ModuleScreen(
                              copy: copy,
                              moduleId: _selectedModuleId!,
                              progress: widget.progressFor(_selectedModuleId!),
                              onCompleteComponent: widget.onCompleteComponent,
                              onBack: () =>
                                  setState(() => _selectedModuleId = null),
                            )
                          : PathScreen(
                              copy: copy,
                              modules: widget.modules,
                              progressFor: widget.progressFor,
                              onOpenModule: (moduleId) =>
                                  setState(() => _selectedModuleId = moduleId),
                            ),
                    ),
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

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.copy,
    required this.menuOpen,
    required this.onMenuOpen,
    required this.onLocaleChanged,
    required this.onLogout,
  });
  final AppCopy copy;
  final bool menuOpen;
  final ValueChanged<bool> onMenuOpen;
  final ValueChanged<String> onLocaleChanged;
  final VoidCallback onLogout;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => onMenuOpen(true),
    child: Material(
      color: AppColors.violet,
      child: Column(
        children: [
          SizedBox(
            height: 70,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  const BrandMark(light: true),
                  const Spacer(),
                  IconButton(
                    tooltip: copy.strings['menu'],
                    onPressed: () => onMenuOpen(!menuOpen),
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            child: menuOpen
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            copy.about,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        LocaleToggle(
                          locale: copy.locale,
                          onChanged: onLocaleChanged,
                          light: true,
                        ),
                        TextButton(
                          onPressed: onLogout,
                          child: Text(
                            copy.logout,
                            style: const TextStyle(color: AppColors.butter),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    ),
  );
}

class NoticeBanner extends StatelessWidget {
  const NoticeBanner({super.key, required this.copy});
  final AppCopy copy;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    color: AppColors.butter,
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 13,
          backgroundColor: AppColors.peach,
          child: Icon(Icons.priority_high, color: AppColors.plum, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                copy.noticeTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(copy.noticeBody, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ],
    ),
  );
}

class PathScreen extends StatelessWidget {
  const PathScreen({
    super.key,
    required this.copy,
    required this.modules,
    required this.progressFor,
    required this.onOpenModule,
  });
  final AppCopy copy;
  final List<ModuleDefinition> modules;
  final double Function(String moduleId) progressFor;
  final ValueChanged<String> onOpenModule;
  @override
  Widget build(BuildContext context) {
    final core = modules[0];
    final following = modules.skip(1).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 44),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 390),
          child: Stack(
            children: [
              const Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: RootPathPainter()),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    copy.pathNow.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.violet,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    copy.welcomeBack,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    copy.pathIntro,
                    style: const TextStyle(color: Color(0xFF716B80)),
                  ),
                  const SizedBox(height: 28),
                  ModuleBubble(
                    number: '01',
                    title: copy.strings[core.titleKey],
                    detail: copy.strings[core.detailKey],
                    status: copy.inProgress,
                    active: true,
                    progress: progressFor(core.id),
                    actionLabel: copy.continueText,
                    onPressed: () => onOpenModule(core.id),
                  ),
                  const SizedBox(height: 28),
                  for (final entry in following.indexed) ...[
                    _FollowUpPosition(
                      index: entry.$1,
                      child: FollowUpBubble(
                        number: (entry.$1 + 2).toString().padLeft(2, '0'),
                        title: copy.strings[entry.$2.titleKey],
                        status: copy.later,
                        detail: copy.strings[entry.$2.detailKey],
                        locked: copy.locked,
                      ),
                    ),
                    const SizedBox(height: 22),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FollowUpPosition extends StatelessWidget {
  const _FollowUpPosition({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (index.isEven) {
      return Align(alignment: Alignment.centerRight, child: child);
    }
    return Padding(padding: const EdgeInsets.only(left: 28), child: child);
  }
}

class ModuleBubble extends StatelessWidget {
  const ModuleBubble({
    super.key,
    required this.number,
    required this.title,
    required this.detail,
    required this.status,
    required this.active,
    required this.progress,
    required this.actionLabel,
    required this.onPressed,
  });
  final String number, title, detail, status, actionLabel;
  final bool active;
  final double progress;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => SoftPanel(
    accent: active ? AppColors.butter : AppColors.mint,
    child: Stack(
      children: [
        Positioned(right: 8, top: 2, child: NumberBadge(number: number)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusPill(label: status),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 45),
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(height: 8),
            Text(detail, style: const TextStyle(fontSize: 14)),
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
            const SizedBox(height: 16),
            FilledButton(onPressed: onPressed, child: Text(actionLabel)),
          ],
        ),
      ],
    ),
  );
}

class FollowUpBubble extends StatefulWidget {
  const FollowUpBubble({
    super.key,
    required this.number,
    required this.title,
    required this.status,
    required this.detail,
    required this.locked,
  });
  final String number, title, status, detail, locked;
  @override
  State<FollowUpBubble> createState() => _FollowUpBubbleState();
}

class _FollowUpBubbleState extends State<FollowUpBubble> {
  bool _expanded = false;
  void _setExpanded(bool value) {
    if (_expanded != value) setState(() => _expanded = value);
  }

  @override
  Widget build(BuildContext context) => Focus(
    onFocusChange: _setExpanded,
    child: MouseRegion(
      onEnter: (_) => _setExpanded(true),
      onExit: (_) => _setExpanded(false),
      child: GestureDetector(
        onTap: () => _setExpanded(true),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: _expanded ? 300 : 185,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF8F6),
            border: Border.all(
              color: const Color(0xFFCFC9D8),
              width: _expanded ? 3 : 2,
            ),
            borderRadius: BorderRadius.circular(_expanded ? 25 : 38),
            boxShadow: [
              BoxShadow(
                color: AppColors.mint.withValues(alpha: .9),
                offset: const Offset(4, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                child: NumberBadge(number: widget.number, small: true),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusPill(label: widget.status, small: true),
                  const SizedBox(height: 7),
                  Padding(
                    padding: const EdgeInsets.only(right: 28),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: _expanded ? 15 : 12,
                      ),
                    ),
                  ),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 180),
                    crossFadeState: _expanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: const SizedBox(
                      height: 0,
                      width: double.infinity,
                    ),
                    secondChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          widget.detail,
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () {},
                          child: Text(widget.locked),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class RootPathPainter extends CustomPainter {
  const RootPathPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final root = Paint()
      ..color = const Color(0xFFBFAEE2).withValues(alpha: .55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final branch = Paint()
      ..color = AppColors.mint.withValues(alpha: .75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final trunk = Path()
      ..moveTo(size.width * .5, 185)
      ..cubicTo(
        size.width * .52,
        235,
        size.width * .59,
        260,
        size.width * .57,
        315,
      )
      ..cubicTo(
        size.width * .55,
        370,
        size.width * .48,
        400,
        size.width * .5,
        455,
      )
      ..cubicTo(
        size.width * .52,
        510,
        size.width * .58,
        550,
        size.width * .56,
        635,
      );
    canvas.drawPath(trunk, root);
    for (final path in [
      Path()
        ..moveTo(size.width * .56, 258)
        ..cubicTo(
          size.width * .68,
          270,
          size.width * .78,
          286,
          size.width * .87,
          305,
        ),
      Path()
        ..moveTo(size.width * .5, 405)
        ..cubicTo(
          size.width * .4,
          420,
          size.width * .28,
          440,
          size.width * .2,
          458,
        ),
      Path()
        ..moveTo(size.width * .55, 545)
        ..cubicTo(
          size.width * .66,
          558,
          size.width * .78,
          575,
          size.width * .86,
          595,
        ),
    ]) {
      canvas.drawPath(path, branch);
    }
  }

  @override
  bool shouldRepaint(covariant RootPathPainter oldDelegate) => false;
}
