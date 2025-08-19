import 'package:flutter/material.dart';

class CategoryScroller extends StatefulWidget {
  const CategoryScroller({
    super.key,
    required this.categories,
    this.initialIndex = 0,
    this.onSelected,
  });

  final List<String> categories; // e.g. ['Cars', 'Planes', 'Bikes']
  final int initialIndex; // default selected chip
  final ValueChanged<int>? onSelected; // returns the selected index

  @override
  State<CategoryScroller> createState() => _CategoryScrollerState();
}

class _CategoryScrollerState extends State<CategoryScroller> {
  late int _selected;

  @override
  void initState() {
    super.initState();
    _selected =
        (widget.initialIndex >= 0 &&
            widget.initialIndex < widget.categories.length)
        ? widget.initialIndex
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 48, // chip height
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: widget.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final isSelected = i == _selected;
          final label = widget.categories[i];

          return GestureDetector(
            onTap: () {
              setState(() => _selected = i);
              widget.onSelected?.call(i);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(999), // oval / pill
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.dividerColor,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Icon(
                        Icons.check,
                        size: 16,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  Text(
                    label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
