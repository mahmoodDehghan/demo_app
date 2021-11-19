class DigitalMoney {
  final String name;
  final String nameEn;
  final String symbol;
  final String icon;
  final double price;
  final double buyPriceIRT;
  final double salePriceIRT;
  final double volume;
  final double percent;

  DigitalMoney(
      {required this.name,
      required this.nameEn,
      required this.symbol,
      required this.icon,
      required this.price,
      required this.buyPriceIRT,
      required this.salePriceIRT,
      required this.volume,
      required this.percent});

  factory DigitalMoney.fromJson(Map<String, dynamic> entry) {
    return DigitalMoney(
      name: entry['name'],
      nameEn: entry['nameEn'],
      symbol: entry['symbol'],
      icon: entry['icon'],
      price: entry['price'],
      buyPriceIRT: entry['buyPriceIRT'],
      salePriceIRT: entry['salePriceIRT'],
      volume: entry['volume'],
      percent: entry['percent'],
    );
  }

  static List<DigitalMoney> convertPriceList(dynamic datas) {
    final result = datas as Map<String, dynamic>;
    if (result['error']) {
      throw Exception("FetchError: ${result['message']}");
    }
    List<DigitalMoney> pricesList = [];
    for (Map<String, dynamic> data in result['result'] as List<dynamic>) {
      pricesList.add(DigitalMoney.fromJson(data));
    }
    return pricesList;
  }
}
