import 'package:encrypt/encrypt.dart';
import 'package:flutterdapp/main.dart' as main

class EncryptionDecryption {
  static final encrypt = Encrypter(AES(Key.fromUtf8(main.password)));
  static final initializationVector = IV.fromLength(16);

  static String encryptAES(String text) =>
      encrypt.encrypt(text, iv: initializationVector).base64;

  static String decryptAES(String encryptedText) =>
      encrypt.decrypt(Encrypted.fromBase64(encryptedText), iv: initializationVector);
}


