import 'dart:io';

import 'package:appcheck/appcheck.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

import '../View/connect-wallet.dart';

class WalletController extends GetxController {
  WalletController();

  late SharedPreferences prefs;
  RxBool isWalletConnected = false.obs;
  @override
  void onInit() async {
    prefs = await SharedPreferences.getInstance();
    getAccountDetails();
    getApps();
    super.onInit();
  }

  var menzyBalance;
  String? acc;
  int? chainid;
  RxBool isBSC = false.obs;
  var connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
          name: 'My App',
          description: 'An app for converting pictures to NFT',
          url: 'https://walletconnect.org',
          icons: [
            'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
          ]));

  var session, uri, _signature;
  List<AppInfo>? installedApps;
  var balance;

  String rpcUrl =
      'https://rinkeby.infura.io/v3/3740cdac04dc4ca494331267ee468a24';
  String privateKey =
      '43c372a183ddb3491841ebc7af43c8fa583925a69ce3b0609d0034a439172e3d';
  String? metamaskPackage;

  loginUsingMetamask(BuildContext context) async {
    if (!connector.connected) {
      try {
        SessionStatus session =
            await connector.createSession(onDisplayUri: (urii) async {
          uri = urii;
          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        });
        chainid = session.chainId;
        acc = session.accounts[0];
        print(session.accounts[0]);
        print(session.chainId);
        print("hahaa ${session.accounts}");
        if (session.chainId == 56 || session.chainId == 97) {
          print("trueee");
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString('account', session.accounts.first);
          pref.setInt('chainid', session.chainId);

          await getAccountDetails();
          Navigator.pop(context);
          Get.to(() => WalletScreen());
        } else {
          print("not  trueee");
          Get.snackbar(
              "Wrong Chain", "Please connect to BSC chain to get results",
              colorText: Colors.white);
          isWalletConnected.value = false;
        }
      } catch (exp) {
        print("errrrorrrr");
        print(exp);
      }
    }
  }

  getValues() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('account') != null && pref.getInt('chainid') != null) {
      isWalletConnected.value = true;
      update();
    } else {
      isWalletConnected.value = false;
      update();
    }
  }

  getAccountDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(pref.getString('account'));
    if (pref.getString('account') != null && pref.getInt('chainid') != null) {
      acc = pref.getString('account');
      chainid = pref.getInt('chainid');
      print("My CHain Id:$chainid");

      session = SessionStatus(
        chainId: chainid!,
        accounts: [acc!],
      );
      update();
      // print(await client.getBalance(EthereumAddress.fromHex(acc.toString())));
      if (chainid == 56 || chainid == 97) {
        isBSC.value = true;
        update();

        await getBalance(acc.toString());
        await getMenzyBalance(acc.toString());
      } else {
        isBSC.value = false;
        update();
        Get.snackbar(
            "Wrong Chain", "Please connect to BSC chain to get results",
            colorText: Colors.white);
      }
    }
  }

  getMenzyBalance(String address) async {
    var response;
    Dio dio = new Dio();

    try {
      response = await dio.post(
        "https://metaverse-apis.herokuapp.com/balance",
        data: {"wallet": address},
      );
      print(response);

      var stringBalance = response.data;
      var intBalance = double.parse(stringBalance);
      menzyBalance = intBalance;
      print(menzyBalance);
      update();

      return response;
    } catch (e) {
      print('Error: $e');
    }
  }

  getBalance(String address) async {
    var response;
    Dio dio = new Dio();

    try {
      response = await dio.get(
          "https://deep-index.moralis.io/api/v2/$address/balance?chain=bsc%20testnet",
          options: Options(
            headers: {
              "x-api-key":
                  "4Xmwpm5AyyRAUwbEoLjcs3JgrlLOpE7qZw2jdmmeIQt419Dy0Xa06H8qgYa2yNAc"
            },
          ));
      print(response);

      var mbalance = response.data['balance'];
      balance = int.parse(mbalance);
      update();

      return response;
    } catch (e) {
      print('Error: $e');
    }
  }

  signMessageWithMetamask(BuildContext context, String message) async {
    if (connector.connected) {
      try {
        print("Message received");
        print(message);

        EthereumWalletConnectProvider provider =
            EthereumWalletConnectProvider(connector);
        launchUrlString(uri, mode: LaunchMode.externalApplication);
        var signature = await provider.personalSign(
            message: message, address: session.accounts[0], password: "");
        print(signature);

        _signature = signature;
        update();
      } catch (exp) {
        print("Error while signing transaction");
        print(exp);
      }
    }
  }

  getNetworkName(chainId) {
    switch (chainId) {
      case 1:
        return 'Ethereum Mainnet';
      case 3:
        return 'Ropsten Testnet';
      case 4:
        return 'Rinkeby Testnet';
      case 5:
        return 'Goreli Testnet';
      case 42:
        return 'Kovan Testnet';
      case 137:
        return 'Polygon Mainnet';
      case 80001:
        return 'Mumbai Testnet';
      case 97:
        return 'BSC Testnet';
      default:
        return 'Unknown Chain';
    }
  }

  List<AppInfo> iOSApps = [
    AppInfo(appName: "Calendar", packageName: "calshow://"),
    AppInfo(appName: "Facebook", packageName: "fb://"),
    AppInfo(appName: "Whatsapp", packageName: "whatsapp://"),
  ];

  Future<void> getApps() async {
    List<AppInfo>? installedApps;
    if (Platform.isAndroid) {
      const package = "com.google.android.apps.maps";
      installedApps = await AppCheck.getInstalledApps();
      metamaskPackage = installedApps![13].packageName.toString();
      debugPrint(installedApps[13].appName.toString());
      await AppCheck.checkAvailability(package).then(
        (app) => debugPrint(app.toString()),
      );

      await AppCheck.isAppEnabled(package).then(
        (enabled) => enabled
            ? debugPrint('$package enabled')
            : debugPrint('$package disabled'),
      );

      installedApps.sort(
        (a, b) => a.appName!.toLowerCase().compareTo(b.appName!.toLowerCase()),
      );
    } else if (Platform.isIOS) {
      // iOS doesn't allow to get installed apps.
      installedApps = iOSApps;

      await AppCheck.checkAvailability("calshow://").then(
        (app) => debugPrint(app.toString()),
      );
    }
    installedApps = installedApps;
    update();
  }
}
