import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:menzy/Models/product_model.dart';
import 'package:menzy/Utils/App-Colors.dart';
import 'package:menzy/View/Market/product_card.dart';

import '../../Controllers/market_controller.dart';

class Marketscreen extends StatefulWidget {
  const Marketscreen({Key? key}) : super(key: key);

  @override
  State<Marketscreen> createState() => _MarketscreenState();
}

class _MarketscreenState extends State<Marketscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text("Merchant Dise"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0,left: 10,right: 10),
        child: GetBuilder<MarketPlaceController>(
          builder: (cont) => cont.isLoading?CircularProgressIndicator(): GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 20),
              itemCount: cont.products.length,
              itemBuilder: (BuildContext ctx, index) {
                Product product = cont.products[index];
                return ProductCard(product:product);
              }),)
      ),
    );
  }
}
