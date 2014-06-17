package com.apportable;

import android.app.Activity;

import android.os.Bundle;
import com.apportable.RuntimeService;

import android.util.Log;

//import com.apportable.Headless.R;

public class HeadlessActivity extends Activity {

    private RuntimeService mRuntimeService;

    private native void onCreated(Bundle savedInstanceState);
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mRuntimeService = new RuntimeService(this);
        mRuntimeService.loadLibraries();
        onCreated(savedInstanceState);
//        setContentView(R.layout.activity_main);
    }
}

