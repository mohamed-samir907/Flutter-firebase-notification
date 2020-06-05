const functions = require('firebase-functions');

const admin = require('firebase-admin')
admin.initializeApp()

exports.sendNotification = functions.firestore
.document("users/{user}/notifications/{notification}")
.onCreate(async (snapshot, context)=> {

    try {
        
        const notificationDocument = snapshot.data()
        const uid = context.params.user;

        const notificationMessage = notificationDocument.message;
        const notificationTitle = notificationDocument.title;

        const userDoc = await admin.firestore().collection("users").doc(uid).get();

        const fcmToken = userDoc.data().fcmToken

        const message = {
            "notification": {
                title: notificationTitle,
                body: notificationMessage
            },
            token: fcmToken
        }
        

        // send to topic
        // admin.messaging().sendToTopic('topic-name')


        // send notification to device

        return admin.messaging().send(message)

    } catch (error) {
        console.log(error)
    }

})