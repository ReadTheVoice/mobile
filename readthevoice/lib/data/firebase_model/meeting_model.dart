class MeetingModel {
  /// A reference to the list of movies.
  /// We are using `withConverter` to ensure that interactions with the collection
  /// are type-safe.
  // final moviesRef = FirebaseFirestore.instance
  //     .collection('firestore-example-app')
  //     .withConverter<Movie>(
  //   fromFirestore: (snapshots, _) => Movie.fromJson(snapshots.data()!),
  //   toFirestore: (movie, _) => movie.toJson(),
  // );

// extension on Query<Movie> {
//   /// Create a firebase query from a [MovieQuery]
//   Query<Movie> queryBy(MovieQuery query) {
//     switch (query) {
//       case MovieQuery.fantasy:
//         return where('genre', arrayContainsAny: ['fantasy']);
//
//       case MovieQuery.sciFi:
//         return where('genre', arrayContainsAny: ['sci-fi']);
//
//       case MovieQuery.likesAsc:
//       case MovieQuery.likesDesc:
//         return orderBy('likes', descending: query == MovieQuery.likesDesc);
//
//       case MovieQuery.year:
//         return orderBy('year', descending: true);
//
//       case MovieQuery.rated:
//         return orderBy('rated', descending: true);
//     }
//   }
// }

}