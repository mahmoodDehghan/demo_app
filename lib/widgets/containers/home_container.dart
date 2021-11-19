import '../../helpers/internet_helper.dart';

import '../../helpers/const_items.dart';
import '../../providers/get_prices_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePageContainer extends HookConsumerWidget {
  const HomePageContainer({Key? key}) : super(key: key);

  Widget getErrorWidget(BuildContext context, String error, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text(
              error,
              style: Theme.of(context).textTheme.headline4,
            )),
        const SizedBox(
          height: 30,
        ),
        IconButton(
          onPressed: () {
            ref.refresh(getPricesProvider);
          },
          icon: Icon(
            Icons.refresh,
            color: Theme.of(context).primaryColor,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pricesProvider = ref.watch(getPricesProvider);
    return pricesProvider.when(
      data: (data) {
        if (data != null) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Column(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Image.network(
                          ConstItems.picBaseUrl + data[index].icon,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 50,
                      child: Center(
                        child: Text(data[index].symbol),
                      ),
                    ),
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
                title: Text(data[index].name),
                subtitle: Text("قیمت: ${data[index].price}"),
                trailing: SizedBox(
                  width: 140,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("خرید: ${data[index].buyPriceIRT}"),
                        Text("فروش: ${data[index].salePriceIRT}"),
                      ],
                      mainAxisSize: MainAxisSize.min,
                    ),
                  ),
                ),
              );
            },
            itemCount: data.length,
          );
        } else {
          return Center(
            child: getErrorWidget(
              context,
              AppLocalizations.of(context)!.generalError,
              ref,
            ),
          );
        }
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (err, stack) {
        if (InternetHelper.isNoInternetError(err.toString())) {
          return getErrorWidget(
              context, AppLocalizations.of(context)!.noInternetError, ref);
        }
        return Center(
          child: getErrorWidget(context, err.toString(), ref),
        );
      },
    );
  }
}
