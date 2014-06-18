package com.apportable;

import android.app.Activity;

import android.os.Bundle;
import com.apportable.RuntimeService;
import android.os.Handler;
import android.view.SurfaceView;
import android.view.SurfaceHolder;

import android.util.Log;

//import com.apportable.Headless.R;

public class HeadlessActivity extends Activity implements SurfaceHolder.Callback {

    private RuntimeService mRuntimeService;

    private native void onCreated(Bundle savedInstanceState);
    
    @Override
    protected void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mRuntimeService = new RuntimeService(this);
        mRuntimeService.loadLibraries();
        
        new Handler().post(new Runnable() {
            @Override
            public void run() {
                SurfaceView surfaceView = new SurfaceView(HeadlessActivity.this);
                surfaceView.getHolder().addCallback(HeadlessActivity.this);
                setContentView(surfaceView);

                onCreated(savedInstanceState);
            }
        });
    }
    
    public native void surfaceCreated(SurfaceHolder holder);
    public native void surfaceChanged(SurfaceHolder holder, int format, int width, int height);
    public native void surfaceDestroyed(SurfaceHolder holder);
}

