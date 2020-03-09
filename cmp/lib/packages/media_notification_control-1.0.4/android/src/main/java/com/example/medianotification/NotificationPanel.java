package com.example.medianotification;

import android.app.Activity;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.TaskStackBuilder;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.os.Bundle;
import androidx.core.app.NotificationCompat;
import android.util.Log;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.RemoteViews;
import android.widget.TextView;

/**
 * Created by dmitry on 14.08.18.
 */

public class NotificationPanel {
    private Context parent;
    private NotificationManager nManager;
    private NotificationCompat.Builder nBuilder;
    private RemoteViews remoteView;
    private String title;
    private String author;
    private String color;
    private String backgroundColor;
    private boolean play;

    public NotificationPanel(Context parent, String title, String author,String backgroundColor, String color, boolean play) {
        this.parent = parent;
        this.title = title;
        this.author = author;
        this.backgroundColor = backgroundColor;
        this.color = color;
        this.play = play;
        int backgroundColorInt = Color.parseColor(backgroundColor.replace("0xFF","#"));
        int colorInt = Color.parseColor(color.replace("0xFF","#"));

        nBuilder = new NotificationCompat.Builder(parent, "media_notification")
                .setSmallIcon(R.drawable.app_icon)
                .setPriority(Notification.PRIORITY_DEFAULT)
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                .setOngoing(this.play)
                .setOnlyAlertOnce(true)
                .setVibrate(new long[]{0L})
                .setColor(backgroundColorInt)
                .setSound(null);

        remoteView = new RemoteViews(parent.getPackageName(), R.layout.notificationlayout);
        remoteView.setInt(R.id.layout,"setBackgroundColor", backgroundColorInt);

        remoteView.setTextViewText(R.id.title, title);
        remoteView.setInt(R.id.title,"setTextColor", colorInt);
        remoteView.setTextViewText(R.id.author, author);
        remoteView.setInt(R.id.author,"setTextColor", colorInt);
        remoteView.setImageViewResource(R.id.image, R.drawable.app_icon);

        remoteView.setInt(R.id.stop,"setColorFilter", colorInt);
        remoteView.setInt(R.id.toggle,"setColorFilter", colorInt);
        remoteView.setInt(R.id.next,"setColorFilter", colorInt);
        remoteView.setInt(R.id.forward,"setColorFilter", colorInt);
        remoteView.setInt(R.id.close,"setColorFilter", colorInt);


        if (this.play) {
            remoteView.setImageViewResource(R.id.toggle, android.R.drawable.ic_pause);
        } else {
            remoteView.setImageViewResource(R.id.toggle, android.R.drawable.ic_play);
        }

        setListeners(remoteView);
        nBuilder.setContent(remoteView);

        Notification notification = nBuilder.build();

        nManager = (NotificationManager) parent.getSystemService(Context.NOTIFICATION_SERVICE);
        nManager.notify(1, notification);
    }

    public void setListeners(RemoteViews view){

        // STOP Button
        Intent stopIntent = new Intent(parent, NotificationReturnSlot.class)
                .setAction("stop");
        PendingIntent pendingStopIntent = PendingIntent.getBroadcast(parent, 0, stopIntent, PendingIntent.FLAG_UPDATE_CURRENT);
        view.setOnClickPendingIntent(R.id.stop, pendingStopIntent);

        // TOGGLE between PLAY & PAUSE
        Intent intent = new Intent(parent, NotificationReturnSlot.class)
            .setAction("toggle")
            .putExtra("title", this.title)
            .putExtra("backgroundColor", this.backgroundColor)
            .putExtra("color", this.color)
            .putExtra("action", !this.play ? "play" : "pause");

        PendingIntent pendingIntent = PendingIntent.getBroadcast(parent, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);
        view.setOnClickPendingIntent(R.id.toggle, pendingIntent);

        // NEXT Button
        Intent nextIntent = new Intent(parent, NotificationReturnSlot.class)
                .setAction("next");
        PendingIntent pendingNextIntent = PendingIntent.getBroadcast(parent, 0, nextIntent, PendingIntent.FLAG_UPDATE_CURRENT);
        view.setOnClickPendingIntent(R.id.next, pendingNextIntent);

        // FORWARD Button
        Intent forwardIntent = new Intent(parent, NotificationReturnSlot.class)
                .setAction("forward");
        PendingIntent pendingForwardIntent = PendingIntent.getBroadcast(parent, 0, forwardIntent, PendingIntent.FLAG_UPDATE_CURRENT);
        view.setOnClickPendingIntent(R.id.forward, pendingForwardIntent);

        // CLOSE Button
        Intent closeIntent = new Intent(parent, NotificationReturnSlot.class)
                .setAction("close");
        PendingIntent closePendingIntent = PendingIntent.getBroadcast(parent, 0, closeIntent, PendingIntent.FLAG_UPDATE_CURRENT);
        view.setOnClickPendingIntent(R.id.close, closePendingIntent);

        /*  ONCLICK
        // Нажатие на уведомление
        Intent selectIntent = new Intent(parent, NotificationReturnSlot.class)
                .setAction("select");
        PendingIntent selectPendingIntent = PendingIntent.getBroadcast(parent, 0, selectIntent, PendingIntent.FLAG_CANCEL_CURRENT);
        view.setOnClickPendingIntent(R.id.layout, selectPendingIntent);
        */
    }


    public void notificationCancel() {
        nManager.cancel(1);
    }
}

