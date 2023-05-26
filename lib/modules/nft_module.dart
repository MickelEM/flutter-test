class NFT {
  final String id;
  final String symbol;
  final String name;

  NFT({
    required this.id,
    required this.symbol,
    required this.name,
  });

  factory NFT.fromJson(Map<String, dynamic> json) {
    return NFT(
      id: json['id'],
      symbol: json['symbol'],
      name: json['name'],
    );
  }
}
