package com.ubd

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.animation.AlphaAnimation
import android.view.animation.Animation
import android.widget.ImageView
import android.widget.LinearLayout
import io.flutter.embedding.android.SplashScreen

class UbdSplashScreen : SplashScreen {

    var view : View? = null
    var imageView : ImageView? = null

    override fun createSplashView(context: Context, savedInstanceState: Bundle?): View? {
        view = LayoutInflater.from(context).inflate(R.layout.splash_view, null, false)
        imageView = view?.findViewById(R.id.imageView)
        return view
    }

    override fun transitionToFlutter(onTransitionComplete: Runnable) {
        imageView?.visibility = View.INVISIBLE
        val fadeOut = AlphaAnimation(1.0f, 0.0f)
        fadeOut.duration = 2000
        imageView?.animation = fadeOut
        fadeOut.setAnimationListener(object: Animation.AnimationListener {
            override fun onAnimationStart(animation: Animation?) {
                onTransitionComplete.run()
            }

            override fun onAnimationEnd(animation: Animation?) {
            }

            override fun onAnimationRepeat(animation: Animation?) {
            }

        })

    }


}