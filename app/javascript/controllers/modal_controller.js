// https://www.bearer.com/blog/how-to-build-modals-with-hotwire-turbo-frames-stimulusjs

import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="modal"
export default class extends Controller {
  close() {
    this.element.remove();
  }
}
