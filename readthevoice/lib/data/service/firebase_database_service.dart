import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:readthevoice/data/constants.dart';
import 'package:readthevoice/data/firebase_model/user_model.dart';

class FirebaseDatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseDatabase realtimeDb = FirebaseDatabase.instance;

  late CollectionReference meetingCollectionReference;
  late CollectionReference userCollectionReference;
  late DatabaseReference transcriptDatabaseReference;

  FirebaseDatabaseService() {
    meetingCollectionReference = firestore.collection(MEETING_COLLECTION);
    userCollectionReference = firestore.collection(USER_COLLECTION);
    transcriptDatabaseReference = realtimeDb.ref(TRANSCRIPT_COLLECTION);
  }

  Future<UserModel> getMeetingCreator(String userId) async {
    var docSnapshot = await userCollectionReference.doc(userId).get();

    if(docSnapshot.exists) {
      final data = docSnapshot.data();
      return const UserModel(id: "", firstName: "", lastName: "");
    }

    return UserModel.example();
  }

  // https://github.com/firebase/flutterfire/blob/master/packages/cloud_firestore/cloud_firestore/example/lib/main.dart
  void getMeetingById(String meetingId) async {
    // var mt = firestore.collection("meetings").doc(meetingId);

    final docRef = meetingCollectionReference.doc(meetingId);
    final documentSnapshot = await docRef.get();

    if (documentSnapshot.exists) {
      final data = documentSnapshot.data();
      print(data); // Access data using field names
    } else {
      print('Document does not exist!');
    }
  }
}


/*
    // Realtime database

    // - Reading Data Once:
    final databaseReference = database.reference().child('users/user_id');
    final snapshot = await databaseReference.once();

    if (snapshot.hasData) {
      final data = snapshot.value;
      print(data); // Access data using field names
    } else {
      print('No data found!');
    }

    // - Listening for Real-time Updates
    final databaseReference = database.reference().child('users/user_id');
    databaseReference.onValue.listen((event) {
      final data = event.snapshot.value;
      print(data['name']); // Access updated data
    });
     */

/*
// Stream transcript

Here's how you can stream data from Firebase Realtime Database and display it on a page in Flutter:

**1. Setting Up (covered previously):**

- Ensure you have Firebase set up and the `firebase_core` and `firebase_database` packages are included in your project.

**2. Accessing Data Stream:**

- Create a reference to the node in the database you want to listen to:

```dart
final databaseReference = FirebaseDatabase.instance.reference().child('users/user_id');
```

**3. Using StreamBuilder:**

- Wrap your widget responsible for displaying data in a `StreamBuilder`:

```dart
StreamBuilder<DatabaseEvent>(
  stream: databaseReference.onValue, // Listen for value changes
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }

    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    // Extract data from the snapshot
    final data = snapshot.data!.snapshot.value;

    return Text('Name: ${data['name']}, Age: ${data['age']}');  // Display data
  },
),
```

**Explanation:**

- The `StreamBuilder` listens to the `onValue` stream of the `databaseReference`.
- The `builder` function handles different scenarios:
  - Error: If an error occurs, display an error message.
  - Loading: While data is being fetched, display a loading indicator.
  - Data Available: When data is available:
    - Extract data from the `snapshot.data!.snapshot.value` map.
    - Display the data in your desired format.

**4. Additional Considerations:**

- You can customize the UI based on different states (loading, error, data available) using conditional widgets (e.g., `if`, `else`).
- Consider using a state management solution (e.g., Provider, Bloc) if you need to manage complex state or share fetched data across multiple widgets.
- Explore other Firebase features like queries and filtering to retrieve specific data from the database.

**Remember:**

- Replace `'users/user_id'` with the actual path to your data node in the database.
- Adjust the data extraction and display logic based on your specific data structure.

By following these steps and incorporating best practices, you can effectively stream data from Firebase Realtime Database and dynamically update your Flutter application's UI.
 */

/*
// Retrieving child node based on filters

Here's how you can retrieve nodes using filters in Firebase Realtime Database for Flutter:

**1. Filtering by Key:**

   - Firebase Realtime Database doesn't directly support filtering by key or value in the way Firestore does. However, you can achieve a similar effect by leveraging queries that start or end at specific key values.

   ```dart
   final databaseReference = FirebaseDatabase.instance.reference()
       .child('users')
       .orderByKey() // Order by key for efficient filtering
       .startAt('user_b') // Start at key 'user_b' (inclusive)
       .endAt('user_d'); // End at key 'user_d' (inclusive)

   // Listen for data or use once() for a one-time retrieval
   ```

   **Explanation:**

   - `orderByKey()` ensures efficient filtering based on key values.
   - `startAt` and `endAt` define the key range to retrieve.
   - This retrieves data for nodes with keys between (or including) 'user_b' and 'user_d'.

**2. Filtering by Value (Limited Approach):**

   - While not strictly filtering by value, you can iterate through child nodes and check their values:

   ```dart
   final databaseReference = FirebaseDatabase.instance.reference().child('users');

   databaseReference.once().then((snapshot) {
     if (snapshot.hasData) {
       final data = snapshot.value as Map<String, dynamic>;
       data.forEach((key, value) {
         if (value['age'] > 25) {
           // Process nodes where 'age' is greater than 25
         }
       });
     }
   });
   ```

   **Explanation:**

   - We retrieve all data from the `users` node using `once()`.
   - We iterate through each child node (`key`, `value`) pair.
   - We check if the `value` (which is a map) has an 'age' field greater than 25.

   **Note:** This approach iterates through all child nodes, making it less efficient for large datasets. Consider alternative solutions for complex value-based filtering.

**3. Alternative Solutions (for Complex Filtering):**

   - Firebase Cloud Functions: Write serverless functions to query and filter data on the server-side, reducing client-side overhead.
   - Firebase Cloud Firestore: If your project requirements demand complex queries and filtering, consider using Firestore, which offers more advanced capabilities compared to Realtime Database in this regard.

**Remember:**

- Choose the filtering approach that best suits your data size and complexity.
- Firebase Realtime Database is optimized for real-time updates, not complex filtering.
- For extensive filtering, explore alternative solutions like Cloud Functions or Firestore.
 */
