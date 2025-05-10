package com.example.alignar

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.isGone
import com.google.android.material.floatingactionbutton.ExtendedFloatingActionButton
import com.google.ar.core.Config
import io.github.sceneview.ar.ArSceneView
import io.github.sceneview.ar.node.ArModelNode
import io.github.sceneview.ar.node.PlacementMode
import io.github.sceneview.math.Position

class MainActivity : AppCompatActivity() {

    private lateinit var sceneView: ArSceneView
    private lateinit var placeButton: ExtendedFloatingActionButton
    private lateinit var modelNode: ArModelNode

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        sceneView = findViewById<ArSceneView>(R.id.sceneView).apply {
            lightEstimationMode = Config.LightEstimationMode.ENVIRONMENTAL_HDR
            lifecycle?.addObserver(this)
        }

        placeButton = findViewById(R.id.place)
        placeButton.isEnabled = false

        modelNode = ArModelNode(sceneView.engine, PlacementMode.INSTANT).apply {
            loadModelGlbAsync(
                glbFileLocation = "models/test.glb",
                scaleToUnits = 1.0f,
                centerOrigin = Position(0.0f, 0.0f, 0.0f)
            ) {
                placeButton.isEnabled = true
            }

            onAnchorChanged = { anchor ->
                placeButton.isGone = anchor != null
            }
        }

        sceneView.addChild(modelNode)

        placeButton.setOnClickListener {
            if (!modelNode.isAnchored) {
                modelNode.anchor()
                sceneView.planeRenderer.isVisible = false
            }
        }
    }
}