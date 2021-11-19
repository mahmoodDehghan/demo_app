import 'dart:convert';

import '../../helpers/const_items.dart';
import '../../models/digital_money.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final getPricesProvider = FutureProvider<List<DigitalMoney>?>((ref) async {
  final response =
      await http.get(Uri.parse(ConstItems.baseUrl + ConstItems.priceUrl));
  if (response.statusCode != 200) return null;
  return DigitalMoney.convertPriceList(jsonDecode(response.body));
});
