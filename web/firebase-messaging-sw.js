// Give the service worker access to Firebase Messaging.
// Note that you can only use Firebase Messaging here. Other Firebase libraries
// are not available in the service worker.
importScripts('https://www.gstatic.com/firebasejs/9.15.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.15.0/firebase-messaging-compat.js');

// Initialize the Firebase app in the service worker by passing in
// your app's Firebase config object.
firebase.initializeApp({
  apiKey: "AIzaSyD_o9BcrmbX9ZBKb_jr3NDTMyw0Fo-RHsk",
  authDomain: "student-resource-hub-24hvca.firebaseapp.com",
  projectId: "student-resource-hub-24hvca",
  storageBucket: "student-resource-hub-24hvca.firebasestorage.app",
  messagingSenderId: "726616670078",
  appId: "1:726616670078:web:0801e1e6b5b20ab441fd2f",
});

// Retrieve an instance of Firebase Messaging so that it can handle background messages.
const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/favicon.png'
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});
