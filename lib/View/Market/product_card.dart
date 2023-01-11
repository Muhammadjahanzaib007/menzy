import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:menzy/Utils/App-Colors.dart';
import 'package:menzy/Utils/App-TextStyle.dart';
import 'package:menzy/utils/App-Contants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var url = "https://menzy.vercel.app/product/${product.id}";
        Clipboard.setData(ClipboardData(text: url));
        await Get.snackbar("Copied", "Url Copied", colorText: Colors.white);
        await launchUrl(
          Uri.parse(
              "https://metamask.app.link/dapp/menzy.vercel.app/product/${product.id}"),
          mode: LaunchMode.externalApplication,
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.blueDark, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        "${AppConstants.SERVER_URL}/${product.image}"),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
            )),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Align(
                    child: Text(
                      product.name ?? "",
                      style: AppTextStyle.boldWhite16,
                    ),
                    alignment: Alignment.topLeft,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    child: Text(
                      "MNZ ${product.price} /-",
                      style: AppTextStyle.boldPrimary14,
                    ),
                    alignment: Alignment.topLeft,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    child: Container(
                      padding:
                          EdgeInsets.only(top: 2, bottom: 3, left: 5, right: 5),
                      decoration: BoxDecoration(
                          color: product.status == 1
                              ? Colors.green
                              : Colors.redAccent,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        product.status == 1 ? "In stock" : "Out of stock",
                        style: AppTextStyle.regularWhite12,
                      ),
                    ),
                    alignment: Alignment.topRight,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
