import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScoreRankingPage extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Three tabs
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

  Widget _buildRankingList(String scoreField) {
    Stream<QuerySnapshot> stream;

    if (scoreField == 'scoreTotal') {
      // For total score, fetch all users without ordering
      stream = _db.collection('users').snapshots();
    } else {
      // For individual games, order by the specific score field
      stream = _db
          .collection('users')
          .orderBy(scoreField, descending: true)
          .snapshots();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Map<String, dynamic>> userDataList = [];

        if (scoreField == 'scoreTotal') {
          // Compute total scores and create a list of user data
          userDataList = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final scoreCrossword = data['scoreCrossword'] ?? 0;
            final scoreLink = data['scoreLink'] ?? 0;
            final totalScore = scoreCrossword + scoreLink;
            final newData = Map<String, dynamic>.from(data);
            newData['scoreTotal'] = totalScore;
            return newData;
          }).toList();

          // Sort userDataList by totalScore descending
          userDataList.sort((a, b) {
            final totalA = a['scoreTotal'] ?? 0;
            final totalB = b['scoreTotal'] ?? 0;
            return totalB.compareTo(totalA);
          });
        } else {
          // For individual scores, use the data as is
          userDataList = snapshot.data!.docs.map((doc) {
            return doc.data() as Map<String, dynamic>;
          }).toList();
        }

        return ListView.builder(
          itemCount: userDataList.length,
          itemBuilder: (context, index) {
            final data = userDataList[index];
            final rank = index + 1;

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  leading: CircleAvatar(
                    backgroundColor: Colors.purpleAccent,
                    child: Text(
                      '#$rank',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    data['username'] ?? 'Unknown',
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
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      Text(
                        '${data[scoreField] ?? 0}',
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
