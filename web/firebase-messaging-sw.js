importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

firebase.initializeApp({
    apiKey: 'AIzaSyDIV5qeNAzHn9mzI3Bjz-Eebe85WZckAdU',
    appId: '1:281518070753:web:46e48842ade008e79e50a0',
    messagingSenderId: '281518070753',
    projectId: 'pcp-m2',
    authDomain: 'pcp-m2.firebaseapp.com',
    storageBucket: 'pcp-m2.appspot.com',
    measurementId: 'G-EWXZE0XNP9',
    databaseURL: 'https://pcp-m2.firebaseio.com',
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});
