self.addEventListener("push", (event) => {
  let options = event.data.json();
  let title = options.title;
  let body = options.body;

  event.waitUntil(
    self.registration.showNotification(title, {
      body,
      icon: "/android-chrome-192x192.png"
    })
  );
});
