import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutterdapp/Encrypt-Decrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ParentModel extends ChangeNotifier {
  bool isLoading = true;
  late Client httpClient;
  late String contractAddress;
  late String emp;
  late Web3Client client;
  late DeployedContract contract;
  late ContractFunction readCoordinates;

  Future<void> initiateSetup() async {
    httpClient = Client();
    client = Web3Client(
      "https://mainnet.infura.io/v3/24cd45b6689b4b3183112fd501758f2c",
      httpClient,
    );
    await getEmp();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getEmp() async {
    await dotenv.load();
    var contractAddress = dotenv.env['CONTRACT_ADDRESS'];
    if (contractAddress != null) {
      contractAddress = contractAddress;
    } else {
      throw 'Contract address not found in .env file';
    }
  }

  Future<void> getCredentials() async {
    await dotenv.load();
    final privateKey = dotenv.env['PRIVATE_KEY'];
    if (privateKey != null) {
      var credentials = EthPrivateKey.fromHex(privateKey);
    } else {
      throw 'Private key not found in .env file';
    }
  }

  Future<void> getDeployedContract() async {
    contract = DeployedContract(
      ContractAbi.fromJson(emp, "Project"),
      EthereumAddress.fromHex(contractAddress),
    );
    readCoordinates = contract.function("readCoordinates");
  }

  void getCoordinates() async {
    try {
      await initiateSetup();
      final List<dynamic> readCoordinates = await client.call(
        contract: contract,
        function: readCoordinates,
        params: [],
      );

      var x = readCoordinates[0];
      var y = readCoordinates[1];

      if (kDebugMode) {
        print("Data retrieved:");
      }
      if (kDebugMode) {
        print("x: $x");
      }
      if (kDebugMode) {
        print("y: $y");
      }

      var latitude = EncryptionDecryption.decryptAES(x);
      var longitude = EncryptionDecryption.decryptAES(y);

      if (kDebugMode) {
        print("Decrypted coordinates:");
      }
      if (kDebugMode) {
        print("Latitude: $latitude");
      }
      if (kDebugMode) {
        print("Longitude: $longitude");
      }

      isLoading = false;
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print("Error fetching coordinates: $error");
      }
      isLoading = false;
      notifyListeners();
    }
  }
}
