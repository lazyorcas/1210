import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="uploader"
export default class extends Controller {
  static targets = ["uploadBtn"];

  connect() {
    addEventListener("turbo:submit-start", () => {
      this.uploadBtnTarget.textContent = "Uploading...";
    });
  }

  disconnect() {
    removeEventListener("turbo:submit-end", () => {
      this.uploadBtnTarget.textContent = "Upload";
    });
  }
}
