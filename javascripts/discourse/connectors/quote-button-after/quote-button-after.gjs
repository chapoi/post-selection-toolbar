// app/components/post-text-selection-toolbar.js
import Component from "@glimmer/component";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";

export default class PostTextSelectionToolbarComponent extends Component {
  @service menu;

  @action
  menuAppears(element) {
    this.element = element;
    document.body.classList.add("selection-toolbar-visible");
    this.startScrollCheck();
  }

  startScrollCheck() {
    this.scrollHandler = this.checkSelectionVisibility.bind(this);
    window.addEventListener("scroll", this.scrollHandler);
    this.visibilityCheckInterval = setInterval(this.scrollHandler, 500);
  }

  checkSelectionVisibility() {
    const selection = window.getSelection();
    if (selection.rangeCount > 0) {
      const range = selection.getRangeAt(0);
      const rect = range.getBoundingClientRect();

      if (
        rect.top >= 0 &&
        rect.left >= 0 &&
        rect.bottom <=
          (window.innerHeight || document.documentElement.clientHeight) &&
        rect.right <=
          (window.innerWidth || document.documentElement.clientWidth)
      ) {
        // do nothing
      } else {
        this.handleSelectionNotVisible();
      }
    }
  }

  handleSelectionNotVisible() {
    document.body.classList.remove("selection-toolbar-visible");
    this.menu.close("post-text-selection-toolbar");
    window.removeEventListener("scroll", this.scrollHandler);
    clearInterval(this.visibilityCheckInterval);
  }

  willDestroy() {
    super.willDestroy(...arguments);
    document.body.classList.remove("selection-toolbar-visible");
    window.removeEventListener("scroll", this.scrollHandler);
  }
}
