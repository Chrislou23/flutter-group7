import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScoreRankingPage extends StatelessWidget {
  // Reference to Firestore database
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Score Rankings'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Crossword'),
              Tab(text: 'Linking Game'),
              Tab(text: 'Total Score'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Crossword Rankings
            _buildRankingList('scoreCrossword'),
            // Tab 2: Linking Game Rankings
            _buildRankingList('scoreLink'),
            // Tab 3: Total Score Rankings
            _buildRankingList('scoreTotal'),
          ],
        ),
      ),
    );
  }

  // Widget to build the ranking list based on the score field
  Widget _buildRankingList(String scoreField) {
    Stream<QuerySnapshot> stream;

    if (scoreField == 'scoreTotal') {
      // For total score, fetch all users without ordering
      stream = _db.collection('users').snapshots();
    } else {
      // For individual games, order by the specific score field descending
      stream = _db
          .collection('users')
          .orderBy(scoreField, descending: true)
          .snapshots();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        // Error handling
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        // Loading indicator while waiting for data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // List to store user data
        List<Map<String, dynamic>> userDataList = [];

        if (scoreField == 'scoreTotal') {
          // Compute total scores for each user
          userDataList = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final scoreCrossword = data['scoreCrossword'] ?? 0;
            final scoreLink = data['scoreLink'] ?? 0;
            final totalScore = scoreCrossword + scoreLink;

            // Create a new data map including totalScore
            final newData = Map<String, dynamic>.from(data);
            newData['scoreTotal'] = totalScore;
            return newData;
          }).toList();

          // Sort the list by totalScore in descending order
          userDataList.sort((a, b) {
            final totalA = a['scoreTotal'] ?? 0;
            final totalB = b['scoreTotal'] ?? 0;
            return totalB.compareTo(totalA);
          });
        } else {
          // For individual game scores, use the data as is
          userDataList = snapshot.data!.docs.map((doc) {
            return doc.data() as Map<String, dynamic>;
          }).toList();
        }

        // Build the list view of rankings
        return ListView.builder(
          itemCount: userDataList.length,
          itemBuilder: (context, index) {
            final data = userDataList[index];
            final rank = index + 1; // Calculate rank

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Background color
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                  boxShadow: [
                    // Shadow effect
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // Position of the shadow
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  leading: CircleAvatar(
                    backgroundColor: Colors.purpleAccent,
                    child: Text(
                      '#$rank', // Display rank number
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    data['username'] ?? 'Unknown', // Display username
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Score',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${data[scoreField] ?? 0}', // Display user's score
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
