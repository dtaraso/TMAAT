package com.tmaat.dtara.onlinemovingestimator;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.media.MediaRecorder;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.MotionEvent;
import android.view.Surface;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.Toast;

import java.io.IOException;


public class camera extends AppCompatActivity {
    private static final String APP_CLASS = "app";
    private android.hardware.Camera mCamera;
    private CameraPreview mPreview;
    private MediaRecorder mMediaRecorder;
    public static final int MEDIA_TYPE_IMAGE = 1;
    public static final int MEDIA_TYPE_VIDEO = 2;
    boolean isPreviewRunning = false;
    SurfaceHolder mSurfaceHolder;

    ProgressDialog progressDialog ;
    public  static final int RequestPermissionCode  = 1 ;

    private android.hardware.Camera.PictureCallback mPicture = new android.hardware.Camera.PictureCallback() {

        @Override
        public void onPictureTaken(byte[] data, android.hardware.Camera camera) {
            View view = findViewById(android.R.id.content);
            imageUpload(data, view);
        }
    };
    public static void setCameraDisplayOrientation(Activity activity, int cameraId, android.hardware.Camera camera) {
        android.hardware.Camera.CameraInfo info = new android.hardware.Camera.CameraInfo();
        android.hardware.Camera.getCameraInfo(cameraId, info);
        int rotation = activity.getWindowManager().getDefaultDisplay().getRotation();
        int degrees = 0;
        switch (rotation) {
            case Surface.ROTATION_0:
                degrees = 0;
                break;
            case Surface.ROTATION_90:
                degrees = 90;
                break;
            case Surface.ROTATION_180:
                degrees = 180;
                break;
            case Surface.ROTATION_270:
                degrees = 270;
                break;
        }

        int result;
        if (info.facing == android.hardware.Camera.CameraInfo.CAMERA_FACING_FRONT) {
            result = (info.orientation + degrees) % 360;
            result = (360 - result) % 360; // compensate the mirror
        } else { // back-facing
            result = (info.orientation - degrees + 360) % 360;
        }
        camera.setDisplayOrientation(result);
    }

    protected void onPause() {
        super.onPause();
        releaseMediaRecorder();       // if you are using MediaRecorder, release it first
        releaseCamera();              // release the camera immediately on pause event
    }

    private void releaseMediaRecorder(){
        if (mMediaRecorder != null) {
            mMediaRecorder.reset();   // clear recorder configuration
            mMediaRecorder.release(); // release the recorder object
            mMediaRecorder = null;
            mCamera.lock();           // lock camera for later use
        }
    }

    private void releaseCamera(){
        if (mCamera != null){
            mCamera.release();        // release the camera for other applications
            mCamera = null;
        }
    }
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_camera);
        // Add a listener to the Capture button
        // Create an instance of Camera
        mCamera = getCameraInstance();

        // Create our Preview view and set it as the content of our activity.
        mPreview = new CameraPreview(this, mCamera);
        FrameLayout preview = (FrameLayout) findViewById(R.id.camera_preview);
        preview.addView(mPreview);
        mCamera.startPreview();
        Button captureButton = (Button) findViewById(R.id.button_capture);
        captureButton.setOnTouchListener(
                new View.OnTouchListener() {
                    @Override
                    public boolean onTouch(View v, MotionEvent event) {
                        switch(event.getAction()) {
                            case MotionEvent.ACTION_DOWN:
                                // PRESSED
                                //mCamera.startPreview();
                                mCamera.takePicture(null, null, mPicture);
                                return true; // if you want to handle the touch event
                            case MotionEvent.ACTION_UP:
                                // RELEASED
                                //mCamera.stopPreview();
                                Toast.makeText(camera.this,getString(R.string.takeImage),Toast.LENGTH_SHORT).show();
                                //SystemClock.sleep(1000);
                                //mCamera.startPreview();
                                //Toast.makeText(camera.this,"If you have taken all the pictures for items, you can click the Done button",Toast.LENGTH_LONG).show();
                                startActivity(new Intent(camera.this,ImageConfirm.class));
                                return true; // if you want to handle the touch event
                        }
                        return false;
                    }
                }
        );
/*        Button doneButton = (Button) findViewById(R.id.done);
        doneButton.setOnClickListener(
                new View.OnClickListener(){
                    @Override
                    public void onClick(View v) {
                        setContentView(R.layout.activity_choose);
                    }
                }
        );*/
        Button PopButton = (Button) findViewById(R.id.Popup);
        PopButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(camera.this,Pop.class));
            }
        });
    }
    /** Check if this device has a camera */
    private boolean checkCameraHardware(Context context) {
        if (context.getPackageManager().hasSystemFeature(PackageManager.FEATURE_CAMERA)){
            // this device has a camera
            return true;
        } else {
            // no camera on this device
            return false;
        }
    }
    /** A safe way to get an instance of the Camera object. */
    public static android.hardware.Camera getCameraInstance(){
        android.hardware.Camera c = null;
        try {
            c = android.hardware.Camera.open(); // attempt to get a Camera instance
        }
        catch (Exception e){
            // Camera is not available (in use or does not exist)
        }
        return c; // returns null if camera is unavailable
    }

    /** A basic Camera preview class */
    public class CameraPreview extends SurfaceView implements SurfaceHolder.Callback {
        private static final String TAG ="TAG" ;
        private SurfaceHolder mHolder;
        private android.hardware.Camera mCamera;

        public CameraPreview(Context context, android.hardware.Camera camera) {
            super(context);
            mCamera = camera;

            // Install a SurfaceHolder.Callback so we get notified when the
            // underlying surface is created and destroyed.
            mHolder = getHolder();
            mHolder.addCallback(this);
            // deprecated setting, but required on Android versions prior to 3.0
            mHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
        }

        public void surfaceCreated(SurfaceHolder holder) {
            // The Surface has been created, now tell the camera where to draw the preview.
            try {
                mCamera.setPreviewDisplay(holder);
                mCamera.startPreview();
                mCamera.setDisplayOrientation(90);
            } catch (IOException e) {
                Log.d(TAG, "Error setting camera preview: " + e.getMessage());
            }
        }

        public void surfaceDestroyed(SurfaceHolder holder) {
            // empty. Take care of releasing the Camera preview in your activity.
        }

        public void surfaceChanged(SurfaceHolder holder, int format, int w, int h) {
            // If your preview can change or rotate, take care of those events here.
            // Make sure to stop the preview before resizing or reformatting it.

            if (mHolder.getSurface() == null){
                // preview surface does not exist
                return;
            }

            // stop preview before making changes
            try {
                mCamera.stopPreview();
            } catch (Exception e){
                // ignore: tried to stop a non-existent preview
            }

            // set preview size and make any resize, rotate or
            // reformatting changes here

            // start preview with new settings
            try {
                mCamera.setPreviewDisplay(mHolder);
                mCamera.startPreview();

            } catch (Exception e){
                Log.d(TAG, "Error starting camera preview: " + e.getMessage());
            }
        }
    }

    public void imageUpload(byte[] data, View view) {
        final byte[] data_final = data;
        final View view_final = view;

        new Thread(new Runnable() {

            @Override
            public void run() {

                Cloud cloud = new Cloud();
                final boolean ok = cloud.ImageUpload(data_final);
                if(!ok) {
                    /*
                     * If we fail to save, display a toast
                     */
                    // Please fill this in...
                    view_final.post(new Runnable() {

                        @Override
                        public void run() {
                            Toast.makeText(view_final.getContext(), "Not a Valid POST Request", Toast.LENGTH_SHORT).show();
                        }
                    });
                } else {
                    updateUI(view_final);
                }
            }
        }).start();
    }

    public void updateUI(View view) {
        Intent intent = new Intent(this, ImageConfirm.class);
        startActivity(intent);
    }
}
