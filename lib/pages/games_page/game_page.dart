import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:mobile_games/timer_provider.dart';
import 'package:mobile_games/pages/games_page/crossword/crossword_game_page.dart';
import 'package:mobile_games/pages/games_page/link/link_game_page.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  // Variable to hold the Future
  late Future<QuerySnapshot> _usersFuture;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Method to fetch data
  Future<void> _fetchUserData() async {
    _usersFuture = FirebaseFirestore.instance.collection('users').get();
    // Wait for the future to complete before calling setState
    await _usersFuture;
    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildOverallRankingList() {
    return RefreshIndicator(
      onRefresh: _fetchUserData,
      child: FutureBuilder<QuerySnapshot>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          // Create a list to hold user data with computed total scores
          List<Map<String, dynamic>> userDataList = docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final scoreCrossword = data['scoreCrossword'] ?? 0;
            final scoreLink = data['scoreLink'] ?? 0;
            final scoreTotal = scoreCrossword + scoreLink;

            // Return a new map containing the user data and total score
            return {
              'username': data['username'] ?? 'Unknown',
              'scoreCrossword': scoreCrossword,
              'scoreLink': scoreLink,
              'scoreTotal': scoreTotal,
            };
          }).toList();

          // Sort the userDataList based on 'scoreTotal' in descending order
          userDataList.sort((a, b) => b['scoreTotal'].compareTo(a['scoreTotal']));

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: userDataList.length,
            itemBuilder: (context, index) {
              final user = userDataList[index];
              final scoreCrossword = user['scoreCrossword'];
              final scoreLink = user['scoreLink'];
              final scoreTotal = user['scoreTotal'];

              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(user['username']),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Crossword: $scoreCrossword'),
                    Text('Link: $scoreLink'),
                    Text('Total: $scoreTotal'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Widget _buildBlockedScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.lock, size: 100, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'REST YOUR EYES',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, timerProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: timerProvider.isBlocked
                ? Text(
                    "Blocked: ${_formatDuration(timerProvider.remainingBlockTime)}",
                    style: const TextStyle(color: Colors.black),
                  )
                : const Text('Game', style: TextStyle(color: Colors.black)),
            centerTitle: true,
          ),
          body: timerProvider.isBlocked
              ? _buildBlockedScreen()
              : Column(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CrosswordGamePage(),
                                ),
                              ).then((_) => _fetchUserData());
                            },
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(8.0),
                                  height: 150,
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                      image: AssetImage('assets/game1.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                const Text(
                                  'Game 1: Crossword',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LinkGamePage(),
                                ),
                              ).then((_) => _fetchUserData());
                            },
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(8.0),
                                  height: 150,
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                      image: AssetImage('assets/game2.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                const Text(
                                  'Game 2: Link Game',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Ranking list for all users
                    Expanded(child: _buildOverallRankingList()),
                  ],
                ),
        );
      },
    );
  }
}
