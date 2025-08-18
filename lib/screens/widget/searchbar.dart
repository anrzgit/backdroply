import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/bloc/images_bloc.dart';
// import your bloc files

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  const SearchAppBar({super.key});

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar> {
  bool _isSearching = false;
  final _controller = TextEditingController();
  final List<String> _orientations = const [
    'landscape',
    'portrait',
    'squarish',
  ];
  String _selectedOrientation = 'landscape';

  void _startSearch() {
    setState(() => _isSearching = true);
  }

  void _cancelSearch() {
    setState(() => _isSearching = false);
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  void _submitSearch() {
    final q = _controller.text.trim();
    if (q.isEmpty) return;
    context.read<ImagesBloc>().add(
      SearchImages(
        query: q,
        page: 1,
        perPage: 18,
        orderBy: 'relevant',
        orientation: _selectedOrientation,
      ),
    );
    FocusScope.of(context).unfocus();
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      titleSpacing: 0,
      title: _isSearching
          ? Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  // Rounded search text field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceVariant.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => _submitSearch(),
                        decoration: const InputDecoration(
                          hintText: 'Search photos',
                          border: InputBorder.none,
                          icon: Icon(Icons.search_rounded),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Orientation dropdown chip
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceVariant.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedOrientation,
                        borderRadius: BorderRadius.circular(12),
                        items: _orientations
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e[0].toUpperCase() + e.substring(1),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _selectedOrientation = v!),
                        icon: const Icon(Icons.expand_more_rounded),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Search',
                    onPressed: _submitSearch,
                    icon: const Icon(Icons.arrow_forward_rounded),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: const Text('Wallpapers'),
            ),
      actions: _isSearching
          ? [
              IconButton(
                tooltip: 'Close',
                onPressed: _cancelSearch,
                icon: const Icon(Icons.close_rounded),
              ),
            ]
          : [
              IconButton(
                tooltip: 'Search',
                onPressed: _startSearch,
                icon: const Icon(Icons.search_rounded),
              ),
            ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildAppBar();
  }
}
