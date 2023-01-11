import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ethers/ethers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart';
import 'package:menzy/Controllers/auth-controller.dart';
import 'package:menzy/Models/nftdata.dart';
import 'package:menzy/Models/user_own_nft.dart';
import 'package:menzy/View/Auth/login.dart';
import 'package:menzy/utils/App-Contants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';

class NFTMarketController extends GetxController {
  NFTMarketController();
  List<NFTData> nfts = [];
  List<NFTData> ownnft = [];
  bool isLoading = false;
  bool scLoading = false;
  bool deloading = false;
  late Client httpclient;
  late Web3Client ethclient;
  String? address;
  var myData;
  int myamount = 0;

  late SharedPreferences prefs;

  @override
  void onInit() async {
    prefs = await SharedPreferences.getInstance();
    address = prefs.getString("account");
    httpclient = Client();
    ethclient = Web3Client(
        "https://falling-floral-vineyard.bsc-testnet.discover.quiknode.pro/c60c866483cc44fbdbd923629269fbbc1cf97819/",
        httpclient);
    await getNFTs();
    await getOwnNft();
    super.onInit();
  }

  Future<dynamic> getNFTs({
    BuildContext? context,
    var userId,
    File? videoFile,
  }) async {
    Dio dio = Dio();
    try {
      isLoading = true;
      update();
      var response = await dio.get(
        "${AppConstants.SERVER_URL}/api/getnft",
      );
      isLoading = false;
      print("==>>>>>>${response.data}");
      update();
      if (response.statusCode == 200) {
        var result = response.data['nftdata'];
        List<NFTData> temp = [];
        result.forEach((e) {
          temp.add(NFTData.fromJson(e));
        });
        nfts = temp;
        update();
        return temp;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode! > 500) {
          Get.snackbar("Internal Server Error",
              "Something went wrong, please try again");
        } else if (e.response!.statusCode! == 401) {
          Get.put(AuthController())
              .logoutUser(context: context, isUnAuth: true)
              .then((value) => {Get.offAll(() => Login())});
          Get.snackbar(
              "Error", "Please login again, your session has been expired");
        } else if (e.response!.statusCode! >= 400) {
          Get.snackbar('Error', e.response!.statusMessage!);
        }
      } else {
        Get.snackbar(
            "No Internet", "Check your internet connection and try again");
      }
      print(e);
      return e.response;
    }
  }

  Future<dynamic> getSingleNFT({
    BuildContext? context,
    var id,
  }) async {
    Dio dio = Dio();
    try {
      print("${AppConstants.SERVER_URL}/api/getsinglenft?id=$id");
      update();
      var response = await dio.get(
        "${AppConstants.SERVER_URL}/api/getsinglenft?id=$id",
      );

      print("single nft ==>>>>>>${response.data}");
      update();
      if (response.statusCode == 200) {
        var result = response.data['data'];
        NFTData temp = NFTData.fromJson(result);
        update();
        return temp;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode! > 500) {
          Get.snackbar("Internal Server Error",
              "Something went wrong, please try again");
        } else if (e.response!.statusCode! == 401) {
          Get.put(AuthController())
              .logoutUser(context: context, isUnAuth: true)
              .then((value) => {Get.offAll(() => Login())});
          Get.snackbar(
              "Error", "Please login again, your session has been expired");
        } else if (e.response!.statusCode! >= 400) {
          Get.snackbar('Error', e.response!.statusMessage!);
        }
      } else {
        Get.snackbar(
            "No Internet", "Check your internet connection and try again");
      }

      print(e);

      return e.response;
    }
  }

  Future<dynamic> changestatus({
    BuildContext? context,
    var id,
    var status,
  }) async {
    Dio dio = Dio();
    try {
      deloading = true;
      update();
      var response = await dio.post(
          "${AppConstants.SERVER_URL}/api/updatestatus",
          data: {"id": id, "status": status});
      print("single nft ==>>>>>>${response.data}");
      update();
      if (response.statusCode == 200) {
        NFTData nftdata = await getSingleNFT(context: null, id: id);
        ownnft[ownnft.indexWhere((element) => nftdata.id == element.id)] =
            nftdata;
        update();
      }
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode! > 500) {
          Get.snackbar("Internal Server Error",
              "Something went wrong, please try again");
        } else if (e.response!.statusCode! == 401) {
          Get.put(AuthController())
              .logoutUser(context: context, isUnAuth: true)
              .then((value) => {Get.offAll(() => Login())});
          Get.snackbar(
              "Error", "Please login again, your session has been expired");
        } else if (e.response!.statusCode! >= 400) {
          Get.snackbar('Error', e.response!.statusMessage!);
        }
      } else {
        Get.snackbar(
            "No Internet", "Check your internet connection and try again");
      }

      print(e);

      return e.response;
    }

    deloading = false;
    getNFTs();
    update();
  }

  Future<dynamic> updateprice({
    BuildContext? context,
    var id,
    var price,
  }) async {
    Dio dio = Dio();
    try {
      deloading = true;
      update();
      var response = await dio.post(
          "${AppConstants.SERVER_URL}/api/updateprice",
          data: {"id": id, "price": price});
      print("price update==>>>>>>${response.data}");
      update();
      if (response.statusCode == 200) {
        NFTData nftdata = await getSingleNFT(context: null, id: id);
        ownnft[ownnft.indexWhere((element) => nftdata.id == element.id)] =
            nftdata;
        update();
      }
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode! > 500) {
          Get.snackbar("Internal Server Error",
              "Something went wrong, please try again");
        } else if (e.response!.statusCode! == 401) {
          Get.put(AuthController())
              .logoutUser(context: context, isUnAuth: true)
              .then((value) => {Get.offAll(() => Login())});
          Get.snackbar(
              "Error", "Please login again, your session has been expired");
        } else if (e.response!.statusCode! >= 400) {
          Get.snackbar('Error', e.response!.statusMessage!);
        }
      } else {
        Get.snackbar(
            "No Internet", "Check your internet connection and try again");
      }

      print(e);

      return e.response;
    }

    deloading = false;
    getNFTs();
    update();
  }

  Future<dynamic> getOwnNft({
    BuildContext? context,
  }) async {
    Dio dio = Dio();
    print(address);
    if (address == null) {
      Get.snackbar("Connect Wallet", "Connect Metamask Wallet",
          colorText: Colors.white);
    } else {
      try {
        scLoading = true;
        ownnft = [];
        update();
        String demoaddr = "0xCe94734965CbA53217523d52D9772b02Db188622";
        var response = await dio.get(
            "https://deep-index.moralis.io/api/v2/$address/nft/0xA84c4B31c793D2FEfd4Db6c0fBd759634c55E044?chain=bsc%20testnet&format=decimal",
            //  "https://testnet.bscscan.com/$address/0xA84c4B31c793D2FEfd4Db6c0fBd759634c55E044#code",
            options: Options(
              headers: {
                "X-API-Key":
                    "eYcwRjbNUaKHO1LjLAa0C77hVkQiokQFesWe7QkOhtQKfaqGEwwE3vbtZGtDuIIx"
              },
            ));
        scLoading = false;
        update();
        print("own nft===>>>>${response.data}");
        if (response.statusCode == 200) {
          var result = response.data['result'];
          result.forEach((e) async {
            Result res = Result.fromJson(e);
            NFTData temdata =
                await getSingleNFT(context: context, id: res.tokenId);
            ownnft.add(temdata);
          });
          update();
          return ownnft;
        }
      } on DioError catch (e) {
        if (e.response != null) {
          if (e.response!.statusCode! > 500) {
            Get.snackbar("Internal Server Error",
                "Something went wrong, please try again");
          } else if (e.response!.statusCode! == 401) {
            Get.put(AuthController())
                .logoutUser(context: context, isUnAuth: true)
                .then((value) => {Get.offAll(() => Login())});
            Get.snackbar(
                "Error", "Please login again, your session has been expired");
          } else if (e.response!.statusCode! >= 400) {
            Get.snackbar('Error', e.response!.statusMessage!);
          }
        } else {
          Get.snackbar(
              "No Internet", "Check your internet connection and try again");
        }

        print(e);

        return e.response;
      }
    }
  }

  Future<dynamic> getipfs({
    required NFTData nft,
  }) async {
    var formData = {
      "image": nft.imgPath,
      'name': nft.name,
    };
    Dio dio = Dio();
    try {
      print("working");

      var response = await dio.post("https://nft-api-sigma.vercel.app/add",
          data: formData);
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Get.snackbar("Congrats", "data retreived",
        //     backgroundColor: AppColors.primary, colorText: AppColors.white);
        print("ipfs  ${response.data}");
        return response.data;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode! > 500) {
          Get.snackbar("Internal Server Error",
              "Something went wrong, please try again");
        } else if (e.response!.statusCode! == 401) {
          bool loggedOut = await AuthController().logoutUser(isUnAuth: true);
          if (loggedOut) {
            Get.offAll(() => const Login());
          }
          Get.snackbar(
              "Error", "Please login again, your session has been expired");
        } else if (e.response!.statusCode! >= 400) {
          Get.snackbar('Error', e.response!.statusMessage!);
        }
      } else {
        Get.snackbar(
            "No Internet", "Check your internet connection and try again");
      }

      print(e);

      return e.response;
    }
  }

  Future<void> mintDaap(NFTData nft, String ipfs) async {
    Credentials fromHex =
        EthPrivateKey.fromHex("0xCe94734965CbA53217523d52D9772b02Db188622");
    DeployedContract contract = await loadcontract();
    final ethfunc = contract.function("mintDapp");
    final result = ethclient.sendTransaction(
        fromHex,
        Transaction.callContract(
            contract: contract,
            function: ethfunc,
            parameters: [
              EthereumAddress.fromHex(address!),
              BigInt.from(nft.id!),
              ethers.utils.parseEther("1"),
              ipfs,
            ],
            maxGas: 2500000),
        chainId: 97);
    // print(address);
    // await ethclient.sendTransaction(
    //   fromHex,
    //   Transaction(
    //     to: EthereumAddress.fromHex('0xe8d096ecf67b49e9e0a4b798ec0e8e2ed7c85325'),
    //     gasPrice: EtherAmount.inWei(BigInt.one),
    //     maxGas: 100000,
    //     value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 1),
    //   ),
    // );
    // var options = {
    //   "value": ethers.utils.parseEther(nft.price!),
    //   "gasLimit":250000
    // };
    print([
      EthereumAddress.fromHex(address!),
      BigInt.from(nft.id!),
      ethers.utils.parseEther(nft.price!),
      ipfs
    ]);
    // List<dynamic> result = await query("mintDapp", [EthereumAddress.fromHex(address!),BigInt.from(nft.id!),EtherAmount.fromUnitAndValue(EtherUnit.ether, 1),ipfs,],);
    myData = result;
    print(myData);
    update();
  }

  Future<DeployedContract> loadcontract() async {
    String abi = await rootBundle.loadString("assets/abifile/abi.json");
    String contractadr = "0xF932882A16f9f129B5172593393386E9D74B2D64";
    final contract = DeployedContract(ContractAbi.fromJson(abi, "Xcoin"),
        EthereumAddress.fromHex(contractadr));
    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadcontract();
    final ethfunction = contract.function(functionName);
    final result = await ethclient.call(
        contract: contract, function: ethfunction, params: args);
    return result;
  }
}
