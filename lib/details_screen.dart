import 'package:flutter/material.dart';
import 'package:nft_app/modules/nft_module.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen(this.data, {super.key});

  final NFT data;

  @override
  State<DetailsScreen> createState() {
    return _DetailsScreenState();
  }
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _comments = <String>[];
  final _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitComment() {
    if (_formKey.currentState!.validate()) {
      final text = _commentController.text.trim();
      setState(() {
        _comments.add(text);
        _commentController.clear();
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.data.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NFT Name
            Text(
              widget.data.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // NFT Symbol
            Text(
              'Symbol: ${widget.data.symbol}',
              style: TextStyle(fontSize: 16),
            ),

            // Comment form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      labelText: 'Your comment',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a comment';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: _submitComment,
                    child: Text('Submit Comment'),
                  ),
                ],
              ),
            ),

            // Comment list
            Expanded(
              child: ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_comments[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
