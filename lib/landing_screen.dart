import 'package:flutter/material.dart';
import 'package:nft_app/details_screen.dart';
import 'package:nft_app/modules/nft_module.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  List<NFT> data = [];

  bool isLoading = false;
  bool isAllDataLoaded = false;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final newNfts = await fetchNFTs();
    setState(() {
      data.addAll(newNfts);
      currentPage++;
    });
  }

  Future<List<NFT>> fetchNFTs() async {
    setState(() {
      isLoading = true;
    });

    final url =
        'https://api.coingecko.com/api/v3/nfts/list?page=$currentPage&per_page=10';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // print(response.body);
      final json = jsonDecode(response.body) as List;
      // print(data);
      return json.map((record) => NFT.fromJson(record)).toList();
    } else {
      throw Exception('Failed to load NFTs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NFT List',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('NFT List'),
        ),
        body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final name = data[index].name;
            final symbol = data[index].symbol;

            return ListTile(
                title: Text(data[index].name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(data[index]),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
