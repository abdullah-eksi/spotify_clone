import 'package:flutter/material.dart';
import '../../model/category.dart';
import '../../model/song.dart';
import '../../model/album.dart';
import '../../model/artist.dart';
import '../../model/playlist.dart';
import 'process/search_process.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchFocused = false;
  final List<String> _searchHistory = [
    'Sezen Aksu',
    'Rock',
    'Pop Türkçe',
    'Tarkan',
  ];

  // Arama sonuçları
  List<Song> _songResults = [];
  List<Album> _albumResults = [];
  List<Artist> _artistResults = [];
  List<Playlist> _playlistResults = [];
  bool _isSearching = false;
  String _currentQuery = '';

  // Arama tipi seçeneği
  String _selectedSearchType = 'Tümü';
  final List<String> _searchTypes = [
    'Tümü',
    'Şarkılar',
    'Albümler',
    'Sanatçılar',
    'Çalma Listeleri',
  ];

  @override
  Widget build(BuildContext context) {
    final categories = SearchCategory.getCategories();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Arama çubuğu
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText:
                            'Şarkı, sanatçı, albüm veya çalma listesi ara',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _isSearchFocused = true;
                        });
                      },
                      onChanged: (value) {
                        if (value.length > 2) {
                          _performSearch(value);
                        } else if (value.isEmpty) {
                          setState(() {
                            _songResults = [];
                            _albumResults = [];
                            _artistResults = [];
                            _playlistResults = [];
                            _currentQuery = '';
                          });
                        }
                      },
                      onSubmitted: (value) {
                        _performSearch(value);
                      },
                    ),
                  ),
                  if (_isSearchFocused)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isSearchFocused = false;
                          _searchController.clear();
                          _songResults = [];
                          _albumResults = [];
                          _artistResults = [];
                          _playlistResults = [];
                        });
                      },
                      child: Text(
                        'İptal',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),

            // Arama tipi seçici
            if (_isSearchFocused)
              Container(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _searchTypes.length,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final type = _searchTypes[index];
                    final isSelected = type == _selectedSearchType;

                    return Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(type),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedSearchType = type;
                              if (_currentQuery.isNotEmpty) {
                                _performSearch(_currentQuery);
                              }
                            });
                          }
                        },
                        backgroundColor: Colors.grey[900],
                        selectedColor: Color(0xFF1DB954), // Spotify yeşili
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Ana içerik: Arama Sonuçları veya Kategoriler
            Expanded(
              child: !_isSearchFocused
                  ? SearchProcess.buildBrowseContent(
                      categories,
                      _onCategorySelected,
                      _onArtistSelected,
                    )
                  : _currentQuery.isEmpty
                  ? SearchProcess.buildSearchHistory(
                      _searchHistory,
                      _onHistoryItemSelected,
                      _onHistoryItemRemoved,
                    )
                  : SearchProcess.buildSearchResults(
                      songResults: _songResults,
                      albumResults: _albumResults,
                      artistResults: _artistResults,
                      playlistResults: _playlistResults,
                      isSearching: _isSearching,
                      context: context,
                    ),
            ),
            // Sayfanın sonuna boşluk ekleme
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = true;
    });

    SearchProcess.performSearch(
      query: query,
      selectedSearchType: _selectedSearchType,
      searchHistory: _searchHistory,
      onHistoryUpdated: (newHistory) {
        setState(() {
          _searchHistory.clear();
          _searchHistory.addAll(newHistory);
        });
      },
      onSearchCompleted:
          (songs, albums, artists, playlists, currentQuery, isSearching) {
            setState(() {
              _songResults = songs;
              _albumResults = albums;
              _artistResults = artists;
              _playlistResults = playlists;
              _currentQuery = currentQuery;
              _isSearching = isSearching;
            });
          },
    );
  }

  void _onCategorySelected(String categoryName) {
    setState(() {
      _isSearchFocused = true;
      _currentQuery = categoryName;
      _searchController.text = categoryName;
      _performSearch(categoryName);
    });
  }

  void _onArtistSelected(String artistName) {
    setState(() {
      _isSearchFocused = true;
      _currentQuery = artistName;
      _searchController.text = artistName;
      _performSearch(artistName);
    });
  }

  void _onHistoryItemSelected(String item) {
    setState(() {
      _searchController.text = item;
      _performSearch(item);
    });
  }

  void _onHistoryItemRemoved(String item) {
    setState(() {
      _searchHistory.remove(item);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
