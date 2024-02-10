import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutterdapp/Encrypt-Decrypt.dart';
import 'main.dart' as pass;

class ParentModel extends ChangeNotifier {
  bool isLoading = true;
  late Client _httpClient;
  late String _contractAddress;
  late String _emp;
  late Web3Client _client;
  late DeployedContract _contract;
  late ContractFunction _readCoordinates;

  Future<void> initiateSetup() async {
    _httpClient = Client();
    _client = Web3Client(
      "https://mainnet.infura.io/v3/24cd45b6689b4b3183112fd501758f2c",
      _httpClient,
    );
    await _getAbi();
    await _getCredentials();
    await _getDeployedContract();
  }

  Future<void> _getAbi() async {
    _emp = await rootBundle.loadString("../assets/abi.json");
    _contractAddress = "0x4943030bce7e49dd13b4dd120c0fef7dde3c18a0";
  }

  Future<void> _getCredentials() async {
    // Omitted for conciseness
  }

  Future<void> _getDeployedContract() async {
    // Omitted for conciseness
  }

  void getCoordinates() async {
    await initiateSetup();
    // Omitted for conciseness
  }
}
