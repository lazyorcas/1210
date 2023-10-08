import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="notification-permission"
export default class extends Controller {
  connect() {
    if (Notification.permission != "granted") {
      this.element.classList.remove("standalone:hidden");
    }
  }

  request() {
    Notification.requestPermission();
  }
}
