import 'package:flutter/material.dart';

import '../models/movie_model.dart';
import '../services/movie_service.dart';
import '../widgets/movie_card.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

const kPrimary = Color(0xFF00CCFF);
const kSecondary = Color(0xFFFF3300);
const kTertiary = Color(0xFF7000FF);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieService _service = MovieService();

  List<MovieModel> _popularMovies = [];
  List<MovieModel> _topRatedMovies = [];
  List<Map<String, dynamic>> _genres = [];
  List<MovieModel> _filteredMovies = [];

  bool _loadingPopular = true;
  bool _loadingTopRated = true;
  bool _loadingGenres = true;

  String? _error;

  int _selectedGenreId = -1;
  String _selectedGenreName = 'All';

  int _activeTab = 0;

  String _sortBy = 'Rating ↓';
  final List<String> _sortOptions = [
    'Rating ↓',
    'Rating ↑',
    'Year ↓',
    'Year ↑',
  ];

  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadAll();
    _searchCtrl.addListener(() {
      setState(() => _searchQuery = _searchCtrl.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    _loadPopular();
    _loadTopRated();
    _loadGenres();
  }

  Future<void> _loadPopular() async {
    try {
      final movies = await _service.getPopularMovies();
      setState(() {
        _popularMovies = movies;
        _loadingPopular = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loadingPopular = false;
      });
    }
  }

  Future<void> _loadTopRated() async {
    try {
      final movies = await _service.getTopRatedMovies();
      setState(() {
        _topRatedMovies = movies;
        _loadingTopRated = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loadingTopRated = false;
      });
    }
  }

  Future<void> _loadGenres() async {
    try {
      final genres = await _service.getGenres();
      setState(() {
        _genres = genres;
        _loadingGenres = false;
      });
    } catch (e) {
      setState(() {
        _loadingGenres = false;
      });
    }
  }

  Future<void> _onGenreSelected(int id, String name) async {
    setState(() {
      _selectedGenreId = id;
      _selectedGenreName = name;
      _filteredMovies = [];
      _loadingGenres = true;
    });

    if (id == -1) {
      setState(() => _loadingGenres = false);
      return;
    }

    try {
      final movies = await _service.getMoviesByGenre(id);
      setState(() {
        _filteredMovies = movies;
        _loadingGenres = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loadingGenres = false;
      });
    }
  }

  List<MovieModel> _sorted(List<MovieModel> list) {
    final copy = [...list];

    switch (_sortBy) {
      case 'Rating ↓':
        copy.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
        break;
      case 'Rating ↑':
        copy.sort((a, b) => a.voteAverage.compareTo(b.voteAverage));
        break;
      case 'Year ↓':
        copy.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
        break;
      case 'Year ↑':
        copy.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
        break;
    }

    return copy;
  }

  List<MovieModel> _searched(List<MovieModel> list) {
    if (_searchQuery.isEmpty) return list;
    return list
        .where((m) => m.title.toLowerCase().contains(_searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;
    final mutedColor = textColor?.withValues(alpha: 0.6);
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
              child: Row(
                children: [
                  Hero(
                    tag: 'movie_icon_hero',
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cardColor,
                        border: Border.all(
                          color: Colors.cyan.withValues(alpha: 0.35),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyan.withValues(alpha: 0.2),
                            blurRadius: 14,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.movie_filter_rounded,
                        color: Color(0xFF00CCFF),
                        size: 20,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFFF3333), Color(0xFF00CCFF)],
                    ).createShader(bounds),
                    child: const Text(
                      'MTV MOVI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      child: TextField(
                        controller: _searchCtrl,
                        readOnly: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchScreen(),
                            ),
                          );
                        },
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search movies...',
                          hintStyle: TextStyle(
                            color: mutedColor,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: mutedColor,
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 4),

                  SizedBox(
                    width: 36,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.favorite,
                        color: Color(0xFFFF3300),
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FavoritesScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(
                    width: 36,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.settings,
                        color: Color(0xFF00CCFF),
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            _buildTabs(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    const tabs = ['Popular', 'Top Rated', 'Categories'];
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;
    final mutedColor = textColor?.withValues(alpha: 0.6);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final active = _activeTab == i;

          return GestureDetector(
            onTap: () => setState(() => _activeTab = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: active ? kPrimary : cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active ? kPrimary : Theme.of(context).dividerColor,
                ),
              ),
              child: Text(
                tabs[i],
                style: TextStyle(
                  color: active ? const Color(0xFF003344) : mutedColor,
                  fontWeight: active ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBody() {
    if (_error != null) return _buildError();

    switch (_activeTab) {
      case 0:
        return _buildPopularTab();
      case 1:
        return _buildTopRatedTab();
      case 2:
        return _buildCategoriesTab();
      default:
        return const SizedBox();
    }
  }

  Widget _buildPopularTab() {
    return RefreshIndicator(
      color: kPrimary,
      backgroundColor: Theme.of(context).cardColor,
      onRefresh: _loadAll,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader('🔥 Popular Movies', kSecondary),
            const SizedBox(height: 12),
            _loadingPopular
                ? _buildShimmerGrid()
                : _buildGrid(_searched(_sorted(_popularMovies))),
            const SizedBox(height: 24),
            _sectionHeader('⭐ Top Rated', kPrimary),
            const SizedBox(height: 12),
            _loadingTopRated
                ? _buildShimmerGrid()
                : _buildGrid(_searched(_sorted(_topRatedMovies))),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRatedTab() {
    return _loadingTopRated
        ? _centered(const CircularProgressIndicator(color: kPrimary))
        : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _searched(_sorted(_topRatedMovies)).length,
            itemBuilder: (_, i) {
              final movie = _searched(_sorted(_topRatedMovies))[i];
              return MovieCard(movie: movie);
            },
          );
  }

  Widget _buildCategoriesTab() {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;
    final mutedColor = textColor?.withValues(alpha: 0.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 46,
          child: _loadingGenres && _genres.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(color: kPrimary),
                )
              : ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  children: [
                    _genreChip(-1, 'All'),
                    ..._genres.map((g) => _genreChip(g['id'], g['name'])),
                  ],
                ),
        ),

        const SizedBox(height: 12),

        Expanded(
          child: _loadingGenres
              ? _centered(const CircularProgressIndicator(color: kPrimary))
              : _selectedGenreId == -1
                  ? _centered(
                      Text(
                        'Select a genre above',
                        style: TextStyle(color: mutedColor),
                      ),
                    )
                  : _filteredMovies.isEmpty
                      ? _centered(
                          Text(
                            'No movies found',
                            style: TextStyle(color: mutedColor),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.6,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: _filteredMovies.length,
                          itemBuilder: (_, i) =>
                              MovieCard(movie: _filteredMovies[i]),
                        ),
        ),
      ],
    );
  }

  Widget _genreChip(int id, String name) {
    final active = _selectedGenreId == id;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;
    final mutedColor = textColor?.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: () => _onGenreSelected(id, name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? kTertiary : cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? kTertiary : Theme.of(context).dividerColor,
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: active ? Colors.white : mutedColor,
            fontSize: 12,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, Color color) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          color: color,
          margin: const EdgeInsets.only(right: 8),
        ),
        Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(List<MovieModel> movies) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;
    final mutedColor = textColor?.withValues(alpha: 0.6);

    if (movies.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'No movies found',
            style: TextStyle(color: mutedColor),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: movies.length,
      itemBuilder: (_, i) => MovieCard(movie: movies[i]),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildError() {
    final mutedColor =
        Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, color: kSecondary, size: 48),
          const SizedBox(height: 12),
          Text(
            _error ?? 'Error',
            style: TextStyle(color: mutedColor),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kPrimary),
            onPressed: () {
              setState(() {
                _error = null;
              });
              _loadAll();
            },
            child: const Text(
              'Retry',
              style: TextStyle(color: Color(0xFF003344)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _centered(Widget child) => Center(child: child);
}