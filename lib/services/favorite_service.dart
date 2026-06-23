import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/movie_model.dart';

class FavoriteService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final List<MovieModel> favoriteMovies = [];

  static String? get _userId => _auth.currentUser?.uid;

  static CollectionReference<Map<String, dynamic>>? get _favoritesRef {
    final uid = _userId;

    if (uid == null) {
      return null;
    }

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites');
  }

  static Future<bool> isFavorite(int movieId) async {
    final ref = _favoritesRef;

    if (ref == null) {
      return false;
    }

    final doc = await ref.doc(movieId.toString()).get();

    return doc.exists;
  }

  static Future<void> toggleFavorite(MovieModel movie) async {
    final ref = _favoritesRef;

    if (ref == null) {
      return;
    }

    final docRef = ref.doc(movie.id.toString());
    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set({
        'id': movie.id,
        'title': movie.title,
        'overview': movie.overview,
        'posterPath': movie.posterPath,
        'releaseDate': movie.releaseDate,
        'rating': movie.rating,
         'genreIds': movie.genreIds,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  static Future<List<MovieModel>> getFavorites() async {
    final ref = _favoritesRef;

    if (ref == null) {
      return [];
    }

    final snapshot = await ref.orderBy('addedAt', descending: true).get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return MovieModel(
        id: data['id'] ?? 0,
        title: data['title'] ?? '',
        overview: data['overview'] ?? '',
        posterPath: data['posterPath'] ?? '',
        releaseDate: data['releaseDate'] ?? '',
        rating: (data['rating'] ?? 0).toDouble(),
         genreIds: const [],
      );
    }).toList();
  }

  static Future<void> removeFavorite(int movieId) async {
    final ref = _favoritesRef;

    if (ref == null) {
      return;
    }

    await ref.doc(movieId.toString()).delete();
  }
}
