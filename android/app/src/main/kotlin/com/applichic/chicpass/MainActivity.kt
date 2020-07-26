package com.applichic.chicpass

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.cryptonode.jncryptor.AES256JNCryptor
import org.cryptonode.jncryptor.CryptorException
import org.cryptonode.jncryptor.JNCryptor
import java.util.*

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "applichic.com/chicpass"
    private var cryptor: JNCryptor = AES256JNCryptor()

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "encrypt") {
                Thread(Runnable {
                    try {
                        val data = call.argument<String>("data")?.toByteArray()
                        val password = call.argument<String>("password")
                        val ciphertext = cryptor.encryptData(data, password?.toCharArray())

                        runOnUiThread {
                            result.success(Base64.getEncoder().encodeToString(ciphertext))
                        }
                    } catch (e: CryptorException) {
                        e.printStackTrace()

                        runOnUiThread {
                            result.error("encryption", e.message, null)
                        }
                    }
                }).start()
            } else if (call.method == "decrypt") {
                Thread(Runnable {
                    try {
                        val data = Base64.getDecoder().decode(call.argument<String>("data"))
                        val password = call.argument<String>("password")
                        val decryptedData = cryptor.decryptData(data, password?.toCharArray())

                        runOnUiThread {
                            result.success(String(decryptedData))
                        }
                    } catch (e: CryptorException) {
                        e.printStackTrace()

                        runOnUiThread {
                            result.error("decryption", e.message, null)
                        }
                    }
                }).start()
            }
        }
    }
}