import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="comments"
export default class extends Controller {
  connect() {
    this.element.lastElementChild.scrollIntoView();
  }
}
