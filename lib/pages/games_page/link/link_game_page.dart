import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_games/timer_provider.dart';
import 'package:mobile_games/pages/games_page/link/link.dart';
import 'package:mobile_games/widgets.dart';

class LinkGamePage extends StatelessWidget {
  const LinkGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, timerProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context); // Navigate back to previous page
              },
            ),
            title: timerProvider.isBlocked
                ? Text(
                    "Blocked: ${_formatDuration(timerProvider.remainingBlockTime)}",
                    style: const TextStyle(color: Colors.black),
                  )
                : const Text('Game Title', style: TextStyle(color: Colors.black)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.black),
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ],
          ),
          body: timerProvider.isBlocked
              ? _buildBlockedScreen()
              : Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 150,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Text(
                          'Game (Image/Info)',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const TabButtons(),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Create a private game',
                      onPressed: () {
                        print('Create a private game pressed');
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      text: 'Fast game',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LinkGame(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
        );
      },
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
}