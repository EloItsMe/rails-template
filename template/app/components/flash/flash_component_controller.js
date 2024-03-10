import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this._open();
    this._closeAfterTimeout(10000);
    this._closeOnDrag();
  }

  close() {
    this.element.setAttribute("data-state", "closed");
    setTimeout(() => {
      this.element.remove();
    }, 200);
  }

  _open() {
    this.element.setAttribute("data-state", "open");
  }

  _closeAfterTimeout(time) {
    setTimeout(() => {
      this.close();
    }, time);
  }

  _closeOnDrag() {
    let touchStartX = 0;
    let touchMoveX = 0;
    const flashWidth = this.element.offsetWidth;

    this.element.addEventListener("touchstart", (event) => {
      touchStartX = event.changedTouches[0].screenX;
    });

    this.element.addEventListener("touchend", (event) => {
      touchMoveX = event.changedTouches[0].screenX;
      let swipeMoreThan25Percent = touchMoveX - touchStartX > flashWidth / 4;

      if (swipeMoreThan25Percent) {
        this.close();
      } else {
        resetPosition(event.target);
      }
    });

    this.element.addEventListener("touchmove", (event) => {
      touchMoveX = event.changedTouches[0].screenX;
      const transformValue = touchMoveX - touchStartX;

      event.target.style.transform = `translateX(${transformValue}px)`;
    });

    const resetPosition = (element) => {
      element.style.transition = "transform 0.2s";
      element.style.transform = "translateX(0)";
      setTimeout(() => {
        element.style.transition = "none";
      }, 200);
    };
  }
}
