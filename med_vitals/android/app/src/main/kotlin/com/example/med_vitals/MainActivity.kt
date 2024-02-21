package com.example.med_vitals

import android.content.res.AssetManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.tensorflow.lite.Interpreter
import java.io.FileInputStream
import java.nio.ByteBuffer
import java.nio.channels.FileChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "emotion_analysis"
    private lateinit var interpreter: Interpreter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        interpreter = Interpreter(loadModelFile("emotion_model.tflite"))
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "runModelOnAudio") {
                val transcription = call.argument<String>("transcription")
                if (transcription != null) {
                    val emotionResults = runModel(transcription)
                    result.success(emotionResults)
                } else {
                    result.error("INVALID_ARGUMENT", "Transcription is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun loadModelFile(modelFilename: String): ByteBuffer {
        val assetManager: AssetManager = applicationContext.assets
        val fileDescriptor = assetManager.openFd(modelFilename)
        val inputStream = FileInputStream(fileDescriptor.fileDescriptor)
        val fileChannel = inputStream.channel
        val startOffset = fileDescriptor.startOffset
        val declaredLength = fileDescriptor.declaredLength
        return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength)
    }

    private fun runModel(transcription: String): List<Double> {
        // Placeholder implementation
        return emptyList()
    }
}
