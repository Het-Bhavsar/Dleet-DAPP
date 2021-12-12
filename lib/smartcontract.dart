// ignore_for_file: unused_field, unused_local_variable, import_of_legacy_library_into_null_safe, non_constant_identifier_names, avoid_print, curly_braces_in_flow_control_structures, unnecessary_new

import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:web3dart/web3dart.dart';
import 'location.dart';
import 'package:web_socket_channel/io.dart';

class SmartContract {
  late Client httpClient;
  late String details;
  late Web3Client ethClient;
  final String _rpcUrl = "http://127.0.0.1:8545";
  final String _wsUrl = "ws://127.0.0.1:8545/";
  var idx = BigInt.from(0);
  bool data = false;
  String productID = '-1';
  var myAddress = "0x6a9d3aFD60fd93599ecbeAaA5563098e305e58A2";

  //initialising State
  SmartContract() {
    httpClient = Client();
    ethClient = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
  }

  // Solidity Function Calls
  Future<DeployedContract> loadContract() async {
    String abi_string = await rootBundle.loadString("abis/SupplyChain.json");
    final jsonAbi = jsonDecode(abi_string);
    String abi = jsonEncode(jsonAbi["abi"]);
    EthereumAddress contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, 'SupplyChain'), contractAddress);
    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);
    return result;
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex(
        "0bec326291bbe4eb8bc51679ec2d99ebf86c14c67e07ccb64746d22eec239e56");
    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract, function: ethFunction, parameters: args),
        chainId: 4);
    return result;
  }

  Future<void> newItem(String productName, String desc, String uname) async {
    String today = date();
    String newLocation = await Location.getLocation();
    await submit('newItem', [productName, today, desc, uname, newLocation]);
    print("Success");
  }

  Future<void> addState(int productID) async {
    String lastLocation = await Location.getLocation();
    var bigID = BigInt.from(productID);
    await submit("addState", [bigID, lastLocation]);
  }

  Future<String> getProductID() async {
    List<dynamic> result = await query('getProductID', []);
    return result[0].toString();
  }

  static List<String> allData = ["hello", "hello", "hello", "hello", "HEllo"];

  getFormattedData(int productID) async {
    String data = await searchProduct(productID);
    print(data);
    int j = 0;
    String temp = "";
    for (int i = 1; i < data.length; i++) {
      if (data[i] == ':') {
        allData[j] = temp;
        j++;
        temp = "";
      } else
        temp = temp + data[i];
    }
    allData[4] = temp;
    print(allData[4]);
    return allData;
  }

  Future<String> searchProduct(int productID) async {
    var bigID = BigInt.from(productID);
    List<dynamic> result = await query("searchProduct", [bigID]);
    return result[0].toString();
  }

  Future<String> getState(int productID) async {
    var p = BigInt.from(productID);
    List<dynamic> result = await query("getState", [p]);
    print(result[0].toString());
    return result[0].toString();
  }

  String date() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }
}
