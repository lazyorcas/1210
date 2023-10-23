// https://www.bearer.com/blog/how-to-build-modals-with-hotwire-turbo-frames-stimulusjs

import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="modal"
export default class extends Controller {
  connect() {
    this.element.classList.add("modal");
    document.body.classList.add("overflow-hidden");
  }

  close() {
    this.element.remove();
    document.body.classList.remove("overflow-hidden");
  }

  disconnect() {
    document.body.classList.remove("overflow-hidden");
  }
}
