package com.applichic.chicpass

import android.R.attr.password
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.cryptonode.jncryptor.AES256JNCryptor
import org.cryptonode.jncryptor.CryptorException
import org.cryptonode.jncryptor.JNCryptor

import java.util.Base64

class MainActivity: FlutterActivity() {
    private val CHANNEL = "applichic.com/chicpass"
    var cryptor: JNCryptor = AES256JNCryptor()

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if(call.method == "encrypt") {
                try {
                    var data = call.argument<String>("data")?.toByteArray()
                    var password = call.argument<String>("password")
                    val ciphertext = cryptor.encryptData(data, password?.toCharArray())
                    result.success(Base64.getEncoder().encodeToString(ciphertext))
                } catch (e: CryptorException) {
                    e.printStackTrace()
                    result.error("encryption", e.message, null)
                }
            } else if(call.method == "decrypt") {
                try {
                    var data = Base64.getDecoder().decode(call.argument<String>("data"))
                    var password = call.argument<String>("password")
                    var decryptedData = cryptor.decryptData(data, password?.toCharArray())
                    result.success(String(decryptedData))
                } catch (e: CryptorException) {
                    e.printStackTrace()
                    result.error("encryption", e.message, null)
                }
            }
        }
    }
}