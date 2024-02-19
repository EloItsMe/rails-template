import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    transitionDuration: Number,
  };

  connect() {
    this._setTransitionDuration(this.transitionDurationValue);
    this._open();
  }

  close() {
    this.element.removeAttribute("visible");
    setTimeout(() => {
      this.element.remove();
    }, this.transitionDurationValue);
  }

  _setTransitionDuration(duration) {
    this.element.style.transitionDuration = `${duration}ms`;
  }

  _open() {
    this.element.setAttribute("visible", "");
  }
}
