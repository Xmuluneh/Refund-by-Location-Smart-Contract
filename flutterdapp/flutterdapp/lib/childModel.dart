import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutterdapp/Encrypt-Decrypt.dart';
import 'main.dart' as pass;

class ChildModel extends ChangeNotifier {
  bool isLoading = true;
  late Client _httpClient;
  late String _contractAddress;
  late String _emp;
  late Web3Client _client;
  late EthPrivateKey _credentials;
  late DeployedContract _contract;
  late String x;
  late String y;
  late String latitude;
  late String longitude;
  late ContractFunction _readCoordinates;
  late ContractFunction _sendCoordinates;

  ChildModel() {
    initiateSetup();
  }

  Future<void> initiateSetup() async {
    _httpClient = Client();
    _client = Web3Client(
      "https://mainnet.infura.io/v3/24cd45b6689b4b3183112fd501758f2c",
      _httpClient,
    );
    await getEmp();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getEmp() async {
    _emp = await rootBundle.loadString("../assets/emp.json");
    _contractAddress = "0x4943030bce7e49dd13b4dd120c0fef7dde3c18a0";
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(
      "d585835f87981557df21fbaf99df4c9d06fd374b6efd121c027e0655cee5b627",
    );
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
      ContractAbi.fromJson(_emp, "Project"),
      EthereumAddress.fromHex(_contractAddress),
    );
    _readCoordinates = _contract.function("readCoordinates");
    _sendCoordinates = _contract.function("sendCoordinates");
  }

  getCoordinates() async {
    List readCoordinates = await _client.call(
      contract: _contract,
      function: _readCoordinates,
      params: [],
    );
    x = readCoordinates[0];
    y = readCoordinates[1];
  }

  addCoordinates(String lat, String lon) async {
    latitude = EncryptionDecryption.encryptAES(lat);
    longitude = EncryptionDecryption.encryptAES(lon);
    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _sendCoordinates,
        parameters: [latitude, longitude],
        maxGas: 100000,
      ),
      chainId: 4,
    );
    getCoordinates();
    isLoading = false;
    notifyListeners();
  }
}
