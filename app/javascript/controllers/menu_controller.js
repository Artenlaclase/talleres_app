import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="menu"
export default class extends Controller {
  static targets = ["mobile", "button"]

  connect() {
    // Ensure mobile menu starts hidden
    if (this.hasMobileTarget) {
      this.mobileTarget.classList.add("hidden")
    }
    if (this.hasButtonTarget) {
      this.buttonTarget.setAttribute("aria-expanded", "false")
    }
  }

  toggle() {
    if (!this.hasMobileTarget) return
    this.mobileTarget.classList.toggle("hidden")
    if (this.hasButtonTarget) {
      const expanded = this.buttonTarget.getAttribute("aria-expanded") === "true"
      this.buttonTarget.setAttribute("aria-expanded", (!expanded).toString())
    }
  }
}
