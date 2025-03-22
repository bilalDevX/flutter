import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

// API Base URL (Update with your FastAPI URL)
const String apiUrl = 'http://your-fastapi-url/analyze_emotions';

// ChatNotifier to manage chat messages
class ChatNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>>> {
  ChatNotifier() : super(const AsyncValue.data([]));

  Future<void> sendMessage(String text) async {
    final dio = Dio();
    state = const AsyncValue.loading(); // Show loading indicator

    try {
      final response = await dio.post(apiUrl, data: {'text': text});

      if (response.statusCode == 200) {
        final newMessage = {
          'text': text,
          'ai_response': response.data['ai_response'],
          'coping_strategy': response.data['coping_strategy'],
        };

        state = AsyncValue.data([...state.value ?? [], newMessage]);
      } else {
        state = AsyncValue.error("Failed to fetch response.");
      }
    } catch (e) {
      state = AsyncValue.error("Error: $e");
    }
  }
}

// Riverpod provider for chat messages
final chatProvider = StateNotifierProvider<ChatNotifier, AsyncValue<List<Map<String, dynamic>>>>>((ref) {
  return ChatNotifier();
});

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChatScreen extends ConsumerWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mental Health Companion')),
      body: Column(
        children: [
          Expanded(
            child: chatState.when(
              data: (messages) => messages.isEmpty
                  ? const Center(child: Text("Start chatting with AI!"))
                  : ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return ListTile(
                          title: Text("You: ${message['text']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("AI: ${message['ai_response']}", style: const TextStyle(color: Colors.blue)),
                              Text("Coping: ${message['coping_strategy']}", style: const TextStyle(color: Colors.green)),
                            ],
                          ),
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text("Error: $err")),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Type your message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      ref.read(chatProvider.notifier).sendMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
