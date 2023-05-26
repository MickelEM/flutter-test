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
  int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    fetchNFTs();
  }

  Future<void> fetchNFTs() async {
    if (isLoading || isAllDataLoaded) return;

    setState(() {
      isLoading = true;
    });

    try {
      final url =
          'https://api.coingecko.com/api/v3/nfts/list?page=$currentPage&per_page=$itemsPerPage';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // print(response.body);
        final data = jsonDecode(response.body);
        // print(data);
        List<NFT> fetchedNFTs = [];
        for (var item in data) {
          final nft = NFT(
            id: item['id'],
            name: item['name'],
            symbol: item['symbol'],
          );
          fetchedNFTs.add(nft);
        }

        print(fetchedNFTs);
        setState(() {
          data.addAll(fetchedNFTs);
          currentPage++;
          isLoading = false;
          if (fetchedNFTs.length < itemsPerPage) {
            isAllDataLoaded = true;
          }
        });
      } else {
        print('Failed to fetch NFTs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(data);
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
