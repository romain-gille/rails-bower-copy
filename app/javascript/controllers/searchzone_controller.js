import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form", "input", "list", "info"];

  connect() {
    // console.log(this.formTarget);
    // console.log(this.inputTarget);
    // console.log(this.listTarget);
    // console.log(this.infoTarget);
  }

  update(event) {
    console.log(event.currentTarget);
    if (
      ["name", "stars", "repository_url"].includes(
        event.currentTarget.dataset.value
      )
    ) {
      this.infoTarget.setAttribute(
        "data-sorted",
        event.currentTarget.dataset.value
      );
    } else {
      this.infoTarget.setAttribute(
        "data-page",
        event.currentTarget.dataset.value
      );
    }

    const url = `${this.formTarget.action}?query=${this.inputTarget.value}&sort=${this.infoTarget.dataset.sorted}&page=${this.infoTarget.dataset.page}`;
    console.log(url);
    fetch(url, { headers: { Accept: "text/plain" } })
      .then((response) => response.text())
      .then((data) => {
        this.listTarget.outerHTML = data;
      });
  }
}
