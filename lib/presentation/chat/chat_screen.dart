import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/models/parsed_transaction_result.dart';
import '../../domain/models/transaction.dart';
import '../../state/app_providers.dart';
import '../common/haro_avatar.dart';
import '../common/transaction_confirmation_card.dart';
import 'chat_message.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _messages = <ChatMessage>[];
  Transaction? _pending;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(appStateProvider).userProfile!;
    if (_messages.isEmpty) {
      _messages.add(
        ChatMessage(
          text:
              'Halo ${profile.name}, mau catat pemasukan atau pengeluaran apa hari ini?',
          isUser: false,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            HaroAvatar(size: 40, mood: HaroMoodVisual.happy),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Haro', style: TextStyle(fontWeight: FontWeight.w900)),
                Text(
                  'Asisten catatan uangmu',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Wrap(
                    spacing: 8,
                    children:
                        ['Beli makan 20rb', 'Gajian 3jt', 'Bayar kos 1,5jt']
                            .map(
                              (chip) => ActionChip(
                                label: Text(chip),
                                onPressed: () => _send(chip),
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 12),
                  ..._messages.map((message) => _Bubble(message: message)),
                  if (_pending != null)
                    TransactionConfirmationCard(
                      transaction: _pending!,
                      onSave: (transaction) async {
                        await ref
                            .read(appStateProvider.notifier)
                            .addTransaction(transaction);
                        setState(() {
                          _pending = null;
                          _messages.add(
                            const ChatMessage(
                              text: 'Meong~ transaksi berhasil disimpan.',
                              isUser: false,
                            ),
                          );
                        });
                      },
                      onCancel: () => setState(() {
                        _pending = null;
                        _messages.add(
                          const ChatMessage(
                            text: 'Oke, aku batal simpan transaksi ini.',
                            isUser: false,
                          ),
                        );
                      }),
                      onEdited: (transaction) =>
                          setState(() => _pending = transaction),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Suara',
                    onPressed: () {},
                    icon: const Icon(Icons.mic_none),
                  ),
                  IconButton(
                    tooltip: 'Kamera',
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_outlined),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Tulis pengeluaran atau pemasukan...',
                      ),
                      onSubmitted: _send,
                    ),
                  ),
                  IconButton.filled(
                    onPressed: () => _send(_controller.text),
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _send(String value) {
    final text = value.trim();
    if (text.isEmpty) return;
    final result = ref.read(transactionParserProvider).parse(text);
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _messages.add(ChatMessage(text: result.assistantMessage, isUser: false));
      _pending = result.intent == ParsedIntent.createTransaction
          ? result.transaction
          : null;
      _controller.clear();
    });
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 290),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : AppColors.darkBrown,
          ),
        ),
      ),
    );
  }
}
