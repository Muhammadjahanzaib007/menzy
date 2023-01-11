import 'dart:convert';

class OWNNFT {
  int? total;
  int? page;
  int? pageSize;
  int? cursor;
  List<Result>? result;

  OWNNFT({this.total, this.page, this.pageSize, this.cursor, this.result});

  OWNNFT.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    pageSize = json['page_size'];
    cursor = json['cursor'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['page'] = this.page;
    data['page_size'] = this.pageSize;
    data['cursor'] = this.cursor;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? tokenAddress;
  String? tokenId;
  String? ownerOf;
  String? blockNumber;
  String? blockNumberMinted;
  String? tokenHash;
  String? amount;
  String? contractType;
  String? name;
  String? symbol;
  String? tokenUri;
  Map<String,dynamic>? metadata;
  String? lastTokenUriSync;
  String? lastMetadataSync;

  Result(
      {this.tokenAddress,
        this.tokenId,
        this.ownerOf,
        this.blockNumber,
        this.blockNumberMinted,
        this.tokenHash,
        this.amount,
        this.contractType,
        this.name,
        this.symbol,
        this.tokenUri,
        this.metadata,
        this.lastTokenUriSync,
        this.lastMetadataSync});

  Result.fromJson(Map<String, dynamic> json) {
    tokenAddress = json['token_address'];
    tokenId = json['token_id'];
    ownerOf = json['owner_of'];
    blockNumber = json['block_number'];
    blockNumberMinted = json['block_number_minted'];
    tokenHash = json['token_hash'];
    amount = json['amount'];
    contractType = json['contract_type'];
    name = json['name'];
    symbol = json['symbol'];
    tokenUri = json['token_uri'];
    metadata =json['metadata']==null?null: jsonDecode(json['metadata']) ;
    lastTokenUriSync = json['last_token_uri_sync'];
    lastMetadataSync = json['last_metadata_sync'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token_address'] = this.tokenAddress;
    data['token_id'] = this.tokenId;
    data['owner_of'] = this.ownerOf;
    data['block_number'] = this.blockNumber;
    data['block_number_minted'] = this.blockNumberMinted;
    data['token_hash'] = this.tokenHash;
    data['amount'] = this.amount;
    data['contract_type'] = this.contractType;
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    data['token_uri'] = this.tokenUri;
    data['metadata'] = this.metadata;
    data['last_token_uri_sync'] = this.lastTokenUriSync;
    data['last_metadata_sync'] = this.lastMetadataSync;
    return data;
  }
}