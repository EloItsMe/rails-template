import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["menu"];

  toggle(_event) {
    this.menuTarget.hasAttribute("open")
      ? this.menuTarget.removeAttribute("open")
      : this.menuTarget.setAttribute("open", "");
  }

  open(_event) {
    this.menuTarget.setAttribute("open", "");
  }

  close(event) {
    if (
      !this.element.contains(event.target) &&
      this.menuTarget.hasAttribute("open")
    ) {
      this.menuTarget.removeAttribute("open");
    }
  }
}
