import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pixagallery/models/image_model.dart' as img;
import 'package:pixagallery/screens/image_detail_screen.dart';
import 'package:pixagallery/utils/api_services.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<img.ImageModel> images = [];
  int page = 1;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchImages();
    _scrollController.addListener(_loadMoreImages);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _fetchImages({String query = ''}) async {
    setState(() {
      isLoading = true;
    });

    try {
      final newImages = await _apiService.fetchImages(page: page, query: query);
      setState(() {
        images.addAll(newImages);
        page++;
      });
    } catch (e) {
      print(e);
      AlertDialog(title: Text(e.toString()));
    }

    setState(() {
      isLoading = false;
    });
  }

  void _loadMoreImages() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchImages();
    }
  }

  void _searchImages(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        page = 1;
        images.clear();
      });
      _fetchImages(query: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PixaGallery'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search images',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _searchImages,
            ),
          ),
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 1.0,
                crossAxisSpacing: 8.0, // Add cross axis spacing
                mainAxisSpacing: 8.0, // Add main axis spacing
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImage(image: image),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: image.previewURL,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Likes: ${image.likes}',
                        ),
                        Text('Views: ${image.views}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
